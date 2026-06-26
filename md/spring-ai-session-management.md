*A New Session API for Spring AI — Structured, Compactable, Multi-Agent-Ready*

**Part 7 of the [Spring AI Agentic Patterns](https://spring.io/blog/2026/04/07/spring-ai-agentic-patterns-6-memory-tools) series** completes the memory picture. After covering [Agent Skills](https://spring.io/blog/2026/01/13/spring-ai-generic-agent-skills), [AskUserQuestionTool](https://spring.io/blog/2026/01/16/spring-ai-ask-user-question-tool), [TodoWriteTool](https://spring.io/blog/2026/01/20/spring-ai-agentic-patterns-3-todowrite/), [Subagent Orchestration](https://spring.io/blog/2026/01/27/spring-ai-agentic-patterns-4-task-subagents), [A2A Integration](https://spring.io/blog/2026/01/29/spring-ai-agentic-patterns-a2a-integration), and [AutoMemoryTools](https://spring.io/blog/2026/04/07/spring-ai-agentic-patterns-6-memory-tools) for long-term cross-session memory, we now add the complementary **short-term layer**: Spring AI Session. Storing conversation history as a flat message list works for short exchanges but breaks down as sessions grow — naive truncation silently discards tool-call sequences mid-exchange, leaving the model with orphaned results and broken turn structure. Spring AI Session solves this by automatically recording every message, tool call, and result for the active exchange and managing the context window intelligently, while `AutoMemoryTools` retains curated facts that must survive beyond the session. A complete agent memory stack needs both; neither replaces the other.

> **Roadmap:** Incubating in [spring-ai-community](https://github.com/spring-ai-community/spring-ai-session); targets Spring AI 2.1 (November 2026), when `ChatMemory` will be deprecated in its favour.

`ChatMemory` evicts the oldest messages with no turn safety, no event identity, no multi-agent support, and no record of what was discarded. Spring AI Session replaces it with an event-sourced log, pluggable compaction strategies, branch isolation, and keyword-searchable recall storage.

🚀 **Want to jump right in?** Skip to the [Getting Started](#getting-started) section.

------------------------------------------------------------------------

## Session API Architecture

![Spring AI Session API Classes](https://raw.githubusercontent.com/spring-io/spring-io-static/refs/heads/main/blog/tzolov/20260412/session-api-classes.png)

### Session and SessionEvent

`Session` is an **immutable metadata-only value object** — it holds the session ID, user ID, TTL, and arbitrary metadata. The event log lives separately in the repository, fetched on demand.

`SessionEvent` wraps a Spring AI `Message` and adds what `Message` intentionally omits: a UUID, `sessionId`, `timestamp`, an optional `branch` label for multi-agent hierarchies, and framework flags like `METADATA_SYNTHETIC`.

    SessionService service = new DefaultSessionService(InMemorySessionRepository.builder().build());

    Session session = service.create(
        CreateSessionRequest.builder().userId("alice").build()
    );

    service.appendMessage(session.id(), new UserMessage("What is Spring AI?"));
    service.appendMessage(session.id(), new AssistantMessage("Spring AI is..."));

    List<Message> history = service.getMessages(session.id()); // ready to pass to an LLM

### Turns

A **turn** is the atomic unit of conversation: one `UserMessage` plus all following events — assistant replies, tool calls, tool results — up to the next `UserMessage`. All compaction strategies operate at turn granularity, so the kept window always starts on a `USER` message. The model never sees an orphaned tool result or a split exchange.

    Turn 1: [USER "What is Spring AI?"]  [ASSISTANT "Spring AI is..."]
    Turn 2: [USER "Can it use tools?"]   [ASSISTANT (tool call)]  [TOOL result]  [ASSISTANT "Yes,..."]

------------------------------------------------------------------------

## Context Compaction

Compaction reduces the event history to fit the context window while preserving coherence. It is driven by two composable abstractions: **triggers** and **strategies**.

### Triggers

    new TurnCountTrigger(20);                                   // fires when > 20 turns
    TokenCountTrigger.builder().threshold(4000).build();        // fires at 4000 estimated tokens

    // OR-composite — fires if either condition is met
    CompositeCompactionTrigger.anyOf(
        new TurnCountTrigger(20),
        TokenCountTrigger.builder().threshold(4000).build()
    );

### Strategies

<table>
<thead>
<tr>
<th>Strategy</th>
<th>LLM call?</th>
<th>Best for</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>SlidingWindowCompactionStrategy</code></td>
<td>No</td>
<td>Cost-sensitive, short-term context</td>
</tr>
<tr>
<td><code>TurnWindowCompactionStrategy</code></td>
<td>No</td>
<td>Turn-structured dialogues</td>
</tr>
<tr>
<td><code>TokenCountCompactionStrategy</code></td>
<td>No</td>
<td>Hard context-window limits</td>
</tr>
<tr>
<td><code>RecursiveSummarizationCompactionStrategy</code></td>
<td>Yes</td>
<td>Long-running, context-rich sessions</td>
</tr>
</tbody>
</table>

The first three keep a verbatim suffix of events (by message count, turn count, or token budget). All three snap the cut point to the nearest turn boundary — no partial turns are ever kept.

**Recursive Summarization** is the most powerful: it uses an LLM to summarize the events being archived and stores the result as a synthetic `user` + `assistant` turn. Each subsequent compaction pass builds on prior summaries — creating a rolling compressed history that never starts from scratch:

    RecursiveSummarizationCompactionStrategy.builder(chatClient)
        .maxEventsToKeep(10)
        .overlapSize(2)   // feed 2 events from the active window into the summary prompt
        .build();

> **Note:** Trigger and strategy must always be configured together — setting one without the other throws `IllegalArgumentException` at build time. Either set both via `.compactionTrigger(...)` and `.compactionStrategy(...)`, or omit both to disable compaction entirely.

------------------------------------------------------------------------

## ChatClient Integration

`SessionMemoryAdvisor` wires session management into the `ChatClient` pipeline transparently. On every request it loads history, prepends it to the prompt, appends the new user and assistant messages, and runs compaction if a trigger fires — all without any manual code in the application.

    @Bean
    SessionMemoryAdvisor sessionMemoryAdvisor(SessionService sessionService,
            ChatClient.Builder chatClientBuilder) {

        return SessionMemoryAdvisor.builder(sessionService)
            .defaultUserId("alice")
            .compactionTrigger(new TurnCountTrigger(20))
            .compactionStrategy(
                RecursiveSummarizationCompactionStrategy.builder(chatClientBuilder.build())
                    .maxEventsToKeep(10)
                    .build()
            )
            .build();
    }

    @Bean
    ChatClient chatClient(ChatClient.Builder chatClientBuilder, SessionMemoryAdvisor advisor) {
        return chatClientBuilder.defaultAdvisors(advisor).build();
    }

Pass a session ID at call time via the advisor context:

    String response = chatClient.prompt()
        .user("Hello!")
        .advisors(a -> a.param(SessionMemoryAdvisor.SESSION_ID_CONTEXT_KEY, "session-abc"))
        .call()
        .content();

If no session exists for the given ID, the advisor creates one automatically.

------------------------------------------------------------------------

## Multi-Agent Branch Isolation

When an orchestrator fans out to parallel sub-agents, all agents can share the same `Session` — but each must see only its own events plus its ancestors'. `SessionEvent.branch` is a dot-separated path that records the producing agent's position in the hierarchy:

    orchestrator        branch = "orch"
    ├── researcher      branch = "orch.researcher"
    └── writer          branch = "orch.writer"

Events with `branch = null` are root-level — visible to every agent. Pass `EventFilter.forBranch()` to apply isolation automatically inside the advisor:

    // Researcher sees: null-branch + "orch" + own "orch.researcher" events
    // Hidden: "orch.writer" (sibling)
    SessionMemoryAdvisor researcherAdvisor = SessionMemoryAdvisor.builder(sessionService)
        .defaultSessionId(sharedSessionId)
        .eventFilter(EventFilter.forBranch("orch.researcher"))
        .build();

Synthetic summary events from `RecursiveSummarizationCompactionStrategy` always carry `branch = null`, so compaction summaries remain visible to every agent in the session.

------------------------------------------------------------------------

## Recall Storage

Compaction improves prompt efficiency, but older events are removed from the active context window. `SessionEventTools` implements the MemGPT *Recall Storage* pattern: the full verbatim event log is always retained and searchable by keyword, even after compaction has pruned it from the prompt.

    ChatClient client = ChatClient.builder(chatModel)
        .defaultTools(SessionEventTools.builder(sessionService).build())
        .defaultAdvisors(advisor)
        .build();

The `conversation_search` tool is auto-discovered by Spring AI. When the model needs to recall a prior exchange it calls the tool with a keyword and an optional `page` index; results come back as chronologically ordered JSON. Synthetic summary events are searchable too — their text is indexed in the recall store.

------------------------------------------------------------------------

## JDBC Persistence

`spring-ai-session-jdbc` stores session data in two tables (`AI_SESSION` and `AI_SESSION_EVENT`, an append-only event log) with support for PostgreSQL, MySQL, MariaDB, and H2. The Spring Boot starter auto-configures everything:

    <dependency>
        <groupId>org.springaicommunity</groupId>
        <artifactId>spring-ai-starter-session-jdbc</artifactId>
    </dependency>

For PostgreSQL or MySQL, enable schema initialisation:

    spring:
      ai:
        session:
          repository:
            jdbc:
              initialize-schema: always

No additional bean declarations are required.

------------------------------------------------------------------------

## Getting Started

**Requirements:** Java 17+, Spring AI `2.0.0-M4+`, Spring Boot `4.0.2+`

**1. Import the BOM:**

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springaicommunity</groupId>
                <artifactId>spring-ai-session-bom</artifactId>
                <version>0.2.0</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

**2. Add a starter** — JDBC for production, or `spring-ai-session-management` alone for in-memory development:

    <dependency>
        <groupId>org.springaicommunity</groupId>
        <artifactId>spring-ai-starter-session-jdbc</artifactId>
    </dependency>

**3. Wire the advisor and use it:**

    @Bean
    SessionMemoryAdvisor sessionMemoryAdvisor(SessionService sessionService) {
        return SessionMemoryAdvisor.builder(sessionService)
            .defaultUserId("alice")
            .compactionTrigger(new TurnCountTrigger(20))
            .compactionStrategy(SlidingWindowCompactionStrategy.builder().maxEvents(10).build())
            .build();
    }

    @Bean
    ChatClient chatClient(ChatModel chatModel, SessionMemoryAdvisor advisor) {
        return ChatClient.builder(chatModel).defaultAdvisors(advisor).build();
    }

    Session session = sessionService.create(
        CreateSessionRequest.builder().userId("alice").build()
    );

    String response = chatClient.prompt()
        .user("What is Spring AI?")
        .advisors(a -> a.param(SessionMemoryAdvisor.SESSION_ID_CONTEXT_KEY, session.id()))
        .call()
        .content();

------------------------------------------------------------------------

## From ChatMemory to Session API

The Session API is designed to **replace** `ChatMemory` as Spring AI's primary conversation persistence abstraction:

<table>
<thead>
<tr>
<th></th>
<th><code>ChatMemory</code></th>
<th>Spring AI Session</th>
</tr>
</thead>
<tbody>
<tr>
<td>Storage unit</td>
<td><code>Message</code> (flat list)</td>
<td><code>SessionEvent</code> (immutable, timestamped, identified)</td>
</tr>
<tr>
<td>Compaction</td>
<td>Evict oldest messages</td>
<td>Four pluggable strategies incl. LLM summarization</td>
</tr>
<tr>
<td>Turn safety</td>
<td>Not enforced</td>
<td>All strategies snap to turn boundaries</td>
</tr>
<tr>
<td>Multi-agent</td>
<td>Not supported</td>
<td>Branch isolation with dot-separated labels</td>
</tr>
<tr>
<td>Recall search</td>
<td>Not available</td>
<td><code>conversation_search</code> tool via <code>SessionEventTools</code></td>
</tr>
<tr>
<td>Concurrency</td>
<td>Implementation-dependent</td>
<td>Optimistic CAS write in all implementations</td>
</tr>
</tbody>
</table>

The equivalent of `MessageWindowChatMemory.builder().maxMessages(20).build()` is:

    SessionMemoryAdvisor.builder(sessionService)
        .compactionTrigger(new TurnCountTrigger(20))
        .compactionStrategy(SlidingWindowCompactionStrategy.builder().maxEvents(20).build())
        .build();

------------------------------------------------------------------------

## Conclusion

Spring AI Session brings a structured, event-sourced **short-term memory** layer to the Spring AI ecosystem — with turn-safe compaction, LLM-powered summarization, multi-agent branch isolation, and keyword-searchable recall storage. Paired with `AutoMemoryTools` from [Part 6](https://spring.io/blog/2026/04/07/spring-ai-agentic-patterns-6-memory-tools), you now have both halves of a complete agent memory stack: a durable long-term layer for facts that outlive the session, and a coherent short-term layer for the active conversation. The library is available from the [spring-ai-community](https://github.com/spring-ai-community/spring-ai-session) organization.

------------------------------------------------------------------------

## Resources

- **GitHub**: [spring-ai-community/spring-ai-session](https://github.com/spring-ai-community/spring-ai-session)
- **Documentation**: [spring-ai-community.github.io/spring-ai-session](https://spring-ai-community.github.io/spring-ai-session/)
- **Spring AI Reference**: [docs.spring.io/spring-ai/reference](https://docs.spring.io/spring-ai/reference/)
- **ChatMemory API** (current): [Chat Memory Reference](https://docs.spring.io/spring-ai/reference/2.0-SNAPSHOT/api/chat-memory.html)

#### Agentic Patterns Series

- **Part 1**: [Agent Skills](https://spring.io/blog/2026/01/13/spring-ai-generic-agent-skills) — modular, reusable agent capabilities
- **Part 2**: [AskUserQuestionTool](https://spring.io/blog/2026/01/16/spring-ai-ask-user-question-tool) — interactive agent workflows
- **Part 3**: [TodoWriteTool](https://spring.io/blog/2026/01/20/spring-ai-agentic-patterns-3-todowrite/) — structured task management
- **Part 4**: [Subagent Orchestration](https://spring.io/blog/2026/01/27/spring-ai-agentic-patterns-4-task-subagents) — hierarchical multi-agent architectures
- **Part 5**: [A2A Integration](https://spring.io/blog/2026/01/29/spring-ai-agentic-patterns-a2a-integration) — building interoperable agents
- **Part 6**: [AutoMemoryTools](https://spring.io/blog/2026/04/07/spring-ai-agentic-patterns-6-memory-tools) — persistent long-term memory across sessions
- **Part 7**: Spring AI Session (this post) — structured short-term memory with turn-safe compaction

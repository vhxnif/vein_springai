#### *File-Based Long-Term Memory for Spring AI Agents*

Agents are only as useful as what they remember. Spring AI's [Chat Memory](https://docs.spring.io/spring-ai/reference/2.0-SNAPSHOT/api/chat-memory.html#page-title) stores the full conversation and can persist it across restarts, but when the window fills, the oldest messages are evicted. The upcoming `Session API` will add recursive summarization to soften this, but precise facts are still lost when details get compressed away.

`AutoMemoryTools` and `AutoMemoryToolsAdvisor`, part of the [spring-ai-agent-utils](https://github.com/spring-ai-community/spring-ai-agent-utils) toolkit, give your agents a **durable, file-based long-term memory** that persists across sessions. The design is inspired by [Claude Code's auto-memory system](https://code.claude.com/docs/en/memory#auto-memory) and the [Claude API Memory Tool spec](https://platform.claude.com/docs/en/agents-and-tools/tool-use/memory-tool) - ported to Spring AI so it works with any LLM provider.

**Long-Term Memory vs. Conversation History**

`ChatMemory` and `AutoMemoryTools` are complementary—a well-configured agent uses both. `ChatMemory` keeps the full conversation window: every turn, automatically, bounded by a sliding window. `AutoMemoryTools` is the curated layer: the AI model writes only what is *worth keeping forever*—a user preference, a project decision, a behavioral correction—to a typed Markdown file that survives indefinitely. Use `ChatMemory` for the current task; use `AutoMemoryTools` for facts that should still be available next week.

**This is Part 6 of our Spring AI Agentic Patterns series.** We've covered [Agent Skills](https://spring.io/blog/2026/01/13/spring-ai-generic-agent-skills), [AskUserQuestionTool](https://spring.io/blog/2026/01/16/spring-ai-ask-user-question-tool), [TodoWriteTool](https://spring.io/blog/2026/01/20/spring-ai-agentic-patterns-3-todowrite/), [Subagent Orchestration](https://spring.io/blog/2026/01/27/spring-ai-agentic-patterns-4-task-subagents), and [A2A Integration](https://spring.io/blog/2026/01/29/spring-ai-agentic-patterns-a2a-integration). Now we add memory that outlives the session.

🚀 **Want to jump right in?** Skip to the [Quick Start](#quick-start) section.

## How It Works

The agent manages its own memory through six targeted tools in `AutoMemoryTools`, all scoped to a sandboxed memories directory. The diagram below shows the full request flow:

![AutoMemoryTools execution flow](https://raw.githubusercontent.com/spring-io/spring-io-static/refs/heads/main/blog/tzolov/20260407/spring-ai-auto-memory-flow.png)

**① User request** — the request, combined with the memory system prompt, flows through the Spring AI advisor stack (`ToolCallAdvisor` + `ChatMemoryAdvisor`) to the LLM. The LLM decides whether to load, create, or update memories before answering.

**② Tool call** — the LLM invokes `AutoMemoryTools`. The tools read and write typed Markdown files in the configured memory directory — `MEMORY.md` as the index, plus individual topic files such as `user_profile.md` or `project_history.md`.

**③ Follow-up retrieve/update** — the LLM may issue additional tool calls to load specific memory files or update existing ones; for example, loading a file after finding its pointer in `MEMORY.md`, or merging entries during consolidation.

**④ Final response** — once all memory operations are complete, the LLM produces its answer, which flows back through the advisor stack to the user.

### Memory System Prompt

The memory system prompt drives this behaviour. Two variants ship in the jar:

- `AUTO_MEMORY_TOOLS_SYSTEM_PROMPT.md` — used with [Options A](#option-a-automemorytoolsadvisor-zero-boilerplate) & [Option B](#option-b-manual-setup-automemorytools-directly); dedicated, sandboxed `AutoMemoryTools`
- `AUTO_MEMORY_FILESYSTEM_TOOLS_SYSTEM_PROMPT.md` — used with [Option C](#option-c-filesystemtools--shelltools); generic `Read`/`Write`/`Edit` via `FileSystemTools`

Both memory system prompts encode the same memory model, differing only in which operations the model is told to call. They instruct the model to read `MEMORY.md` at session start, save via the two-step workflow (`MemoryCreate` → `MemoryInsert`), apply the four memory types, skip ephemeral content, verify recalled facts before acting on them, and keep the index in sync when deleting or renaming files.

### MEMORY.md — The Index File

`MEMORY.md` is the always-loaded index. It's a flat list of one-line pointers to all memory files:

    - [User Profile](user_profile.md) — Alice, backend engineer, prefers short answers
    - [Feedback Testing](feedback_testing.md) — always use real DB in integration tests
    - [Project Auth Rewrite](project_auth.md) — driven by legal compliance, not tech debt

The model reads this index at the start of each session, then selectively loads the files that look relevant—keeping the context window lean even as memory grows.

### Memory File Format

Each memory is a Markdown file with YAML frontmatter:

    ---
    name: user profile
    description: Alice — backend engineer, prefers short answers
    type: user
    ---

    Backend engineer named Alice.
    Prefers concise, direct responses without trailing summaries.

### Memory Types

Not everything is worth keeping. The memory model defines four types, each with clear guidance on what to save and when—so the agent accumulates signal, not noise:

- **`user`** — role, goals, expertise, communication style
- **`feedback`** — corrections and confirmed approaches ("stop summarizing", "yes, that was right")
- **`project`** — decisions and deadlines not in code or git (migration targets, freeze dates)
- **`reference`** — pointers to external systems (Linear boards, Grafana dashboards, Slack channels)

### Memory Operations

`AutoMemoryTools` exposes six purpose-named, sandboxed operations. Option C achieves the same outcome through the general-purpose `FileSystemTools` and `ShellTools` operations.

#### AutoMemoryTools

Options A and B use `AutoMemoryTools`, which implements the [Claude API Memory Tool specification](https://platform.claude.com/docs/en/agents-and-tools/tool-use/memory-tool) one-to-one with purpose-named, sandboxed operations:

<table>
<thead>
<tr>
<th>Tool</th>
<th>Purpose</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>MemoryView</code></td>
<td>Read a file with line numbers, or list a directory two levels deep</td>
</tr>
<tr>
<td><code>MemoryCreate</code></td>
<td>Create a new memory file (Step 1 of two-step save)</td>
</tr>
<tr>
<td><code>MemoryStrReplace</code></td>
<td>Replace an exact, unique string in an existing file</td>
</tr>
<tr>
<td><code>MemoryInsert</code></td>
<td>Insert text after a given line number—primary use: appending to <code>MEMORY.md</code></td>
</tr>
<tr>
<td><code>MemoryDelete</code></td>
<td>Delete a file or directory recursively</td>
</tr>
<tr>
<td><code>MemoryRename</code></td>
<td>Rename or move a file; updates <code>MEMORY.md</code> link separately</td>
</tr>
</tbody>
</table>

#### FileSystemTools & ShellTools

Option C uses the general-purpose `FileSystemTools` and `ShellTools` instead, mapping to the same operations:

<table>
<thead>
<tr>
<th>Operation</th>
<th>Equivalent to</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>Read</code></td>
<td><code>MemoryView</code></td>
</tr>
<tr>
<td><code>Write</code></td>
<td><code>MemoryCreate</code></td>
</tr>
<tr>
<td><code>Edit</code></td>
<td><code>MemoryStrReplace</code> / <code>MemoryInsert</code></td>
</tr>
<tr>
<td><code>Bash</code> (e.g. <code>rm</code>, <code>mv</code>)</td>
<td><code>MemoryDelete</code> / <code>MemoryRename</code></td>
</tr>
</tbody>
</table>

Options A and B sandbox all paths; Option C has no sandbox — the agent has full filesystem access.

## Integration Approaches

There are three ways to add long-term memory to a Spring AI agent, ranging from zero-boilerplate to fully manual. Choose based on how much control you need over the system prompt, the security concerns and whether your agent already uses general-purpose filesystem tools.

### Option A: AutoMemoryToolsAdvisor (zero-boilerplate)

Drop a single advisor into your `ChatClient` builder:

    ChatClient chatClient = ChatClient.builder(chatModel)
        .defaultAdvisors(
            // Long-term memory — facts that survive across sessions
            AutoMemoryToolsAdvisor.builder()
                .memoriesRootDirectory("/home/user/.agent/memories")
                .build(),

            // Conversation history — full message window for this session
            MessageChatMemoryAdvisor.builder(
                MessageWindowChatMemory.builder().maxMessages(100).build())
                .build(),

            // Tool calling
            ToolCallAdvisor.builder().disableInternalConversationHistory().build())
        .build();

On every request the advisor automatically injects `AUTO_MEMORY_TOOLS_SYSTEM_PROMPT.md` into the system message, registers all six `AutoMemoryTools` (deduplicating any existing registrations), and optionally appends a consolidation reminder if the `memoryConsolidationTrigger` fires.

![AutoMemoryTools Advisor](https://raw.githubusercontent.com/spring-io/spring-io-static/refs/heads/main/blog/tzolov/20260407/spring-ai-auto-memory-tools-advisor.png)

`AutoMemoryToolsAdvisor` runs first in the chain, augmenting the request context with the memory system prompt and the six tool definitions before handing off to `ToolCallAdvisor` and `ChatMemoryAdvisor`. By the time the enriched context reaches the LLM it already contains the conversation history, tool definitions, and memory instructions—everything the model needs to decide what to load, save, or update.

### Option B: Manual Setup (AutoMemoryTools directly)

Wire `AutoMemoryTools` into your `ChatClient` alongside the companion system prompt:

    @Value("classpath:/prompt/AUTO_MEMORY_TOOLS_SYSTEM_PROMPT.md")
    Resource memorySystemPrompt;

    @Value("${agent.memory.dir}")
    String memoryDir;

    ChatClient chatClient = chatClientBuilder
        .defaultSystem(p -> p
            .text(memorySystemPrompt)
            .param("MEMORIES_ROOT_DIERCTORY", memoryDir))
        .defaultTools(
            AutoMemoryTools.builder().memoriesDir(memoryDir).build(),
            TodoWriteTool.builder().build())
        .defaultAdvisors(ToolCallAdvisor.builder().build())
        .build();

Use this approach when you want full control over the system prompt structure—for example, combining memory with a custom main system prompt.

### Option C: FileSystemTools + ShellTools

If the agent already has `FileSystemTools` and `ShellTools` for other tasks, you can implement the same memory pattern without adding `AutoMemoryTools` at all. The agent uses the same `Read`, `Write`, and `Edit` operations it would use for any file work—memory is just another directory.

    @Value("classpath:/prompt/AUTO_MEMORY_FILESYSTEM_TOOLS_SYSTEM_PROMPT.md")
    Resource memorySystemPrompt;

    @Value("${agent.memory.dir}")
    String memoryDir;

    ChatClient chatClient = chatClientBuilder
        .defaultSystem(p -> p
            .text(memorySystemPrompt)
            .param("MEMORIES_ROOT_DIERCTORY", memoryDir))   // tells the agent where to write
        .defaultTools(
            ShellTools.builder().build(),         // Bash — mkdir, ls, etc.
            FileSystemTools.builder().build())    // Read, Write, Edit — memory file operations
        .defaultAdvisors(ToolCallAdvisor.builder().build())
        .build();

The same memory conventions apply—typed files, `MEMORY.md` index, two-step save—but there is **no sandbox**: the agent has full filesystem access and stays in the configured directory by convention only.

<table>
<thead>
<tr>
<th></th>
<th><code>AutoMemoryTools</code> (Options A &amp; B)</th>
<th><code>FileSystemTools</code> (Option C)</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>Path model</strong></td>
<td>Relative paths, sandboxed to memories root</td>
<td>Absolute paths, full filesystem access</td>
</tr>
<tr>
<td><strong>Safety</strong></td>
<td>Built-in traversal guard</td>
<td>No sandbox — agent follows prompt by convention</td>
</tr>
<tr>
<td><strong>Tool names</strong></td>
<td>Purpose-named (<code>MemoryCreate</code>, <code>MemoryView</code>, …)</td>
<td>Generic (<code>Write</code>, <code>Read</code>, <code>Edit</code>)</td>
</tr>
<tr>
<td><strong>Best for</strong></td>
<td>Memory-only agents, isolation required</td>
<td>Agents already using filesystem tools for other tasks</td>
</tr>
</tbody>
</table>

This approach follows the [Claude Code auto-memory pattern](https://code.claude.com/docs/en/memory) directly, where the same file tools serve both code editing and memory management.

> ⚠️ **Security note:** With `FileSystemTools`, the agent can read and write anywhere on the filesystem. Only use this approach in trusted, controlled environments.

## Keeping Memory Clean

Over time a memory store accumulates redundant, overlapping, or stale entries. Periodically asking the agent to consolidate—merge duplicates, drop outdated facts, tighten descriptions—keeps the store lean and the `MEMORY.md` index readable.

**Options B and C (explicit):** just ask:

    USER> Please consolidate your memory — merge duplicates and remove anything outdated.

**Option A (automatic trigger):** `AutoMemoryToolsAdvisor` accepts a `memoryConsolidationTrigger` predicate. When it returns `true`, a `<system-reminder>` is injected into the next request's system message, prompting the model to consolidate without the user having to ask. The demo uses a dual-condition trigger—time elapsed or the user says "bye":

    Instant lastInteraction = Instant.now();

    AutoMemoryToolsAdvisor.builder()
        .memoriesRootDirectory(memoryDir)
        .memoryConsolidationTrigger((request, instant) -> {
            var previous = lastInteraction;
            lastInteraction = Instant.now();

            // Consolidate when more than 60 seconds pass between turns
            if (instant.isAfter(previous.plusSeconds(60))) {
                return true;
            }
            // Also consolidate when the user says goodbye
            var msg = request.prompt().getLastUserOrToolResponseMessage().getText();
            return msg != null && msg.toLowerCase().contains("bye");
        })
        .build()

Other useful strategies:

    // Probabilistic: ~5% of requests
    .memoryConsolidationTrigger((req, now) -> Math.random() < 0.05)

    // Turn-count: every 50 calls
    AtomicInteger counter = new AtomicInteger();
    .memoryConsolidationTrigger((req, now) -> counter.incrementAndGet() % 50 == 0)

## Quick Start

### 1. Add the Dependency

    <dependency>
        <groupId>org.springaicommunity</groupId>
        <artifactId>spring-ai-agent-utils</artifactId>
        <version>0.7.0</version>
    </dependency>

> **Note:** For the latest stable release, check the [GitHub releases page](https://github.com/spring-ai-community/spring-ai-agent-utils/releases). Requires Spring AI `2.0.0-M4+`.

### 2. Configure the Memory Directory

    # application.properties
    agent.memory.dir=${user.home}/.spring-ai-agent/my-app/memory

### 3. Wire It Up

    @Value("${agent.memory.dir}")
    String memoryDir;

    ChatClient chatClient = chatClientBuilder
        .defaultAdvisors(
            // Long-term memory — facts that survive across sessions
            AutoMemoryToolsAdvisor.builder()
                .memoriesRootDirectory(memoryDir)
                .build(),

            // Conversation history — full message window for this session
            MessageChatMemoryAdvisor.builder(MessageWindowChatMemory.builder().maxMessages(100).build())
                .build(),

            // Tool calling
            ToolCallAdvisor.builder().disableInternalConversationHistory().build())
        .build();

### 4. See It in Action

First session:

    USER> My name is Alice. I'm a backend engineer and I prefer short answers.
    USER> Remember: we're migrating from PostgreSQL to CockroachDB this quarter.

Second session (new JVM process):

    USER> What do you know about me?
    ASSISTANT> You're Alice, a backend engineer. You prefer short answers.
               You're migrating from PostgreSQL to CockroachDB this quarter.

## Example Projects

Three runnable examples are available in the repository:

**[memory-tools-advisor-demo](https://github.com/spring-ai-community/spring-ai-agent-utils/tree/main/examples/memory/memory-tools-advisor-demo)** (Option A) — `AutoMemoryToolsAdvisor` + `ToolCallAdvisor` + `MessageChatMemoryAdvisor` + custom logging advisor, with a dual-condition consolidation trigger.

**[memory-tools-demo](https://github.com/spring-ai-community/spring-ai-agent-utils/tree/main/examples/memory/memory-tools-demo)** (Option B) — `AutoMemoryTools` wired manually alongside `TodoWriteTool`, showing explicit system prompt composition.

**[memory-filesystem-tools-demo](https://github.com/spring-ai-community/spring-ai-agent-utils/tree/main/examples/memory/memory-filesystem-tools-demo)** (Option C) — same memory conventions implemented with `FileSystemTools` + `ShellTools`, no dedicated memory tools required.

All three support Anthropic Claude, Google Gemini, and OpenAI—uncomment the desired provider in `pom.xml` and set the API key.

## Conclusion

`AutoMemoryTools` is a Spring AI port of the memory patterns Anthropic pioneered in [Claude Code](https://code.claude.com/docs/en/memory) and the [Claude API Memory Tool specification](https://platform.claude.com/docs/en/agents-and-tools/tool-use/memory-tool)—the `MEMORY.md` index, typed files, two-step save, and sandboxed six-operation API—available to any LLM provider via Spring AI.

Long-term memory is the missing layer between stateless LLM calls and truly useful agents. Add `AutoMemoryToolsAdvisor` and your agent starts accumulating knowledge that survives the session.

**Series links:**

- **Part 1**: [Agent Skills](https://spring.io/blog/2026/01/13/spring-ai-generic-agent-skills) — Modular, reusable capabilities
- **Part 2**: [AskUserQuestionTool](https://spring.io/blog/2026/01/16/spring-ai-ask-user-question-tool) — Interactive workflows
- **Part 3**: [TodoWriteTool](https://spring.io/blog/2026/01/20/spring-ai-agentic-patterns-3-todowrite/) — Structured planning
- **Part 4**: [Subagent Orchestration](https://spring.io/blog/2026/01/27/spring-ai-agentic-patterns-4-task-subagents) — Hierarchical agent architectures
- **Part 5**: [A2A Integration](https://spring.io/blog/2026/01/29/spring-ai-agentic-patterns-a2a-integration) — Building interoperable agents
- **Part 6**: AutoMemoryTools (this post) — Long-term memory across sessions

## Resources

#### Spring AI Agent Utils

- **GitHub**: [spring-ai-agent-utils](https://github.com/spring-ai-community/spring-ai-agent-utils)
- **AutoMemoryTools docs**: [AutoMemoryTools](https://spring-ai-community.github.io/spring-ai-agent-utils/latest-snapshot/tools/AutoMemoryTools/)
- **AutoMemoryToolsAdvisor docs**: [AutoMemoryToolsAdvisor](https://spring-ai-community.github.io/spring-ai-agent-utils/latest-snapshot/tools/AutoMemoryToolsAdvisor/)
- **Full documentation**: [spring-ai-community.github.io/spring-ai-agent-utils](https://spring-ai-community.github.io/spring-ai-agent-utils/latest-snapshot/)

#### Example Projects

- [memory-tools-advisor-demo](https://github.com/spring-ai-community/spring-ai-agent-utils/tree/main/examples/memory/memory-tools-advisor-demo) — full advisor stack (Option A)
- [memory-tools-demo](https://github.com/spring-ai-community/spring-ai-agent-utils/tree/main/examples/memory/memory-tools-demo) — manual setup (Option B)
- [memory-filesystem-tools-demo](https://github.com/spring-ai-community/spring-ai-agent-utils/tree/main/examples/memory/memory-filesystem-tools-demo) — filesystem tools approach (Option C)

![](https://raw.githubusercontent.com/spring-io/spring-io-static/refs/heads/main/blog/igopinathan/20260129/spring-ai-a2a-logo.png)

The **Agent2Agent (A2A) Protocol** is an open standard for seamless AI agent communication. It enables agents to discover capabilities, exchange messages, and coordinate workflows across platforms—regardless of their implementation.

**[Spring AI A2A](https://github.com/spring-ai-community/spring-ai-a2a)** integrates the A2A Java SDK with Spring AI through Spring Boot autoconfiguration. It seamlessly connects the A2A protocol with Spring AI's `ChatClient` and tools, enabling you to expose your agents as A2A servers.

This post is part of the **Spring AI Agentic Patterns** series. While previous posts covered making individual agents more capable ([Agent Skills](https://spring.io/blog/2026/01/13/spring-ai-generic-agent-skills/), [AskUserQuestionTool](https://spring.io/blog/2026/01/16/spring-ai-ask-user-question-tool/), [TodoWriteTool](https://spring.io/blog/2026/01/20/spring-ai-agentic-patterns-3-todowrite/), [Sub-agent orchestration](https://spring.io/blog/2026/01/27/spring-ai-agentic-patterns-4-task-subagents/)), this post shows how the A2A Protocol enables agents to collaborate across system boundaries through practical examples.

## Agent2Agent (A2A) Protocol

The [A2A Protocol](https://a2a-protocol.org/) is an open standard for AI agent communication, providing a vendor-neutral foundation that enables agents to discover capabilities, exchange messages, and coordinate workflows. Built on HTTP, SSE, and JSON-RPC standards.

**Agent Discovery** is the foundation of A2A communication. Agents discover each other's capabilities through the **AgentCard**—a standardized JSON document exposed at `/.well-known/agent-card.json` that describes an agent's identity, capabilities, and skills. This follows a three-step pattern: **Discovery** → **Initiation** → **Completion**.

The protocol defines two roles: **A2A Server** agents expose endpoints for discovery and message handling, while **A2A Client** agents initiate communication by discovering remote agents and sending messages.

The **[A2A Java SDK](https://github.com/a2aproject/a2a-java)** provides a Java implementation with server-side components for processing requests and managing tasks, and client-side components for calling remote agents. It supports multiple transports (HTTP, SSE, JSON-RPC) and handles low-level protocol details.

## Spring AI A2A Integration

While the A2A Java SDK provides the protocol implementation, integrating it with Spring AI requires additional plumbing. This is where the **Spring AI A2A** project comes in.

The `spring-ai-a2a` project currently focuses on the **server-side integration**, enabling you to expose your Spring AI agents as A2A-compliant servers.

![](https://raw.githubusercontent.com/spring-io/spring-io-static/refs/heads/main/blog/igopinathan/20260129/spring-ai-a2a-integration.png)

This covers:

- **Spring Boot Auto-configuration**: Autoconfigured A2A endpoints
- **Spring AI Integration**: Direct integration with Spring AI's `ChatClient` and `tools`
- **JSON-RPC Transport via REST Controllers**: Currently implements JSON-RPC transport for agent communication. Controllers provide endpoints for agent cards and message handling.
- **AgentExecutor Implementation**: `DefaultAgentExecutor` that bridges A2A SDK and Spring AI

Here's what the integration handles for you:

    // The framework automatically exposes these A2A endpoints (relative to your context path):
    POST   /                                  // Handle JSON-RPC sendMessage requests
    GET    /.well-known/agent-card.json      // Agent card (standard A2A location)
    GET    /card                              // Agent card (alternative endpoint)

## How It Works

![](https://raw.githubusercontent.com/spring-io/spring-io-static/refs/heads/main/blog/igopinathan/20260129/spring-ai-a2a-flow.png)

**Step-by-step:**

1.  **Agent Discovery** : Before communication begins, the client fetches the server's `AgentCard` from `/.well-known/agent-card.json` to discover capabilities, skills, and protocol details
2.  **Request Reception**: `MessageController` receives the A2A JSON-RPC `sendMessage` request at the root endpoint
3.  **Execution**: Routes to your `AgentExecutor` bean (Spring AI A2A provides the default implementation: `DefaultAgentExecutor`)
4.  **Handler Invocation**: The `ChatClientExecutorHandler` lambda is invoked with the Spring AI ChatClient and request context
5.  **Spring AI ChatClient Response**: The Spring AI `ChatClient` response is packaged as an A2A JSON-RPC message

## Getting Started

Let's build interoperable agent systems with Spring AI A2A. We'll start with prerequisites and setup, then work through practical examples: a single-agent server and a multi-agent orchestration.

### Prerequisites

- Java 17 or later
- Spring Boot 4.0.1
- Spring AI 2.0.0-M2
- An LLM provider (OpenAI, Anthropic, etc.)

### Dependencies

Add the Spring AI A2A starter to your project to expose your Spring AI agent as an A2A server:

    <dependency>
       <groupId>org.springaicommunity</groupId>
       <artifactId>spring-ai-a2a-server-autoconfigure</artifactId>
       <version>0.2.0</version>
    </dependency>

This starter includes the A2A Java SDK (v0.3.3.Final) as a transitive dependency.

For applications that need to call remote A2A agents, explicitly add the A2A SDK client:

    <dependency>
       <groupId>io.github.a2asdk</groupId>
       <artifactId>a2a-java-sdk-client</artifactId>
       <version>0.3.3.Final</version>
    </dependency>

### Configuration

Configure your application in `application.properties`:

    # Server configuration
    server.servlet.context-path=/weather

    # LLM Configuration (example with Anthropic Claude)
    spring.ai.anthropic.api-key=${ANTHROPIC_API_KEY}
    spring.ai.anthropic.chat.options.model=claude-sonnet-4-5-20250929

    # For multi-agent orchestration (Example 2), configure remote agent URLs:
    # remote.agents.urls=http://localhost:10001/foo/,http://localhost:10002/bar/

### Example 1: Agent Server

Expose a Spring AI application with tools as an A2A server:

    @Configuration
    public class WeatherAgentConfiguration {

       @Bean
       public AgentCard agentCard(@Value("${server.port:8080}") int port,
               @Value("${server.servlet.context-path:/}") String contextPath) {
           // This AgentCard is automatically exposed at /.well-known/agent-card.json
           // Other agents discover this agent's capabilities through this endpoint
           return new AgentCard.Builder()
               .name("Weather Agent")
               .description("Provides weather information for cities")
               .url("http://localhost:" + port + contextPath + "/")
               .version("1.0.0")
               .capabilities(new AgentCapabilities.Builder().streaming(false).build())
               .defaultInputModes(List.of("text"))
               .defaultOutputModes(List.of("text"))
               .skills(List.of(new AgentSkill.Builder()
                   .id("weather_search")
                   .name("Search weather")
                   .description("Get temperature for any city")
                   .tags(List.of("weather"))
                   .examples(List.of("What's the weather in London?"))
                   .build()))
               .protocolVersion("0.3.0")
               .build();
       }

       @Bean
       public AgentExecutor agentExecutor(ChatClient.Builder chatClientBuilder, WeatherTools weatherTools) {

           ChatClient chatClient = chatClientBuilder.clone()
               .defaultSystem("You are a weather assistant. Use the temperature tool to answer questions.")
               .defaultTools(weatherTools)  // Register Spring AI tools
               .build();

           return new DefaultAgentExecutor(chatClient, (chat, requestContext) -> {
               String userMessage = DefaultAgentExecutor.extractTextFromMessage(requestContext.getMessage());
               return chat.prompt().user(userMessage).call().content();
           });
       }
    }

    @Service
    class WeatherTools {
        ...
    }

Your Spring AI agent is now an A2A-compliant server. Other agents can **discover** its capabilities through the standard `/.well-known/agent-card.json` endpoint and then send weather queries via POST to the root endpoint. The autoconfiguration handles exposing both the AgentCard and message endpoints.

### Example 2: Agent Client

Here's a practical example of an agent client: A host agent that orchestrates specialized agents for travel planning (Airbnb accommodations and weather information).

    @Service
    public class RemoteAgentConnections {

       private final Map<String, AgentCard> agentCards = new HashMap<>();

       public RemoteAgentConnections(@Value("${remote.agents.urls}") List<String> agentUrls) {
           // Discover remote agents at startup (see Agent Discovery section above)
           for (String url : agentUrls) {
               String path = new URI(url).getPath();
               AgentCard card = A2A.getAgentCard(url, path + ".well-known/agent-card.json", null);
               this.agentCards.put(card.name(), card);
           }
       }

       @Tool(description = "Sends a task to a remote agent. Use this to delegate work to specialized agents.")
       public String sendMessage(
               @ToolParam(description = "The name of the agent") String agentName,
               @ToolParam(description = "The task description to send") String task) {

           AgentCard agentCard = this.agentCards.get(agentName);

           // Create A2A message
           Message message = new Message.Builder()
               .role(Message.Role.USER)
               .parts(List.of(new TextPart(task, null)))
               .build();

           // Use A2A Java SDK Client
           CompletableFuture<String> responseFuture = new CompletableFuture<>();

           Client client = Client.builder(agentCard)
               .clientConfig(new ClientConfig.Builder()
                   .setAcceptedOutputModes(List.of("text"))
                   .build())
               .withTransport(JSONRPCTransport.class, new JSONRPCTransportConfig())
               .addConsumers(List.of(consumer -> {
                   if (consumer instanceof TextPart textPart) {
                       responseFuture.complete(textPart.getText());
                   }
               }))
               .build();

           client.sendMessage(message);
           return responseFuture.get(60, TimeUnit.SECONDS);
       }

       public String getAgentDescriptions() {
           return agentCards.values().stream()
               .map(card -> card.name() + ": " + card.description())
               .collect(Collectors.joining("\n"));
       }
    }

    @Configuration
    public class HostAgentConfiguration {

       @Bean
       public ChatClient routingChatClient(ChatClient.Builder chatClientBuilder,
               RemoteAgentConnections remoteAgentConnections) {

           String systemPrompt = """
               You coordinate tasks across specialized agents.
               Available agents:
               %s
               Use the sendMessage tool to delegate tasks to the appropriate agent.
               """.formatted(remoteAgentConnections.getAgentDescriptions());

           return chatClientBuilder
               .defaultSystem(systemPrompt)
               .defaultTools(remoteAgentConnections)  // Register as Spring AI tool
               .build();
       }
    }

**What's happening here:**

1.  The host agent (client) **discovers** remote agents at startup by fetching their `AgentCard` from the standard `.well-known/agent-card.json` endpoints
2.  `RemoteAgentConnections` is registered as a Spring AI `@Tool` with the `ChatClient`
3.  When a user asks "Plan a trip to London", the LLM decides which agents to call via the `sendMessage` tool
4.  The tool uses the **A2A Java SDK Client** to communicate with remote agents
5.  Results are aggregated and returned to the user

This pattern enables LLM-driven routing—the model decides which specialized agents to invoke based on the user's query.

## What's Next

While the current release focuses on server-side integration, the Spring AI community is exploring opportunities to enhance the A2A client experience for Spring AI applications.

**Potential Future Enhancements:**

- **Security**: Support for A2A authentication and authorization
- **Agent Discovery**: Spring Boot autoconfiguration for discovering and routing to A2A agents
- **Client Auto-configuration**: Autoconfigured A2A client connections with Spring-friendly abstractions
- **Multiple Transport Support**: SSE (Server-Sent Events) for real-time streaming responses, expanding beyond the current JSON-RPC implementation
- **Enhanced Observability**: Spring Boot Actuator integration for monitoring A2A interactions

These enhancements would provide additional support for building Spring AI applications that act as A2A agent clients, providing consistent integration patterns for both client and server implementations.

**Want to contribute?** The Spring AI A2A project welcomes community contributions. Check out the [GitHub repository](https://github.com/spring-ai-community/spring-ai-a2a) to get involved.

## Conclusion

The A2A Protocol represents a significant step toward interoperable AI agent ecosystems. By standardizing how agents communicate, it removes barriers to building sophisticated multi-agent systems.

The Spring AI A2A community project provides the integration needed to participate in this ecosystem. Through Spring Boot autoconfiguration, you can expose your Spring AI agents as A2A servers, integrate with other A2A-compliant agents, and build orchestration patterns that leverage Spring Boot's conventions.

As the A2A ecosystem grows, more agents, tools, and platforms may adopt this standard, expanding options for agent collaboration and composition.

To begin integrating A2A Protocol support with your Spring AI agents, refer to the resources below.

## Resources

- [A2A Protocol Specification](https://a2a-protocol.org/)
- [A2A Java SDK](https://github.com/a2aproject/a2a-java)
- [Spring AI A2A Community Project](https://github.com/spring-ai-community/spring-ai-a2a)
- [Spring AI Documentation](https://docs.spring.io/spring-ai/reference/)
- [Example: Travel Planner Multi-Agent System](https://github.com/spring-ai-community/spring-ai-a2a/tree/main/spring-ai-a2a-examples/airbnb-planner)

#### Series Links

- **Part 1**: [Agent Skills](https://spring.io/blog/2026/01/13/spring-ai-generic-agent-skills) - Modular, reusable capabilities
- **Part 2**: [AskUserQuestionTool](https://spring.io/blog/2026/01/16/spring-ai-ask-user-question-tool) - Interactive workflows
- **Part 3**: [TodoWriteTool](https://spring.io/blog/2026/01/20/spring-ai-agentic-patterns-3-todowrite/) - Structured planning
- **Part 4**: [Subagent Orchestration](https://spring.io/blog/2026/01/27/spring-ai-agentic-patterns-4-task-subagents) - Hierarchical agent architectures
- **Part 5**: A2A Integration (this post) - Building interoperable agents with the Agent2Agent protocol
- **Part (soon)**: Subagent Extension Framework (coming soon) - Protocol-agnostic agent orchestration

#### Related Spring AI Blogs

- [Dynamic Tool Discovery](https://spring.io/blog/2025/12/11/spring-ai-tool-search-tools-tzolov) - Achieve 34-64% token savings
- [Tool Argument Augmentation](https://spring.io/blog/2025/12/23/spring-ai-tool-argument-augmenter-tzolov) - Capture LLM reasoning during tool execution

Search

## Streamable-HTTP MCP Servers

The Streamable HTTP transport allows MCP servers to operate as independent processes that can handle multiple client connections using HTTP POST and GET requests, with optional Server-Sent Events (SSE) streaming for multiple server messages. It replaces the SSE transport.

These servers, introduced with spec version 2025-03-26, are ideal for applications that need to notify clients about dynamic changes to tools, resources, or prompts.

### Streamable-HTTP WebMVC Server

Use the `spring-ai-starter-mcp-server-webmvc` dependency:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-mcp-server-webmvc</artifactId>
    </dependency>

and set the `spring.ai.mcp.server.protocol` property to `STREAMABLE`.

- Full MCP server capabilities with Spring MVC Streamable transport

- Support for tools, resources, prompts, completion, logging, progression, ping, root-changes capabilities

- Persistent connection management

### Streamable-HTTP WebFlux Server

Use the `spring-ai-starter-mcp-server-webflux` dependency:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-mcp-server-webflux</artifactId>
    </dependency>

and set the `spring.ai.mcp.server.protocol` property to `STREAMABLE`.

- Reactive MCP server with WebFlux Streamable transport

- Support for tools, resources, prompts, completion, logging, progression, ping, root-changes capabilities

- Non-blocking, persistent connection management

## Configuration Properties

### Common Properties

All common properties are prefixed with `spring.ai.mcp.server`:

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Property</th>
<th class="tableblock halign-left valign-top">Description</th>
<th class="tableblock halign-left valign-top">Default</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>enabled</code></p></td>
<td class="tableblock halign-left valign-top"><p>Enable/disable the streamable MCP server</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>protocol</code></p></td>
<td class="tableblock halign-left valign-top"><p>MCP server protocol</p></td>
<td class="tableblock halign-left valign-top"><p>Must be set to <code>STREAMABLE</code> to enable the streamable server</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>tool-callback-converter</code></p></td>
<td class="tableblock halign-left valign-top"><p>Enable/disable the conversion of Spring AI ToolCallbacks into MCP Tool specs</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>name</code></p></td>
<td class="tableblock halign-left valign-top"><p>Server name for identification</p></td>
<td class="tableblock halign-left valign-top"><p><code>mcp-server</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>version</code></p></td>
<td class="tableblock halign-left valign-top"><p>Server version</p></td>
<td class="tableblock halign-left valign-top"><p><code>1.0.0</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>instructions</code></p></td>
<td class="tableblock halign-left valign-top"><p>Optional instructions for client interaction</p></td>
<td class="tableblock halign-left valign-top"><p><code>null</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>type</code></p></td>
<td class="tableblock halign-left valign-top"><p>Server type (SYNC/ASYNC)</p></td>
<td class="tableblock halign-left valign-top"><p><code>SYNC</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>capabilities.resource</code></p></td>
<td class="tableblock halign-left valign-top"><p>Enable/disable resource capabilities</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>capabilities.tool</code></p></td>
<td class="tableblock halign-left valign-top"><p>Enable/disable tool capabilities</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>capabilities.prompt</code></p></td>
<td class="tableblock halign-left valign-top"><p>Enable/disable prompt capabilities</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>capabilities.completion</code></p></td>
<td class="tableblock halign-left valign-top"><p>Enable/disable completion capabilities</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>resource-change-notification</code></p></td>
<td class="tableblock halign-left valign-top"><p>Enable resource change notifications</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>prompt-change-notification</code></p></td>
<td class="tableblock halign-left valign-top"><p>Enable prompt change notifications</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>tool-change-notification</code></p></td>
<td class="tableblock halign-left valign-top"><p>Enable tool change notifications</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>expose-mcp-client-tools</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to re-expose downstream MCP tools (provided by MCP clients) as tools in this MCP server</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>tool-response-mime-type</code></p></td>
<td class="tableblock halign-left valign-top"><p>Response MIME type per tool name</p></td>
<td class="tableblock halign-left valign-top"><p><code>-</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>request-timeout</code></p></td>
<td class="tableblock halign-left valign-top"><p>Request timeout duration</p></td>
<td class="tableblock halign-left valign-top"><p><code>20 seconds</code></p></td>
</tr>
</tbody>
</table>

### MCP Annotations Properties

MCP Server Annotations provide a declarative way to implement MCP server handlers using Java annotations.

The server mcp-annotations properties are prefixed with `spring.ai.mcp.server.annotation-scanner`:

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 30%" />
<col style="width: 40%" />
<col style="width: 30%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Property</th>
<th class="tableblock halign-left valign-top">Description</th>
<th class="tableblock halign-left valign-top">Default Value</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>enabled</code></p></td>
<td class="tableblock halign-left valign-top"><p>Enable/disable the MCP server annotations auto-scanning</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
</tbody>
</table>

### Streamable-HTTP Properties

All streamable-HTTP properties are prefixed with `spring.ai.mcp.server.streamable-http`:

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Property</th>
<th class="tableblock halign-left valign-top">Description</th>
<th class="tableblock halign-left valign-top">Default</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>mcp-endpoint</code></p></td>
<td class="tableblock halign-left valign-top"><p>Custom MCP endpoint path</p></td>
<td class="tableblock halign-left valign-top"><p><code>/mcp</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>keep-alive-interval</code></p></td>
<td class="tableblock halign-left valign-top"><p>Connection keep-alive interval</p></td>
<td class="tableblock halign-left valign-top"><p><code>null</code> (disabled)</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>disallow-delete</code></p></td>
<td class="tableblock halign-left valign-top"><p>Disallow delete operations</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
</tbody>
</table>

## Features and Capabilities

The MCP Server supports four main capability types that can be individually enabled or disabled:

- **Tools** - Enable/disable tool capabilities with `spring.ai.mcp.server.capabilities.tool=true|false`

- **Resources** - Enable/disable resource capabilities with `spring.ai.mcp.server.capabilities.resource=true|false`

- **Prompts** - Enable/disable prompt capabilities with `spring.ai.mcp.server.capabilities.prompt=true|false`

- **Completions** - Enable/disable completion capabilities with `spring.ai.mcp.server.capabilities.completion=true|false`

All capabilities are enabled by default. Disabling a capability will prevent the server from registering and exposing the corresponding features to clients.

The MCP Server Boot Starter allows servers to expose tools, resources, and prompts to clients. It automatically converts custom capability handlers registered as Spring beans to sync/async specifications based on the server type:

### Tools

Allows servers to expose tools that can be invoked by language models. The MCP Server Boot Starter provides:

- Change notification support

- Spring AI Tools are automatically converted to sync/async specifications based on the server type

- Automatic tool specification through Spring beans:

    @Bean
    public ToolCallbackProvider myTools(...) {
        List<ToolCallback> tools = ...
        return ToolCallbackProvider.from(tools);
    }

or using the low-level API:

    @Bean
    public List<McpServerFeatures.SyncToolSpecification> myTools(...) {
        List<McpServerFeatures.SyncToolSpecification> tools = ...
        return tools;
    }

The auto-configuration will automatically detect and register all tool callbacks from:

- Individual `ToolCallback` beans

- Lists of `ToolCallback` beans

- `ToolCallbackProvider` beans

Tools are de-duplicated by name, with the first occurrence of each tool name being used.

#### Tool Context Support

The ToolContext is supported, allowing contextual information to be passed to tool calls. It contains an `McpSyncServerExchange` instance under the `exchange` key, accessible via `McpToolUtils.getMcpExchange(toolContext)`. See this example demonstrating `exchange.loggingNotification(…​)` and `exchange.createMessage(…​)`.

### Resources

Provides a standardized way for servers to expose resources to clients.

- Static and dynamic resource specifications

- Optional change notifications

- Support for resource templates

- Automatic conversion between sync/async resource specifications

- Automatic resource specification through Spring beans:

    @Bean
    public List<McpServerFeatures.SyncResourceSpecification> myResources(...) {
        var systemInfoResource = new McpSchema.Resource(...);
        var resourceSpecification = new McpServerFeatures.SyncResourceSpecification(systemInfoResource, (exchange, request) -> {
            try {
                var systemInfo = Map.of(...);
                String jsonContent = new JsonMapper().writeValueAsString(systemInfo);
                return new McpSchema.ReadResourceResult(
                        List.of(new McpSchema.TextResourceContents(request.uri(), "application/json", jsonContent)));
            }
            catch (Exception e) {
                throw new RuntimeException("Failed to generate system info", e);
            }
        });

        return List.of(resourceSpecification);
    }

### Prompts

Provides a standardized way for servers to expose prompt templates to clients.

- Change notification support

- Template versioning

- Automatic conversion between sync/async prompt specifications

- Automatic prompt specification through Spring beans:

    @Bean
    public List<McpServerFeatures.SyncPromptSpecification> myPrompts() {
        var prompt = new McpSchema.Prompt("greeting", "A friendly greeting prompt",
            List.of(new McpSchema.PromptArgument("name", "The name to greet", true)));

        var promptSpecification = new McpServerFeatures.SyncPromptSpecification(prompt, (exchange, getPromptRequest) -> {
            String nameArgument = (String) getPromptRequest.arguments().get("name");
            if (nameArgument == null) { nameArgument = "friend"; }
            var userMessage = new PromptMessage(Role.USER, TextContent.builder("Hello " + nameArgument + "! How can I assist you today?").build());
            return GetPromptResult.builder(List.of(userMessage)).description("A personalized greeting message").build();
        });

        return List.of(promptSpecification);
    }

### Completions

Provides a standardized way for servers to expose completion capabilities to clients.

- Support for both sync and async completion specifications

- Automatic registration through Spring beans:

    @Bean
    public List<McpServerFeatures.SyncCompletionSpecification> myCompletions() {
        var completion = new McpServerFeatures.SyncCompletionSpecification(
            new McpSchema.PromptReference(
                        "ref/prompt", "code-completion", "Provides code completion suggestions"),
            (exchange, request) -> {
                // Implementation that returns completion suggestions
                return new McpSchema.CompleteResult(List.of("python", "pytorch", "pyside"), 10, true);
            }
        );

        return List.of(completion);
    }

### Logging

Provides a standardized way for servers to send structured log messages to clients. From within the tool, resource, prompt or completion call handler use the provided `McpSyncServerExchange`/`McpAsyncServerExchange` `exchange` object to send logging messages:

    (exchange, request) -> {
            exchange.loggingNotification(LoggingMessageNotification.builder(LoggingLevel.INFO, "This is a test log message")
                .logger("test-logger")
                .build());
    }

On the MCP client you can register logging consumers to handle these messages:

    mcpClientSpec.loggingConsumer((McpSchema.LoggingMessageNotification log) -> {
        // Handle log messages
    });

### Progress

Provides a standardized way for servers to send progress updates to clients. From within the tool, resource, prompt or completion call handler use the provided `McpSyncServerExchange`/`McpAsyncServerExchange` `exchange` object to send progress notifications:

    (exchange, request) -> {
            exchange.progressNotification(ProgressNotification.builder("test-progress-token", 0.25)
                .total(1.0)
                .message("tool call in progress")
                .build());
    }

The Mcp Client can receive progress notifications and update its UI accordingly. For this it needs to register a progress consumer.

    mcpClientSpec.progressConsumer((McpSchema.ProgressNotification progress) -> {
        // Handle progress notifications
    });

### Root List Changes

When roots change, clients that support `listChanged` send a root change notification.

- Support for monitoring root changes

- Automatic conversion to async consumers for reactive applications

- Optional registration through Spring beans

    @Bean
    public BiConsumer<McpSyncServerExchange, List<McpSchema.Root>> rootsChangeHandler() {
        return (exchange, roots) -> {
            logger.info("Registering root resources: {}", roots);
        };
    }

### Ping

Ping mechanism for the server to verify that its clients are still alive. From within the tool, resource, prompt or completion call handler use the provided `McpSyncServerExchange`/`McpAsyncServerExchange` `exchange` object to send ping messages:

    (exchange, request) -> {
            exchange.ping();
    }

### Keep Alive

Server can optionally, periodically issue pings to connected clients to verify connection health.

By default, keep-alive is disabled. To enable keep-alive, set the `keep-alive-interval` property in your configuration:

    spring:
      ai:
        mcp:
          server:
            streamable-http:
              keep-alive-interval: 30s

## Usage Examples

### Streamable HTTP Server Configuration

    # Using spring-ai-starter-mcp-server-streamable-webmvc
    spring:
      ai:
        mcp:
          server:
            protocol: STREAMABLE
            name: streamable-mcp-server
            version: 1.0.0
            type: SYNC
            instructions: "This streamable server provides real-time notifications"
            resource-change-notification: true
            tool-change-notification: true
            prompt-change-notification: true
            streamable-http:
              mcp-endpoint: /api/mcp
              keep-alive-interval: 30s

### Creating a Spring Boot Application with MCP Server

    @Service
    public class WeatherService {

        @Tool(description = "Get weather information by city name")
        public String getWeather(String cityName) {
            // Implementation
        }
    }

    @SpringBootApplication
    public class McpServerApplication {

        private static final Logger logger = LoggerFactory.getLogger(McpServerApplication.class);

        public static void main(String[] args) {
            SpringApplication.run(McpServerApplication.class, args);
        }

        @Bean
        public ToolCallbackProvider weatherTools(WeatherService weatherService) {
            return MethodToolCallbackProvider.builder().toolObjects(weatherService).build();
        }
    }

The auto-configuration will automatically register the tool callbacks as MCP tools. You can have multiple beans producing ToolCallbacks, and the auto-configuration will merge them.

STDIO and SSE MCP Servers Stateless Streamable-HTTP MCP Servers

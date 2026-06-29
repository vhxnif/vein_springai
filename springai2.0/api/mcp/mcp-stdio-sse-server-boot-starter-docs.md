Search

## STDIO and SSE MCP Servers

The STDIO and SSE MCP Servers support multiple transport mechanisms, each with its dedicated starter.

### STDIO MCP Server

Full MCP Server feature support with `STDIO` server transport.

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-mcp-server</artifactId>
    </dependency>

- Suitable for command-line and desktop tools

- No additional web dependencies required

- Configuration of basic server components

- Handling of tool, resource, and prompt specifications

- Management of server capabilities and change notifications

- Support for both sync and async server implementations

### SSE WebMVC Server

Full MCP Server feature support with `SSE` (Server-Sent Events) server transport based on Spring MVC and an optional `STDIO` transport.

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-mcp-server-webmvc</artifactId>
    </dependency>

- HTTP-based transport using Spring MVC (`WebMvcSseServerTransportProvider`)

- Automatically configured SSE endpoints

- Optional `STDIO` transport (enabled by setting `spring.ai.mcp.server.stdio=true`)

- Includes `spring-boot-starter-web` and `org.springframework.ai:mcp-spring-webmvc` dependencies

### SSE WebFlux Server

Full MCP Server feature support with `SSE` (Server-Sent Events) server transport based on Spring WebFlux and an optional `STDIO` transport.

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-mcp-server-webflux</artifactId>
    </dependency>

The starter activates the `McpWebFluxServerAutoConfiguration` and `McpServerAutoConfiguration` auto-configurations to provide:

- Reactive transport using Spring WebFlux (`WebFluxSseServerTransportProvider`)

- Automatically configured reactive SSE endpoints

- Optional `STDIO` transport (enabled by setting `spring.ai.mcp.server.stdio=true`)

- Includes `spring-boot-starter-webflux` and `org.springframework.ai:mcp-spring-webflux` dependencies

## Configuration Properties

### Common Properties

All Common properties are prefixed with `spring.ai.mcp.server`:

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
<td class="tableblock halign-left valign-top"><p>Enable/disable the MCP server</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>tool-callback-converter</code></p></td>
<td class="tableblock halign-left valign-top"><p>Enable/disable the conversion of Spring AI ToolCallbacks into MCP Tool specs</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>stdio</code></p></td>
<td class="tableblock halign-left valign-top"><p>Enable/disable STDIO transport</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
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
<td class="tableblock halign-left valign-top"><p>Optional instructions to provide guidance to the client on how to interact with this server</p></td>
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
<td class="tableblock halign-left valign-top"><p>Optional response MIME type per tool name. For example, <code>spring.ai.mcp.server.tool-response-mime-type.generateImage=image/png</code> will associate the <code>image/png</code> MIME type with the <code>generateImage()</code> tool name</p></td>
<td class="tableblock halign-left valign-top"><p><code>-</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>request-timeout</code></p></td>
<td class="tableblock halign-left valign-top"><p>Duration to wait for server responses before timing out requests. Applies to all requests made through the client, including tool calls, resource access, and prompt operations</p></td>
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

### SSE Properties

All SSE properties are prefixed with `spring.ai.mcp.server`:

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
<td class="tableblock halign-left valign-top"><p><code>sse-message-endpoint</code></p></td>
<td class="tableblock halign-left valign-top"><p>Custom SSE message endpoint path for web transport to be used by the client to send messages</p></td>
<td class="tableblock halign-left valign-top"><p><code>/mcp/message</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>sse-endpoint</code></p></td>
<td class="tableblock halign-left valign-top"><p>Custom SSE endpoint path for web transport</p></td>
<td class="tableblock halign-left valign-top"><p><code>/sse</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>base-url</code></p></td>
<td class="tableblock halign-left valign-top"><p>Optional URL prefix. For example, <code>base-url=/api/v1</code> means that the client should access the SSE endpoint at <code>/api/v1</code> + <code>sse-endpoint</code> and the message endpoint is <code>/api/v1</code> + <code>sse-message-endpoint</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>-</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>keep-alive-interval</code></p></td>
<td class="tableblock halign-left valign-top"><p>Connection keep-alive interval</p></td>
<td class="tableblock halign-left valign-top"><p><code>null</code> (disabled)</p></td>
</tr>
</tbody>
</table>

## Features and Capabilities

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
            keep-alive-interval: 30s

## Usage Examples

### Standard STDIO Server Configuration

    # Using spring-ai-starter-mcp-server
    spring:
      ai:
        mcp:
          server:
            name: stdio-mcp-server
            version: 1.0.0
            type: SYNC

### WebMVC Server Configuration

    # Using spring-ai-starter-mcp-server-webmvc
    spring:
      ai:
        mcp:
          server:
            name: webmvc-mcp-server
            version: 1.0.0
            type: SYNC
            instructions: "This server provides weather information tools and resources"
            capabilities:
              tool: true
              resource: true
              prompt: true
              completion: true
            # sse properties
            sse-message-endpoint: /mcp/messages
            keep-alive-interval: 30s

### WebFlux Server Configuration

    # Using spring-ai-starter-mcp-server-webflux
    spring:
      ai:
        mcp:
          server:
            name: webflux-mcp-server
            version: 1.0.0
            type: ASYNC  # Recommended for reactive applications
            instructions: "This reactive server provides weather information tools and resources"
            capabilities:
              tool: true
              resource: true
              prompt: true
              completion: true
            # sse properties
            sse-message-endpoint: /mcp/messages
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

## Example Applications

- Weather Server (WebFlux) - Spring AI MCP Server Boot Starter with WebFlux transport

- Weather Server (STDIO) - Spring AI MCP Server Boot Starter with STDIO transport

- Weather Server Manual Configuration - Spring AI MCP Server Boot Starter that doesn’t use auto-configuration but uses the Java SDK to configure the server manually

MCP Server Boot Starters Streamable-HTTP MCP Servers

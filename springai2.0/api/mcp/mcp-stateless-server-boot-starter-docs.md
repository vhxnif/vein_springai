Search

## Stateless Streamable-HTTP MCP Servers

Stateless Streamable-HTTP MCP servers are designed for simplified deployments where session state is not maintained between requests. These servers are ideal for microservices architectures and cloud-native deployments.

### Stateless WebMVC Server

Use the `spring-ai-starter-mcp-server-webmvc` dependency:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-mcp-server-webmvc</artifactId>
    </dependency>

and set the `spring.ai.mcp.server.protocol` property to `STATELESS`.

    spring.ai.mcp.server.protocol=STATELESS

- Stateless operation with Spring MVC transport

- No session state management

- Simplified deployment model

- Optimized for cloud-native environments

### Stateless WebFlux Server

Use the `spring-ai-starter-mcp-server-webflux` dependency:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-mcp-server-webflux</artifactId>
    </dependency>

and set the `spring.ai.mcp.server.protocol` property to `STATELESS`.

- Reactive stateless operation with WebFlux transport

- No session state management

- Non-blocking request processing

- Optimized for high-throughput scenarios

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
<td class="tableblock halign-left valign-top"><p>Enable/disable the stateless MCP server</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>protocol</code></p></td>
<td class="tableblock halign-left valign-top"><p>MCP server protocol</p></td>
<td class="tableblock halign-left valign-top"><p>Must be set to <code>STATELESS</code> to enable the stateless server</p></td>
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

### Stateless Connection Properties

All connection properties are prefixed with `spring.ai.mcp.server.stateless`:

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
<td class="tableblock halign-left valign-top"><p><code>disallow-delete</code></p></td>
<td class="tableblock halign-left valign-top"><p>Disallow delete operations</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
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
    public List<McpStatelessServerFeatures.SyncToolSpecification> myTools(...) {
        List<McpStatelessServerFeatures.SyncToolSpecification> tools = ...
        return tools;
    }

The auto-configuration will automatically detect and register all tool callbacks from:

- Individual `ToolCallback` beans

- Lists of `ToolCallback` beans

- `ToolCallbackProvider` beans

Tools are de-duplicated by name, with the first occurrence of each tool name being used.

### Resources

Provides a standardized way for servers to expose resources to clients.

- Static and dynamic resource specifications

- Optional change notifications

- Support for resource templates

- Automatic conversion between sync/async resource specifications

- Automatic resource specification through Spring beans:

    @Bean
    public List<McpStatelessServerFeatures.SyncResourceSpecification> myResources(...) {
        var systemInfoResource = new McpSchema.Resource(...);
        var resourceSpecification = new McpStatelessServerFeatures.SyncResourceSpecification(systemInfoResource, (context, request) -> {
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
    public List<McpStatelessServerFeatures.SyncPromptSpecification> myPrompts() {
        var prompt = new McpSchema.Prompt("greeting", "A friendly greeting prompt",
            List.of(new McpSchema.PromptArgument("name", "The name to greet", true)));

        var promptSpecification = new McpStatelessServerFeatures.SyncPromptSpecification(prompt, (context, getPromptRequest) -> {
            String nameArgument = (String) getPromptRequest.arguments().get("name");
            if (nameArgument == null) { nameArgument = "friend"; }
            var userMessage = new PromptMessage(Role.USER, TextContent.builder("Hello " + nameArgument + "! How can I assist you today?").build());
            return GetPromptResult.builder(List.of(userMessage)).description("A personalized greeting message").build();
        });

        return List.of(promptSpecification);
    }

### Completion

Provides a standardized way for servers to expose completion capabilities to clients.

- Support for both sync and async completion specifications

- Automatic registration through Spring beans:

    @Bean
    public List<McpStatelessServerFeatures.SyncCompletionSpecification> myCompletions() {
        var completion = new McpStatelessServerFeatures.SyncCompletionSpecification(
            new McpSchema.PromptReference(
                        "ref/prompt", "code-completion", "Provides code completion suggestions"),
            (exchange, request) -> {
                // Implementation that returns completion suggestions
                return new McpSchema.CompleteResult(List.of("python", "pytorch", "pyside"), 10, true);
            }
        );

        return List.of(completion);
    }

## Usage Examples

### Stateless Server Configuration

    spring:
      ai:
        mcp:
          server:
            protocol: STATELESS
            name: stateless-mcp-server
            version: 1.0.0
            type: ASYNC
            instructions: "This stateless server is optimized for cloud deployments"
            streamable-http:
              mcp-endpoint: /api/mcp

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

Streamable-HTTP MCP Servers MCP Security (WIP)

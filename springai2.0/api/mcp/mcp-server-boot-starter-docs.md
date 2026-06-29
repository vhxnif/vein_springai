Search

# MCP Server Boot Starter

Model Context Protocol (MCP) Servers are programs that expose specific capabilities to AI applications through standardized protocol interfaces. Each server provides focused functionality for a particular domain.

The Spring AI MCP Server Boot Starters provide auto-configuration for setting up MCP Servers in Spring Boot applications. They enable seamless integration of MCP server capabilities with Spring Boot’s auto-configuration system.

The MCP Server Boot Starters offer:

- Automatic configuration of MCP server components, including tools, resources, and prompts

- Support for different MCP protocol versions, including STDIO, SSE, Streamable-HTTP, and stateless servers

- Support for both synchronous and asynchronous operation modes

- Multiple transport layer options

- Flexible tool, resource, and prompt specification

- Change notification capabilities

- Annotation-based server development with automatic bean scanning and registration

## MCP Server Boot Starters

MCP Servers support multiple protocol and transport mechanisms. Use the dedicated starter and the correct `spring.ai.mcp.server.protocol` property to configure your server:

### STDIO

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Server Type</th>
<th class="tableblock halign-left valign-top">Dependency</th>
<th class="tableblock halign-left valign-top">Property</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Standard Input/Output (STDIO)</p></td>
<td class="tableblock halign-left valign-top"><p><code>spring-ai-starter-mcp-server</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.mcp.server.stdio=true</code></p></td>
</tr>
</tbody>
</table>

### WebMVC

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Server Type</p></td>
<td class="tableblock halign-left valign-top"><p>Dependency</p></td>
<td class="tableblock halign-left valign-top"><p>Property</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>SSE WebMVC _(deprecated since 2.0.0, use STREAMABLE instead)</p></td>
<td class="tableblock halign-left valign-top"><p><code>spring-ai-starter-mcp-server-webmvc</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.mcp.server.protocol=SSE</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Streamable-HTTP WebMVC</p></td>
<td class="tableblock halign-left valign-top"><p><code>spring-ai-starter-mcp-server-webmvc</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.mcp.server.protocol=STREAMABLE</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Stateless WebMVC</p></td>
<td class="tableblock halign-left valign-top"><p><code>spring-ai-starter-mcp-server-webmvc</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.mcp.server.protocol=STATELESS</code></p></td>
</tr>
</tbody>
</table>

### WebFlux (Reactive)

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Server Type</p></td>
<td class="tableblock halign-left valign-top"><p>Dependency</p></td>
<td class="tableblock halign-left valign-top"><p>Property</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>SSE WebFlux _(deprecated since 2.0.0, use STREAMABLE instead)</p></td>
<td class="tableblock halign-left valign-top"><p><code>spring-ai-starter-mcp-server-webflux</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.mcp.server.protocol=SSE</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Streamable-HTTP WebFlux</p></td>
<td class="tableblock halign-left valign-top"><p><code>spring-ai-starter-mcp-server-webflux</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.mcp.server.protocol=STREAMABLE</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Stateless WebFlux</p></td>
<td class="tableblock halign-left valign-top"><p><code>spring-ai-starter-mcp-server-webflux</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.mcp.server.protocol=STATELESS</code></p></td>
</tr>
</tbody>
</table>

## Server Capabilities

Depending on the server and transport types, MCP Servers can support various capabilities, such as:

- **Tools** - Allows servers to expose tools that can be invoked by language models

- **Resources** - Provides a standardized way for servers to expose resources to clients

- **Prompts** - Provides a standardized way for servers to expose prompt templates to clients

- **Utility/Completions** - Provides a standardized way for servers to offer argument autocompletion suggestions for prompts and resource URIs

- **Utility/Logging** - Provides a standardized way for servers to send structured log messages to clients

- **Utility/Progress** - Optional progress tracking for long-running operations through notification messages

- **Utility/Ping** - Optional health check mechanism for the server to report its status

All capabilities are enabled by default. Disabling a capability will prevent the server from registering and exposing the corresponding features to clients.

## Server Protocols

MCP provides several protocol types including:

- **STDIO** - In process (e.g. server runs inside the host application) protocol. Communication is over standard in and standard out. To enable the `STDIO` set `spring.ai.mcp.server.stdio=true`.

- **SSE** - Server-sent events protocol for real-time updates. The server operates as an independent process that can handle multiple client connections.

- **Streamable-HTTP** - The Streamable HTTP transport allows MCP servers to operate as independent processes that can handle multiple client connections using HTTP POST and GET requests, with optional Server-Sent Events (SSE) streaming for multiple server messages. It replaces the SSE transport. To enable the `STREAMABLE` protocol, set `spring.ai.mcp.server.protocol=STREAMABLE`.

- **Stateless** - Stateless MCP servers are designed for simplified deployments where session state is not maintained between requests. They are ideal for microservices architectures and cloud-native deployments. To enable the `STATELESS` protocol, set `spring.ai.mcp.server.protocol=STATELESS`.

## Sync/Async Server API Options

The MCP Server API supports imperative (i.e. synchronous) and reactive (e.g. asynchronous) programming models.

- **Synchronous Server** - The default server type implemented using `McpSyncServer`. It is designed for straightforward request-response patterns in your applications. To enable this server type, set `spring.ai.mcp.server.type=SYNC` in your configuration. When activated, it automatically handles the configuration of synchronous tool specifications.

**NOTE:** The SYNC server will register only synchronous MCP annotated methods. Asynchronous methods will be ignored.

- **Asynchronous Server** - The asynchronous server implementation uses `McpAsyncServer` and is optimized for non-blocking operations. To enable this server type, configure your application with `spring.ai.mcp.server.type=ASYNC`. This server type automatically sets up asynchronous tool specifications with built-in Project Reactor support.

**NOTE:** The ASYNC server will register only asynchronous MCP annotated methods. Synchronous methods will be ignored.

## MCP Server Annotations

The MCP Server Boot Starters provide comprehensive support for annotation-based server development, allowing you to create MCP servers using declarative Java annotations instead of manual configuration.

### Key Annotations

- **@McpTool** - Mark methods as MCP tools with automatic JSON schema generation

- **@McpResource** - Provide access to resources via URI templates

- **@McpPrompt** - Generate prompt messages for AI interactions

- **@McpComplete** - Provide auto-completion functionality for prompts

### Special Parameters

The annotation system supports special parameter types that provide additional context:

- **`McpMeta`** - Access metadata from MCP requests

- **`@McpProgressToken`** - Receive progress tokens for long-running operations

- **`McpSyncServerExchange`/`McpAsyncServerExchange`** - Full server context for advanced operations

- **`McpTransportContext`** - Lightweight context for stateless operations

- **`CallToolRequest`** - Dynamic schema support for flexible tools

### Simple Example

    @Component
    public class CalculatorTools {

        @McpTool(name = "add", description = "Add two numbers together")
        public int add(
                @McpToolParam(description = "First number", required = true) int a,
                @McpToolParam(description = "Second number", required = true) int b) {
            return a + b;
        }

        @McpResource(uri = "config://{key}", name = "Configuration")
        public String getConfig(String key) {
            return configData.get(key);
        }
    }

### Adding data to McpTransportContext

By default, the `McpTransportContext` is empty (`McpTransportContext.EMPTY`). This is by design, to keep the MCP server transport-agnostic.

If you need transport-specific metadata (for example, HTTP headers, remote host, etc) in your tools, configure a `TransportContextExtractor` on your transport provider.

For WebMVC:

    @Bean
    public WebMvcStreamableServerTransportProvider transport() {
        return WebMvcStreamableServerTransportProvider.builder()
            .contextExtractor(serverRequest -> {
                String authorization = serverRequest.headers().firstHeader("Authorization");
                return McpTransportContext.create(Map.of("authorization", authorization));
            })
            .build();
    }

For WebFlux (reactive):

    @Bean
    public WebFluxStreamableServerTransportProvider transport() {
        return WebFluxStreamableServerTransportProvider.builder()
            .contextExtractor(serverRequest -> {
                String authorization = serverRequest.headers().firstHeader("Authorization");
                return McpTransportContext.create(Map.of("authorization", authorization));
            })
            .build();
    }

Once configured, access the context via `McpSyncRequestContext` (or `McpAsyncRequestContext`) in your tool.

    @McpTool
    public String accessProtectedResource(McpSyncRequestContext requestContext) {
        McpTransportContext context = requestContext.transportContext();
        String authorization = (String) context.get("authorization");

        return "Successfully accessed protected resource.";
    }

### Auto-Configuration

With Spring Boot auto-configuration, annotated beans are automatically detected and registered:

    @SpringBootApplication
    public class McpServerApplication {
        public static void main(String[] args) {
            SpringApplication.run(McpServerApplication.class, args);
        }
    }

The auto-configuration will:

1.  Scan for beans with MCP annotations

2.  Create appropriate specifications

3.  Register them with the MCP server

4.  Handle both sync and async implementations based on configuration

### Configuration Properties

Configure the server annotation scanner:

    spring:
      ai:
        mcp:
          server:
            type: SYNC  # or ASYNC
            annotation-scanner:
              enabled: true

### Additional Resources

- Server Annotations Reference - Complete guide to server annotations

- Special Parameters - Advanced parameter injection

- Examples - Comprehensive examples and use cases

## Example Applications

- Weather Server (SSE WebFlux) - Spring AI MCP Server Boot Starter with WebFlux transport

- Weather Server (STDIO) - Spring AI MCP Server Boot Starter with STDIO transport

- Weather Server Manual Configuration - Spring AI MCP Server Boot Starter that doesn’t use auto-configuration but uses the Java SDK to configure the server manually

- Streamable-HTTP WebFlux/WebMVC Example - TODO

- Stateless WebFlux/WebMVC Example - TODO

## Additional Resources

- MCP Server Annotations - Declarative server development with annotations

- Special Parameters - Advanced parameter injection and context access

- MCP Annotations Examples - Comprehensive examples and use cases

- Spring AI Documentation

- Model Context Protocol Specification

- Spring Boot Auto-configuration

MCP Client Boot Starters STDIO and SSE MCP Servers

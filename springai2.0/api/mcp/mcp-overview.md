Search

# Model Context Protocol (MCP)

The Model Context Protocol (MCP) is a standardized protocol that enables AI models to interact with external tools and resources in a structured way. Think of it as a bridge between your AI models and the real world - allowing them to access databases, APIs, file systems, and other external services through a consistent interface. It supports multiple transport mechanisms to provide flexibility across different environments.

The MCP Java SDK provides a Java implementation of the Model Context Protocol, enabling standardized interaction with AI models and tools through both synchronous and asynchronous communication patterns.

Spring AI embraces MCP with comprehensive support through dedicated Boot Starters and MCP Java Annotations, making it easier than ever to build sophisticated AI-powered applications that can seamlessly connect to external systems. This means Spring developers can participate in both sides of the MCP ecosystem - building AI applications that consume MCP servers and creating MCP servers that expose Spring-based services to the wider AI community. Bootstrap your AI applications with MCP support using Spring Initializer.

## MCP Java SDK Architecture

The Java MCP implementation follows a three-layer architecture that separates concerns for maintainability and flexibility:

Figure 1. MCP Stack Architecture

### Client/Server Layer (Top)

The top layer handles the main application logic and protocol operations:

- **McpClient** - Manages client-side operations and server connections

- **McpServer** - Handles server-side protocol operations and client requests

- Both components utilize the session layer below for communication management

### Session Layer (Middle)

The middle layer manages communication patterns and maintains connection state:

- **McpSession** - Core session management interface

- **McpClientSession** - Client-specific session implementation

- **McpServerSession** - Server-specific session implementation

### Transport Layer (Bottom)

The bottom layer handles the actual message transport and serialization:

- **McpTransport** - Manages JSON-RPC message serialization and deserialization

- Supports multiple transport implementations (STDIO, HTTP/SSE, Streamable-HTTP, etc.)

- Provides the foundation for all higher-level communication

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">MCP Client</th>
<th class="tableblock halign-left valign-top"></th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The MCP Client is a key component in the Model Context Protocol (MCP) architecture, responsible for establishing and managing connections with MCP servers. It implements the client-side of the protocol, handling:</p>
</div>
<div>
<ul>
<li><p>Protocol version negotiation to ensure compatibility with servers</p></li>
<li><p>Capability negotiation to determine available features</p></li>
<li><p>Message transport and JSON-RPC communication</p></li>
<li><p>Tool discovery and execution</p></li>
<li><p>Resource access and management</p></li>
<li><p>Prompt system interactions</p></li>
<li><p>Optional features:</p>
<div>
<ul>
<li><p>Roots management</p></li>
<li><p>Sampling support</p></li>
</ul>
</div></li>
<li><p>Synchronous and asynchronous operations</p></li>
<li><p>Transport options:</p>
<div>
<ul>
<li><p>Stdio-based transport for process-based communication</p></li>
<li><p>Java HttpClient-based SSE client transport</p></li>
<li><p>WebFlux SSE client transport for reactive HTTP streaming</p></li>
</ul>
</div></li>
</ul>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
</tr>
</tbody>
</table>

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">MCP Server</th>
<th class="tableblock halign-left valign-top"></th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The MCP Server is a foundational component in the Model Context Protocol (MCP) architecture that provides tools, resources, and capabilities to clients. It implements the server-side of the protocol, responsible for:</p>
</div>
<div>
<ul>
<li><p>Server-side protocol operations implementation</p>
<div>
<ul>
<li><p>Tool exposure and discovery</p></li>
<li><p>Resource management with URI-based access</p></li>
<li><p>Prompt template provision and handling</p></li>
<li><p>Capability negotiation with clients</p></li>
<li><p>Structured logging and notifications</p></li>
</ul>
</div></li>
<li><p>Concurrent client connection management</p></li>
<li><p>Synchronous and Asynchronous API support</p></li>
<li><p>Transport implementations:</p>
<div>
<ul>
<li><p>Stdio, Streamable-HTTP, Stateless Streamable-HTTP, SSE</p></li>
</ul>
</div></li>
</ul>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
</tr>
</tbody>
</table>

For detailed implementation guidance, using the low-level MCP Client/Server APIs, refer to the MCP Java SDK documentation. For simplified setup using Spring Boot, use the MCP Boot Starters described below.

## Spring AI MCP Integration

Spring AI provides MCP integration through the following Spring Boot starters:

### Client Starters

- `spring-ai-starter-mcp-client` - Core starter providing `STDIO`, Servlet-based `Streamable-HTTP`, `Stateless Streamable-HTTP` and `SSE` support

- `spring-ai-starter-mcp-client-webflux` - WebFlux-based `Streamable-HTTP`, `Stateless Streamable-HTTP` and `SSE` transport implementation

### Server Starters

#### STDIO

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

#### WebMVC

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
<td class="tableblock halign-left valign-top"><p>SSE WebMVC</p></td>
<td class="tableblock halign-left valign-top"><p><code>spring-ai-starter-mcp-server-webmvc</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.mcp.server.protocol=SSE</code> or empty</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Streamable-HTTP WebMVC</p></td>
<td class="tableblock halign-left valign-top"><p><code>spring-ai-starter-mcp-server-webmvc</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.mcp.server.protocol=STREAMABLE</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Stateless Streamable-HTTP WebMVC</p></td>
<td class="tableblock halign-left valign-top"><p><code>spring-ai-starter-mcp-server-webmvc</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.mcp.server.protocol=STATELESS</code></p></td>
</tr>
</tbody>
</table>

#### WebFlux (Reactive)

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
<td class="tableblock halign-left valign-top"><p>SSE WebFlux</p></td>
<td class="tableblock halign-left valign-top"><p><code>spring-ai-starter-mcp-server-webflux</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.mcp.server.protocol=SSE</code> or empty</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Streamable-HTTP WebFlux</p></td>
<td class="tableblock halign-left valign-top"><p><code>spring-ai-starter-mcp-server-webflux</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.mcp.server.protocol=STREAMABLE</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Stateless Streamable-HTTP WebFlux</p></td>
<td class="tableblock halign-left valign-top"><p><code>spring-ai-starter-mcp-server-webflux</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.mcp.server.protocol=STATELESS</code></p></td>
</tr>
</tbody>
</table>

## Spring AI MCP Annotations

In addition to the programmatic MCP client & server configuration, Spring AI provides annotation-based method handling for MCP servers and clients through the MCP Annotations module. This approach simplifies the creation and registration of MCP operations using a clean, declarative programming model with Java annotations.

The MCP Annotations module enables developers to:

- Create MCP tools, resources, and prompts using simple annotations

- Handle client-side notifications and requests declaratively

- Reduce boilerplate code and improve maintainability

- Automatically generate JSON schemas for tool parameters

- Access special parameters and context information

Key features include:

- Server Annotations: `@McpTool`, `@McpResource`, `@McpPrompt`, `@McpComplete`

- Client Annotations: `@McpLogging`, `@McpSampling`, `@McpElicitation`, `@McpProgress`

- Special Parameters: `McpSyncServerExchange`, `McpAsyncServerExchange`, `McpTransportContext`, `McpMeta`

- **Automatic Discovery**: Annotation scanning with configurable package inclusion/exclusion

- **Spring Boot Integration**: Seamless integration with MCP Boot Starters

## Upgrading to Spring AI 2.0

Starting with **Spring AI 2.0**, the Spring-specific MCP transport implementations (`mcp-spring-webflux` and `mcp-spring-webmvc`) are no longer shipped by the MCP Java SDK. They have been moved into the Spring AI project itself. This is a breaking change that requires dependency and import updates for applications that directly reference these transport artifacts or classes.

### Maven Dependency Group ID Change

The `mcp-spring-webflux` and `mcp-spring-webmvc` artifacts have moved from the `io.modelcontextprotocol.sdk` group to `org.springframework.ai`.

Before (MCP Java SDK &lt; 1.0.x and Spring AI &lt; 2.0.x)

    <dependency>
        <groupId>io.modelcontextprotocol.sdk</groupId>
        <artifactId>mcp-spring-webflux</artifactId>
    </dependency>

    <dependency>
        <groupId>io.modelcontextprotocol.sdk</groupId>
        <artifactId>mcp-spring-webmvc</artifactId>
    </dependency>

After (MCP Java SDK &gt;= 1.0.x and Spring AI &gt;= 2.0.x)

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>mcp-spring-webflux</artifactId>
    </dependency>

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>mcp-spring-webmvc</artifactId>
    </dependency>

### Java Package Relocation

All transport classes have been relocated to `org.springframework.ai` packages.

<table class="tableblock frame-all grid-all stretch">
<caption>Table 1. Server transport classes</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Class</th>
<th class="tableblock halign-left valign-top">Old package (MCP SDK)</th>
<th class="tableblock halign-left valign-top">New package (Spring AI)</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>WebFluxSseServerTransportProvider</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>io.modelcontextprotocol.server.transport</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.mcp.server.webflux.transport</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>WebFluxStreamableServerTransportProvider</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>io.modelcontextprotocol.server.transport</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.mcp.server.webflux.transport</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>WebFluxStatelessServerTransport</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>io.modelcontextprotocol.server.transport</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.mcp.server.webflux.transport</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>WebMvcSseServerTransportProvider</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>io.modelcontextprotocol.server.transport</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.mcp.server.webmvc.transport</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>WebMvcStreamableServerTransportProvider</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>io.modelcontextprotocol.server.transport</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.mcp.server.webmvc.transport</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>WebMvcStatelessServerTransport</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>io.modelcontextprotocol.server.transport</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.mcp.server.webmvc.transport</code></p></td>
</tr>
</tbody>
</table>

<table class="tableblock frame-all grid-all stretch">
<caption>Table 2. Client transport classes</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Class</th>
<th class="tableblock halign-left valign-top">Old package (MCP SDK)</th>
<th class="tableblock halign-left valign-top">New package (Spring AI)</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>WebFluxSseClientTransport</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>io.modelcontextprotocol.client.transport</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.mcp.client.webflux.transport</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>WebClientStreamableHttpTransport</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>io.modelcontextprotocol.client.transport</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.mcp.client.webflux.transport</code></p></td>
</tr>
</tbody>
</table>

Example import update

    // Before
    import io.modelcontextprotocol.server.transport.WebFluxSseServerTransportProvider;
    import io.modelcontextprotocol.server.transport.WebMvcSseServerTransportProvider;
    import io.modelcontextprotocol.client.transport.WebFluxSseClientTransport;
    import io.modelcontextprotocol.client.transport.WebClientStreamableHttpTransport;

    // After
    import org.springframework.ai.mcp.server.webflux.transport.WebFluxSseServerTransportProvider;
    import org.springframework.ai.mcp.server.webmvc.transport.WebMvcSseServerTransportProvider;
    import org.springframework.ai.mcp.client.webflux.transport.WebFluxSseClientTransport;
    import org.springframework.ai.mcp.client.webflux.transport.WebClientStreamableHttpTransport;

### MCP SDK Version Requirement

Spring AI 2.0 requires **MCP Java SDK 1.0.0** (RC1 or later). The SDK version has been bumped from `0.18.x` to the `1.0.x` release line. Update your BOM or explicit version accordingly.

### Spring Boot Auto-configuration Users

If you rely **exclusively on Spring Boot auto-configuration** via the Spring AI starters, you do **not** need to change any Java code. The auto-configurations have already been updated internally to reference the new packages. Only update your `pom.xml`/`build.gradle` dependency coordinates as described above.

## Additional Resources

- MCP Annotations Documentation

- MCP Client Boot Starters Documentation

- MCP Server Boot Starters Documentation

- MCP Utilities Documentation

- Model Context Protocol Specification

Tool Calling MCP Client Boot Starters

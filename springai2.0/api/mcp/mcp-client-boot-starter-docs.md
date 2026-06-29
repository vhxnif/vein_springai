Search

# MCP Client Boot Starter

The Spring AI MCP (Model Context Protocol) Client Boot Starter provides auto-configuration for MCP client functionality in Spring Boot applications. It supports both synchronous and asynchronous client implementations with various transport options.

The MCP Client Boot Starter provides:

- Management of multiple client instances

- Automatic client initialization (if enabled)

- Support for multiple named transports (STDIO, Http/SSE and Streamable HTTP)

- Integration with Spring AI’s tool execution framework

- Tool filtering capabilities for selective tool inclusion/exclusion

- Customizable tool name prefix generation for avoiding naming conflicts

- Proper lifecycle management with automatic cleanup of resources when the application context is closed

- Customizable client creation through customizers

## Starters

### Standard MCP Client

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-mcp-client</artifactId>
    </dependency>

The standard starter connects simultaneously to one or more MCP servers over `STDIO` (in-process), `SSE`, `Streamable-HTTP` and `Stateless Streamable-HTTP` transports. The SSE and Streamable-Http transports use the JDK HttpClient-based transport implementation. Each connection to an MCP server creates a new MCP client instance. You can choose either `SYNC` or `ASYNC` MCP clients (note: you cannot mix sync and async clients). For production deployment, we recommend using the WebFlux-based SSE & StreamableHttp connection with the `spring-ai-starter-mcp-client-webflux`.

### WebFlux Client

The WebFlux starter provides similar functionality to the standard starter but uses a WebFlux-based Streamable-Http, Stateless Streamable-Http and SSE transport implementation.

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-mcp-client-webflux</artifactId>
    </dependency>

## Configuration Properties

### Common Properties

The common properties are prefixed with `spring.ai.mcp.client`:

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
<td class="tableblock halign-left valign-top"><p>Enable/disable the MCP client</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>name</code></p></td>
<td class="tableblock halign-left valign-top"><p>Name of the MCP client instance</p></td>
<td class="tableblock halign-left valign-top"><p><code>spring-ai-mcp-client</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>version</code></p></td>
<td class="tableblock halign-left valign-top"><p>Version of the MCP client instance</p></td>
<td class="tableblock halign-left valign-top"><p><code>1.0.0</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>initialized</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to initialize clients on creation</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>request-timeout</code></p></td>
<td class="tableblock halign-left valign-top"><p>Timeout duration for MCP client requests</p></td>
<td class="tableblock halign-left valign-top"><p><code>20s</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>type</code></p></td>
<td class="tableblock halign-left valign-top"><p>Client type (SYNC or ASYNC). All clients must be either sync or async; mixing is not supported</p></td>
<td class="tableblock halign-left valign-top"><p><code>SYNC</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>root-change-notification</code></p></td>
<td class="tableblock halign-left valign-top"><p>Enable/disable root change notifications for all clients</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>toolcallback.enabled</code></p></td>
<td class="tableblock halign-left valign-top"><p>Enable/disable the MCP tool callback integration with Spring AI’s tool execution framework</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
</tbody>
</table>

### MCP Annotations Properties

MCP Client Annotations provide a declarative way to implement MCP client handlers using Java annotations. The client mcp-annotations properties are prefixed with `spring.ai.mcp.client.annotation-scanner`:

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
<td class="tableblock halign-left valign-top"><p>Enable/disable the MCP client annotations auto-scanning</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
</tbody>
</table>

### Stdio Transport Properties

Properties for Standard I/O transport are prefixed with `spring.ai.mcp.client.stdio`:

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
<td class="tableblock halign-left valign-top"><p><code>servers-configuration</code></p></td>
<td class="tableblock halign-left valign-top"><p>Resource containing the MCP servers configuration in JSON format</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>connections</code></p></td>
<td class="tableblock halign-left valign-top"><p>Map of named stdio connection configurations</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>connections.[name].command</code></p></td>
<td class="tableblock halign-left valign-top"><p>The command to execute for the MCP server</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>connections.[name].args</code></p></td>
<td class="tableblock halign-left valign-top"><p>List of command arguments</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>connections.[name].env</code></p></td>
<td class="tableblock halign-left valign-top"><p>Map of environment variables for the server process</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

Example configuration:

    spring:
      ai:
        mcp:
          client:
            stdio:
              root-change-notification: true
              connections:
                server1:
                  command: /path/to/server
                  args:
                    - --port=8080
                    - --mode=production
                  env:
                    API_KEY: your-api-key
                    DEBUG: "true"

Alternatively, you can configure stdio connections using an external JSON file using the Claude Desktop format:

    spring:
      ai:
        mcp:
          client:
            stdio:
              servers-configuration: classpath:mcp-servers.json

The Claude Desktop format looks like this:

    {
      "mcpServers": {
        "filesystem": {
          "command": "npx",
          "args": [
            "-y",
            "@modelcontextprotocol/server-filesystem",
            "/Users/username/Desktop",
            "/Users/username/Downloads"
          ]
        }
      }
    }

### Windows STDIO Configuration

#### Why Windows Needs Special Handling

When Java’s `ProcessBuilder` (used internally by `StdioClientTransport`) attempts to spawn a process on Windows, it can only execute:

- Native executables (`.exe` files)

- System commands available to `cmd.exe`

Windows batch files like `npx.cmd`, `npm.cmd`, and even `python.cmd` (from the Microsoft Store) require the `cmd.exe` shell to execute them.

#### Solution: cmd.exe Wrapper

Wrap batch file commands with `cmd.exe /c`:

**Windows Configuration:**

    {
      "mcpServers": {
        "filesystem": {
          "command": "cmd.exe",
          "args": [
            "/c",
            "npx",
            "-y",
            "@modelcontextprotocol/server-filesystem",
            "C:\\Users\\username\\Desktop"
          ]
        }
      }
    }

**Linux/macOS Configuration:**

    {
      "mcpServers": {
        "filesystem": {
          "command": "npx",
          "args": [
            "-y",
            "@modelcontextprotocol/server-filesystem",
            "/Users/username/Desktop"
          ]
        }
      }
    }

#### Cross-Platform Programmatic Configuration

For applications that need to work across platforms without separate configuration files, use OS detection in your Spring Boot application:

    @Bean(destroyMethod = "close")
    @ConditionalOnMissingBean(McpSyncClient.class)
    public McpSyncClient mcpClient() {
        ServerParameters stdioParams;

        if (isWindows()) {
            // Windows: cmd.exe /c npx approach
            var winArgs = new ArrayList<>(Arrays.asList(
                "/c", "npx", "-y", "@modelcontextprotocol/server-filesystem", "target"));
            stdioParams = ServerParameters.builder("cmd.exe")
                    .args(winArgs)
                    .build();
        } else {
            // Linux/Mac: direct npx approach
            stdioParams = ServerParameters.builder("npx")
                    .args("-y", "@modelcontextprotocol/server-filesystem", "target")
                    .build();
        }

        return McpClient.sync(new StdioClientTransport(stdioParams, McpJsonDefaults.getMapper()))
                .requestTimeout(Duration.ofSeconds(10))
                .build()
                .initialize();
    }

    private static boolean isWindows() {
        return System.getProperty("os.name").toLowerCase().contains("win");
    }

#### Path Considerations

**Relative paths** (recommended for portability):

    {
      "command": "cmd.exe",
      "args": ["/c", "npx", "-y", "@modelcontextprotocol/server-filesystem", "target"]
    }

The MCP server resolves relative paths based on the application’s working directory.

**Absolute paths** (Windows requires backslashes or escaped forward slashes):

    {
      "command": "cmd.exe",
      "args": ["/c", "npx", "-y", "@modelcontextprotocol/server-filesystem", "C:\\Users\\username\\project\\target"]
    }

#### Common Windows Batch Files Requiring cmd.exe

- `npx.cmd`, `npm.cmd` - Node package managers

- `python.cmd` - Python (Microsoft Store installation)

- `pip.cmd` - Python package manager

- `mvn.cmd` - Maven wrapper

- `gradle.cmd` - Gradle wrapper

- Custom `.cmd` or `.bat` scripts

#### Reference Implementation

See Spring AI Examples - Filesystem for a complete cross-platform MCP client implementation that automatically detects the OS and configures the client appropriately.

### Streamable-HTTP Transport Properties

Used for connecting to Streamable-HTTP and Stateless Streamable-HTTP MCP servers.

Properties for Streamable-HTTP transport are prefixed with `spring.ai.mcp.client.streamable-http`:

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
<td class="tableblock halign-left valign-top"><p><code>connections</code></p></td>
<td class="tableblock halign-left valign-top"><p>Map of named Streamable-HTTP connection configurations</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>connections.[name].url</code></p></td>
<td class="tableblock halign-left valign-top"><p>Base URL endpoint for Streamable-Http communication with the MCP server</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>connections.[name].endpoint</code></p></td>
<td class="tableblock halign-left valign-top"><p>the streamable-http endpoint (as url suffix) to use for the connection</p></td>
<td class="tableblock halign-left valign-top"><p><code>/mcp</code></p></td>
</tr>
</tbody>
</table>

Example configuration:

    spring:
      ai:
        mcp:
          client:
            streamable-http:
              connections:
                server1:
                  url: http://localhost:8080
                server2:
                  url: http://otherserver:8081
                  endpoint: /custom-sse

### SSE Transport Properties

Properties for Server-Sent Events (SSE) transport are prefixed with `spring.ai.mcp.client.sse`:

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
<td class="tableblock halign-left valign-top"><p><code>connections</code></p></td>
<td class="tableblock halign-left valign-top"><p>Map of named SSE connection configurations</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>connections.[name].url</code></p></td>
<td class="tableblock halign-left valign-top"><p>Base URL endpoint for SSE communication with the MCP server</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>connections.[name].sse-endpoint</code></p></td>
<td class="tableblock halign-left valign-top"><p>the sse endpoint (as url suffix) to use for the connection</p></td>
<td class="tableblock halign-left valign-top"><p><code>/sse</code></p></td>
</tr>
</tbody>
</table>

Example configurations:

    spring:
      ai:
        mcp:
          client:
            sse:
              connections:
                # Simple configuration using default /sse endpoint
                server1:
                  url: http://localhost:8080
                # Custom SSE endpoint
                server2:
                  url: http://otherserver:8081
                  sse-endpoint: /custom-sse
                # Complex URL with path and token (like MCP Hub)
                mcp-hub:
                  url: http://localhost:3000
                  sse-endpoint: /mcp-hub/sse/cf9ec4527e3c4a2cbb149a85ea45ab01
                # SSE endpoint with query parameters
                api-server:
                  url: https://api.example.com
                  sse-endpoint: /v1/mcp/events?token=abc123&format=json

#### URL Splitting Guidelines

When you have a full SSE URL, split it into base URL and endpoint path:

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Full URL</th>
<th class="tableblock halign-left valign-top">Configuration</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>http://localhost:3000/mcp-hub/sse/token123</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>url: </code><code>localhost:3000</code><br />
<code>sse-endpoint: /mcp-hub/sse/token123</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>https://api.service.com/v2/events?key=secret</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>url: </code><code>api.service.com</code><br />
<code>sse-endpoint: /v2/events?key=secret</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>http://localhost:8080/sse</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>url: </code><code>localhost:8080</code><br />
<code>sse-endpoint: /sse</code> (or omit for default)</p></td>
</tr>
</tbody>
</table>

#### Troubleshooting SSE Connections

**404 Not Found Errors:**

- Verify URL splitting: ensure the base `url` contains only the scheme, host, and port

- Check the `sse-endpoint` starts with `/` and includes the full path and query parameters

- Test the full URL directly in a browser or curl to confirm it’s accessible

### Streamable Http Transport Properties

Properties for Streamable Http transport are prefixed with `spring.ai.mcp.client.streamable-http`:

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
<td class="tableblock halign-left valign-top"><p><code>connections</code></p></td>
<td class="tableblock halign-left valign-top"><p>Map of named Streamable Http connection configurations</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>connections.[name].url</code></p></td>
<td class="tableblock halign-left valign-top"><p>Base URL endpoint for Streamable-Http communication with the MCP server</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>connections.[name].endpoint</code></p></td>
<td class="tableblock halign-left valign-top"><p>the streamable-http endpoint (as url suffix) to use for the connection</p></td>
<td class="tableblock halign-left valign-top"><p><code>/mcp</code></p></td>
</tr>
</tbody>
</table>

Example configuration:

    spring:
      ai:
        mcp:
          client:
            streamable-http:
              connections:
                server1:
                  url: http://localhost:8080
                server2:
                  url: http://otherserver:8081
                  endpoint: /custom-sse

## Features

### Sync/Async Client Types

The starter supports two types of clients:

- Synchronous - default client type (`spring.ai.mcp.client.type=SYNC`), suitable for traditional request-response patterns with blocking operations

**NOTE:** The SYNC client will register only synchronous MCP annotated methods. Asynchronous methods will be ignored.

- Asynchronous - suitable for reactive applications with non-blocking operations, configured using `spring.ai.mcp.client.type=ASYNC`

**NOTE:** The ASYNC client will register only asynchronous MCP annotated methods. Synchronous methods will be ignored.

### Client Customization

The auto-configuration provides extensive client spec customization capabilities through callback interfaces. These customizers allow you to configure various aspects of the MCP client behavior, from request timeouts to event handling and message processing.

#### Customization Types

The following customization options are available:

- **Request Configuration** - Set custom request timeouts

- **Custom Sampling Handlers** - standardized way for servers to request LLM sampling (`completions` or `generations`) from LLMs via clients. This flow allows clients to maintain control over model access, selection, and permissions while enabling servers to leverage AI capabilities — with no server API keys necessary.

- **File system (Roots) Access** - standardized way for clients to expose filesystem `roots` to servers. Roots define the boundaries of where servers can operate within the filesystem, allowing them to understand which directories and files they have access to. Servers can request the list of roots from supporting clients and receive notifications when that list changes.

- **Elicitation Handlers** - standardized way for servers to request additional information from users through the client during interactions.

- **Event Handlers** - client’s handler to be notified when a certain server event occurs:

  - Tools change notifications - when the list of available server tools changes

  - Resources change notifications - when the list of available server resources changes.

  - Prompts change notifications - when the list of available server prompts changes.

  - **Logging Handlers** - standardized way for servers to send structured log messages to clients.

  - **Progress Handlers** - standardized way for servers to send structured progress messages to clients.

Clients can control logging verbosity by setting minimum log levels

#### Client Customization Example

You can implement `McpCustomizer<McpClient.SyncSpec>` for synchronous clients or `McpCustomizer<McpClient.AsyncSpec>` for asynchronous clients, depending on your application’s needs.

The `serverConfigurationName` parameter is the name of the server configuration that the customizer is being applied to and the MCP Client is created for.

The MCP client auto-configuration automatically detects and applies any customizers found in the application context.

### Transport Support

The auto-configuration supports multiple transport types:

- Standard I/O (Stdio) (activated by the `spring-ai-starter-mcp-client` and `spring-ai-starter-mcp-client-webflux`)

- (HttpClient) HTTP/SSE and Streamable-HTTP (activated by the `spring-ai-starter-mcp-client`)

- (WebFlux) HTTP/SSE and Streamable-HTTP (activated by the `spring-ai-starter-mcp-client-webflux`)

### Tool Filtering

The MCP Client Boot Starter supports filtering of discovered tools through the `McpToolFilter` interface. This allows you to selectively include or exclude tools based on custom criteria such as the MCP connection information or tool properties.

To implement tool filtering, create a bean that implements the `McpToolFilter` interface:

    @Component
    public class CustomMcpToolFilter implements McpToolFilter {

        @Override
        public boolean test(McpConnectionInfo connectionInfo, McpSchema.Tool tool) {
            // Filter logic based on connection information and tool properties
            // Return true to include the tool, false to exclude it

            // Example: Exclude tools from a specific client
            if (connectionInfo.clientInfo().name().equals("restricted-client")) {
                return false;
            }

            // Example: Only include tools with specific names
            if (tool.name().startsWith("allowed_")) {
                return true;
            }

            // Example: Filter based on tool description or other properties
            if (tool.description() != null &&
                tool.description().contains("experimental")) {
                return false;
            }

            return true; // Include all other tools by default
        }
    }

The `McpConnectionInfo` record provides access to:

- `clientCapabilities` - The capabilities of the MCP client

- `clientInfo` - Information about the MCP client (name and version)

- `initializeResult` - The initialization result from the MCP server

The filter is automatically detected and applied to both synchronous and asynchronous MCP tool callback providers. If no custom filter is provided, all discovered tools are included by default.

Note: Only one `McpToolFilter` bean should be defined in the application context. If multiple filters are needed, combine them into a single composite filter implementation.

### Tool Name Prefix Generation

The MCP Client Boot Starter supports customizable tool name prefix generation through the `McpToolNamePrefixGenerator` interface. This feature helps avoid naming conflicts when integrating tools from multiple MCP servers by adding unique prefixes to tool names.

By default, if no custom `McpToolNamePrefixGenerator` bean is provided, the starter uses `DefaultMcpToolNamePrefixGenerator` which ensures unique tool names across all MCP client connections. The default generator:

- Tracks all existing connections and tool names to ensure uniqueness

- Formats tool names by replacing non-alphanumeric characters with underscores (e.g., `my-tool` becomes `my_tool`)

- When duplicate tool names are detected across different connections, adds a counter prefix (e.g., `alt_1_toolName`, `alt_2_toolName`)

- Is thread-safe and maintains idempotency - the same combination of (client, server, tool) always gets the same unique name

- Ensures the final name doesn’t exceed 64 characters (truncating from the beginning if necessary)

For example: \* First occurrence of tool `search` → `search` \* Second occurrence of tool `search` from a different connection → `alt_1_search` \* Tool with special characters `my-special-tool` → `my_special_tool`

You can customize this behavior by providing your own implementation:

    @Component
    public class CustomToolNamePrefixGenerator implements McpToolNamePrefixGenerator {

        @Override
        public String prefixedToolName(McpConnectionInfo connectionInfo, Tool tool) {
            // Custom logic to generate prefixed tool names

            // Example: Use server name and version as prefix
            String serverName = connectionInfo.initializeResult().serverInfo().name();
            String serverVersion = connectionInfo.initializeResult().serverInfo().version();
            return serverName + "_v" + serverVersion.replace(".", "_") + "_" + tool.name();
        }
    }

The `McpConnectionInfo` record provides comprehensive information about the MCP connection:

- `clientCapabilities` - The capabilities of the MCP client

- `clientInfo` - Information about the MCP client (name, title, and version)

- `initializeResult` - The initialization result from the MCP server, including server information

#### Built-in Prefix Generators

The framework provides several built-in prefix generators:

- `DefaultMcpToolNamePrefixGenerator` - Ensures unique tool names by tracking duplicates and adding counter prefixes when needed (used by default if no custom bean is provided)

- `McpToolNamePrefixGenerator.noPrefix()` - Returns tool names without any prefix (may cause conflicts if multiple servers provide tools with the same name)

To disable prefixing entirely and use raw tool names (not recommended if using multiple MCP servers), register the no-prefix generator as a bean:

    @Configuration
    public class McpConfiguration {

        @Bean
        public McpToolNamePrefixGenerator mcpToolNamePrefixGenerator() {
            return McpToolNamePrefixGenerator.noPrefix();
        }
    }

The prefix generator is automatically detected and applied to both synchronous and asynchronous MCP tool callback providers through Spring’s `ObjectProvider` mechanism. If no custom generator bean is provided, the `DefaultMcpToolNamePrefixGenerator` is used automatically.

### Tool Context to MCP Meta Converter

The MCP Client Boot Starter supports customizable conversion of Spring AI’s ToolContext to MCP tool-call metadata through the `ToolContextToMcpMetaConverter` interface. This feature allows you to pass additional contextual information (e.g. user id, secrets token) as metadata along with the LLM’s generated call arguments.

For example you can pass the MCP `progressToken` to your MCP Progress Flow in the tool context to track the progress of long-running operations:

    ChatModel chatModel = ...

    String response = ChatClient.create(chatModel)
            .prompt("Tell me more about the customer with ID 42")
            .toolContext(Map.of("progressToken", "my-progress-token"))
            .call()
            .content();

By default, if no custom converter bean is provided, the starter uses `ToolContextToMcpMetaConverter.defaultConverter()` which:

- Filters out the MCP exchange key (`McpToolUtils.TOOL_CONTEXT_MCP_EXCHANGE_KEY`)

- Filters out entries with null values

- Passes through all other context entries as metadata

You can customize this behavior by providing your own implementation:

    @Component
    public class CustomToolContextToMcpMetaConverter implements ToolContextToMcpMetaConverter {

        @Override
        public Map<String, Object> convert(ToolContext toolContext) {
            if (toolContext == null || toolContext.getContext() == null) {
                return Map.of();
            }

            // Custom logic to convert tool context to MCP metadata
            Map<String, Object> metadata = new HashMap<>();

            // Example: Add custom prefix to all keys
            for (Map.Entry<String, Object> entry : toolContext.getContext().entrySet()) {
                if (entry.getValue() != null) {
                    metadata.put("app_" + entry.getKey(), entry.getValue());
                }
            }

            // Example: Add additional metadata
            metadata.put("timestamp", System.currentTimeMillis());
            metadata.put("source", "spring-ai");

            return metadata;
        }
    }

#### Built-in Converters

The framework provides built-in converters:

- `ToolContextToMcpMetaConverter.defaultConverter()` - Filters out MCP exchange key and null values (used by default if no custom bean is provided)

- `ToolContextToMcpMetaConverter.noOp()` - Returns an empty map, effectively disabling context-to-metadata conversion

To disable context-to-metadata conversion entirely:

    @Configuration
    public class McpConfiguration {

        @Bean
        public ToolContextToMcpMetaConverter toolContextToMcpMetaConverter() {
            return ToolContextToMcpMetaConverter.noOp();
        }
    }

The converter is automatically detected and applied to both synchronous and asynchronous MCP tool callbacks through Spring’s `ObjectProvider` mechanism. If no custom converter bean is provided, the default converter is used automatically.

### Disable the MCP ToolCallback Auto-Configuration

The MCP ToolCallback auto-configuration is enabled by default, but can be disabled with the `spring.ai.mcp.client.toolcallback.enabled=false` property.

When disabled, no `ToolCallbackProvider` bean is created from the available MCP tools.

## MCP Client Annotations

The MCP Client Boot Starter automatically detects and registers annotated methods for handling various MCP client operations:

- **@McpLogging** - Handles logging message notifications from MCP servers

- **@McpSampling** - Handles sampling requests from MCP servers for LLM completions

- **@McpElicitation** - Handles elicitation requests to gather additional information from users

- **@McpProgress** - Handles progress notifications for long-running operations

- **@McpToolListChanged** - Handles notifications when the server’s tool list changes

- **@McpResourceListChanged** - Handles notifications when the server’s resource list changes

- **@McpPromptListChanged** - Handles notifications when the server’s prompt list changes

Example usage:

    @Component
    public class McpClientHandlers {

        @McpLogging(clients = "server1")
        public void handleLoggingMessage(LoggingMessageNotification notification) {
            System.out.println("Received log: " + notification.level() +
                              " - " + notification.data());
        }

        @McpSampling(clients = "server1")
        public CreateMessageResult handleSamplingRequest(CreateMessageRequest request) {
            // Process the request and generate a response
            String response = generateLLMResponse(request);

            return CreateMessageResult.builder(Role.ASSISTANT, response, "gpt-4")
                .build();
        }

        @McpProgress(clients = "server1")
        public void handleProgressNotification(ProgressNotification notification) {
            double percentage = notification.progress() * 100;
            System.out.println(String.format("Progress: %.2f%% - %s",
                percentage, notification.message()));
        }

        @McpToolListChanged(clients = "server1")
        public void handleToolListChanged(List<McpSchema.Tool> updatedTools) {
            System.out.println("Tool list updated: " + updatedTools.size() + " tools available");
            // Update local tool registry
            toolRegistry.updateTools(updatedTools);
        }
    }

The annotations support both synchronous and asynchronous implementations, and can be configured for specific clients using the `clients` parameter:

    @McpLogging(clients = "server1")
    public void handleServer1Logs(LoggingMessageNotification notification) {
        // Handle logs from specific server
        logToFile("server1.log", notification);
    }

    @McpSampling(clients = "server1")
    public Mono<CreateMessageResult> handleAsyncSampling(CreateMessageRequest request) {
        return Mono.fromCallable(() -> {
            String response = generateLLMResponse(request);
            return CreateMessageResult.builder(Role.ASSISTANT, response, "gpt-4")
                .build();
        }).subscribeOn(Schedulers.boundedElastic());
    }

For detailed information about all available annotations and their usage patterns, see the MCP Client Annotations documentation.

## Usage Example

Add the appropriate starter dependency to your project and configure the client in `application.properties` or `application.yml`:

    spring:
      ai:
        mcp:
          client:
            enabled: true
            name: my-mcp-client
            version: 1.0.0
            request-timeout: 30s
            type: SYNC  # or ASYNC for reactive applications
            sse:
              connections:
                server1:
                  url: http://localhost:8080
                server2:
                  url: http://otherserver:8081
            streamable-http:
              connections:
                server3:
                  url: http://localhost:8083
                  endpoint: /mcp
            stdio:
              root-change-notification: false
              connections:
                server1:
                  command: /path/to/server
                  args:
                    - --port=8080
                    - --mode=production
                  env:
                    API_KEY: your-api-key
                    DEBUG: "true"

The MCP client beans will be automatically configured and available for injection:

    @Autowired
    private List<McpSyncClient> mcpSyncClients;  // For sync client

    // OR

    @Autowired
    private List<McpAsyncClient> mcpAsyncClients;  // For async client

When tool callbacks are enabled (the default behavior), the registered MCP Tools with all MCP clients are provided as a `ToolCallbackProvider` instance:

    @Autowired
    private SyncMcpToolCallbackProvider toolCallbackProvider;
    ToolCallback[] toolCallbacks = toolCallbackProvider.getToolCallbacks();

## Example Applications

- Brave Web Search Chatbot - A chatbot that uses the Model Context Protocol to interact with a web search server.

- Default MCP Client Starter - A simple example of using the default `spring-ai-starter-mcp-client` MCP Client Boot Starter.

- WebFlux MCP Client Starter - A simple example of using the `spring-ai-starter-mcp-client-webflux` MCP Client Boot Starter.

## Additional Resources

- Spring AI Documentation

- Model Context Protocol Specification

- Spring Boot Auto-configuration

Model Context Protocol (MCP) MCP Server Boot Starters

Search

# Testcontainers

Spring AI provides Spring Boot auto-configuration for establishing a connection to a model service or vector store running via Testcontainers. To enable it, add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
       <groupId>org.springframework.ai</groupId>
       <artifactId>spring-ai-spring-boot-testcontainers</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-spring-boot-testcontainers'
    }

## Service Connections

The following service connection factories are provided in the `spring-ai-spring-boot-testcontainers` module:

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Connection Details</th>
<th class="tableblock halign-left valign-top">Matched on</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>AwsOpenSearchConnectionDetails</code></p></td>
<td class="tableblock halign-left valign-top"><p>Containers of type <code>LocalStackContainer</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>ChromaConnectionDetails</code></p></td>
<td class="tableblock halign-left valign-top"><p>Containers of type <code>ChromaDBContainer</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>McpSseClientConnectionDetails</code></p></td>
<td class="tableblock halign-left valign-top"><p>Containers of type <code>DockerMcpGatewayContainer</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>MilvusServiceClientConnectionDetails</code></p></td>
<td class="tableblock halign-left valign-top"><p>Containers of type <code>MilvusContainer</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>OllamaConnectionDetails</code></p></td>
<td class="tableblock halign-left valign-top"><p>Containers of type <code>OllamaContainer</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>OpenSearchConnectionDetails</code></p></td>
<td class="tableblock halign-left valign-top"><p>Containers of type <code>OpenSearchContainer</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>QdrantConnectionDetails</code></p></td>
<td class="tableblock halign-left valign-top"><p>Containers of type <code>QdrantContainer</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>TypesenseConnectionDetails</code></p></td>
<td class="tableblock halign-left valign-top"><p>Containers of type <code>TypesenseContainer</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>WeaviateConnectionDetails</code></p></td>
<td class="tableblock halign-left valign-top"><p>Containers of type <code>WeaviateContainer</code></p></td>
</tr>
</tbody>
</table>

More service connections are provided by the spring boot module `spring-boot-testcontainers`. Refer to the Testcontainers Service Connections documentation page for the full list.

Development-time Services Getting Started with MCP

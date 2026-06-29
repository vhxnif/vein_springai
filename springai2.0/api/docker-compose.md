Search

# Docker Compose

Spring AI provides Spring Boot auto-configuration for establishing a connection to a model service or vector store running via Docker Compose. To enable it, add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
       <groupId>org.springframework.ai</groupId>
       <artifactId>spring-ai-spring-boot-docker-compose</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-spring-boot-docker-compose'
    }

## Service Connections

The following service connection factories are provided in the `spring-ai-spring-boot-docker-compose` module:

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Connection Details</p></td>
<td class="tableblock halign-left valign-top"><p>Matched on</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>AwsOpenSearchConnectionDetails</code></p></td>
<td class="tableblock halign-left valign-top"><p>Containers named <code>localstack/localstack</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>ChromaConnectionDetails</code></p></td>
<td class="tableblock halign-left valign-top"><p>Containers named <code>chromadb/chroma</code>, <code>ghcr.io/chroma-core/chroma</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>MilvusServiceClientConnectionDetails</code></p></td>
<td class="tableblock halign-left valign-top"><p>Containers named <code>milvusdb/milvus</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>OllamaConnectionDetails</code></p></td>
<td class="tableblock halign-left valign-top"><p>Containers named <code>ollama/ollama</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>OpenSearchConnectionDetails</code></p></td>
<td class="tableblock halign-left valign-top"><p>Containers named <code>opensearchproject/opensearch</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>QdrantConnectionDetails</code></p></td>
<td class="tableblock halign-left valign-top"><p>Containers named <code>qdrant/qdrant</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>TypesenseConnectionDetails</code></p></td>
<td class="tableblock halign-left valign-top"><p>Containers named <code>typesense/typesense</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>WeaviateConnectionDetails</code></p></td>
<td class="tableblock halign-left valign-top"><p>Containers named <code>semitechnologies/weaviate</code>, <code>cr.weaviate.io/semitechnologies/weaviate</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>McpSseClientConnectionDetails</code></p></td>
<td class="tableblock halign-left valign-top"><p>Containers named <code>docker/mcp-gateway</code></p></td>
</tr>
</tbody>
</table>

More service connections are provided by the spring boot module `spring-boot-docker-compose`. Refer to the Docker Compose Support documentation page for the full list.

Observability Testcontainers

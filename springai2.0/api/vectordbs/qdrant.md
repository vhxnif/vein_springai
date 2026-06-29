Search

# Qdrant

This section walks you through setting up the Qdrant `VectorStore` to store document embeddings and perform similarity searches.

Qdrant is an open-source, high-performance vector search engine/database. It uses HNSW (Hierarchical Navigable Small World) algorithm for efficient k-NN search operations and provides advanced filtering capabilities for metadata-based queries.

## Prerequisites

- Qdrant Instance: Set up a Qdrant instance by following the installation instructions in the Qdrant documentation.

- If required, an API key for the EmbeddingModel to generate the embeddings stored by the `QdrantVectorStore`.

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the Qdrant Vector Store. To enable it, add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-vector-store-qdrant</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-vector-store-qdrant'
    }

Please have a look at the list of configuration parameters for the vector store to learn about the default values and configuration options.

The vector store implementation can initialize the requisite schema for you, but you must opt-in by specifying the `initializeSchema` boolean in the builder or by setting `…​initialize-schema=true` in the `application.properties` file.

Additionally, you will need a configured `EmbeddingModel` bean. Refer to the EmbeddingModel section for more information.

Now you can auto-wire the `QdrantVectorStore` as a vector store in your application.

    @Autowired VectorStore vectorStore;

    // ...

    List<Document> documents = List.of(
        new Document("Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!!", Map.of("meta1", "meta1")),
        new Document("The World is Big and Salvation Lurks Around the Corner"),
        new Document("You walk forward facing the past and you turn back toward the future.", Map.of("meta2", "meta2")));

    // Add the documents to Qdrant
    vectorStore.add(documents);

    // Retrieve documents similar to a query
    List<Document> results = vectorStore.similaritySearch(SearchRequest.builder().query("Spring").topK(5).build());

### Configuration Properties

To connect to Qdrant and use the `QdrantVectorStore`, you need to provide access details for your instance. A simple configuration can be provided via Spring Boot’s `application.yml`:

    spring:
      ai:
        vectorstore:
          qdrant:
            host: <qdrant host>
            port: <qdrant grpc port>
            api-key: <qdrant api key>
            collection-name: <collection name>
            content-field-name: <content field name>
            use-tls: false
            initialize-schema: true

Properties starting with `spring.ai.vectorstore.qdrant.*` are used to configure the `QdrantVectorStore`:

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 25%" />
<col style="width: 62%" />
<col style="width: 12%" />
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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.qdrant.host</code></p></td>
<td class="tableblock halign-left valign-top"><p>The host of the Qdrant server</p></td>
<td class="tableblock halign-left valign-top"><p><code>localhost</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.qdrant.port</code></p></td>
<td class="tableblock halign-left valign-top"><p>The gRPC port of the Qdrant server</p></td>
<td class="tableblock halign-left valign-top"><p><code>6334</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.qdrant.api-key</code></p></td>
<td class="tableblock halign-left valign-top"><p>The API key to use for authentication</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.qdrant.collection-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>The name of the collection to use</p></td>
<td class="tableblock halign-left valign-top"><p><code>vector_store</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.qdrant.content-field-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>The name of the field storing document content in Qdrant payloads. Useful when integrating with existing collections that use different field names (e.g., "page_content", "text", "content").</p></td>
<td class="tableblock halign-left valign-top"><p><code>doc_content</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.qdrant.use-tls</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to use TLS(HTTPS)</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.qdrant.initialize-schema</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to initialize the schema</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
</tbody>
</table>

## Manual Configuration

Instead of using the Spring Boot auto-configuration, you can manually configure the Qdrant vector store. For this you need to add the `spring-ai-qdrant-store` to your project:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-qdrant-store</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-qdrant-store'
    }

Create a Qdrant client bean:

    @Bean
    public QdrantClient qdrantClient() {
        QdrantGrpcClient.Builder grpcClientBuilder =
            QdrantGrpcClient.newBuilder(
                "<QDRANT_HOSTNAME>",
                <QDRANT_GRPC_PORT>,
                <IS_TLS>);
        grpcClientBuilder.withApiKey("<QDRANT_API_KEY>");

        return new QdrantClient(grpcClientBuilder.build());
    }

Then create the `QdrantVectorStore` bean using the builder pattern:

    @Bean
    public VectorStore vectorStore(QdrantClient qdrantClient, EmbeddingModel embeddingModel) {
        return QdrantVectorStore.builder(qdrantClient, embeddingModel)
            .collectionName("custom-collection")     // Optional: defaults to "vector_store"
            .contentFieldName("page_content")        // Optional: defaults to "doc_content"
            .initializeSchema(true)                  // Optional: defaults to false
            .batchingStrategy(new TokenCountBatchingStrategy()) // Optional: defaults to TokenCountBatchingStrategy
            .build();
    }

    // This can be any EmbeddingModel implementation
    @Bean
    public EmbeddingModel embeddingModel() {
        return new OpenAiEmbeddingModel(OpenAiEmbeddingOptions.builder().apiKey(System.getenv("OPENAI_API_KEY")).build());
    }

## Working with Existing Collections

When integrating Spring AI with pre-existing Qdrant collections, you may need to configure the content field name to match the schema already in use.

By default, `QdrantVectorStore` stores document content in a field named `doc_content`. However, existing collections might use different naming conventions such as `page_content`, `text`, `content`, or other custom names.

### Using Custom Content Field Names

You can configure the content field name to match your existing collection schema:

**Via Properties:**

    spring:
      ai:
        vectorstore:
          qdrant:
            collection-name: my_existing_collection
            content-field-name: page_content  # Match existing schema

**Programmatically:**

    @Bean
    public VectorStore vectorStore(QdrantClient qdrantClient, EmbeddingModel embeddingModel) {
        return QdrantVectorStore.builder(qdrantClient, embeddingModel)
            .collectionName("my_existing_collection")
            .contentFieldName("text")  // Use existing field name
            .initializeSchema(false)   // Don't recreate existing schema
            .build();
    }

## Metadata Filtering

You can leverage the generic, portable metadata filters with Qdrant store as well.

For example, you can use either the text expression language:

    vectorStore.similaritySearch(
        SearchRequest.builder()
            .query("The World")
            .topK(TOP_K)
            .similarityThreshold(SIMILARITY_THRESHOLD)
            .filterExpression("author in ['john', 'jill'] && article_type == 'blog'").build());

or programmatically using the `Filter.Expression` DSL:

    FilterExpressionBuilder b = new FilterExpressionBuilder();

    vectorStore.similaritySearch(SearchRequest.builder()
        .query("The World")
        .topK(TOP_K)
        .similarityThreshold(SIMILARITY_THRESHOLD)
        .filterExpression(b.and(
            b.in("author", "john", "jill"),
            b.eq("article_type", "blog")).build()).build());

## Accessing the Native Client

The Qdrant Vector Store implementation provides access to the underlying native Qdrant client (`QdrantClient`) through the `getNativeClient()` method:

    QdrantVectorStore vectorStore = context.getBean(QdrantVectorStore.class);
    Optional<QdrantClient> nativeClient = vectorStore.getNativeClient();

    if (nativeClient.isPresent()) {
        QdrantClient client = nativeClient.get();
        // Use the native client for Qdrant-specific operations
    }

The native client gives you access to Qdrant-specific features and operations that might not be exposed through the `VectorStore` interface.

Pinecone Redis

Search

# Neo4j

This section walks you through setting up `Neo4jVectorStore` to store document embeddings and perform similarity searches.

Neo4j is an open-source NoSQL graph database. It is a fully transactional database (ACID) that stores data structured as graphs consisting of nodes, connected by relationships. Inspired by the structure of the real world, it allows for high query performance on complex data while remaining intuitive and simple for the developer.

The Neo4j’s Vector Search allows users to query vector embeddings from large datasets. An embedding is a numerical representation of a data object, such as text, image, audio, or document. Embeddings can be stored on *Node* properties and can be queried with the `db.index.vector.queryNodes()` function. Those indexes are powered by Lucene using a Hierarchical Navigable Small World Graph (HNSW) to perform a k approximate nearest neighbors (k-ANN) query over the vector fields.

## Prerequisites

- A running Neo4j (5.15+) instance. The following options are available:

  - Docker image

  - Neo4j Desktop

  - Neo4j Aura

  - Neo4j Server instance

- If required, an API key for the EmbeddingModel to generate the embeddings stored by the `Neo4jVectorStore`.

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the Neo4j Vector Store. To enable it, add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-vector-store-neo4j</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-vector-store-neo4j'
    }

Please have a look at the list of Configuration Properties for the vector store to learn about the default values and configuration options.

The vector store implementation can initialize the requisite schema for you, but you must opt-in by specifying the `initializeSchema` boolean in the appropriate constructor or by setting `…​initialize-schema=true` in the `application.properties` file.

Additionally, you will need a configured `EmbeddingModel` bean. Refer to the EmbeddingModel section for more information.

Now you can auto-wire the `Neo4jVectorStore` as a vector store in your application.

    @Autowired VectorStore vectorStore;

    // ...

    List<Document> documents = List.of(
        new Document("Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!!", Map.of("meta1", "meta1")),
        new Document("The World is Big and Salvation Lurks Around the Corner"),
        new Document("You walk forward facing the past and you turn back toward the future.", Map.of("meta2", "meta2")));

    // Add the documents to Neo4j
    vectorStore.add(documents);

    // Retrieve documents similar to a query
    List<Document> results = vectorStore.similaritySearch(SearchRequest.builder().query("Spring").topK(5).build());

### Configuration Properties

To connect to Neo4j and use the `Neo4jVectorStore`, you need to provide access details for your instance. A simple configuration can be provided via Spring Boot’s `application.yml`:

    spring:
      neo4j:
        uri: <neo4j instance URI>
        authentication:
          username: <neo4j username>
          password: <neo4j password>
      ai:
        vectorstore:
          neo4j:
            initialize-schema: true
            database-name: neo4j
            index-name: custom-index
            embedding-dimension: 1536
            distance-type: cosine

The Spring Boot properties starting with `spring.neo4j.*` are used to configure the Neo4j client:

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
<td class="tableblock halign-left valign-top"><p><code>spring.neo4j.uri</code></p></td>
<td class="tableblock halign-left valign-top"><p>URI for connecting to the Neo4j instance</p></td>
<td class="tableblock halign-left valign-top"><p><code>neo4j://localhost:7687</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.neo4j.authentication.username</code></p></td>
<td class="tableblock halign-left valign-top"><p>Username for authentication with Neo4j</p></td>
<td class="tableblock halign-left valign-top"><p><code>neo4j</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.neo4j.authentication.password</code></p></td>
<td class="tableblock halign-left valign-top"><p>Password for authentication with Neo4j</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

Properties starting with `spring.ai.vectorstore.neo4j.*` are used to configure the `Neo4jVectorStore`:

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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.neo4j.initialize-schema</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to initialize the required schema</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.neo4j.database-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>The name of the Neo4j database to use</p></td>
<td class="tableblock halign-left valign-top"><p><code>neo4j</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.neo4j.index-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>The name of the index to store the vectors</p></td>
<td class="tableblock halign-left valign-top"><p><code>spring-ai-document-index</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.neo4j.embedding-dimension</code></p></td>
<td class="tableblock halign-left valign-top"><p>The number of dimensions in the vector</p></td>
<td class="tableblock halign-left valign-top"><p><code>1536</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.neo4j.distance-type</code></p></td>
<td class="tableblock halign-left valign-top"><p>The distance function to use</p></td>
<td class="tableblock halign-left valign-top"><p><code>cosine</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.neo4j.label</code></p></td>
<td class="tableblock halign-left valign-top"><p>The label used for document nodes</p></td>
<td class="tableblock halign-left valign-top"><p><code>Document</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.neo4j.embedding-property</code></p></td>
<td class="tableblock halign-left valign-top"><p>The property name used to store embeddings</p></td>
<td class="tableblock halign-left valign-top"><p><code>embedding</code></p></td>
</tr>
</tbody>
</table>

The following distance functions are available:

- `cosine` - Default, suitable for most use cases. Measures cosine similarity between vectors.

- `euclidean` - Euclidean distance between vectors. Lower values indicate higher similarity.

## Manual Configuration

Instead of using the Spring Boot auto-configuration, you can manually configure the Neo4j vector store. For this you need to add the `spring-ai-neo4j-store` to your project:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-neo4j-store</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-neo4j-store'
    }

Create a Neo4j `Driver` bean. Read the Neo4j Documentation for more in-depth information about the configuration of a custom driver.

    @Bean
    public Driver driver() {
        return GraphDatabase.driver("neo4j://<host>:<bolt-port>",
                AuthTokens.basic("<username>", "<password>"));
    }

Then create the `Neo4jVectorStore` bean using the builder pattern:

    @Bean
    public VectorStore vectorStore(Driver driver, EmbeddingModel embeddingModel) {
        return Neo4jVectorStore.builder(driver, embeddingModel)
            .databaseName("neo4j")                // Optional: defaults to "neo4j"
            .distanceType(Neo4jDistanceType.COSINE) // Optional: defaults to COSINE
            .embeddingDimension(1536)                      // Optional: defaults to 1536
            .label("Document")                     // Optional: defaults to "Document"
            .embeddingProperty("embedding")        // Optional: defaults to "embedding"
            .indexName("custom-index")             // Optional: defaults to "spring-ai-document-index"
            .initializeSchema(true)                // Optional: defaults to false
            .batchingStrategy(new TokenCountBatchingStrategy()) // Optional: defaults to TokenCountBatchingStrategy
            .build();
    }

    // This can be any EmbeddingModel implementation
    @Bean
    public EmbeddingModel embeddingModel() {
        return new OpenAiEmbeddingModel(OpenAiEmbeddingOptions.builder().apiKey(System.getenv("OPENAI_API_KEY")).build());
    }

## Metadata Filtering

You can leverage the generic, portable metadata filters with Neo4j store as well.

For example, you can use either the text expression language:

    vectorStore.similaritySearch(
        SearchRequest.builder()
            .query("The World")
            .topK(TOP_K)
            .similarityThreshold(SIMILARITY_THRESHOLD)
            .filterExpression("author in ['john', 'jill'] && 'article_type' == 'blog'").build());

or programmatically using the `Filter.Expression` DSL:

    FilterExpressionBuilder b = new FilterExpressionBuilder();

    vectorStore.similaritySearch(SearchRequest.builder()
        .query("The World")
        .topK(TOP_K)
        .similarityThreshold(SIMILARITY_THRESHOLD)
        .filterExpression(b.and(
            b.in("author", "john", "jill"),
            b.eq("article_type", "blog")).build()).build());

For example, this portable filter expression:

    author in ['john', 'jill'] && 'article_type' == 'blog'

is converted into the proprietary Neo4j filter format:

    node.`metadata.author` IN ["john","jill"] AND node.`metadata.'article_type'` = "blog"

## Accessing the Native Client

The Neo4j Vector Store implementation provides access to the underlying native Neo4j client (`Driver`) through the `getNativeClient()` method:

    Neo4jVectorStore vectorStore = context.getBean(Neo4jVectorStore.class);
    Optional<Driver> nativeClient = vectorStore.getNativeClient();

    if (nativeClient.isPresent()) {
        Driver driver = nativeClient.get();
        // Use the native client for Neo4j-specific operations
    }

The native client gives you access to Neo4j-specific features and operations that might not be exposed through the `VectorStore` interface.

MongoDB Atlas OpenSearch

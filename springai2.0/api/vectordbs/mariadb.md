Search

# MariaDB Vector Store

This section walks you through setting up `MariaDBVectorStore` to store document embeddings and perform similarity searches.

MariaDB Vector is part of MariaDB 11.7 and enables storing and searching over machine learning-generated embeddings. It provides efficient vector similarity search capabilities using vector indexes, supporting both cosine similarity and Euclidean distance metrics.

## Prerequisites

- A running MariaDB (11.7+) instance. The following options are available:

  - Docker image

  - MariaDB Server

  - MariaDB SkySQL

- If required, an API key for the EmbeddingModel to generate the embeddings stored by the `MariaDBVectorStore`.

## Auto-Configuration

Spring AI provides Spring Boot auto-configuration for the MariaDB Vector Store. To enable it, add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-vector-store-mariadb</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-vector-store-mariadb'
    }

The vector store implementation can initialize the required schema for you, but you must opt-in by specifying the `initializeSchema` boolean in the appropriate constructor or by setting `…​initialize-schema=true` in the `application.properties` file.

Additionally, you will need a configured `EmbeddingModel` bean. Refer to the EmbeddingModel section for more information.

For example, to use the OpenAI EmbeddingModel, add the following dependency:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-openai</artifactId>
    </dependency>

Now you can auto-wire the `MariaDBVectorStore` in your application:

    @Autowired VectorStore vectorStore;

    // ...

    List<Document> documents = List.of(
        new Document("Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!!", Map.of("meta1", "meta1")),
        new Document("The World is Big and Salvation Lurks Around the Corner"),
        new Document("You walk forward facing the past and you turn back toward the future.", Map.of("meta2", "meta2")));

    // Add the documents to MariaDB
    vectorStore.add(documents);

    // Retrieve documents similar to a query
    List<Document> results = vectorStore.similaritySearch(SearchRequest.builder().query("Spring").topK(5).build());

### Configuration Properties

To connect to MariaDB and use the `MariaDBVectorStore`, you need to provide access details for your instance. A simple configuration can be provided via Spring Boot’s `application.yml`:

    spring:
      datasource:
        url: jdbc:mariadb://localhost/db
        username: myUser
        password: myPassword
      ai:
        vectorstore:
          mariadb:
            initialize-schema: true
            distance-type: COSINE
            dimensions: 1536

Properties starting with `spring.ai.vectorstore.mariadb.*` are used to configure the `MariaDBVectorStore`:

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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.mariadb.initialize-schema</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to initialize the required schema</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.mariadb.distance-type</code></p></td>
<td class="tableblock halign-left valign-top"><p>Search distance type. Use <code>COSINE</code> (default) or <code>EUCLIDEAN</code>. If vectors are normalized to length 1, you can use <code>EUCLIDEAN</code> for best performance.</p></td>
<td class="tableblock halign-left valign-top"><p><code>COSINE</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.mariadb.dimensions</code></p></td>
<td class="tableblock halign-left valign-top"><p>Embeddings dimension. If not specified explicitly, will retrieve dimensions from the provided <code>EmbeddingModel</code>.</p></td>
<td class="tableblock halign-left valign-top"><p><code>1536</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.mariadb.remove-existing-vector-store-table</code></p></td>
<td class="tableblock halign-left valign-top"><p>Deletes the existing vector store table on startup.</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.mariadb.schema-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>Vector store schema name</p></td>
<td class="tableblock halign-left valign-top"><p><code>null</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.mariadb.table-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>Vector store table name</p></td>
<td class="tableblock halign-left valign-top"><p><code>vector_store</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.mariadb.schema-validation</code></p></td>
<td class="tableblock halign-left valign-top"><p>Enables schema and table name validation to ensure they are valid and existing objects.</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
</tbody>
</table>

## Manual Configuration

Instead of using the Spring Boot auto-configuration, you can manually configure the MariaDB vector store. For this you need to add the following dependencies to your project:

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-jdbc</artifactId>
    </dependency>

    <dependency>
        <groupId>org.mariadb.jdbc</groupId>
        <artifactId>mariadb-java-client</artifactId>
        <scope>runtime</scope>
    </dependency>

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-mariadb-store</artifactId>
    </dependency>

Then create the `MariaDBVectorStore` bean using the builder pattern:

    @Bean
    public VectorStore vectorStore(JdbcTemplate jdbcTemplate, EmbeddingModel embeddingModel) {
        return MariaDBVectorStore.builder(jdbcTemplate, embeddingModel)
            .dimensions(1536)                      // Optional: defaults to 1536
            .distanceType(MariaDBDistanceType.COSINE) // Optional: defaults to COSINE
            .schemaName("mydb")                    // Optional: defaults to null
            .vectorTableName("custom_vectors")     // Optional: defaults to "vector_store"
            .contentFieldName("text")             // Optional: defaults to "content"
            .embeddingFieldName("embedding")      // Optional: defaults to "embedding"
            .idFieldName("doc_id")                // Optional: defaults to "id"
            .metadataFieldName("meta")           // Optional: defaults to "metadata"
            .initializeSchema(true)               // Optional: defaults to false
            .schemaValidation(true)              // Optional: defaults to false
            .removeExistingVectorStoreTable(false) // Optional: defaults to false
            .maxDocumentBatchSize(10000)         // Optional: defaults to 10000
            .build();
    }

    // This can be any EmbeddingModel implementation
    @Bean
    public EmbeddingModel embeddingModel() {
        return new OpenAiEmbeddingModel(OpenAiEmbeddingOptions.builder().apiKey(System.getenv("OPENAI_API_KEY")).build());
    }

## Metadata Filtering

You can leverage the generic, portable metadata filters with MariaDB Vector store.

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

## Similarity Scores

The MariaDB Vector Store automatically calculates similarity scores for documents returned from similarity searches. These scores provide a normalized measure of how closely each document matches your search query.

### Score Calculation

Similarity scores are calculated using the formula `score = 1.0 - distance`, where:

- Score: A value between `0.0` and `1.0`, where `1.0` indicates perfect similarity and `0.0` indicates no similarity

- Distance: The raw distance value calculated using the configured distance type (`COSINE` or `EUCLIDEAN`)

This means that documents with smaller distances (more similar) will have higher scores, making the results more intuitive to interpret.

### Accessing Scores

You can access the similarity score for each document through the `getScore()` method:

    List<Document> results = vectorStore.similaritySearch(
        SearchRequest.builder()
            .query("Spring AI")
            .topK(5)
            .build());

    for (Document doc : results) {
        double score = doc.getScore();  // Value between 0.0 and 1.0
        System.out.println("Document: " + doc.getText());
        System.out.println("Similarity Score: " + score);
    }

### Search Results Ordering

Search results are automatically ordered by similarity score in descending order (highest score first). This ensures that the most relevant documents appear at the top of your results.

### Distance Metadata

In addition to the similarity score, the raw distance value is still available in the document metadata:

    for (Document doc : results) {
        double score = doc.getScore();
        float distance = (Float) doc.getMetadata().get("distance");

        System.out.println("Score: " + score + ", Distance: " + distance);
    }

### Similarity Threshold

When using similarity thresholds in your search requests, specify the threshold as a score value (`0.0` to `1.0`) rather than a distance:

    List<Document> results = vectorStore.similaritySearch(
        SearchRequest.builder()
            .query("Spring AI")
            .topK(10)
            .similarityThreshold(0.8)  // Only return documents with score >= 0.8
            .build());

This makes threshold values consistent and intuitive - higher values mean more restrictive searches that only return highly similar documents.

## Accessing the Native Client

The MariaDB Vector Store implementation provides access to the underlying native JDBC client (`JdbcTemplate`) through the `getNativeClient()` method:

    MariaDBVectorStore vectorStore = context.getBean(MariaDBVectorStore.class);
    Optional<JdbcTemplate> nativeClient = vectorStore.getNativeClient();

    if (nativeClient.isPresent()) {
        JdbcTemplate jdbc = nativeClient.get();
        // Use the native client for MariaDB-specific operations
    }

The native client gives you access to MariaDB-specific features and operations that might not be exposed through the `VectorStore` interface.

GemFire Milvus

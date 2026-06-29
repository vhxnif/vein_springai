Search

# Oracle Database 23ai - AI Vector Search

The AI Vector Search capabilities of the Oracle Database 23ai (23.4+) are available as a Spring AI `VectorStore` to help you to store document embeddings and perform similarity searches. Of course, all other features are also available.

## Auto-Configuration

Start by adding the Oracle Vector Store boot starter dependency to your project:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-vector-store-oracle</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-vector-store-oracle'
    }

If you need this vector store to initialize the schema for you then you’ll need to pass true for the `initializeSchema` boolean parameter in the appropriate constructor or by setting `…​initialize-schema=true` in the `application.properties` file.

The Vector Store, also requires an `EmbeddingModel` instance to calculate embeddings for the documents. You can pick one of the available EmbeddingModel Implementations.

For example to use the OpenAI EmbeddingModel add the following dependency to your project:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-openai</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-model-openai'
    }

To connect to and configure the `OracleVectorStore`, you need to provide access details for your database. A simple configuration can either be provided via Spring Boot’s `application.yml`

    spring:
      datasource:
        url: jdbc:oracle:thin:@//localhost:1521/freepdb1
        username: mlops
        password: mlops
      ai:
        vectorstore:
          oracle:
            index-type: IVF
            distance-type: COSINE
            dimensions: 1536

Now you can Auto-wire the `OracleVectorStore` in your application and use it:

    @Autowired VectorStore vectorStore;

    // ...

    List<Document> documents = List.of(
        new Document("Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!!", Map.of("meta1", "meta1")),
        new Document("The World is Big and Salvation Lurks Around the Corner"),
        new Document("You walk forward facing the past and you turn back toward the future.", Map.of("meta2", "meta2")));

    // Add the documents to Oracle Vector Store
    vectorStore.add(documents);

    // Retrieve documents similar to a query
    List<Document> results = this.vectorStore.similaritySearch(SearchRequest.builder().query("Spring").topK(5).build());

### Configuration properties

You can use the following properties in your Spring Boot configuration to customize the `OracleVectorStore`.

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
<th class="tableblock halign-left valign-top">Default value</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.oracle.index-type</code></p></td>
<td class="tableblock halign-left valign-top"><p>Nearest neighbor search index type. Options are <code>NONE</code> - exact nearest neighbor search, <code>IVF</code> - Inverted Flat File index. It has faster build times and uses less memory than HNSW, but has lower query performance (in terms of speed-recall tradeoff). <code>HNSW</code> - creates a multilayer graph. It has slower build times and uses more memory than IVF, but has better query performance (in terms of speed-recall tradeoff).</p></td>
<td class="tableblock halign-left valign-top"><p>NONE</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.oracle.distance-type</code></p></td>
<td class="tableblock halign-left valign-top"><p>Search distance type among <code>COSINE</code> (default), <code>DOT</code>, <code>EUCLIDEAN</code>, <code>EUCLIDEAN_SQUARED</code>, and <code>MANHATTAN</code>.</p>
<p>NOTE: If vectors are normalized, you can use <code>DOT</code> or <code>COSINE</code> for best performance.</p></td>
<td class="tableblock halign-left valign-top"><p>COSINE</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.oracle.forced-normalization</code></p></td>
<td class="tableblock halign-left valign-top"><p>Allows enabling vector normalization (if true) before insertion and for similarity search.</p>
<p>CAUTION: Setting this to true is a requirement to allow for search request similarity threshold.</p>
<p>NOTE: If vectors are normalized, you can use <code>DOT</code> or <code>COSINE</code> for best performance.</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.oracle.dimensions</code></p></td>
<td class="tableblock halign-left valign-top"><p>Embeddings dimension. If not specified explicitly the OracleVectorStore will allow the maximum: 65535. Dimensions are set to the embedding column on table creation. If you change the dimensions your would have to re-create the table as well.</p></td>
<td class="tableblock halign-left valign-top"><p>65535</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.oracle.remove-existing-vector-store-table</code></p></td>
<td class="tableblock halign-left valign-top"><p>Drops the existing table on start up.</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.oracle.initialize-schema</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to initialize the required schema.</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.oracle.search-accuracy</code></p></td>
<td class="tableblock halign-left valign-top"><p>Denote the requested accuracy target in the presence of index. Disabled by default. You need to provide an integer in the range [1,100] to override the default index accuracy (95). Using lower accuracy provides approximate similarity search trading off speed versus accuracy.</p></td>
<td class="tableblock halign-left valign-top"><p>-1 (<code>DEFAULT_SEARCH_ACCURACY</code>)</p></td>
</tr>
</tbody>
</table>

## Metadata filtering

You can leverage the generic, portable metadata filters with the `OracleVectorStore`.

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
            b.in("author","john", "jill"),
            b.eq("article_type", "blog")).build()).build());

## Manual Configuration

Instead of using the Spring Boot auto-configuration, you can manually configure the `OracleVectorStore`. For this you need to add the Oracle JDBC driver and `JdbcTemplate` auto-configuration dependencies to your project:

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-jdbc</artifactId>
    </dependency>

    <dependency>
        <groupId>com.oracle.database.jdbc</groupId>
        <artifactId>ojdbc11</artifactId>
        <scope>runtime</scope>
    </dependency>

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-oracle-store</artifactId>
    </dependency>

To configure the `OracleVectorStore` in your application, you can use the following setup:

    @Bean
    public VectorStore vectorStore(JdbcTemplate jdbcTemplate, EmbeddingModel embeddingModel) {
        return OracleVectorStore.builder(jdbcTemplate, embeddingModel)
            .tableName("my_vectors")
            .indexType(OracleVectorStoreIndexType.IVF)
            .distanceType(OracleVectorStoreDistanceType.COSINE)
            .dimensions(1536)
            .searchAccuracy(95)
            .initializeSchema(true)
            .build();
    }

## Run Oracle Database 23ai locally

    docker run --rm --name oracle23ai -p 1521:1521 -e APP_USER=mlops -e APP_USER_PASSWORD=mlops -e ORACLE_PASSWORD=mlops gvenzl/oracle-free:23-slim

You can then connect to the database using:

    sql mlops/mlops@localhost/freepdb1

## Accessing the Native Client

The Oracle Vector Store implementation provides access to the underlying native Oracle client (`OracleConnection`) through the `getNativeClient()` method:

    OracleVectorStore vectorStore = context.getBean(OracleVectorStore.class);
    Optional<OracleConnection> nativeClient = vectorStore.getNativeClient();

    if (nativeClient.isPresent()) {
        OracleConnection connection = nativeClient.get();
        // Use the native client for Oracle-specific operations
    }

The native client gives you access to Oracle-specific features and operations that might not be exposed through the `VectorStore` interface.

OpenSearch PGvector

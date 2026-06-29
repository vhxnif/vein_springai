Search

# PGvector

This section walks you through setting up the PGvector `VectorStore` to store document embeddings and perform similarity searches.

PGvector is an open-source extension for PostgreSQL that enables storing and searching over machine learning-generated embeddings. It provides different capabilities that let users identify both exact and approximate nearest neighbors. It is designed to work seamlessly with other PostgreSQL features, including indexing and querying.

## Prerequisites

First you need access to PostgreSQL instance with enabled `vector`, `hstore` and `uuid-ossp` extensions.

On startup with the schema initialization feature explicitly enabled, the `PgVectorStore` will attempt to install the required database extensions and create the required `vector_store` table with an index if not existing.

Optionally, you can do this manually like so:

    CREATE EXTENSION IF NOT EXISTS vector;
    CREATE EXTENSION IF NOT EXISTS hstore;
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

    CREATE TABLE IF NOT EXISTS vector_store (
        id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
        content text,
        metadata json,
        embedding vector(1536) // 1536 is the default embedding dimension
    );

    CREATE INDEX ON vector_store USING HNSW (embedding vector_cosine_ops);

Next, if required, an API key for the EmbeddingModel to generate the embeddings stored by the `PgVectorStore`.

## Auto-Configuration

Then add the PgVectorStore boot starter dependency to your project:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-vector-store-pgvector</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-vector-store-pgvector'
    }

The vector store implementation can initialize the required schema for you, but you must opt-in by specifying the `initializeSchema` boolean in the appropriate constructor or by setting `…​initialize-schema=true` in the `application.properties` file.

The Vector Store also requires an `EmbeddingModel` instance to calculate embeddings for the documents. You can pick one of the available EmbeddingModel Implementations.

For example, to use the OpenAI EmbeddingModel, add the following dependency to your project:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-openai</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-model-openai'
    }

To connect to and configure the `PgVectorStore`, you need to provide access details for your instance. A simple configuration can be provided via Spring Boot’s `application.yml`.

    spring:
      datasource:
        url: jdbc:postgresql://localhost:5432/postgres
        username: postgres
        password: postgres
      ai:
        vectorstore:
          pgvector:
            index-type: HNSW
            distance-type: COSINE_DISTANCE
            dimensions: 1536
            max-document-batch-size: 10000 # Optional: Maximum number of documents per batch

Now you can auto-wire the `VectorStore` in your application and use it

    @Autowired VectorStore vectorStore;

    // ...

    List<Document> documents = List.of(
        new Document("Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!!", Map.of("meta1", "meta1")),
        new Document("The World is Big and Salvation Lurks Around the Corner"),
        new Document("You walk forward facing the past and you turn back toward the future.", Map.of("meta2", "meta2")));

    // Add the documents to PGVector
    vectorStore.add(documents);

    // Retrieve documents similar to a query
    List<Document> results = this.vectorStore.similaritySearch(SearchRequest.builder().query("Spring").topK(5).build());

### Configuration properties

You can use the following properties in your Spring Boot configuration to customize the PGVector vector store.

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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.pgvector.index-type</code></p></td>
<td class="tableblock halign-left valign-top"><p>Nearest neighbor search index type. Options are <code>NONE</code> - exact nearest neighbor search, <code>IVFFlat</code> - index divides vectors into lists, and then searches a subset of those lists that are closest to the query vector. It has faster build times and uses less memory than HNSW, but has lower query performance (in terms of speed-recall tradeoff). <code>HNSW</code> - creates a multilayer graph. It has slower build times and uses more memory than IVFFlat, but has better query performance (in terms of speed-recall tradeoff). There’s no training step like IVFFlat, so the index can be created without any data in the table.</p></td>
<td class="tableblock halign-left valign-top"><p>HNSW</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.pgvector.distance-type</code></p></td>
<td class="tableblock halign-left valign-top"><p>Search distance type. Defaults to <code>COSINE_DISTANCE</code>. But if vectors are normalized to length 1, you can use <code>EUCLIDEAN_DISTANCE</code> or <code>NEGATIVE_INNER_PRODUCT</code> for best performance.</p></td>
<td class="tableblock halign-left valign-top"><p>COSINE_DISTANCE</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.pgvector.dimensions</code></p></td>
<td class="tableblock halign-left valign-top"><p>Embeddings dimension. If not specified explicitly the PgVectorStore will retrieve the dimensions form the provided <code>EmbeddingModel</code>. Dimensions are set to the embedding column the on table creation. If you change the dimensions your would have to re-create the vector_store table as well.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.pgvector.remove-existing-vector-store-table</code></p></td>
<td class="tableblock halign-left valign-top"><p>Deletes the existing <code>vector_store</code> table on start up.</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.pgvector.initialize-schema</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to initialize the required schema</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.pgvector.schema-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>Vector store schema name</p></td>
<td class="tableblock halign-left valign-top"><p><code>public</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.pgvector.table-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>Vector store table name</p></td>
<td class="tableblock halign-left valign-top"><p><code>vector_store</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.pgvector.schema-validation</code></p></td>
<td class="tableblock halign-left valign-top"><p>Enables schema and table name validation to ensure they are valid and existing objects.</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.pgvector.max-document-batch-size</code></p></td>
<td class="tableblock halign-left valign-top"><p>Maximum number of documents to process in a single batch.</p></td>
<td class="tableblock halign-left valign-top"><p>10000</p></td>
</tr>
</tbody>
</table>

## Metadata filtering

You can leverage the generic, portable metadata filters with the PgVector store.

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

Instead of using the Spring Boot auto-configuration, you can manually configure the `PgVectorStore`. For this you need to add the PostgreSQL connection and `JdbcTemplate` auto-configuration dependencies to your project:

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-jdbc</artifactId>
    </dependency>

    <dependency>
        <groupId>org.postgresql</groupId>
        <artifactId>postgresql</artifactId>
        <scope>runtime</scope>
    </dependency>

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-pgvector-store</artifactId>
    </dependency>

To configure PgVector in your application, you can use the following setup:

    @Bean
    public VectorStore vectorStore(JdbcTemplate jdbcTemplate, EmbeddingModel embeddingModel) {
        return PgVectorStore.builder(jdbcTemplate, embeddingModel)
            .dimensions(1536)                    // Optional: defaults to model dimensions or 1536
            .distanceType(COSINE_DISTANCE)       // Optional: defaults to COSINE_DISTANCE
            .indexType(HNSW)                     // Optional: defaults to HNSW
            .initializeSchema(true)              // Optional: defaults to false
            .schemaName("public")                // Optional: defaults to "public"
            .vectorTableName("vector_store")     // Optional: defaults to "vector_store"
            .maxDocumentBatchSize(10000)         // Optional: defaults to 10000
            .build();
    }

## Run Postgres & PGVector DB locally

    docker run -it --rm --name postgres -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres pgvector/pgvector

You can connect to this server like this:

    psql -U postgres -h localhost -p 5432

## Accessing the Native Client

The PGVector Store implementation provides access to the underlying native JDBC client (`JdbcTemplate`) through the `getNativeClient()` method:

    PgVectorStore vectorStore = context.getBean(PgVectorStore.class);
    Optional<JdbcTemplate> nativeClient = vectorStore.getNativeClient();

    if (nativeClient.isPresent()) {
        JdbcTemplate jdbc = nativeClient.get();
        // Use the native client for PostgreSQL-specific operations
    }

The native client gives you access to PostgreSQL-specific features and operations that might not be exposed through the `VectorStore` interface.

Oracle Pinecone

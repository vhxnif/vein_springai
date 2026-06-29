Search

# Apache Cassandra Vector Store

This section walks you through setting up `CassandraVectorStore` to store document embeddings and perform similarity searches.

## What is Apache Cassandra?

Apache Cassandra® is a true open source distributed database renowned for linear scalability, proven fault-tolerance and low latency, making it the perfect platform for mission-critical transactional data.

Its Vector Similarity Search (VSS) is based on the JVector library that ensures best-in-class performance and relevancy.

A vector search in Apache Cassandra is done as simply as:

    SELECT content FROM table ORDER BY content_vector ANN OF query_embedding;

More docs on this can be read here.

This Spring AI Vector Store is designed to work for both brand-new RAG applications and be able to be retrofitted on top of existing data and tables.

The store can also be used for non-RAG use-cases in an existing database, e.g. semantic searches, geo-proximity searches, etc.

The store will automatically create, or enhance, the schema as needed according to its configuration. If you don’t want the schema modifications, configure the store with `initializeSchema`.

When using spring-boot-autoconfigure `initializeSchema` defaults to `false`, per Spring Boot standards, and you must opt-in to schema creation/modifications by setting `…​initialize-schema=true` in the `application.properties` file.

## What is JVector?

JVector is a pure Java embedded vector search engine.

It stands out from other HNSW Vector Similarity Search implementations by being:

- Algorithmic-fast. JVector uses state of the art graph algorithms inspired by DiskANN and related research that offer high recall and low latency.

- Implementation-fast. JVector uses the Panama SIMD API to accelerate index build and queries.

- Memory efficient. JVector compresses vectors using product quantization so they can stay in memory during searches.

- Disk-aware. JVector’s disk layout is designed to do the minimum necessary iops at query time.

- Concurrent. Index builds scale linearly to at least 32 threads. Double the threads, half the build time.

- Incremental. Query your index as you build it. No delay between adding a vector and being able to find it in search results.

- Easy to embed. API designed for easy embedding, by people using it in production.

## Prerequisites

1.  A `EmbeddingModel` instance to compute the document embeddings. This is usually configured as a Spring Bean. Several options are available:

    - `Transformers Embedding` - computes the embedding in your local environment. The default is via ONNX and the all-MiniLM-L6-v2 Sentence Transformers. This just works.

    - If you want to use OpenAI’s Embeddings - uses the OpenAI embedding endpoint. You need to create an account at OpenAI Signup and generate the api-key token at API Keys.

    - There are many more choices, see `Embeddings API` docs.

2.  An Apache Cassandra instance, from version 5.0-beta1

    1.  DIY Quick Start

    2.  For a managed offering Astra DB offers a healthy free tier offering.

## Dependencies

Add these dependencies to your project:

- For just the Cassandra Vector Store:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-cassandra-store</artifactId>
    </dependency>

- Or, for everything you need in a RAG application (using the default ONNX Embedding Model):

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-vector-store-cassandra</artifactId>
    </dependency>

## Configuration Properties

You can use the following properties in your Spring Boot configuration to customize the Apache Cassandra vector store.

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 66%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Property</th>
<th class="tableblock halign-left valign-top">Default Value</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.cassandra.keyspace</code></p></td>
<td class="tableblock halign-left valign-top"><p>springframework</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.cassandra.table</code></p></td>
<td class="tableblock halign-left valign-top"><p>ai_vector_store</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.cassandra.initialize-schema</code></p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.cassandra.index-name</code></p></td>
<td class="tableblock halign-left valign-top"></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.cassandra.content-column-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>content</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.cassandra.embedding-column-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>embedding</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.cassandra.fixed-thread-pool-executor-size</code></p></td>
<td class="tableblock halign-left valign-top"><p>16</p></td>
</tr>
</tbody>
</table>

## Usage

### Basic Usage

Create a CassandraVectorStore instance as a Spring Bean:

    @Bean
    public VectorStore vectorStore(CqlSession session, EmbeddingModel embeddingModel) {
        return CassandraVectorStore.builder(embeddingModel)
            .session(session)
            .keyspace("my_keyspace")
            .table("my_vectors")
            .build();
    }

Once you have the vector store instance, you can add documents and perform searches:

    // Add documents
    vectorStore.add(List.of(
        new Document("1", "content1", Map.of("key1", "value1")),
        new Document("2", "content2", Map.of("key2", "value2"))
    ));

    // Search with filters
    List<Document> results = vectorStore.similaritySearch(
        SearchRequest.query("search text")
            .withTopK(5)
            .withSimilarityThreshold(0.7f)
            .withFilterExpression("metadata.key1 == 'value1'")
    );

### Advanced Configuration

For more complex use cases, you can configure additional settings in your Spring Bean:

    @Bean
    public VectorStore vectorStore(CqlSession session, EmbeddingModel embeddingModel) {
        return CassandraVectorStore.builder(embeddingModel)
            .session(session)
            .keyspace("my_keyspace")
            .table("my_vectors")
            // Configure primary keys
            .partitionKeys(List.of(
                new SchemaColumn("id", DataTypes.TEXT),
                new SchemaColumn("category", DataTypes.TEXT)
            ))
            .clusteringKeys(List.of(
                new SchemaColumn("timestamp", DataTypes.TIMESTAMP)
            ))
            // Add metadata columns with optional indexing
            .addMetadataColumns(
                new SchemaColumn("category", DataTypes.TEXT, SchemaColumnTags.INDEXED),
                new SchemaColumn("score", DataTypes.DOUBLE)
            )
            // Customize column names
            .contentColumnName("text")
            .embeddingColumnName("vector")
            // Performance tuning
            .fixedThreadPoolExecutorSize(32)
            // Schema management
            .initializeSchema(true)
            // Custom batching strategy
            .batchingStrategy(new TokenCountBatchingStrategy())
            .build();
    }

### Connection Configuration

There are two ways to configure the connection to Cassandra:

- Using an injected CqlSession (recommended):

    @Bean
    public VectorStore vectorStore(CqlSession session, EmbeddingModel embeddingModel) {
        return CassandraVectorStore.builder(embeddingModel)
            .session(session)
            .keyspace("my_keyspace")
            .table("my_vectors")
            .build();
    }

- Using connection details directly in the builder:

    @Bean
    public VectorStore vectorStore(EmbeddingModel embeddingModel) {
        return CassandraVectorStore.builder(embeddingModel)
            .contactPoint(new InetSocketAddress("localhost", 9042))
            .localDatacenter("datacenter1")
            .keyspace("my_keyspace")
            .build();
    }

### Metadata Filtering

You can leverage the generic, portable metadata filters with the CassandraVectorStore. For metadata columns to be searchable they must be either primary keys or SAI indexed. To make non-primary-key columns indexed, configure the metadata column with the `SchemaColumnTags.INDEXED`.

For example, you can use either the text expression language:

    vectorStore.similaritySearch(
        SearchRequest.builder().query("The World")
            .topK(5)
            .filterExpression("country in ['UK', 'NL'] && year >= 2020").build());

or programmatically using the expression DSL:

    Filter.Expression f = new FilterExpressionBuilder()
        .and(
            f.in("country", "UK", "NL"),
            f.gte("year", 2020)
        ).build();

    vectorStore.similaritySearch(
        SearchRequest.builder().query("The World")
            .topK(5)
            .filterExpression(f).build());

The portable filter expressions get automatically converted into CQL queries.

## Advanced Example: Vector Store on top of Wikipedia Dataset

The following example demonstrates how to use the store on an existing schema. Here we use the schema from the github.com/datastax-labs/colbert-wikipedia-data project which comes with the full wikipedia dataset ready vectorized for you.

First, create the schema in the Cassandra database:

    wget https://s.apache.org/colbert-wikipedia-schema-cql -O colbert-wikipedia-schema.cql
    cqlsh -f colbert-wikipedia-schema.cql

Then configure the store using the builder pattern:

    @Bean
    public VectorStore vectorStore(CqlSession session, EmbeddingModel embeddingModel) {
        List<SchemaColumn> partitionColumns = List.of(
            new SchemaColumn("wiki", DataTypes.TEXT),
            new SchemaColumn("language", DataTypes.TEXT),
            new SchemaColumn("title", DataTypes.TEXT)
        );

        List<SchemaColumn> clusteringColumns = List.of(
            new SchemaColumn("chunk_no", DataTypes.INT),
            new SchemaColumn("bert_embedding_no", DataTypes.INT)
        );

        List<SchemaColumn> extraColumns = List.of(
            new SchemaColumn("revision", DataTypes.INT),
            new SchemaColumn("id", DataTypes.INT)
        );

        return CassandraVectorStore.builder()
            .session(session)
            .embeddingModel(embeddingModel)
            .keyspace("wikidata")
            .table("articles")
            .partitionKeys(partitionColumns)
            .clusteringKeys(clusteringColumns)
            .contentColumnName("body")
            .embeddingColumnName("all_minilm_l6_v2_embedding")
            .indexName("all_minilm_l6_v2_ann")
            .initializeSchema(false)
            .addMetadataColumns(extraColumns)
            .primaryKeyTranslator((List<Object> primaryKeys) -> {
                if (primaryKeys.isEmpty()) {
                    return "test§¶0";
                }
                return String.format("%s§¶%s", primaryKeys.get(2), primaryKeys.get(3));
            })
            .documentIdTranslator((id) -> {
                String[] parts = id.split("§¶");
                String title = parts[0];
                int chunk_no = parts.length > 1 ? Integer.parseInt(parts[1]) : 0;
                return List.of("simplewiki", "en", title, chunk_no, 0);
            })
            .build();
    }

    @Bean
    public EmbeddingModel embeddingModel() {
        // default is ONNX all-MiniLM-L6-v2 which is what we want
        return new TransformersEmbeddingModel();
    }

### Loading the Complete Wikipedia Dataset

To load the full wikipedia dataset:

1.  Download `simplewiki-sstable.tar` from s.apache.org/simplewiki-sstable-tar (this will take a while, the file is tens of GBs)

2.  Load the data:

    tar -xf simplewiki-sstable.tar -C ${CASSANDRA_DATA}/data/wikidata/articles-*/
    nodetool import wikidata articles ${CASSANDRA_DATA}/data/wikidata/articles-*/

## Accessing the Native Client

The Cassandra Vector Store implementation provides access to the underlying native Cassandra client (`CqlSession`) through the `getNativeClient()` method:

    CassandraVectorStore vectorStore = context.getBean(CassandraVectorStore.class);
    Optional<CqlSession> nativeClient = vectorStore.getNativeClient();

    if (nativeClient.isPresent()) {
        CqlSession session = nativeClient.get();
        // Use the native client for Cassandra-specific operations
    }

The native client gives you access to Cassandra-specific features and operations that might not be exposed through the `VectorStore` interface.

Amazon Bedrock Knowledge Base Chroma

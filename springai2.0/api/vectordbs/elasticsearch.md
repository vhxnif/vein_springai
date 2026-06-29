Search

# Elasticsearch

This section walks you through setting up the Elasticsearch `VectorStore` to store document embeddings and perform similarity searches.

Elasticsearch is an open source search and analytics engine based on the Apache Lucene library.

## Prerequisites

A running Elasticsearch instance. The following options are available:

- Docker

- Self-Managed Elasticsearch

- Elastic Cloud

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the Elasticsearch Vector Store. To enable it, add the following dependency to your project’s Maven `pom.xml` or Gradle `build.gradle` build files:

The vector store implementation can initialize the requisite schema for you, but you must opt-in by specifying the `initializeSchema` boolean in the appropriate constructor or by setting `…​initialize-schema=true` in the `application.properties` file. Alternatively you can opt-out the initialization and create the index manually using the Elasticsearch client, which can be useful if the index needs advanced mapping or additional configuration.

Please have a look at the list of configuration parameters for the vector store to learn about the default values and configuration options. These properties can be also set by configuring the `ElasticsearchVectorStoreOptions` bean.

Additionally, you will need a configured `EmbeddingModel` bean. Refer to the EmbeddingModel section for more information.

Now you can auto-wire the `ElasticsearchVectorStore` as a vector store in your application.

    @Autowired VectorStore vectorStore;

    // ...

    List <Document> documents = List.of(
        new Document("Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!!", Map.of("meta1", "meta1")),
        new Document("The World is Big and Salvation Lurks Around the Corner"),
        new Document("You walk forward facing the past and you turn back toward the future.", Map.of("meta2", "meta2")));

    // Add the documents to Elasticsearch
    vectorStore.add(documents);

    // Retrieve documents similar to a query
    List<Document> results = this.vectorStore.similaritySearch(SearchRequest.builder().query("Spring").topK(5).build());

### Configuration Properties

To connect to Elasticsearch and use the `ElasticsearchVectorStore`, you need to provide access details for your instance. A simple configuration can either be provided via Spring Boot’s `application.yml`,

    spring:
      elasticsearch:
        uris: <elasticsearch instance URIs>
        username: <elasticsearch username>
        password: <elasticsearch password>
      ai:
        vectorstore:
          elasticsearch:
            initialize-schema: true
            index-name: custom-index
            dimensions: 1536
            similarity: cosine

The Spring Boot properties starting with `spring.elasticsearch.*` are used to configure the Elasticsearch client:

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
<td class="tableblock halign-left valign-top"><p><code>spring.elasticsearch.connection-timeout</code></p></td>
<td class="tableblock halign-left valign-top"><p>Connection timeout used when communicating with Elasticsearch.</p></td>
<td class="tableblock halign-left valign-top"><p><code>1s</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.elasticsearch.password</code></p></td>
<td class="tableblock halign-left valign-top"><p>Password for authentication with Elasticsearch.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.elasticsearch.username</code></p></td>
<td class="tableblock halign-left valign-top"><p>Username for authentication with Elasticsearch.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.elasticsearch.uris</code></p></td>
<td class="tableblock halign-left valign-top"><p>Comma-separated list of the Elasticsearch instances to use.</p></td>
<td class="tableblock halign-left valign-top"><p><code>http://localhost:9200</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.elasticsearch.path-prefix</code></p></td>
<td class="tableblock halign-left valign-top"><p>Prefix added to the path of every request sent to Elasticsearch.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.elasticsearch.restclient.sniffer.delay-after-failure</code></p></td>
<td class="tableblock halign-left valign-top"><p>Delay of a sniff execution scheduled after a failure.</p></td>
<td class="tableblock halign-left valign-top"><p><code>1m</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.elasticsearch.restclient.sniffer.interval</code></p></td>
<td class="tableblock halign-left valign-top"><p>Interval between consecutive ordinary sniff executions.</p></td>
<td class="tableblock halign-left valign-top"><p><code>5m</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.elasticsearch.restclient.ssl.bundle</code></p></td>
<td class="tableblock halign-left valign-top"><p>SSL bundle name.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.elasticsearch.socket-keep-alive</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to enable socket keep alive between client and Elasticsearch.</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.elasticsearch.socket-timeout</code></p></td>
<td class="tableblock halign-left valign-top"><p>Socket timeout used when communicating with Elasticsearch.</p></td>
<td class="tableblock halign-left valign-top"><p><code>30s</code></p></td>
</tr>
</tbody>
</table>

Properties starting with `spring.ai.vectorstore.elasticsearch.*` are used to configure the `ElasticsearchVectorStore`:

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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.elasticsearch.initialize-schema</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to initialize the required schema</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.elasticsearch.index-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>The name of the index to store the vectors</p></td>
<td class="tableblock halign-left valign-top"><p><code>spring-ai-document-index</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.elasticsearch.dimensions</code></p></td>
<td class="tableblock halign-left valign-top"><p>The number of dimensions in the vector</p></td>
<td class="tableblock halign-left valign-top"><p><code>1536</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.elasticsearch.similarity</code></p></td>
<td class="tableblock halign-left valign-top"><p>The similarity function to use</p></td>
<td class="tableblock halign-left valign-top"><p><code>cosine</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.elasticsearch.embedding-field-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>The name of the vector field to search against</p></td>
<td class="tableblock halign-left valign-top"><p><code>embedding</code></p></td>
</tr>
</tbody>
</table>

The following similarity functions are available:

- `cosine` - Default, suitable for most use cases. Measures cosine similarity between vectors.

- `l2_norm` - Euclidean distance between vectors. Lower values indicate higher similarity.

- `dot_product` - Best performance for normalized vectors (e.g., OpenAI embeddings).

More details about each in the Elasticsearch Documentation on dense vectors.

## Metadata Filtering

You can leverage the generic, portable metadata filters with Elasticsearch as well.

For example, you can use either the text expression language:

    vectorStore.similaritySearch(SearchRequest.builder()
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

is converted into the proprietary Elasticsearch filter format:

    (metadata.author:john OR jill) AND metadata.article_type:blog

## Manual Configuration

Instead of using the Spring Boot auto-configuration, you can manually configure the Elasticsearch vector store. For this you need to add the `spring-ai-elasticsearch-store` to your project:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-elasticsearch-store</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-elasticsearch-store'
    }

Create an Elasticsearch `Rest5Client` bean. Read the Elasticsearch Documentation for more in-depth information about the configuration of a custom Rest5Client.

    @Bean
    public Rest5Client restClient() {
        return Rest5Client.builder(new HttpHost("<host>", 9200, "http"))
            .setDefaultHeaders(new Header[]{
                new BasicHeader("Authorization", "Basic <encoded username and password>")
            })
            .build();
    }

Then create the `ElasticsearchVectorStore` bean using the builder pattern:

    @Bean
    public VectorStore vectorStore(Rest5Client restClient, EmbeddingModel embeddingModel) {
        ElasticsearchVectorStoreOptions options = new ElasticsearchVectorStoreOptions();
        options.setIndexName("custom-index");    // Optional: defaults to "spring-ai-document-index"
        options.setSimilarity(COSINE);           // Optional: defaults to COSINE
        options.setDimensions(1536);             // Optional: defaults to model dimensions or 1536

        return ElasticsearchVectorStore.builder(restClient, embeddingModel)
            .options(options)                     // Optional: use custom options
            .initializeSchema(true)               // Optional: defaults to false
            .batchingStrategy(new TokenCountBatchingStrategy()) // Optional: defaults to TokenCountBatchingStrategy
            .build();
    }

    // This can be any EmbeddingModel implementation
    @Bean
    public EmbeddingModel embeddingModel() {
        return new OpenAiEmbeddingModel(OpenAiEmbeddingOptions.builder().apiKey(System.getenv("OPENAI_API_KEY")).build());
    }

## Accessing the Native Client

The Elasticsearch Vector Store implementation provides access to the underlying native Elasticsearch client (`ElasticsearchClient`) through the `getNativeClient()` method:

    ElasticsearchVectorStore vectorStore = context.getBean(ElasticsearchVectorStore.class);
    Optional<ElasticsearchClient> nativeClient = vectorStore.getNativeClient();

    if (nativeClient.isPresent()) {
        ElasticsearchClient client = nativeClient.get();
        // Use the native client for Elasticsearch-specific operations
    }

The native client gives you access to Elasticsearch-specific features and operations that might not be exposed through the `VectorStore` interface.

Couchbase GemFire

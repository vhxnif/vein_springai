Search

# OpenSearch

This section walks you through setting up `OpenSearchVectorStore` to store document embeddings and perform similarity searches.

OpenSearch is an open-source search and analytics engine originally forked from Elasticsearch, distributed under the Apache License 2.0. It enhances AI application development by simplifying the integration and management of AI-generated assets. OpenSearch supports vector, lexical, and hybrid search capabilities, leveraging advanced vector database functionalities to facilitate low-latency queries and similarity searches as detailed on the vector database page.

The OpenSearch k-NN functionality allows users to query vector embeddings from large datasets. An embedding is a numerical representation of a data object, such as text, image, audio, or document. Embeddings can be stored in the index and queried using various similarity functions.

## Prerequisites

- A running OpenSearch instance. The following options are available:

  - Self-Managed OpenSearch

  - Amazon OpenSearch Service

- If required, an API key for the EmbeddingModel to generate the embeddings stored by the `OpenSearchVectorStore`.

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the OpenSearch Vector Store. To enable it, add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-vector-store-opensearch</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file:

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-vector-store-opensearch'
    }

Please have a look at the list of configuration parameters for the vector store to learn about the default values and configuration options.

Additionally, you will need a configured `EmbeddingModel` bean. Refer to the EmbeddingModel section for more information.

Now you can auto-wire the `OpenSearchVectorStore` as a vector store in your application:

    @Autowired VectorStore vectorStore;

    // ...

    List<Document> documents = List.of(
        new Document("Spring AI rocks!! Spring AI rocks!! Spring AI rocks!!", Map.of("meta1", "meta1")),
        new Document("The World is Big and Salvation Lurks Around the Corner"),
        new Document("You walk forward facing the past and you turn back toward the future.", Map.of("meta2", "meta2")));

    // Add the documents to OpenSearch
    vectorStore.add(documents);

    // Retrieve documents similar to a query
    List<Document> results = vectorStore.similaritySearch(SearchRequest.builder().query("Spring").topK(5).build());

### Configuration Properties

To connect to OpenSearch and use the `OpenSearchVectorStore`, you need to provide access details for your instance. A simple configuration can be provided via Spring Boot’s `application.yml`:

    spring:
      ai:
        vectorstore:
          opensearch:
            uris: <opensearch instance URIs>
            username: <opensearch username>
            password: <opensearch password>
            index-name: spring-ai-document-index
            initialize-schema: true
            similarity-function: cosinesimil
            read-timeout: <time to wait for response>
            connect-timeout: <time to wait until connection established>
            path-prefix: <custom path prefix>
            ssl-bundle: <name of SSL bundle>
            aws:  # Only for Amazon OpenSearch Service
              host: <aws opensearch host>
              service-name: <aws service name>
              access-key: <aws access key>
              secret-key: <aws secret key>
              region: <aws region>

Properties starting with `spring.ai.vectorstore.opensearch.*` are used to configure the `OpenSearchVectorStore`:

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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.opensearch.uris</code></p></td>
<td class="tableblock halign-left valign-top"><p>URIs of the OpenSearch cluster endpoints</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.opensearch.username</code></p></td>
<td class="tableblock halign-left valign-top"><p>Username for accessing the OpenSearch cluster</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.opensearch.password</code></p></td>
<td class="tableblock halign-left valign-top"><p>Password for the specified username</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.opensearch.index-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>Name of the index to store vectors</p></td>
<td class="tableblock halign-left valign-top"><p><code>spring-ai-document-index</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.opensearch.initialize-schema</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to initialize the required schema</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.opensearch.similarity-function</code></p></td>
<td class="tableblock halign-left valign-top"><p>The similarity function to use (cosinesimil, l1, l2, linf, innerproduct)</p></td>
<td class="tableblock halign-left valign-top"><p><code>cosinesimil</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.opensearch.use-approximate-knn</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to use approximate k-NN for faster searches. If true, uses HNSW-based approximate search. If false, uses exact brute-force k-NN. See Approximate k-NN and Exact k-NN</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.opensearch.dimensions</code></p></td>
<td class="tableblock halign-left valign-top"><p>Number of dimensions for vector embeddings. Used when creating index mapping for approximate k-NN. If not set, uses the embedding model’s dimensions.</p></td>
<td class="tableblock halign-left valign-top"><p><code>1536</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.opensearch.mapping-json</code></p></td>
<td class="tableblock halign-left valign-top"><p>Custom JSON mapping for the index. Overrides default mapping generation.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.opensearch.read-timeout</code></p></td>
<td class="tableblock halign-left valign-top"><p>Time to wait for response from the opposite endpoint. 0 - infinity.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.opensearch.connect-timeout</code></p></td>
<td class="tableblock halign-left valign-top"><p>Time to wait until connection established. 0 - infinity.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.opensearch.path-prefix</code></p></td>
<td class="tableblock halign-left valign-top"><p>Path prefix for OpenSearch API endpoints. Useful when OpenSearch is behind a reverse proxy with a non-root path.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.opensearch.ssl-bundle</code></p></td>
<td class="tableblock halign-left valign-top"><p>Name of the SSL Bundle to use in case of SSL connection</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.opensearch.aws.host</code></p></td>
<td class="tableblock halign-left valign-top"><p>Hostname of the OpenSearch instance</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.opensearch.aws.service-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>AWS service name</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.opensearch.aws.access-key</code></p></td>
<td class="tableblock halign-left valign-top"><p>AWS access key</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.opensearch.aws.secret-key</code></p></td>
<td class="tableblock halign-left valign-top"><p>AWS secret key</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.opensearch.aws.region</code></p></td>
<td class="tableblock halign-left valign-top"><p>AWS region</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

The following similarity functions are available:

- `cosinesimil` - Default, suitable for most use cases. Measures cosine similarity between vectors.

- `l1` - Manhattan distance between vectors.

- `l2` - Euclidean distance between vectors.

- `linf` - Chebyshev distance between vectors.

## Manual Configuration

Instead of using the Spring Boot auto-configuration, you can manually configure the OpenSearch vector store. For this you need to add the `spring-ai-opensearch-store` to your project:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-opensearch-store</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file:

    dependencies {
        implementation 'org.springframework.ai:spring-ai-opensearch-store'
    }

Create an OpenSearch client bean:

    @Bean
    public OpenSearchClient openSearchClient() {
        RestClient restClient = RestClient.builder(
            HttpHost.create("http://localhost:9200"))
            .build();

        return new OpenSearchClient(new RestClientTransport(
            restClient, new JacksonJsonpMapper()));
    }

Then create the `OpenSearchVectorStore` bean using the builder pattern:

    @Bean
    public VectorStore vectorStore(OpenSearchClient openSearchClient, EmbeddingModel embeddingModel) {
        return OpenSearchVectorStore.builder(openSearchClient, embeddingModel)
            .index("custom-index")                // Optional: defaults to "spring-ai-document-index"
            .similarityFunction("l2")             // Optional: defaults to "cosinesimil"
            .useApproximateKnn(true)              // Optional: defaults to false (exact k-NN)
            .dimensions(1536)                     // Optional: defaults to 1536 or embedding model's dimensions
            .initializeSchema(true)               // Optional: defaults to false
            .batchingStrategy(new TokenCountBatchingStrategy()) // Optional: defaults to TokenCountBatchingStrategy
            .build();
    }

    // This can be any EmbeddingModel implementation
    @Bean
    public EmbeddingModel embeddingModel() {
        return new OpenAiEmbeddingModel(OpenAiEmbeddingOptions.builder().apiKey(System.getenv("OPENAI_API_KEY")).build());
    }

## Metadata Filtering

You can leverage the generic, portable metadata filters with OpenSearch as well.

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

is converted into the proprietary OpenSearch filter format:

    (metadata.author:john OR jill) AND metadata.article_type:blog

## Accessing the Native Client

The OpenSearch Vector Store implementation provides access to the underlying native OpenSearch client (`OpenSearchClient`) through the `getNativeClient()` method:

    OpenSearchVectorStore vectorStore = context.getBean(OpenSearchVectorStore.class);
    Optional<OpenSearchClient> nativeClient = vectorStore.getNativeClient();

    if (nativeClient.isPresent()) {
        OpenSearchClient client = nativeClient.get();
        // Use the native client for OpenSearch-specific operations
    }

The native client gives you access to OpenSearch-specific features and operations that might not be exposed through the `VectorStore` interface.

Neo4j Oracle

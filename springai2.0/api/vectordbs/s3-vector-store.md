Search

# S3 Vector Store

This section walks you through setting up `S3VectorStore` to store document embeddings and perform similarity searches.

AWS S3 Vector Store is a serverless object storage which supports storing and querying vector at scale.

S3 Vector Store API extends the core features of AWS S3 Bucket and allows you to use S3 as a vector database:

- Store vectors and the associated metadata within hashes or JSON documents

- Retrieve vectors

- Perform vector searches

## Prerequisites

1.  A S3 Vector Store Bucket

    - How to create S3 Vector Bucket

2.  `EmbeddingModel` instance to compute the document embeddings. Several options are available:

    - If required, an API key for the EmbeddingModel to generate the embeddings stored by the `S3VectorStore`.

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the S3 Vector Store. To enable it, add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-vector-store-s3</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-vector-store-s3'
    }

Please have a look at the list of configuration parameters for the vector store to learn about the default values and configuration options.

Additionally, you will need a configured `EmbeddingModel` bean. Refer to the EmbeddingModel section for more information.

Now you can auto-wire the `S3VectorStore` as a vector store in your application.

    @Autowired VectorStore vectorStore;

    // ...

    List <Document> documents = List.of(
        new Document("Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!!", Map.of("meta1", "meta1")),
        new Document("The World is Big and Salvation Lurks Around the Corner"),
        new Document("You walk forward facing the past and you turn back toward the future.", Map.of("meta2", "meta2")));

    // Add the documents to S3 Vector Store Bucket
    vectorStore.add(documents);

    // Retrieve documents similar to a query
    List<Document> results = this.vectorStore.similaritySearch(SearchRequest.builder().query("Spring").topK(5).build());

### Configuration Properties

To connect to AWS S3 Vector Store and use the `S3VectorStore`, you will need to create a `Bean` of `S3VectorsClient` which needs to be supplied with correct Credentials and Region.

Properties starting with `spring.ai.vectorstore.s3.*` are used to configure the `S3VectorStore`:

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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.s3.index-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>The name of the index to store the vectors</p></td>
<td class="tableblock halign-left valign-top"><p><code>spring-ai-index</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.s3.vector-bucket-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>The name of bucket where vectors are located</p></td>
<td class="tableblock halign-left valign-top"><p><code>my-vector-bucket-on-aws</code></p></td>
</tr>
</tbody>
</table>

## Metadata Filtering

You can leverage the generic, portable metadata filters with S3 Vector Store as well.

For example, you can use either the text expression language:

    vectorStore.similaritySearch(SearchRequest.builder()
            .query("The World")
            .topK(TOP_K)
            .similarityThreshold(SIMILARITY_THRESHOLD)
            .filterExpression("country in ['UK', 'NL'] && year >= 2020").build());

or programmatically using the `Filter.Expression` DSL:

    FilterExpressionBuilder b = new FilterExpressionBuilder();

    vectorStore.similaritySearch(SearchRequest.builder()
            .query("The World")
            .topK(TOP_K)
            .similarityThreshold(SIMILARITY_THRESHOLD)
            .filterExpression(b.and(
                    b.in("country", "UK", "NL"),
                    b.gte("year", 2020)).build()).build());

For example, this portable filter expression:

    country in ['UK', 'NL'] && year >= 2020

is converted into the proprietary S3 Vector Store filter format:

    @country:{UK | NL} @year:[2020 inf]

## Manual Configuration

Instead of using the Spring Boot auto-configuration, you can manually configure the S3 Vector Store. For this you need to add the `spring-ai-s3-vector-store` to your project:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-s3-vector-store</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-s3-vector-store'
    }

Then create the `S3VectorStore` bean using the builder pattern:

    @Bean
    VectorStore s3VectorStore(S3VectorsClient s3VectorsClient, EmbeddingModel embeddingModel) {
        S3VectorStore.Builder builder = new S3VectorStore.Builder(s3VectorsClient, embeddingModel); // Required a must
        builder.indexName(properties.getIndexName()) // Required indexName must be specified
                .vectorBucketName(properties.getVectorBucketName()) // Required vectorBucketName must be specified
                .filterExpressionConverter(yourConverter);  // Optional if you want to override default filterConverter
        return builder.build();
        }

    // This can be any EmbeddingModel implementation
    @Bean
    public EmbeddingModel embeddingModel() {
        return new OpenAiEmbeddingModel(OpenAiEmbeddingOptions.builder().apiKey(System.getenv("OPENAI_API_KEY")).build());
    }

## Accessing the Native Client

The S3 Vector Store implementation provides access to the underlying native S3VectorsClient client:

    S3VectorStore vectorStore = context.getBean(S3VectorStore.class);
    Optional<S3VectorsClient> nativeClient = vectorStore.getNativeClient();

    if (nativeClient.isPresent()) {
        S3VectorsClient s3Client = nativeClient.get();
        // Use the native client for S3-Vector-Store-specific operations
    }

The native client gives you access to S3-Vector-Store-specific features and operations that might not be exposed through the `VectorStore` interface.

Weaviate Observability

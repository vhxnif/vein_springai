Search

# Pinecone

This section walks you through setting up the Pinecone `VectorStore` to store document embeddings and perform similarity searches.

Pinecone is a popular cloud-based vector database, which allows you to store and search vectors efficiently.

## Prerequisites

1.  Pinecone Account: Before you start, sign up for a Pinecone account.

2.  Pinecone Project: Once registered, generate an API key and create and index. You’ll need these details for configuration.

3.  `EmbeddingModel` instance to compute the document embeddings. Several options are available:

    - If required, an API key for the EmbeddingModel to generate the embeddings stored by the `PineconeVectorStore`.

To set up `PineconeVectorStore`, gather the following details from your Pinecone account:

- Pinecone API Key

- Pinecone Index Name

- Pinecone Namespace

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the Pinecone Vector Store. To enable it, add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-vector-store-pinecone</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-vector-store-pinecone'
    }

Additionally, you will need a configured `EmbeddingModel` bean. Refer to the EmbeddingModel section for more information.

Here is an example of the needed bean:

    @Bean
    public EmbeddingModel embeddingModel() {
        // Can be any other EmbeddingModel implementation.
        return new OpenAiEmbeddingModel(OpenAiEmbeddingOptions.builder().apiKey(System.getenv("OPENAI_API_KEY")).build());
    }

To connect to Pinecone you need to provide access details for your instance. A simple configuration can either be provided via Spring Boot’s *application.properties*,

    spring.ai.vectorstore.pinecone.api-key=<your api key>
    spring.ai.vectorstore.pinecone.index-name=<your index name>

    # API key if needed, e.g. OpenAI
    spring.ai.openai.api.key=<api-key>

Please have a look at the list of configuration parameters for the vector store to learn about the default values and configuration options.

Now you can Auto-wire the Pinecone Vector Store in your application and use it

    @Autowired VectorStore vectorStore;

    // ...

    List <Document> documents = List.of(
        new Document("Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!!", Map.of("meta1", "meta1")),
        new Document("The World is Big and Salvation Lurks Around the Corner"),
        new Document("You walk forward facing the past and you turn back toward the future.", Map.of("meta2", "meta2")));

    // Add the documents
    vectorStore.add(documents);

    // Retrieve documents similar to a query
    List<Document> results = this.vectorStore.similaritySearch(SearchRequest.builder().query("Spring").topK(5).build());

### Configuration properties

You can use the following properties in your Spring Boot configuration to customize the Pinecone vector store.

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.pinecone.api-key</code></p></td>
<td class="tableblock halign-left valign-top"><p>Pinecone API Key</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.pinecone.index-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>Pinecone index name</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.pinecone.namespace</code></p></td>
<td class="tableblock halign-left valign-top"><p>Pinecone namespace</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.pinecone.content-field-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>Pinecone metadata field name used to store the original text content.</p></td>
<td class="tableblock halign-left valign-top"><p><code>document_content</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.pinecone.distance-metadata-field-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>Pinecone metadata field name used to store the computed distance.</p></td>
<td class="tableblock halign-left valign-top"><p><code>distance</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.pinecone.server-side-timeout</code></p></td>
<td class="tableblock halign-left valign-top"></td>
<td class="tableblock halign-left valign-top"><p>20 sec.</p></td>
</tr>
</tbody>
</table>

## Metadata filtering

You can leverage the generic, portable metadata filters with the Pinecone store.

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

If you prefer to configure `PineconeVectorStore` manually, you can do so by using the `PineconeVectorStore#Builder`.

Add these dependencies to your project:

- OpenAI: Required for calculating embeddings.

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-openai</artifactId>
    </dependency>

- Pinecone

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-pinecone-store</artifactId>
    </dependency>

### Sample Code

To configure Pinecone in your application, you can use the following setup:

    @Bean
    public VectorStore pineconeVectorStore(EmbeddingModel embeddingModel) {
        return PineconeVectorStore.builder(embeddingModel)
                .apiKey(PINECONE_API_KEY)
                .indexName(PINECONE_INDEX_NAME)
                .namespace(PINECONE_NAMESPACE) // the free tier doesn't support namespaces.
                .contentFieldName(CUSTOM_CONTENT_FIELD_NAME) // optional field to store the original content. Defaults to `document_content`
                .build();
    }

In your main code, create some documents:

    List<Document> documents = List.of(
        new Document("Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!!", Map.of("meta1", "meta1")),
        new Document("The World is Big and Salvation Lurks Around the Corner"),
        new Document("You walk forward facing the past and you turn back toward the future.", Map.of("meta2", "meta2")));

Add the documents to Pinecone:

    vectorStore.add(documents);

And finally, retrieve documents similar to a query:

    List<Document> results = vectorStore.similaritySearch(SearchRequest.query("Spring").topK(5).build());

If all goes well, you should retrieve the document containing the text "Spring AI rocks!!".

## Accessing the Native Client

The Pinecone Vector Store implementation provides access to the underlying native Pinecone client (`PineconeConnection`) through the `getNativeClient()` method:

    PineconeVectorStore vectorStore = context.getBean(PineconeVectorStore.class);
    Optional<PineconeConnection> nativeClient = vectorStore.getNativeClient();

    if (nativeClient.isPresent()) {
        PineconeConnection client = nativeClient.get();
        // Use the native client for Pinecone-specific operations
    }

The native client gives you access to Pinecone-specific features and operations that might not be exposed through the `VectorStore` interface.

PGvector Qdrant

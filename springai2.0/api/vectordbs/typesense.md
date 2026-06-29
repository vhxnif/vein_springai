Search

# Typesense

This section walks you through setting up `TypesenseVectorStore` to store document embeddings and perform similarity searches.

Typesense is an open source typo tolerant search engine that is optimized for instant sub-50ms searches while providing an intuitive developer experience. It provides vector search capabilities that allow you to store and query high-dimensional vectors alongside your regular search data.

## Prerequisites

- A running Typesense instance. The following options are available:

  - Typesense Cloud (recommended)

  - Docker image *typesense/typesense:latest*

- If required, an API key for the EmbeddingModel to generate the embeddings stored by the `TypesenseVectorStore`.

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the Typesense Vector Store. To enable it add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-vector-store-typesense</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-vector-store-typesense'
    }

Please have a look at the list of configuration parameters for the vector store to learn about the default values and configuration options.

The vector store implementation can initialize the requisite schema for you but you must opt-in by setting `…​initialize-schema=true` in the `application.properties` file.

Additionally you will need a configured `EmbeddingModel` bean. Refer to the EmbeddingModel section for more information.

Now you can auto-wire the `TypesenseVectorStore` as a vector store in your application:

    @Autowired VectorStore vectorStore;

    // ...

    List<Document> documents = List.of(
        new Document("Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!!", Map.of("meta1", "meta1")),
        new Document("The World is Big and Salvation Lurks Around the Corner"),
        new Document("You walk forward facing the past and you turn back toward the future.", Map.of("meta2", "meta2")));

    // Add the documents to Typesense
    vectorStore.add(documents);

    // Retrieve documents similar to a query
    List<Document> results = vectorStore.similaritySearch(SearchRequest.builder().query("Spring").topK(5).build());

### Configuration Properties

To connect to Typesense and use the `TypesenseVectorStore` you need to provide access details for your instance. A simple configuration can be provided via Spring Boot’s `application.yml`:

    spring:
      ai:
        vectorstore:
          typesense:
            initialize-schema: true
            collection-name: vector_store
            embedding-dimension: 1536
            client:
              protocol: http
              host: localhost
              port: 8108
              api-key: xyz

Properties starting with `spring.ai.vectorstore.typesense.*` are used to configure the `TypesenseVectorStore`:

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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.typesense.initialize-schema</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to initialize the required schema</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.typesense.collection-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>The name of the collection to store vectors</p></td>
<td class="tableblock halign-left valign-top"><p><code>vector_store</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.typesense.embedding-dimension</code></p></td>
<td class="tableblock halign-left valign-top"><p>The number of dimensions in the vector</p></td>
<td class="tableblock halign-left valign-top"><p><code>1536</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.typesense.client.protocol</code></p></td>
<td class="tableblock halign-left valign-top"><p>HTTP Protocol</p></td>
<td class="tableblock halign-left valign-top"><p><code>http</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.typesense.client.host</code></p></td>
<td class="tableblock halign-left valign-top"><p>Hostname</p></td>
<td class="tableblock halign-left valign-top"><p><code>localhost</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.typesense.client.port</code></p></td>
<td class="tableblock halign-left valign-top"><p>Port</p></td>
<td class="tableblock halign-left valign-top"><p><code>8108</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.typesense.client.api-key</code></p></td>
<td class="tableblock halign-left valign-top"><p>API Key</p></td>
<td class="tableblock halign-left valign-top"><p><code>xyz</code></p></td>
</tr>
</tbody>
</table>

## Manual Configuration

Instead of using the Spring Boot auto-configuration you can manually configure the Typesense vector store. For this you need to add the `spring-ai-typesense-store` to your project:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-typesense-store</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-typesense-store'
    }

Create a Typesense `Client` bean:

    @Bean
    public Client typesenseClient() {
        List<Node> nodes = new ArrayList<>();
        nodes.add(new Node("http", "localhost", "8108"));
        Configuration configuration = new Configuration(nodes, Duration.ofSeconds(5), "xyz");
        return new Client(configuration);
    }

Then create the `TypesenseVectorStore` bean using the builder pattern:

    @Bean
    public VectorStore vectorStore(Client client, EmbeddingModel embeddingModel) {
        return TypesenseVectorStore.builder(client, embeddingModel)
            .collectionName("custom_vectors")     // Optional: defaults to "vector_store"
            .embeddingDimension(1536)            // Optional: defaults to 1536
            .initializeSchema(true)              // Optional: defaults to false
            .batchingStrategy(new TokenCountBatchingStrategy()) // Optional: defaults to TokenCountBatchingStrategy
            .build();
    }

    // This can be any EmbeddingModel implementation
    @Bean
    public EmbeddingModel embeddingModel() {
        return new OpenAiEmbeddingModel(OpenAiEmbeddingOptions.builder().apiKey(System.getenv("OPENAI_API_KEY")).build());
    }

## Metadata Filtering

You can leverage the generic portable metadata filters with Typesense store as well.

For example you can use either the text expression language:

    vectorStore.similaritySearch(
        SearchRequest.builder()
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

For example this portable filter expression:

    country in ['UK', 'NL'] && year >= 2020

is converted into the proprietary Typesense filter format:

    country: ['UK', 'NL'] && year: >=2020

## Accessing the Native Client

The Typesense Vector Store implementation provides access to the underlying native Typesense client (`Client`) through the `getNativeClient()` method:

    TypesenseVectorStore vectorStore = context.getBean(TypesenseVectorStore.class);
    Optional<Client> nativeClient = vectorStore.getNativeClient();

    if (nativeClient.isPresent()) {
        Client client = nativeClient.get();
        // Use the native client for Typesense-specific operations
    }

The native client gives you access to Typesense-specific features and operations that might not be exposed through the `VectorStore` interface.

Redis Weaviate

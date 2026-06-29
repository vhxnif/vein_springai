Search

# Weaviate

This section walks you through setting up the Weaviate VectorStore to store document embeddings and perform similarity searches.

Weaviate is an open-source vector database that allows you to store data objects and vector embeddings from your favorite ML-models and scale seamlessly into billions of data objects. It provides tools to store document embeddings, content, and metadata and to search through those embeddings, including metadata filtering.

## Prerequisites

- A running Weaviate instance. The following options are available:

  - Weaviate Cloud Service (requires account creation and API key)

  - Docker container

- If required, an API key for the EmbeddingModel to generate the embeddings stored by the `WeaviateVectorStore`.

## Dependencies

Add the Weaviate Vector Store dependency to your project:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-weaviate-store</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-weaviate-store'
    }

## Configuration

To connect to Weaviate and use the `WeaviateVectorStore`, you need to provide access details for your instance. Configuration can be provided via Spring Boot’s *application.properties*:

    spring.ai.vectorstore.weaviate.host=<host_of_your_weaviate_instance>
    spring.ai.vectorstore.weaviate.scheme=<http_or_https>
    spring.ai.vectorstore.weaviate.api-key=<your_api_key>
    # API key if needed, e.g. OpenAI
    spring.ai.openai.api-key=<api-key>

If you prefer to use environment variables for sensitive information like API keys, you have multiple options:

### Option 1: Using Spring Expression Language (SpEL)

You can use custom environment variable names and reference them in your application configuration:

    # In application.yml
    spring:
      ai:
        vectorstore:
          weaviate:
            host: ${WEAVIATE_HOST}
            scheme: ${WEAVIATE_SCHEME}
            api-key: ${WEAVIATE_API_KEY}
        openai:
          api-key: ${OPENAI_API_KEY}

    # In your environment or .env file
    export WEAVIATE_HOST=<host_of_your_weaviate_instance>
    export WEAVIATE_SCHEME=<http_or_https>
    export WEAVIATE_API_KEY=<your_api_key>
    export OPENAI_API_KEY=<api-key>

### Option 2: Accessing Environment Variables Programmatically

Alternatively, you can access environment variables in your Java code:

    String weaviateApiKey = System.getenv("WEAVIATE_API_KEY");
    String openAiApiKey = System.getenv("OPENAI_API_KEY");

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the Weaviate Vector Store. To enable it, add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-vector-store-weaviate</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-vector-store-weaviate'
    }

Please have a look at the list of configuration parameters for the vector store to learn about the default values and configuration options.

Additionally, you will need a configured `EmbeddingModel` bean. Refer to the EmbeddingModel section for more information.

Here is an example of the required bean:

    @Bean
    public EmbeddingModel embeddingModel() {
        // Retrieve API key from a secure source or environment variable
        String apiKey = System.getenv("OPENAI_API_KEY");

        // Can be any other EmbeddingModel implementation
        return new OpenAiEmbeddingModel(OpenAiEmbeddingOptions.builder().apiKey(apiKey).build());
    }

Now you can auto-wire the `WeaviateVectorStore` as a vector store in your application.

## Manual Configuration

Instead of using Spring Boot auto-configuration, you can manually configure the `WeaviateVectorStore` using the builder pattern:

    @Bean
    public WeaviateClient weaviateClient() {
        return new WeaviateClient(new Config("http", "localhost:8080"));
    }

    @Bean
    public VectorStore vectorStore(WeaviateClient weaviateClient, EmbeddingModel embeddingModel) {
        return WeaviateVectorStore.builder(weaviateClient, embeddingModel)
            .options(options)                              // Optional: use custom options
            .consistencyLevel(ConsistentLevel.QUORUM)      // Optional: defaults to ConsistentLevel.ONE
            .filterMetadataFields(List.of(                 // Optional: fields that can be used in filters
                MetadataField.text("country"),
                MetadataField.number("year")))
            .build();
    }

## Metadata filtering

You can leverage the generic, portable metadata filters with Weaviate store as well.

For example, you can use either the text expression language:

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

For example, this portable filter expression:

    country in ['UK', 'NL'] && year >= 2020

is converted into the proprietary Weaviate GraphQL filter format:

    operator: And
    operands:
        [{
            operator: Or
            operands:
                [{
                    path: ["meta_country"]
                    operator: Equal
                    valueText: "UK"
                },
                {
                    path: ["meta_country"]
                    operator: Equal
                    valueText: "NL"
                }]
        },
        {
            path: ["meta_year"]
            operator: GreaterThanEqual
            valueNumber: 2020
        }]

## Run Weaviate in Docker

To quickly get started with a local Weaviate instance, you can run it in Docker:

    docker run -it --rm --name weaviate \
        -e AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED=true \
        -e PERSISTENCE_DATA_PATH=/var/lib/weaviate \
        -e QUERY_DEFAULTS_LIMIT=25 \
        -e DEFAULT_VECTORIZER_MODULE=none \
        -e CLUSTER_HOSTNAME=node1 \
        -p 8080:8080 \
        semitechnologies/weaviate:1.22.4

This starts a Weaviate instance accessible at localhost:8080.

## WeaviateVectorStore properties

You can use the following properties in your Spring Boot configuration to customize the Weaviate vector store.

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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.weaviate.host</code></p></td>
<td class="tableblock halign-left valign-top"><p>The host of the Weaviate server</p></td>
<td class="tableblock halign-left valign-top"><p>localhost:8080</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.weaviate.scheme</code></p></td>
<td class="tableblock halign-left valign-top"><p>Connection schema</p></td>
<td class="tableblock halign-left valign-top"><p>http</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.weaviate.api-key</code></p></td>
<td class="tableblock halign-left valign-top"><p>The API key for authentication</p></td>
<td class="tableblock halign-left valign-top"></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.weaviate.object-class</code></p></td>
<td class="tableblock halign-left valign-top"><p>The class name for storing documents.</p></td>
<td class="tableblock halign-left valign-top"><p>SpringAiWeaviate</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.weaviate.content-field-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>The field name for content</p></td>
<td class="tableblock halign-left valign-top"><p>content</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.weaviate.meta-field-prefix</code></p></td>
<td class="tableblock halign-left valign-top"><p>The field prefix for metadata</p></td>
<td class="tableblock halign-left valign-top"><p>meta_</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.weaviate.consistency-level</code></p></td>
<td class="tableblock halign-left valign-top"><p>Desired tradeoff between consistency and speed</p></td>
<td class="tableblock halign-left valign-top"><p>ConsistentLevel.ONE</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.weaviate.filter-field</code></p></td>
<td class="tableblock halign-left valign-top"><p>Configures metadata fields that can be used in filters. Format: spring.ai.vectorstore.weaviate.filter-field.&lt;field-name&gt;=&lt;field-type&gt;</p></td>
<td class="tableblock halign-left valign-top"></td>
</tr>
</tbody>
</table>

## Accessing the Native Client

The Weaviate Vector Store implementation provides access to the underlying native Weaviate client (`WeaviateClient`) through the `getNativeClient()` method:

    WeaviateVectorStore vectorStore = context.getBean(WeaviateVectorStore.class);
    Optional<WeaviateClient> nativeClient = vectorStore.getNativeClient();

    if (nativeClient.isPresent()) {
        WeaviateClient client = nativeClient.get();
        // Use the native client for Weaviate-specific operations
    }

The native client gives you access to Weaviate-specific features and operations that might not be exposed through the `VectorStore` interface.

Typesense S3 Vector Store

Search

# Chroma

This section will walk you through setting up the Chroma VectorStore to store document embeddings and perform similarity searches.

Chroma is the open-source embedding database. It gives you the tools to store document embeddings, content, and metadata and to search through those embeddings, including metadata filtering.

## Prerequisites

1.  Access to ChromaDB. Compatible with Chroma Cloud, or setup local ChromaDB in the appendix shows how to set up a DB locally with a Docker container.

    - For Chroma Cloud: You’ll need your API key, tenant name, and database name from your Chroma Cloud dashboard.

    - For local ChromaDB: No additional configuration required beyond starting the container.

2.  `EmbeddingModel` instance to compute the document embeddings. Several options are available:

    - If required, an API key for the EmbeddingModel to generate the embeddings stored by the `ChromaVectorStore`.

On startup, the `ChromaVectorStore` creates the required collection if one is not provisioned already.

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the Chroma Vector Store. To enable it, add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-vector-store-chroma</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-vector-store-chroma'
    }

The vector store implementation can initialize the requisite schema for you, but you must opt-in by specifying the `initializeSchema` boolean in the appropriate constructor or by setting `…​initialize-schema=true` in the `application.properties` file.

Additionally, you will need a configured `EmbeddingModel` bean. Refer to the EmbeddingModel section for more information.

Here is an example of the needed bean:

    @Bean
    public EmbeddingModel embeddingModel() {
        // Can be any other EmbeddingModel implementation.
        return new OpenAiEmbeddingModel(OpenAiEmbeddingOptions.builder().apiKey(System.getenv("OPENAI_API_KEY")).build());
    }

To connect to Chroma you need to provide access details for your instance. A simple configuration can either be provided via Spring Boot’s *application.properties*,

    # Chroma Vector Store connection properties
    spring.ai.vectorstore.chroma.client.host=<your Chroma instance host>  // for Chroma Cloud: api.trychroma.com
    spring.ai.vectorstore.chroma.client.port=<your Chroma instance port> // for Chroma Cloud: 443
    spring.ai.vectorstore.chroma.client.key-token=<your access token (if configure)> // for Chroma Cloud: use the API key
    spring.ai.vectorstore.chroma.client.username=<your username (if configure)>
    spring.ai.vectorstore.chroma.client.password=<your password (if configure)>

    # Chroma Vector Store tenant and database properties (required for Chroma Cloud)
    spring.ai.vectorstore.chroma.tenant-name=<your tenant name> // default: SpringAiTenant
    spring.ai.vectorstore.chroma.database-name=<your database name> // default: SpringAiDatabase

    # Chroma Vector Store collection properties
    spring.ai.vectorstore.chroma.initialize-schema=<true or false>
    spring.ai.vectorstore.chroma.collection-name=<your collection name>

    # Chroma Vector Store configuration properties

    # OpenAI API key if the OpenAI auto-configuration is used.
    spring.ai.openai.api.key=<OpenAI Api-key>

Please have a look at the list of configuration parameters for the vector store to learn about the default values and configuration options.

Now you can auto-wire the Chroma Vector Store in your application and use it

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

You can use the following properties in your Spring Boot configuration to customize the vector store.

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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.chroma.client.host</code></p></td>
<td class="tableblock halign-left valign-top"><p>Server connection host</p></td>
<td class="tableblock halign-left valign-top"><p>http://localhost</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.chroma.client.port</code></p></td>
<td class="tableblock halign-left valign-top"><p>Server connection port</p></td>
<td class="tableblock halign-left valign-top"><p><code>8000</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.chroma.client.key-token</code></p></td>
<td class="tableblock halign-left valign-top"><p>Access token (if configured)</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.chroma.client.username</code></p></td>
<td class="tableblock halign-left valign-top"><p>Access username (if configured)</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.chroma.client.password</code></p></td>
<td class="tableblock halign-left valign-top"><p>Access password (if configured)</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.chroma.tenant-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>Tenant (required for Chroma Cloud)</p></td>
<td class="tableblock halign-left valign-top"><p><code>SpringAiTenant</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.chroma.database-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>Database name (required for Chroma Cloud)</p></td>
<td class="tableblock halign-left valign-top"><p><code>SpringAiDatabase</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.chroma.collection-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>Collection name</p></td>
<td class="tableblock halign-left valign-top"><p><code>SpringAiCollection</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.chroma.initialize-schema</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to initialize the required schema (creates tenant/database/collection if they don’t exist)</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
</tbody>
</table>

### Chroma Cloud Configuration

For Chroma Cloud, you need to provide the tenant and database names from your Chroma Cloud instance. Here’s an example configuration:

    # Chroma Cloud connection
    spring.ai.vectorstore.chroma.client.host=api.trychroma.com
    spring.ai.vectorstore.chroma.client.port=443
    spring.ai.vectorstore.chroma.client.key-token=<your-chroma-cloud-api-key>

    # Chroma Cloud tenant and database (required)
    spring.ai.vectorstore.chroma.tenant-name=<your-tenant-id>
    spring.ai.vectorstore.chroma.database-name=<your-database-name>

    # Collection configuration
    spring.ai.vectorstore.chroma.collection-name=my-collection
    spring.ai.vectorstore.chroma.initialize-schema=true

## Metadata filtering

You can leverage the generic, portable metadata filters with ChromaVector store as well.

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
                                b.in("john", "jill"),
                                b.eq("article_type", "blog")).build()).build());

For example, this portable filter expression:

    author in ['john', 'jill'] && article_type == 'blog'

is converted into the proprietary Chroma format

    {"$and":[
        {"author": {"$in": ["john", "jill"]}},
        {"article_type":{"$eq":"blog"}}]
    }

## Manual Configuration

If you prefer to configure the Chroma Vector Store manually, you can do so by creating a `ChromaVectorStore` bean in your Spring Boot application.

Add these dependencies to your project: \* Chroma VectorStore.

    <dependency>
      <groupId>org.springframework.ai</groupId>
      <artifactId>spring-ai-chroma-store</artifactId>
    </dependency>

- OpenAI: Required for calculating embeddings. You can use any other embedding model implementation.

    <dependency>
     <groupId>org.springframework.ai</groupId>
     <artifactId>spring-ai-starter-model-openai</artifactId>
    </dependency>

### Sample Code

Create a `RestClient.Builder` instance with proper ChromaDB authorization configurations and Use it to create a `ChromaApi` instance:

    @Bean
    public RestClient.Builder builder() {
        return RestClient.builder().requestFactory(new SimpleClientHttpRequestFactory());
    }


    @Bean
    public ChromaApi chromaApi(RestClient.Builder restClientBuilder) {
       String chromaUrl = "http://localhost:8000";
       ChromaApi chromaApi = new ChromaApi(chromaUrl, restClientBuilder);
       return chromaApi;
    }

Integrate with OpenAI’s embeddings by adding the Spring Boot OpenAI starter to your project. This provides you with an implementation of the Embeddings client:

    @Bean
    public VectorStore chromaVectorStore(EmbeddingModel embeddingModel, ChromaApi chromaApi) {
     return ChromaVectorStore.builder(chromaApi, embeddingModel)
        .tenantName("your-tenant-name") // default: SpringAiTenant
        .databaseName("your-database-name") // default: SpringAiDatabase
        .collectionName("TestCollection")
        .initializeSchema(true)
        .build();
    }

In your main code, create some documents:

    List<Document> documents = List.of(
     new Document("Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!!", Map.of("meta1", "meta1")),
     new Document("The World is Big and Salvation Lurks Around the Corner"),
     new Document("You walk forward facing the past and you turn back toward the future.", Map.of("meta2", "meta2")));

Add the documents to your vector store:

    vectorStore.add(documents);

And finally, retrieve documents similar to a query:

    List<Document> results = vectorStore.similaritySearch("Spring");

If all goes well, you should retrieve the document containing the text "Spring AI rocks!!".

### Run Chroma Locally

    docker run -it --rm --name chroma -p 8000:8000 ghcr.io/chroma-core/chroma:1.0.0

Starts a chroma store at localhost:8000/api/v1

Apache Cassandra Vector Store Couchbase

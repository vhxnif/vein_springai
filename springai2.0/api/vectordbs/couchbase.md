Search

# Couchbase

This section will walk you through setting up the `CouchbaseSearchVectorStore` to store document embeddings and perform similarity searches using Couchbase.

Couchbase is a distributed, JSON document database, with all the desired capabilities of a relational DBMS. Among other features, it allows users to query information using vector-based storage and retrieval.

## Prerequisites

A running Couchbase instance. The following options are available: Couchbase \* Docker \* Capella - Couchbase as a Service \* Install Couchbase locally \* Couchbase Kubernetes Operator

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the Couchbase Vector Store. To enable it, add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-vector-store-couchbase</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-vector-store-couchbase'
    }

The vector store implementation can initialize the configured bucket, scope, collection and search index for you, with default options, but you must opt-in by specifying the `initializeSchema` boolean in the appropriate constructor.

Please have a look at the list of configuration parameters for the vector store to learn about the default values and configuration options.

Additionally, you will need a configured `EmbeddingModel` bean. Refer to the EmbeddingModel section for more information.

Now you can auto-wire the `CouchbaseSearchVectorStore` as a vector store in your application.

    @Autowired VectorStore vectorStore;

    // ...

    List <Document> documents = List.of(
        new Document("Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!!", Map.of("meta1", "meta1")),
        new Document("The World is Big and Salvation Lurks Around the Corner"),
        new Document("You walk forward facing the past and you turn back toward the future.", Map.of("meta2", "meta2")));

    // Add the documents to Qdrant
    vectorStore.add(documents);

    // Retrieve documents similar to a query
    List<Document> results = vectorStore.similaritySearch(SearchRequest.query("Spring").withTopK(5));

### Configuration Properties

To connect to Couchbase and use the `CouchbaseSearchVectorStore`, you need to provide access details for your instance. Configuration can be provided via Spring Boot’s `application.properties`:

    spring.ai.openai.api-key=<key>
    spring.couchbase.connection-string=<conn_string>
    spring.couchbase.username=<username>
    spring.couchbase.password=<password>

If you prefer to use environment variables for sensitive information like passwords or API keys, you have multiple options:

#### Option 1: Using Spring Expression Language (SpEL)

You can use custom environment variable names and reference them in your application configuration using SpEL:

    # In application.yml
    spring:
      ai:
        openai:
          api-key: ${OPENAI_API_KEY}
      couchbase:
        connection-string: ${COUCHBASE_CONN_STRING}
        username: ${COUCHBASE_USER}
        password: ${COUCHBASE_PASSWORD}

    # In your environment or .env file
    export OPENAI_API_KEY=<api-key>
    export COUCHBASE_CONN_STRING=<couchbase connection string like couchbase://localhost>
    export COUCHBASE_USER=<couchbase username>
    export COUCHBASE_PASSWORD=<couchbase password>

#### Option 2: Accessing Environment Variables Programmatically

Alternatively, you can access environment variables in your Java code:

    String apiKey = System.getenv("OPENAI_API_KEY");

This approach gives you flexibility in naming your environment variables while keeping sensitive information out of your application configuration files.

Spring Boot’s auto-configuration feature for the Couchbase Cluster will create a bean instance that will be used by the `CouchbaseSearchVectorStore`.

The Spring Boot properties starting with `spring.couchbase.*` are used to configure the Couchbase cluster instance:

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
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
<td class="tableblock halign-left valign-top"><p><code>spring.couchbase.connection-string</code></p></td>
<td class="tableblock halign-left valign-top"><p>A couchbase connection string</p></td>
<td class="tableblock halign-left valign-top"><p><code>couchbase://localhost</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.couchbase.password</code></p></td>
<td class="tableblock halign-left valign-top"><p>Password for authentication with Couchbase.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.couchbase.username</code></p></td>
<td class="tableblock halign-left valign-top"><p>Username for authentication with Couchbase.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.couchbase.env.io.minEndpoints</code></p></td>
<td class="tableblock halign-left valign-top"><p>Minimum number of sockets per node.</p></td>
<td class="tableblock halign-left valign-top"><p>1</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.couchbase.env.io.maxEndpoints</code></p></td>
<td class="tableblock halign-left valign-top"><p>Maximum number of sockets per node.</p></td>
<td class="tableblock halign-left valign-top"><p>12</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.couchbase.env.io.idleHttpConnectionTimeout</code></p></td>
<td class="tableblock halign-left valign-top"><p>Length of time an HTTP connection may remain idle before it is closed and removed from the pool.</p></td>
<td class="tableblock halign-left valign-top"><p>1s</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.couchbase.env.ssl.enabled</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to enable SSL support. Enabled automatically if a "bundle" is provided unless specified otherwise.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.couchbase.env.ssl.bundle</code></p></td>
<td class="tableblock halign-left valign-top"><p>SSL bundle name.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.couchbase.env.timeouts.connect</code></p></td>
<td class="tableblock halign-left valign-top"><p>Bucket connect timeout.</p></td>
<td class="tableblock halign-left valign-top"><p>10s</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.couchbase.env.timeouts.disconnect</code></p></td>
<td class="tableblock halign-left valign-top"><p>Bucket disconnect timeout.</p></td>
<td class="tableblock halign-left valign-top"><p>10s</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.couchbase.env.timeouts.key-value</code></p></td>
<td class="tableblock halign-left valign-top"><p>Timeout for operations on a specific key-value.</p></td>
<td class="tableblock halign-left valign-top"><p>2500ms</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.couchbase.env.timeouts.key-value</code></p></td>
<td class="tableblock halign-left valign-top"><p>Timeout for operations on a specific key-value with a durability level.</p></td>
<td class="tableblock halign-left valign-top"><p>10s</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.couchbase.env.timeouts.key-value-durable</code></p></td>
<td class="tableblock halign-left valign-top"><p>Timeout for operations on a specific key-value with a durability level.</p></td>
<td class="tableblock halign-left valign-top"><p>10s</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.couchbase.env.timeouts.query</code></p></td>
<td class="tableblock halign-left valign-top"><p>SQL++ query operations timeout.</p></td>
<td class="tableblock halign-left valign-top"><p>75s</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.couchbase.env.timeouts.view</code></p></td>
<td class="tableblock halign-left valign-top"><p>Regular and geospatial view operations timeout.</p></td>
<td class="tableblock halign-left valign-top"><p>75s</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.couchbase.env.timeouts.search</code></p></td>
<td class="tableblock halign-left valign-top"><p>Timeout for the search service.</p></td>
<td class="tableblock halign-left valign-top"><p>75s</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.couchbase.env.timeouts.analytics</code></p></td>
<td class="tableblock halign-left valign-top"><p>Timeout for the analytics service.</p></td>
<td class="tableblock halign-left valign-top"><p>75s</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.couchbase.env.timeouts.management</code></p></td>
<td class="tableblock halign-left valign-top"><p>Timeout for the management operations.</p></td>
<td class="tableblock halign-left valign-top"><p>75s</p></td>
</tr>
</tbody>
</table>

Properties starting with the `spring.ai.vectorstore.couchbase.*` prefix are used to configure `CouchbaseSearchVectorStore`.

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.couchbase.index-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>The name of the index to store the vectors.</p></td>
<td class="tableblock halign-left valign-top"><p>spring-ai-document-index</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.couchbase.bucket-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>The name of the Couchbase Bucket, parent of the scope.</p></td>
<td class="tableblock halign-left valign-top"><p>default</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.couchbase.scope-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>The name of the Couchbase scope, parent of the collection. Search queries will be executed in the scope context.</p></td>
<td class="tableblock halign-left valign-top"><p><em>default</em></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.couchbase.collection-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>The name of the Couchbase collection to store the Documents.</p></td>
<td class="tableblock halign-left valign-top"><p><em>default</em></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.couchbase.dimensions</code></p></td>
<td class="tableblock halign-left valign-top"><p>The number of dimensions in the vector.</p></td>
<td class="tableblock halign-left valign-top"><p>1536</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.couchbase.similarity</code></p></td>
<td class="tableblock halign-left valign-top"><p>The similarity function to use.</p></td>
<td class="tableblock halign-left valign-top"><p><code>dot_product</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.couchbase.optimization</code></p></td>
<td class="tableblock halign-left valign-top"><p>The similarity function to use.</p></td>
<td class="tableblock halign-left valign-top"><p><code>recall</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.couchbase.initialize-schema</code></p></td>
<td class="tableblock halign-left valign-top"><p>whether to initialize the required schema</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
</tbody>
</table>

The following similarity functions are available:

- l2\_norm

- dot\_product

The following index optimizations are available:

- recall

- latency

More details about each in the Couchbase Documentation on vector searches.

## Metadata Filtering

You can leverage the generic, portable metadata filters with the Couchbase store.

For example, you can use either the text expression language:

    vectorStore.similaritySearch(
        SearchRequest.defaults()
        .query("The World")
        .topK(TOP_K)
        .filterExpression("author in ['john', 'jill'] && article_type == 'blog'"));

or programmatically using the `Filter.Expression` DSL:

    FilterExpressionBuilder b = new FilterExpressionBuilder();

    vectorStore.similaritySearch(SearchRequest.defaults()
        .query("The World")
        .topK(TOP_K)
        .filterExpression(b.and(
            b.in("author","john", "jill"),
            b.eq("article_type", "blog")).build()));

## Manual Configuration

Instead of using the Spring Boot auto-configuration, you can manually configure the Couchbase vector store. For this you need to add the `spring-ai-couchbase-store` to your project:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-couchbase-store</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-couchbase-store'
    }

Create a Couchbase `Cluster` bean. Read the Couchbase Documentation for more in-depth information about the configuration of a custom Cluster instance.

    @Bean
    public Cluster cluster() {
        return Cluster.connect("couchbase://localhost", "username", "password");
    }

and then create the `CouchbaseSearchVectorStore` bean using the builder pattern:

    @Bean
    public VectorStore couchbaseSearchVectorStore(Cluster cluster,
                                                  EmbeddingModel embeddingModel,
                                                  Boolean initializeSchema) {
        return CouchbaseSearchVectorStore
                .builder(cluster, embeddingModel)
                .bucketName("test")
                .scopeName("test")
                .collectionName("test")
                .initializeSchema(initializeSchema)
                .build();
    }

    // This can be any EmbeddingModel implementation.
    @Bean
    public EmbeddingModel embeddingModel() {
        return new OpenAiEmbeddingModel(OpenAiEmbeddingOptions.builder().apiKey(this.openaiKey).build());
    }

## Limitations

Chroma Elasticsearch

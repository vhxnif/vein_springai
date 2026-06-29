Search

# MongoDB Atlas

This section walks you through setting up MongoDB Atlas as a vector store to use with Spring AI.

## What is MongoDB Atlas?

MongoDB Atlas is the fully-managed cloud database from MongoDB available in AWS, Azure, and GCP. Atlas supports native Vector Search and full text search on your MongoDB document data.

MongoDB Atlas Vector Search allows you to store your embeddings in MongoDB documents, create vector search indexes, and perform KNN searches with an approximate nearest neighbor algorithm (Hierarchical Navigable Small Worlds). You can use the `$vectorSearch` aggregation operator in a MongoDB aggregation stage to perform a search on your vector embeddings.

## Prerequisites

- An Atlas cluster running MongoDB version 6.0.11, 7.0.2, or later. To get started with MongoDB Atlas, you can follow the instructions here. Ensure that your IP address is included in your Atlas project’s access list.

- A running MongoDB Atlas instance with Vector Search enabled

- Collection with vector search index configured

- Collection schema with id (string), content (string), metadata (document), and embedding (vector) fields

- Proper access permissions for index and collection operations

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the MongoDB Atlas Vector Store. To enable it, add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-vector-store-mongodb-atlas</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file:

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-vector-store-mongodb-atlas'
    }

The vector store implementation can initialize the requisite schema for you, but you must opt-in by setting `spring.ai.vectorstore.mongodb.initialize-schema=true` in the `application.properties` file. Alternatively you can opt-out the initialization and create the index manually using the MongoDB Atlas UI, Atlas Administration API, or Atlas CLI, which can be useful if the index needs advanced mapping or additional configuration.

Please have a look at the list of configuration parameters for the vector store to learn about the default values and configuration options.

Additionally, you will need a configured `EmbeddingModel` bean. Refer to the EmbeddingModel section for more information.

Now you can auto-wire the `MongoDBAtlasVectorStore` as a vector store in your application:

    @Autowired VectorStore vectorStore;

    // ...

    List<Document> documents = List.of(
        new Document("Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!!", Map.of("meta1", "meta1")),
        new Document("The World is Big and Salvation Lurks Around the Corner"),
        new Document("You walk forward facing the past and you turn back toward the future.", Map.of("meta2", "meta2")));

    // Add the documents to MongoDB Atlas
    vectorStore.add(documents);

    // Retrieve documents similar to a query
    List<Document> results = vectorStore.similaritySearch(SearchRequest.builder().query("Spring").topK(5).build());

### Configuration Properties

To connect to MongoDB Atlas and use the `MongoDBAtlasVectorStore`, you need to provide access details for your instance. A simple configuration can be provided via Spring Boot’s `application.yml`:

    spring:
      data:
        mongodb:
          uri: <mongodb atlas connection string>
          database: <database name>
      ai:
        vectorstore:
          mongodb:
            initialize-schema: true
            collection-name: custom_vector_store
            index-name: custom_vector_index
            path-name: custom_embedding
            metadata-fields-to-filter: author,year

Properties starting with `spring.ai.vectorstore.mongodb.*` are used to configure the `MongoDBAtlasVectorStore`:

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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.mongodb.initialize-schema</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to initialize the required schema</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.mongodb.collection-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>The name of the collection to store the vectors</p></td>
<td class="tableblock halign-left valign-top"><p><code>vector_store</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.mongodb.index-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>The name of the vector search index</p></td>
<td class="tableblock halign-left valign-top"><p><code>vector_index</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.mongodb.path-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>The path where vectors are stored</p></td>
<td class="tableblock halign-left valign-top"><p><code>embedding</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.mongodb.metadata-fields-to-filter</code></p></td>
<td class="tableblock halign-left valign-top"><p>Comma-separated list of metadata fields that can be used for filtering</p></td>
<td class="tableblock halign-left valign-top"><p>empty list</p></td>
</tr>
</tbody>
</table>

## Manual Configuration

Instead of using the Spring Boot auto-configuration, you can manually configure the MongoDB Atlas vector store. For this you need to add the `spring-ai-mongodb-atlas-store` to your project:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-mongodb-atlas-store</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file:

    dependencies {
        implementation 'org.springframework.ai:spring-ai-mongodb-atlas-store'
    }

Create a `MongoTemplate` bean:

    @Bean
    public MongoTemplate mongoTemplate() {
        return new MongoTemplate(MongoClients.create("<mongodb atlas connection string>"), "<database name>");
    }

Then create the `MongoDBAtlasVectorStore` bean using the builder pattern:

    @Bean
    public VectorStore vectorStore(MongoTemplate mongoTemplate, EmbeddingModel embeddingModel) {
        return MongoDBAtlasVectorStore.builder(mongoTemplate, embeddingModel)
            .collectionName("custom_vector_store")           // Optional: defaults to "vector_store"
            .vectorIndexName("custom_vector_index")          // Optional: defaults to "vector_index"
            .pathName("custom_embedding")                    // Optional: defaults to "embedding"
            .numCandidates(500)                             // Optional: defaults to 200
            .metadataFieldsToFilter(List.of("author", "year")) // Optional: defaults to empty list
            .initializeSchema(true)                         // Optional: defaults to false
            .batchingStrategy(new TokenCountBatchingStrategy()) // Optional: defaults to TokenCountBatchingStrategy
            .build();
    }

    // This can be any EmbeddingModel implementation
    @Bean
    public EmbeddingModel embeddingModel() {
        return new OpenAiEmbeddingModel(OpenAiEmbeddingOptions.builder().apiKey(System.getenv("OPENAI_API_KEY")).build());
    }

## Metadata Filtering

You can leverage the generic, portable metadata filters with MongoDB Atlas as well.

For example, you can use either the text expression language:

    vectorStore.similaritySearch(SearchRequest.builder()
            .query("The World")
            .topK(5)
            .similarityThreshold(0.7)
            .filterExpression("author in ['john', 'jill'] && article_type == 'blog'").build());

or programmatically using the `Filter.Expression` DSL:

    FilterExpressionBuilder b = new FilterExpressionBuilder();

    vectorStore.similaritySearch(SearchRequest.builder()
            .query("The World")
            .topK(5)
            .similarityThreshold(0.7)
            .filterExpression(b.and(
                    b.in("author", "john", "jill"),
                    b.eq("article_type", "blog")).build()).build());

For example, this portable filter expression:

    author in ['john', 'jill'] && article_type == 'blog'

is converted into the proprietary MongoDB Atlas filter format:

    {
      "$and": [
        {
          "$or": [
            { "metadata.author": "john" },
            { "metadata.author": "jill" }
          ]
        },
        {
          "metadata.article_type": "blog"
        }
      ]
    }

## Tutorials and Code Examples

To get started with Spring AI and MongoDB:

- See the Getting Started guide for Spring AI Integration.

- For a comprehensive code example demonstrating Retrieval Augmented Generation (RAG) with Spring AI and MongoDB, refer to this detailed tutorial.

## Accessing the Native Client

The MongoDB Atlas Vector Store implementation provides access to the underlying native MongoDB client (`MongoClient`) through the `getNativeClient()` method:

    MongoDBAtlasVectorStore vectorStore = context.getBean(MongoDBAtlasVectorStore.class);
    Optional<MongoClient> nativeClient = vectorStore.getNativeClient();

    if (nativeClient.isPresent()) {
        MongoClient client = nativeClient.get();
        // Use the native client for MongoDB-specific operations
    }

The native client gives you access to MongoDB-specific features and operations that might not be exposed through the `VectorStore` interface.

Milvus Neo4j

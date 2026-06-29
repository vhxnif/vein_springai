Search

# Redis

This section walks you through setting up `RedisVectorStore` to store document embeddings and perform similarity searches.

Redis is an open source (BSD licensed), in-memory data structure store used as a database, cache, message broker, and streaming engine. Redis provides data structures such as strings, hashes, lists, sets, sorted sets with range queries, bitmaps, hyperloglogs, geospatial indexes, and streams.

Redis Search and Query extends the core features of Redis OSS and allows you to use Redis as a vector database:

- Store vectors and the associated metadata within hashes or JSON documents

- Retrieve vectors

- Perform vector similarity searches (KNN)

- Perform range-based vector searches with radius threshold

- Perform full-text searches on TEXT fields

- Support for multiple distance metrics (COSINE, L2, IP) and vector algorithms (HNSW, FLAT)

## Prerequisites

1.  A Redis Stack instance

    - Redis Cloud (recommended)

    - Docker image *redis/redis-stack:latest*

2.  `EmbeddingModel` instance to compute the document embeddings. Several options are available:

    - If required, an API key for the EmbeddingModel to generate the embeddings stored by the `RedisVectorStore`.

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the Redis Vector Store. To enable it, add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-vector-store-redis</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-vector-store-redis'
    }

The vector store implementation can initialize the requisite schema for you, but you must opt-in by specifying the `initializeSchema` boolean in the appropriate constructor or by setting `…​initialize-schema=true` in the `application.properties` file.

Please have a look at the list of configuration parameters for the vector store to learn about the default values and configuration options.

Additionally, you will need a configured `EmbeddingModel` bean. Refer to the EmbeddingModel section for more information.

Now you can auto-wire the `RedisVectorStore` as a vector store in your application.

    @Autowired VectorStore vectorStore;

    // ...

    List <Document> documents = List.of(
        new Document("Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!!", Map.of("meta1", "meta1")),
        new Document("The World is Big and Salvation Lurks Around the Corner"),
        new Document("You walk forward facing the past and you turn back toward the future.", Map.of("meta2", "meta2")));

    // Add the documents to Redis
    vectorStore.add(documents);

    // Retrieve documents similar to a query
    List<Document> results = this.vectorStore.similaritySearch(SearchRequest.builder().query("Spring").topK(5).build());

### Configuration Properties

To connect to Redis and use the `RedisVectorStore`, you need to provide access details for your instance. A simple configuration can be provided via Spring Boot’s `application.yml`,

    spring:
      data:
        redis:
          url: <redis instance url>
      ai:
        vectorstore:
          redis:
            initialize-schema: true
            index-name: custom-index
            prefix: custom-prefix

For redis connection configuration, alternatively, a simple configuration can be provided via Spring Boot’s *application.properties*.

    spring.data.redis.host=localhost
    spring.data.redis.port=6379
    spring.data.redis.username=default
    spring.data.redis.password=

Properties starting with `spring.ai.vectorstore.redis.*` are used to configure the `RedisVectorStore`:

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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.redis.initialize-schema</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to initialize the required schema</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.redis.index-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>The name of the index to store the vectors</p></td>
<td class="tableblock halign-left valign-top"><p><code>spring-ai-index</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.redis.prefix</code></p></td>
<td class="tableblock halign-left valign-top"><p>The prefix for Redis keys</p></td>
<td class="tableblock halign-left valign-top"><p><code>embedding:</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.redis.distance-metric</code></p></td>
<td class="tableblock halign-left valign-top"><p>Distance metric for vector similarity (COSINE, L2, IP)</p></td>
<td class="tableblock halign-left valign-top"><p><code>COSINE</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.redis.vector-algorithm</code></p></td>
<td class="tableblock halign-left valign-top"><p>Vector indexing algorithm (HNSW, FLAT)</p></td>
<td class="tableblock halign-left valign-top"><p><code>HNSW</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.redis.hnsw-m</code></p></td>
<td class="tableblock halign-left valign-top"><p>HNSW: Number of maximum outgoing connections</p></td>
<td class="tableblock halign-left valign-top"><p><code>16</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.redis.hnsw-ef-construction</code></p></td>
<td class="tableblock halign-left valign-top"><p>HNSW: Number of maximum connections during index building</p></td>
<td class="tableblock halign-left valign-top"><p><code>200</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.redis.hnsw-ef-runtime</code></p></td>
<td class="tableblock halign-left valign-top"><p>HNSW: Number of connections to consider during search</p></td>
<td class="tableblock halign-left valign-top"><p><code>10</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.redis.default-range-threshold</code></p></td>
<td class="tableblock halign-left valign-top"><p>Default radius threshold for range searches</p></td>
<td class="tableblock halign-left valign-top"><p><code>0.8</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.redis.text-scorer</code></p></td>
<td class="tableblock halign-left valign-top"><p>Text scoring algorithm (BM25, TFIDF, BM25STD, DISMAX, DOCSCORE)</p></td>
<td class="tableblock halign-left valign-top"><p><code>BM25</code></p></td>
</tr>
</tbody>
</table>

## Metadata Filtering

You can leverage the generic, portable metadata filters with Redis as well.

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

is converted into the proprietary Redis filter format:

    @country:{UK | NL} @year:[2020 inf]

## Manual Configuration

Instead of using the Spring Boot auto-configuration, you can manually configure the Redis vector store. For this you need to add the `spring-ai-redis-store` to your project:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-redis-store</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-redis-store'
    }

Create a `RedisClient` bean:

    @Bean
    public RedisClient jedisClient() {
        return RedisClient.builder().hostAndPort("<host>", 6379).build();
    }

Then create the `RedisVectorStore` bean using the builder pattern:

    @Bean
    public VectorStore vectorStore(RedisClient jedisClient, EmbeddingModel embeddingModel) {
        return RedisVectorStore.builder(jedisClient, embeddingModel)
            .indexName("custom-index")                // Optional: defaults to "spring-ai-index"
            .prefix("custom-prefix")                  // Optional: defaults to "embedding:"
            .contentFieldName("content")              // Optional: field for document content
            .embeddingFieldName("embedding")          // Optional: field for vector embeddings
            .vectorAlgorithm(Algorithm.HNSW)          // Optional: HNSW or FLAT (defaults to HNSW)
            .distanceMetric(DistanceMetric.COSINE)    // Optional: COSINE, L2, or IP (defaults to COSINE)
            .hnswM(16)                                // Optional: HNSW connections (defaults to 16)
            .hnswEfConstruction(200)                  // Optional: HNSW build parameter (defaults to 200)
            .hnswEfRuntime(10)                        // Optional: HNSW search parameter (defaults to 10)
            .defaultRangeThreshold(0.8)               // Optional: default radius for range searches
            .textScorer(TextScorer.BM25)              // Optional: text scoring algorithm (defaults to BM25)
            .metadataFields(                          // Optional: define metadata fields for filtering
                MetadataField.tag("country"),
                MetadataField.numeric("year"),
                MetadataField.text("description"))
            .initializeSchema(true)                   // Optional: defaults to false
            .batchingStrategy(new TokenCountBatchingStrategy()) // Optional: defaults to TokenCountBatchingStrategy
            .build();
    }

    // This can be any EmbeddingModel implementation
    @Bean
    public EmbeddingModel embeddingModel() {
        return new OpenAiEmbeddingModel(OpenAiEmbeddingOptions.builder().apiKey(System.getenv("OPENAI_API_KEY")).build());
    }

## Accessing the Native Client

The Redis Vector Store implementation provides access to the underlying native Redis client (`RedisClient`) through the `getNativeClient()` method:

    RedisVectorStore vectorStore = context.getBean(RedisVectorStore.class);
    Optional<RedisClient> nativeClient = vectorStore.getNativeClient();

    if (nativeClient.isPresent()) {
        RedisClient jedisClient = nativeClient.get();
        // Use the native client for Redis-specific operations
    }

The native client gives you access to Redis-specific features and operations that might not be exposed through the `VectorStore` interface.

## Distance Metrics

The Redis Vector Store supports three distance metrics for vector similarity:

- **COSINE**: Cosine similarity (default) - measures the cosine of the angle between vectors

- **L2**: Euclidean distance - measures the straight-line distance between vectors

- **IP**: Inner Product - measures the dot product between vectors

Each metric is automatically normalized to a 0-1 similarity score, where 1 is most similar.

    RedisVectorStore vectorStore = RedisVectorStore.builder(jedisClient, embeddingModel)
        .distanceMetric(DistanceMetric.COSINE)  // or L2, IP
        .build();

## HNSW Algorithm Configuration

The Redis Vector Store uses the HNSW (Hierarchical Navigable Small World) algorithm by default for efficient approximate nearest neighbor search. You can tune the HNSW parameters for your specific use case:

    RedisVectorStore vectorStore = RedisVectorStore.builder(jedisClient, embeddingModel)
        .vectorAlgorithm(Algorithm.HNSW)
        .hnswM(32)                    // Maximum outgoing connections per node (default: 16)
        .hnswEfConstruction(100)      // Connections during index building (default: 200)
        .hnswEfRuntime(50)            // Connections during search (default: 10)
        .build();

Parameter guidelines:

- **M**: Higher values improve recall but increase memory usage and index time. Typical values: 12-48.

- **EF\_CONSTRUCTION**: Higher values improve index quality but increase build time. Typical values: 100-500.

- **EF\_RUNTIME**: Higher values improve search accuracy but increase latency. Typical values: 10-100.

For smaller datasets or when exact results are required, use the FLAT algorithm instead:

    RedisVectorStore vectorStore = RedisVectorStore.builder(jedisClient, embeddingModel)
        .vectorAlgorithm(Algorithm.FLAT)
        .build();

## Text Search

The Redis Vector Store provides text search capabilities using Redis Query Engine’s full-text search features. This allows you to find documents based on keywords and phrases in TEXT fields:

    // Search for documents containing specific text
    List<Document> textResults = vectorStore.searchByText(
        "machine learning",   // search query
        "content",            // field to search (must be TEXT type)
        10,                   // limit
        "category == 'AI'"    // optional filter expression
    );

Text search supports:

- Single word searches

- Phrase searches with exact matching when `inOrder` is true

- Term-based searches with OR semantics when `inOrder` is false

- Stopword filtering to ignore common words

- Multiple text scoring algorithms

Configure text search behavior at construction time:

    RedisVectorStore vectorStore = RedisVectorStore.builder(jedisClient, embeddingModel)
        .textScorer(TextScorer.TFIDF)                    // Text scoring algorithm
        .inOrder(true)                                   // Match terms in order
        .stopwords(Set.of("is", "a", "the", "and"))      // Ignore common words
        .metadataFields(MetadataField.text("description")) // Define TEXT fields
        .build();

### Text Scoring Algorithms

Several text scoring algorithms are available:

- **BM25**: Modern version of TF-IDF with term saturation (default)

- **TFIDF**: Classic term frequency-inverse document frequency

- **BM25STD**: Standardized BM25

- **DISMAX**: Disjunction max

- **DOCSCORE**: Document score

Scores are normalized to a 0-1 range for consistency with vector similarity scores.

## Range Search

The range search returns all documents within a specified radius threshold, rather than a fixed number of nearest neighbors:

    // Search with explicit radius
    List<Document> rangeResults = vectorStore.searchByRange(
        "AI and machine learning",  // query
        0.8,                        // radius (similarity threshold)
        "category == 'AI'"          // optional filter expression
    );

You can also set a default range threshold at construction time:

    RedisVectorStore vectorStore = RedisVectorStore.builder(jedisClient, embeddingModel)
        .defaultRangeThreshold(0.8)  // Set default threshold
        .build();

    // Use default threshold
    List<Document> results = vectorStore.searchByRange("query");

Range search is useful when you want to retrieve all relevant documents above a similarity threshold, rather than limiting to a specific count.

## Semantic Caching

Semantic caching is a powerful optimization technique that leverages Redis vector search capabilities to cache and retrieve AI chat responses based on the **semantic similarity** of user queries rather than exact string matching. This enables intelligent response reuse even when users phrase similar questions differently.

### Why Semantic Caching?

Traditional caching relies on exact key matches, which fails when users ask semantically equivalent questions with different wording:

- "What is the capital of France?"

- "Tell me France’s capital city"

- "Which city is the capital of France?"

All three queries have the same answer, but traditional caching would treat them as different requests, resulting in redundant LLM API calls. Semantic caching solves this by comparing the **meaning** of queries using vector embeddings.

**Benefits:**

- **Reduced API costs**: Avoid redundant calls to expensive LLM APIs

- **Lower latency**: Return cached responses instantly instead of waiting for model inference

- **Improved scalability**: Handle higher query volumes without proportional API cost increases

- **Consistent responses**: Return identical answers for semantically similar questions

### Auto-configuration

Spring AI provides Spring Boot auto-configuration for the Redis Semantic Cache. To enable it, add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-vector-store-redis-semantic-cache</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file:

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-vector-store-redis-semantic-cache'
    }

### Configuration Properties

Properties starting with `spring.ai.vectorstore.redis.semantic-cache.*` configure the semantic cache:

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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.redis.semantic-cache.enabled</code></p></td>
<td class="tableblock halign-left valign-top"><p>Enable or disable the semantic cache</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.redis.semantic-cache.host</code></p></td>
<td class="tableblock halign-left valign-top"><p>Redis server host</p></td>
<td class="tableblock halign-left valign-top"><p><code>localhost</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.redis.semantic-cache.port</code></p></td>
<td class="tableblock halign-left valign-top"><p>Redis server port</p></td>
<td class="tableblock halign-left valign-top"><p><code>6379</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.redis.semantic-cache.similarity-threshold</code></p></td>
<td class="tableblock halign-left valign-top"><p>Similarity threshold for cache hits (0.0-1.0). Higher values require closer semantic matches.</p></td>
<td class="tableblock halign-left valign-top"><p><code>0.95</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.redis.semantic-cache.index-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>Name of the Redis search index for cache entries</p></td>
<td class="tableblock halign-left valign-top"><p><code>semantic-cache-index</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.redis.semantic-cache.prefix</code></p></td>
<td class="tableblock halign-left valign-top"><p>Key prefix for cached entries in Redis</p></td>
<td class="tableblock halign-left valign-top"><p><code>semantic-cache:</code></p></td>
</tr>
</tbody>
</table>

Example configuration in `application.yml`:

    spring:
      ai:
        vectorstore:
          redis:
            semantic-cache:
              enabled: true
              host: localhost
              port: 6379
              similarity-threshold: 0.85
              index-name: my-app-cache
              prefix: "my-app:semantic-cache:"

### Using the SemanticCacheAdvisor

The `SemanticCacheAdvisor` integrates seamlessly with Spring AI’s `ChatClient` advisor pattern. It automatically caches responses and returns cached results for similar queries:

    @Autowired
    private SemanticCache semanticCache;

    @Autowired
    private ChatModel chatModel;

    public void example() {
        // Create the cache advisor
        SemanticCacheAdvisor cacheAdvisor = SemanticCacheAdvisor.builder()
            .cache(semanticCache)
            .build();

        // First query - calls the LLM and caches the response
        ChatResponse response1 = ChatClient.builder(chatModel)
            .build()
            .prompt("What is the capital of France?")
            .advisors(cacheAdvisor)
            .call()
            .chatResponse();

        // Similar query - returns cached response (no LLM call)
        ChatResponse response2 = ChatClient.builder(chatModel)
            .build()
            .prompt("Tell me the capital city of France")
            .advisors(cacheAdvisor)
            .call()
            .chatResponse();

        // response1 and response2 contain the same cached answer
    }

The advisor automatically:

1.  Checks the cache for semantically similar queries before calling the LLM

2.  Returns cached responses when a match is found above the similarity threshold

3.  Caches new responses after successful LLM calls

4.  Supports both synchronous and streaming chat operations

### Direct Cache Usage

You can also interact with the `SemanticCache` directly for fine-grained control:

    @Autowired
    private SemanticCache semanticCache;

    // Store a response with a query
    semanticCache.set("What is the capital of France?", chatResponse);

    // Store with TTL (time-to-live) for automatic expiration
    semanticCache.set("What's the weather today?", weatherResponse, Duration.ofHours(1));

    // Retrieve a semantically similar response
    Optional<ChatResponse> cached = semanticCache.get("Tell me France's capital");

    if (cached.isPresent()) {
        // Use the cached response
        String answer = cached.get().getResult().getOutput().getText();
    }

    // Clear all cached entries
    semanticCache.clear();

### Manual Configuration

For more control, you can manually configure the semantic cache components:

    @Configuration
    public class SemanticCacheConfig {

        @Bean
        public RedisClient jedisClient() {
            return RedisClient.builder().hostAndPort("localhost", 6379).build();
        }

        @Bean
        public SemanticCache semanticCache(RedisClient jedisClient, EmbeddingModel embeddingModel) {
            return DefaultSemanticCache.builder()
                .jedisClient(jedisClient)
                .embeddingModel(embeddingModel)
                .distanceThreshold(0.3)           // Lower = stricter matching
                .indexName("my-semantic-cache")
                .prefix("cache:")
                .build();
        }

        @Bean
        public SemanticCacheAdvisor semanticCacheAdvisor(SemanticCache cache) {
            return SemanticCacheAdvisor.builder()
                .cache(cache)
                .build();
        }
    }

### Cache Isolation with Namespaces

For multi-tenant applications or when you need separate cache spaces, use different index names to isolate cache entries:

    // Create isolated caches for different users or contexts
    SemanticCache user1Cache = DefaultSemanticCache.builder()
        .jedisClient(jedisClient)
        .embeddingModel(embeddingModel)
        .indexName("user-1-cache")
        .build();

    SemanticCache user2Cache = DefaultSemanticCache.builder()
        .jedisClient(jedisClient)
        .embeddingModel(embeddingModel)
        .indexName("user-2-cache")
        .build();

    // Each user gets their own isolated cache space
    SemanticCacheAdvisor user1Advisor = SemanticCacheAdvisor.builder()
        .cache(user1Cache)
        .build();

### System Prompt Isolation

The `SemanticCacheAdvisor` automatically isolates cached responses based on the system prompt. This ensures that the same user query with different system prompts returns different cached responses, which is essential for applications with multiple AI personas or context-dependent behavior.

    SemanticCacheAdvisor cacheAdvisor = SemanticCacheAdvisor.builder()
        .cache(semanticCache)
        .build();

    // Query with technical support persona
    ChatResponse technicalResponse = ChatClient.builder(chatModel)
        .build()
        .prompt()
        .system("You are a technical support specialist. Provide detailed technical answers.")
        .user("How do I reset my password?")
        .advisors(cacheAdvisor)
        .call()
        .chatResponse();

    // Same query with customer service persona - cache MISS (different context)
    ChatResponse serviceResponse = ChatClient.builder(chatModel)
        .build()
        .prompt()
        .system("You are a friendly customer service agent. Keep responses brief and helpful.")
        .user("How do I reset my password?")
        .advisors(cacheAdvisor)
        .call()
        .chatResponse();

    // Same query with technical support persona again - cache HIT
    ChatResponse technicalAgain = ChatClient.builder(chatModel)
        .build()
        .prompt()
        .system("You are a technical support specialist. Provide detailed technical answers.")
        .user("How do I reset my password?")
        .advisors(cacheAdvisor)
        .call()
        .chatResponse();
    // Returns the cached technical response

**How it works:**

The advisor computes a deterministic hash of the system prompt and uses it as a metadata filter when storing and retrieving cached responses:

- Same user question + same system prompt → cache hit

- Same user question + different system prompt → cache miss (separate cache entry)

- Queries without a system prompt share a common cache space

### Context-Aware Cache API

For advanced use cases, you can use the context-aware cache methods directly:

    // Store with explicit context hash
    String contextHash = "technical-support-context";
    semanticCache.set("How do I reset my password?", response, contextHash);

    // Retrieve with context filtering
    Optional<ChatResponse> cached = semanticCache.get("How do I reset my password?", contextHash);

    // Different context hash returns empty (no match)
    Optional<ChatResponse> otherContext = semanticCache.get("How do I reset my password?", "billing-context");

### Tuning the Similarity Threshold

The similarity threshold determines how closely a query must match a cached entry to be considered a hit. The threshold is expressed as a value between 0.0 and 1.0:

- **Higher threshold (e.g., 0.95)**: Requires very close semantic matches. Reduces false positives but may miss valid cache hits.

- **Lower threshold (e.g., 0.70)**: Allows broader semantic matches. Increases cache hit rate but may return less relevant cached responses.

    // Strict matching - only very similar queries hit the cache
    SemanticCache strictCache = DefaultSemanticCache.builder()
        .jedisClient(jedisClient)
        .embeddingModel(embeddingModel)
        .distanceThreshold(0.2)  // Strict (distance-based, lower = stricter)
        .build();

    // Lenient matching - broader semantic similarity accepted
    SemanticCache lenientCache = DefaultSemanticCache.builder()
        .jedisClient(jedisClient)
        .embeddingModel(embeddingModel)
        .distanceThreshold(0.5)  // Lenient
        .build();

### TTL and Cache Expiration

Cached responses can be configured with a time-to-live (TTL) for automatic expiration. This is essential for time-sensitive data:

    // Cache weather data for 1 hour
    semanticCache.set("What's the weather in New York?", weatherResponse, Duration.ofHours(1));

    // Cache general knowledge indefinitely (no TTL)
    semanticCache.set("What is photosynthesis?", scienceResponse);

    // Redis automatically removes expired entries

### How It Works

The semantic cache operates using the following flow:

1.  **Query embedding**: When a query arrives, it is converted to a vector embedding using the configured `EmbeddingModel`

2.  **Vector search**: Redis performs a range-based vector search (`VECTOR_RANGE`) to find cached entries within the similarity threshold

3.  **Cache hit**: If a semantically similar query is found, the cached `ChatResponse` is returned immediately

4.  **Cache miss**: If no match is found, the query proceeds to the LLM, and the response is cached for future use

The implementation leverages Redis’s efficient vector indexing (HNSW algorithm) for fast similarity searches, even with large cache sizes.

Qdrant Typesense

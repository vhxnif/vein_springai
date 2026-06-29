Search

# Chat Memory

Large language models (LLMs) are stateless, meaning they do not retain information about previous interactions. This can be a limitation when you want to maintain context or state across multiple interactions. To address this, Spring AI provides chat memory features that allow you to store and retrieve information across multiple interactions with the LLM.

The `ChatMemory` abstraction allows you to implement various types of memory to support different use cases. The underlying storage of the messages is handled by the `ChatMemoryRepository`, whose sole responsibility is to store and retrieve messages. It’s up to the `ChatMemory` implementation to decide which messages to keep and when to remove them. Examples of strategies could include keeping the last N messages, keeping messages for a certain time period, or keeping messages up to a certain token limit.

Before choosing a memory type, it’s essential to understand the difference between chat memory and chat history.

- **Chat Memory**. The information that a large-language model retains and uses to maintain contextual awareness throughout a conversation.

- **Chat History**. The entire conversation history, including all messages exchanged between the user and the model.

The `ChatMemory` abstraction is designed to manage the *chat memory*. It allows you to store and retrieve messages that are relevant to the current conversation context. However, it is not the best fit for storing the *chat history*. If you need to maintain a complete record of all the messages exchanged, you should consider using a different approach, such as relying on Spring Data for efficient storage and retrieval of the complete chat history.

## Quick Start

Spring AI auto-configures a `ChatMemory` bean that you can use directly in your application. By default, it uses an in-memory repository to store messages (`InMemoryChatMemoryRepository`) and a `MessageWindowChatMemory` implementation to manage the conversation history. If a different repository is already configured (e.g., Cassandra, JDBC, or Neo4j), Spring AI will use that instead.

    @Autowired
    ChatMemory chatMemory;

The following sections will describe further the different memory types and repositories available in Spring AI.

## Memory Types

The `ChatMemory` abstraction allows you to implement various types of memory to suit different use cases. The choice of memory type can significantly impact the performance and behavior of your application. This section describes the built-in memory types provided by Spring AI and their characteristics.

### Message Window Chat Memory

`MessageWindowChatMemory` maintains a sliding window of messages up to a specified maximum size. When the number of messages exceeds the maximum, older messages are evicted while always preserving `SystemMessage` instances. The default window size is 20 messages.

    MessageWindowChatMemory memory = MessageWindowChatMemory.builder()
        .maxMessages(10)
        .build();

This is the default message type used by Spring AI to auto-configure a `ChatMemory` bean.

#### Turn-boundary eviction

When eviction is needed, `MessageWindowChatMemory` always removes whole turns rather than cutting mid-turn. A *turn* starts at a `UserMessage` and includes all subsequent assistant replies, tool calls, and tool responses up to the next `UserMessage`. If the raw eviction point lands on a non-user message (for example, an assistant reply in the middle of a tool-calling exchange), the cut is advanced forward to the next `UserMessage` so that the kept window always begins at a complete turn.

This means `maxMessages` is an *upper bound* on the number of messages stored — the actual count may be somewhat lower when snapping is needed to find the next turn boundary.

## Memory Storage

Spring AI offers the `ChatMemoryRepository` abstraction for storing chat memory. This section describes the built-in repositories provided by Spring AI and how to use them, but you can also implement your own repository if needed.

### In-Memory Repository

`InMemoryChatMemoryRepository` stores messages in memory using a `ConcurrentHashMap`.

By default, if no other repository is already configured, Spring AI auto-configures a `ChatMemoryRepository` bean of type `InMemoryChatMemoryRepository` that you can use directly in your application.

    @Autowired
    ChatMemoryRepository chatMemoryRepository;

If you’d rather create the `InMemoryChatMemoryRepository` manually, you can do so as follows:

    ChatMemoryRepository repository = new InMemoryChatMemoryRepository();

### JdbcChatMemoryRepository

`JdbcChatMemoryRepository` is a built-in implementation that uses JDBC to store messages in a relational database. It supports multiple databases out-of-the-box and is suitable for applications that require persistent storage of chat memory.

Messages are retrieved in ascending order (oldest-to-newest), which is the expected format for LLM conversation history. Ordering is maintained by a `sequence_id` column that records each message’s position within its conversation. Each message also stores a creation `timestamp`, exposed in the message metadata under the `JdbcChatMemoryRepository.CONVERSATION_TS` key as a `java.time.Instant`, so applications can display when a message was created.

First, add the following dependency to your project:

Spring AI provides auto-configuration for the `JdbcChatMemoryRepository`, that you can use directly in your application.

    @Autowired
    JdbcChatMemoryRepository chatMemoryRepository;

    ChatMemory chatMemory = MessageWindowChatMemory.builder()
        .chatMemoryRepository(chatMemoryRepository)
        .maxMessages(10)
        .build();

If you’d rather create the `JdbcChatMemoryRepository` manually, you can do so by providing a `JdbcTemplate` instance and a `JdbcChatMemoryRepositoryDialect`:

    ChatMemoryRepository chatMemoryRepository = JdbcChatMemoryRepository.builder()
        .jdbcTemplate(jdbcTemplate)
        .dialect(new PostgresChatMemoryRepositoryDialect())
        .build();

    ChatMemory chatMemory = MessageWindowChatMemory.builder()
        .chatMemoryRepository(chatMemoryRepository)
        .maxMessages(10)
        .build();

#### Reading Message Timestamps

Each stored message records when it was created. The timestamp is available in the message metadata under the `JdbcChatMemoryRepository.CONVERSATION_TS` key as a `java.time.Instant`, which is useful for displaying message times in a UI:

    List<Message> messages = chatMemory.get(conversationId);
    for (Message message : messages) {
        Instant createdAt = (Instant) message.getMetadata().get(JdbcChatMemoryRepository.CONVERSATION_TS);
    }

The timestamp is preserved when a conversation is saved again, so a message keeps its original creation time for the lifetime of the conversation.

#### Supported Databases and Dialect Abstraction

Spring AI supports multiple relational databases via a dialect abstraction. The following databases are supported out-of-the-box:

- PostgreSQL

- MySQL / MariaDB

- SQL Server

- HSQLDB

- Oracle Database

The correct dialect can be auto-detected from the JDBC URL when using `JdbcChatMemoryRepositoryDialect.from(DataSource)`. You can extend support for other databases by implementing the `JdbcChatMemoryRepositoryDialect` interface.

#### Configuration Properties

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 25%" />
<col style="width: 62%" />
<col style="width: 12%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Property</p></td>
<td class="tableblock halign-left valign-top"><p>Description</p></td>
<td class="tableblock halign-left valign-top"><p>Default Value</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.repository.jdbc.initialize-schema</code></p></td>
<td class="tableblock halign-left valign-top"><p>Controls when to initialize the schema. Values: <code>embedded</code> (default), <code>always</code>, <code>never</code>.</p></td>
<td class="tableblock halign-left valign-top"><p><code>embedded</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.repository.jdbc.schema</code></p></td>
<td class="tableblock halign-left valign-top"><p>Location of the schema script to use for initialization. Supports <code>classpath:</code> URLs and platform placeholders.</p></td>
<td class="tableblock halign-left valign-top"><p><code>classpath:org/springframework/ai/chat/memory/repository/jdbc/schema-@@platform@@.sql</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.repository.jdbc.platform</code></p></td>
<td class="tableblock halign-left valign-top"><p>Platform to use in initialization scripts if the @@platform@@ placeholder is used.</p></td>
<td class="tableblock halign-left valign-top"><p><em>auto-detected</em></p></td>
</tr>
</tbody>
</table>

#### Schema Initialization

The auto-configuration will automatically create the `SPRING_AI_CHAT_MEMORY` table on startup, using a vendor-specific SQL script for your database. By default, schema initialization runs only for embedded databases (H2, HSQL, Derby, etc.).

You can control schema initialization using the `spring.ai.chat.memory.repository.jdbc.initialize-schema` property:

    spring.ai.chat.memory.repository.jdbc.initialize-schema=embedded # Only for embedded DBs (default)
    spring.ai.chat.memory.repository.jdbc.initialize-schema=always   # Always initialize
    spring.ai.chat.memory.repository.jdbc.initialize-schema=never    # Never initialize (useful with Flyway/Liquibase)

To override the schema script location, use:

    spring.ai.chat.memory.repository.jdbc.schema=classpath:/custom/path/schema-mysql.sql

#### Extending Dialects

To add support for a new database, implement the `JdbcChatMemoryRepositoryDialect` interface and provide SQL for selecting, inserting, and deleting messages. You can then pass your custom dialect to the repository builder.

    ChatMemoryRepository chatMemoryRepository = JdbcChatMemoryRepository.builder()
        .jdbcTemplate(jdbcTemplate)
        .dialect(new MyCustomDbDialect())
        .build();

### CassandraChatMemoryRepository

`CassandraChatMemoryRepository` uses Apache Cassandra to store messages. It is suitable for applications that require persistent storage of chat memory, especially for availability, durability, scale, and when taking advantage of time-to-live (TTL) feature.

`CassandraChatMemoryRepository` has a time-series schema, keeping record of all past chat windows, valuable for governance and auditing. Setting time-to-live to some value, for example three years, is recommended.

Messages are retrieved in ascending timestamp order (oldest-to-newest), which is the expected format for LLM conversation history.

To use `CassandraChatMemoryRepository` first, add the dependency to your project:

Spring AI provides auto-configuration for the `CassandraChatMemoryRepository` that you can use directly in your application.

    @Autowired
    CassandraChatMemoryRepository chatMemoryRepository;

    ChatMemory chatMemory = MessageWindowChatMemory.builder()
        .chatMemoryRepository(chatMemoryRepository)
        .maxMessages(10)
        .build();

If you’d rather create the `CassandraChatMemoryRepository` manually, you can do so by providing a `CassandraChatMemoryRepositoryConfig` instance:

    ChatMemoryRepository chatMemoryRepository = CassandraChatMemoryRepository
        .create(CassandraChatMemoryRepositoryConfig.builder().withCqlSession(cqlSession));

    ChatMemory chatMemory = MessageWindowChatMemory.builder()
        .chatMemoryRepository(chatMemoryRepository)
        .maxMessages(10)
        .build();

#### Configuration Properties

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 25%" />
<col style="width: 62%" />
<col style="width: 12%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Property</p></td>
<td class="tableblock halign-left valign-top"><p>Description</p></td>
<td class="tableblock halign-left valign-top"><p>Default Value</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.cassandra.contactPoints</code></p></td>
<td class="tableblock halign-left valign-top"><p>Host(s) to initiate cluster discovery</p></td>
<td class="tableblock halign-left valign-top"><p><code>127.0.0.1</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.cassandra.port</code></p></td>
<td class="tableblock halign-left valign-top"><p>Cassandra native protocol port to connect to</p></td>
<td class="tableblock halign-left valign-top"><p><code>9042</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.cassandra.localDatacenter</code></p></td>
<td class="tableblock halign-left valign-top"><p>Cassandra datacenter to connect to</p></td>
<td class="tableblock halign-left valign-top"><p><code>datacenter1</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.cassandra.time-to-live</code></p></td>
<td class="tableblock halign-left valign-top"><p>Time to live (TTL) for messages written in Cassandra</p></td>
<td class="tableblock halign-left valign-top"></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.cassandra.keyspace</code></p></td>
<td class="tableblock halign-left valign-top"><p>Cassandra keyspace</p></td>
<td class="tableblock halign-left valign-top"><p><code>springframework</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.cassandra.messages-column</code></p></td>
<td class="tableblock halign-left valign-top"><p>Cassandra column name for messages</p></td>
<td class="tableblock halign-left valign-top"><p><code>springframework</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.cassandra.table</code></p></td>
<td class="tableblock halign-left valign-top"><p>Cassandra table</p></td>
<td class="tableblock halign-left valign-top"><p><code>ai_chat_memory</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.cassandra.initialize-schema</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to initialize the schema on startup.</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
</tbody>
</table>

#### Schema Initialization

The auto-configuration will automatically create the `ai_chat_memory` table.

You can disable the schema initialization by setting the property `spring.ai.chat.memory.repository.cassandra.initialize-schema` to `false`.

### Neo4j ChatMemoryRepository

`Neo4jChatMemoryRepository` is a built-in implementation that uses Neo4j to store chat messages as nodes and relationships in a property graph database. It is suitable for applications that want to leverage Neo4j’s graph capabilities for chat memory persistence.

Messages are retrieved in ascending message index order (oldest-to-newest), which is the expected format for LLM conversation history.

First, add the following dependency to your project:

Spring AI provides auto-configuration for the `Neo4jChatMemoryRepository`, which you can use directly in your application.

    @Autowired
    Neo4jChatMemoryRepository chatMemoryRepository;

    ChatMemory chatMemory = MessageWindowChatMemory.builder()
        .chatMemoryRepository(chatMemoryRepository)
        .maxMessages(10)
        .build();

If you’d rather create the `Neo4jChatMemoryRepository` manually, you can do so by providing a Neo4j `Driver` instance:

    ChatMemoryRepository chatMemoryRepository = Neo4jChatMemoryRepository.builder()
        .driver(driver)
        .build();

    ChatMemory chatMemory = MessageWindowChatMemory.builder()
        .chatMemoryRepository(chatMemoryRepository)
        .maxMessages(10)
        .build();

#### Configuration Properties

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 25%" />
<col style="width: 62%" />
<col style="width: 12%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Property</p></td>
<td class="tableblock halign-left valign-top"><p>Description</p></td>
<td class="tableblock halign-left valign-top"><p>Default Value</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.repository.neo4j.session-label</code></p></td>
<td class="tableblock halign-left valign-top"><p>The label for the nodes that store conversation sessions</p></td>
<td class="tableblock halign-left valign-top"><p><code>Session</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.repository.neo4j.message-label</code></p></td>
<td class="tableblock halign-left valign-top"><p>The label for the nodes that store messages</p></td>
<td class="tableblock halign-left valign-top"><p><code>Message</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.repository.neo4j.tool-call-label</code></p></td>
<td class="tableblock halign-left valign-top"><p>The label for nodes that store tool calls (e.g. in Assistant Messages)</p></td>
<td class="tableblock halign-left valign-top"><p><code>ToolCall</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.repository.neo4j.metadata-label</code></p></td>
<td class="tableblock halign-left valign-top"><p>The label for nodes that store message metadata</p></td>
<td class="tableblock halign-left valign-top"><p><code>Metadata</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.repository.neo4j.tool-response-label</code></p></td>
<td class="tableblock halign-left valign-top"><p>The label for the nodes that store tool responses</p></td>
<td class="tableblock halign-left valign-top"><p><code>ToolResponse</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.repository.neo4j.media-label</code></p></td>
<td class="tableblock halign-left valign-top"><p>The label for the nodes that store media associated with a message</p></td>
<td class="tableblock halign-left valign-top"><p><code>Media</code></p></td>
</tr>
</tbody>
</table>

#### Index Initialization

The Neo4j repository will automatically ensure that indexes are created for conversation IDs and message indices to optimize performance. If you use custom labels, indexes will be created for those labels as well. No schema initialization is required, but you should ensure your Neo4j instance is accessible to your application.

### MongoChatMemoryRepository

`MongoChatMemoryRepository` is a built-in implementation that uses MongoDB to store messages. It is suitable for applications that require a flexible, document-oriented database for chat memory persistence.

Messages are retrieved in ascending timestamp order (oldest-to-newest), which is the expected format for LLM conversation history. This ordering is consistent across all chat memory repository implementations.

First, add the following dependency to your project:

Spring AI provides auto-configuration for the `MongoChatMemoryRepository`, which you can use directly in your application.

    @Autowired
    MongoChatMemoryRepository chatMemoryRepository;

    ChatMemory chatMemory = MessageWindowChatMemory.builder()
        .chatMemoryRepository(chatMemoryRepository)
        .maxMessages(10)
        .build();

If you’d rather create the `MongoChatMemoryRepository` manually, you can do so by providing a `MongoTemplate` instance:

    ChatMemoryRepository chatMemoryRepository = MongoChatMemoryRepository.builder()
        .mongoTemplate(mongoTemplate)
        .build();

    ChatMemory chatMemory = MessageWindowChatMemory.builder()
        .chatMemoryRepository(chatMemoryRepository)
        .maxMessages(10)
        .build();

#### Configuration Properties

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 25%" />
<col style="width: 62%" />
<col style="width: 12%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Property</p></td>
<td class="tableblock halign-left valign-top"><p>Description</p></td>
<td class="tableblock halign-left valign-top"><p>Default Value</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.repository.mongo.create-indices</code></p></td>
<td class="tableblock halign-left valign-top"><p>Should indices be created or recreated automatically on startup. Note: Changing the * TTL value will drop the TTL index and recreate it</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.repository.mongo.ttl</code></p></td>
<td class="tableblock halign-left valign-top"><p>Time to live (TTL) for messages written in MongoDB, in seconds. If not set, messages will be stored indefinitely.</p></td>
<td class="tableblock halign-left valign-top"><p><code>0</code></p></td>
</tr>
</tbody>
</table>

#### Collection Initialization

The auto-configuration will automatically create the `ai_chat_memory` collection on startup if it does not already exist.

### RedisChatMemoryRepository

`RedisChatMemoryRepository` is a built-in implementation that uses Redis Stack (with Redis Query Engine and RedisJSON) to store chat messages. It is suitable for applications that require high-performance, low-latency chat memory persistence with optional TTL (time-to-live) support and advanced querying capabilities.

The repository stores messages as JSON documents and creates a search index for efficient querying. It also provides extended query capabilities through the `AdvancedRedisChatMemoryRepository` interface for searching messages by content, type, time range, and metadata.

Messages are retrieved in ascending timestamp order (oldest-to-newest), which is the expected format for LLM conversation history.

First, add the following dependency to your project:

Spring AI provides auto-configuration for the `RedisChatMemoryRepository`, which you can use directly in your application.

    @Autowired
    RedisChatMemoryRepository chatMemoryRepository;

    ChatMemory chatMemory = MessageWindowChatMemory.builder()
        .chatMemoryRepository(chatMemoryRepository)
        .maxMessages(10)
        .build();

If you’d rather create the `RedisChatMemoryRepository` manually, you can do so by providing a `RedisClient` client:

    RedisClient jedisClient = RedisClient.builder().hostAndPort("localhost", 6379).build();

    ChatMemoryRepository chatMemoryRepository = RedisChatMemoryRepository.builder()
        .jedisClient(jedisClient)
        .indexName("my-chat-index")
        .keyPrefix("my-chat:")
        .timeToLive(Duration.ofHours(24))
        .build();

    ChatMemory chatMemory = MessageWindowChatMemory.builder()
        .chatMemoryRepository(chatMemoryRepository)
        .maxMessages(10)
        .build();

#### Configuration Properties

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 25%" />
<col style="width: 62%" />
<col style="width: 12%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Property</p></td>
<td class="tableblock halign-left valign-top"><p>Description</p></td>
<td class="tableblock halign-left valign-top"><p>Default Value</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.redis.host</code></p></td>
<td class="tableblock halign-left valign-top"><p>Redis server host</p></td>
<td class="tableblock halign-left valign-top"><p><code>localhost</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.redis.port</code></p></td>
<td class="tableblock halign-left valign-top"><p>Redis server port</p></td>
<td class="tableblock halign-left valign-top"><p><code>6379</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.redis.index-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>Name of the Redis search index</p></td>
<td class="tableblock halign-left valign-top"><p><code>chat-memory-idx</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.redis.key-prefix</code></p></td>
<td class="tableblock halign-left valign-top"><p>Key prefix for chat memory entries</p></td>
<td class="tableblock halign-left valign-top"><p><code>chat-memory:</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.redis.time-to-live</code></p></td>
<td class="tableblock halign-left valign-top"><p>Time to live for chat memory entries (e.g., <code>24h</code>, <code>30d</code>)</p></td>
<td class="tableblock halign-left valign-top"><p><em>no expiration</em></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.redis.initialize-schema</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to initialize the Redis schema on startup</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.redis.max-conversation-ids</code></p></td>
<td class="tableblock halign-left valign-top"><p>Maximum number of conversation IDs to return</p></td>
<td class="tableblock halign-left valign-top"><p><code>1000</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.memory.redis.max-messages-per-conversation</code></p></td>
<td class="tableblock halign-left valign-top"><p>Maximum number of messages to return per conversation</p></td>
<td class="tableblock halign-left valign-top"><p><code>1000</code></p></td>
</tr>
</tbody>
</table>

#### Advanced Querying

The `RedisChatMemoryRepository` also implements `AdvancedRedisChatMemoryRepository`, which provides extended query capabilities:

    // Cast to access advanced features
    AdvancedRedisChatMemoryRepository advancedRepo = (AdvancedRedisChatMemoryRepository) chatMemoryRepository;

    // Find messages by type across all conversations
    List<MessageWithConversation> userMessages = advancedRepo.findByType(MessageType.USER, 100);

    // Find messages containing specific content
    List<MessageWithConversation> results = advancedRepo.findByContent("Spring AI", 50);

    // Find messages within a time range
    List<MessageWithConversation> recentMessages = advancedRepo.findByTimeRange(
        conversationId,
        Instant.now().minus(Duration.ofHours(1)),
        Instant.now(),
        100
    );

    // Find messages by metadata
    List<MessageWithConversation> priorityMessages = advancedRepo.findByMetadata("priority", "high", 50);

    // Execute custom Redis queries
    List<MessageWithConversation> customResults = advancedRepo.executeQuery("@type:USER @content:Redis", 100);

#### Metadata Field Indexing

To enable efficient querying on custom metadata fields, you can configure metadata field definitions:

    spring.ai.chat.memory.redis.metadata-fields[0].name=priority
    spring.ai.chat.memory.redis.metadata-fields[0].type=tag
    spring.ai.chat.memory.redis.metadata-fields[1].name=score
    spring.ai.chat.memory.redis.metadata-fields[1].type=numeric
    spring.ai.chat.memory.redis.metadata-fields[2].name=category
    spring.ai.chat.memory.redis.metadata-fields[2].type=tag

Supported field types are: `tag` (for exact match filtering), `text` (for full-text search), and `numeric` (for range queries).

#### Schema Initialization

The auto-configuration will automatically create the Redis search index on startup if it does not already exist. You can disable this behavior by setting `spring.ai.chat.memory.redis.initialize-schema=false`.

#### Requirements

- Redis Stack 7.0 or higher (includes Redis Query Engine and RedisJSON modules)

- Jedis client library (included as a dependency)

## Memory in Chat Client

When using the ChatClient API, you can provide a `ChatMemory` implementation to maintain conversation context across multiple interactions.

Spring AI provides a few built-in Advisors that you can use to configure the memory behavior of the `ChatClient`, based on your needs.

- `MessageChatMemoryAdvisor`. This advisor manages the conversation memory using the provided `ChatMemory` implementation. On each interaction, it retrieves the conversation history from the memory and includes it in the prompt as a collection of messages.

- `VectorStoreChatMemoryAdvisor`. This advisor manages the conversation memory using the provided `VectorStore` implementation. On each interaction, it retrieves the conversation history from the vector store and appends it to the system message as plain text.

For example, if you want to use `MessageWindowChatMemory` with the `MessageChatMemoryAdvisor`, you can configure it as follows:

    ChatMemory chatMemory = MessageWindowChatMemory.builder().build();

    ChatClient chatClient = ChatClient.builder(chatModel)
        .defaultAdvisors(MessageChatMemoryAdvisor.builder(chatMemory).build())
        .build();

When performing a call to the `ChatClient`, the memory will be automatically managed by the `MessageChatMemoryAdvisor`. The conversation history will be retrieved from the memory based on the specified conversation ID.

    String conversationId = "007";

    chatClient.prompt()
        .user("Do I have license to code?")
        .advisors(a -> a.param(ChatMemory.CONVERSATION_ID, conversationId))
        .call()
        .content();

### VectorStoreChatMemoryAdvisor

#### Custom Template

The `VectorStoreChatMemoryAdvisor` uses a default template to augment the system message with the retrieved conversation memory. You can customize this behavior by providing your own `PromptTemplate` object via the `.promptTemplate()` builder method.

The custom `PromptTemplate` can use any `TemplateRenderer` implementation (by default, it uses `StPromptTemplate` based on the StringTemplate engine). The important requirement is that the template must contain the following two placeholders:

- an `instructions` placeholder to receive the original system message.

- a `long_term_memory` placeholder to receive the retrieved conversation memory.

## Memory in Chat Model

If you’re working directly with a `ChatModel` instead of a `ChatClient`, you can manage the memory explicitly:

    // Create a memory instance
    ChatMemory chatMemory = MessageWindowChatMemory.builder().build();
    String conversationId = "007";

    // First interaction
    UserMessage userMessage1 = new UserMessage("My name is James Bond");
    chatMemory.add(conversationId, userMessage1);
    ChatResponse response1 = chatModel.call(new Prompt(chatMemory.get(conversationId)));
    chatMemory.add(conversationId, response1.getResult().getOutput());

    // Second interaction
    UserMessage userMessage2 = new UserMessage("What is my name?");
    chatMemory.add(conversationId, userMessage2);
    ChatResponse response2 = chatModel.call(new Prompt(chatMemory.get(conversationId)));
    chatMemory.add(conversationId, response2.getResult().getOutput());

    // The response will contain "James Bond"

Mistral AI Tool Calling

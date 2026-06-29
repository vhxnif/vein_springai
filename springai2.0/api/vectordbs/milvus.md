Search

# Milvus

Milvus is an open-source vector database that has garnered significant attention in the fields of data science and machine learning. One of its standout features lies in its robust support for vector indexing and querying. Milvus employs state-of-the-art, cutting-edge algorithms to accelerate the search process, making it exceptionally efficient at retrieving similar vectors, even when handling extensive datasets.

## Prerequisites

- A running Milvus instance. The following options are available:

  - Milvus Standalone: Docker, Operator, Helm,DEB/RPM, Docker Compose.

  - Milvus Cluster: Operator, Helm.

- If required, an API key for the EmbeddingModel to generate the embeddings stored by the `MilvusVectorStore`.

## Dependencies

Then add the Milvus VectorStore boot starter dependency to your project:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-vector-store-milvus</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-vector-store-milvus'
    }

The vector store implementation can initialize the requisite schema for you, but you must opt-in by specifying the `initializeSchema` boolean in the appropriate constructor or by setting `…​initialize-schema=true` in the `application.properties` file.

The Vector Store, also requires an `EmbeddingModel` instance to calculate embeddings for the documents. You can pick one of the available EmbeddingModel Implementations.

To connect to and configure the `MilvusVectorStore`, you need to provide access details for your instance. A simple configuration can either be provided via Spring Boot’s `application.yml`

    spring:
        ai:
            vectorstore:
                milvus:
                    client:
                        host: "localhost"
                        port: 19530
                        username: "root"
                        password: "milvus"
                    databaseName: "default"
                    collectionName: "vector_store"
                    embeddingDimension: 1536
                    indexType: IVF_FLAT
                    metricType: COSINE

Now you can Auto-wire the Milvus Vector Store in your application and use it

    @Autowired VectorStore vectorStore;

    // ...

    List <Document> documents = List.of(
        new Document("Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!!", Map.of("meta1", "meta1")),
        new Document("The World is Big and Salvation Lurks Around the Corner"),
        new Document("You walk forward facing the past and you turn back toward the future.", Map.of("meta2", "meta2")));

    // Add the documents to Milvus Vector Store
    vectorStore.add(documents);

    // Retrieve documents similar to a query
    List<Document> results = this.vectorStore.similaritySearch(SearchRequest.builder().query("Spring").topK(5).build());

### Manual Configuration

Instead of using the Spring Boot auto-configuration, you can manually configure the `MilvusVectorStore`. To add the following dependencies to your project:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-milvus-store</artifactId>
    </dependency>

To configure MilvusVectorStore in your application, you can use the following setup:

       @Bean
        public VectorStore vectorStore(MilvusServiceClient milvusClient, EmbeddingModel embeddingModel) {
            return MilvusVectorStore.builder(milvusClient, embeddingModel)
                    .collectionName("test_vector_store")
                    .databaseName("default")
                    .indexType(IndexType.IVF_FLAT)
                    .metricType(MetricType.COSINE)
                    .batchingStrategy(new TokenCountBatchingStrategy())
                    .initializeSchema(true)
                    .build();
        }

        @Bean
        public MilvusServiceClient milvusClient() {
            return new MilvusServiceClient(ConnectParam.newBuilder()
                .withAuthorization("minioadmin", "minioadmin")
                .withUri(milvusContainer.getEndpoint())
                .build());
        }

## Metadata filtering

You can leverage the generic, portable metadata filters with the Milvus store.

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

## Using MilvusSearchRequest

MilvusSearchRequest extends SearchRequest, allowing you to use Milvus-specific search parameters such as native expressions and search parameter JSON.

    MilvusSearchRequest request = MilvusSearchRequest.milvusBuilder()
        .query("sample query")
        .topK(5)
        .similarityThreshold(0.7)
        .nativeExpression("metadata[\"age\"] > 30") // Overrides filterExpression if both are set
        .filterExpression("age <= 30") // Ignored if nativeExpression is set
        .searchParamsJson("{\"nprobe\":128}")
        .build();
    List results = vectorStore.similaritySearch(request);

This allows greater flexibility when using Milvus-specific search features.

## Importance of `nativeExpression` and `searchParamsJson` in `MilvusSearchRequest`

These two parameters enhance Milvus search precision and ensure optimal query performance:

**nativeExpression**: Enables additional filtering capabilities using Milvus' native filtering expressions. Milvus Filtering

Example:

    MilvusSearchRequest request = MilvusSearchRequest.milvusBuilder()
        .query("sample query")
        .topK(5)
        .nativeExpression("metadata['category'] == 'science'")
        .build();

**searchParamsJson**: Essential for tuning search behavior when using IVF\_FLAT, Milvus' default index. Milvus Vector Index

By default, `IVF_FLAT` requires `nprobe` to be set for accurate results. If not specified, `nprobe` defaults to `1`, which can lead to poor recall or even zero search results.

Example:

    MilvusSearchRequest request = MilvusSearchRequest.milvusBuilder()
        .query("sample query")
        .topK(5)
        .searchParamsJson("{\"nprobe\":128}")
        .build();

Using `nativeExpression` ensures advanced filtering, while `searchParamsJson` prevents ineffective searches caused by a low default `nprobe` value.

## Milvus VectorStore properties

You can use the following properties in your Spring Boot configuration to customize the Milvus vector store.

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 40%" />
<col style="width: 50%" />
<col style="width: 10%" />
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
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.database-name</p></td>
<td class="tableblock halign-left valign-top"><p>The name of the Milvus database to use.</p></td>
<td class="tableblock halign-left valign-top"><p>default</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.collection-name</p></td>
<td class="tableblock halign-left valign-top"><p>Milvus collection name to store the vectors</p></td>
<td class="tableblock halign-left valign-top"><p>vector_store</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.initialize-schema</p></td>
<td class="tableblock halign-left valign-top"><p>whether to initialize Milvus' backend</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.embedding-dimension</p></td>
<td class="tableblock halign-left valign-top"><p>The dimension of the vectors to be stored in the Milvus collection.</p></td>
<td class="tableblock halign-left valign-top"><p>1536</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.index-type</p></td>
<td class="tableblock halign-left valign-top"><p>The type of the index to be created for the Milvus collection.</p></td>
<td class="tableblock halign-left valign-top"><p>IVF_FLAT</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.metric-type</p></td>
<td class="tableblock halign-left valign-top"><p>The metric type to be used for the Milvus collection.</p></td>
<td class="tableblock halign-left valign-top"><p>COSINE</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.index-parameters</p></td>
<td class="tableblock halign-left valign-top"><p>The index parameters to be used for the Milvus collection.</p></td>
<td class="tableblock halign-left valign-top"><p>{"nlist":1024}</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.id-field-name</p></td>
<td class="tableblock halign-left valign-top"><p>The ID field name for the collection</p></td>
<td class="tableblock halign-left valign-top"><p>doc_id</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.auto-id</p></td>
<td class="tableblock halign-left valign-top"><p>Boolean flag to indicate if the auto-id is used for the ID field</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.content-field-name</p></td>
<td class="tableblock halign-left valign-top"><p>The content field name for the collection</p></td>
<td class="tableblock halign-left valign-top"><p>content</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.metadata-field-name</p></td>
<td class="tableblock halign-left valign-top"><p>The metadata field name for the collection</p></td>
<td class="tableblock halign-left valign-top"><p>metadata</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.embedding-field-name</p></td>
<td class="tableblock halign-left valign-top"><p>The embedding field name for the collection</p></td>
<td class="tableblock halign-left valign-top"><p>embedding</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.client.host</p></td>
<td class="tableblock halign-left valign-top"><p>The name or address of the host.</p></td>
<td class="tableblock halign-left valign-top"><p>localhost</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.client.port</p></td>
<td class="tableblock halign-left valign-top"><p>The connection port.</p></td>
<td class="tableblock halign-left valign-top"><p>19530</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.client.uri</p></td>
<td class="tableblock halign-left valign-top"><p>The uri of Milvus instance</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.client.token</p></td>
<td class="tableblock halign-left valign-top"><p>Token serving as the key for identification and authentication purposes.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.client.connect-timeout-ms</p></td>
<td class="tableblock halign-left valign-top"><p>Connection timeout value of client channel. The timeout value must be greater than zero .</p></td>
<td class="tableblock halign-left valign-top"><p>10000</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.client.keep-alive-time-ms</p></td>
<td class="tableblock halign-left valign-top"><p>Keep-alive time value of client channel. The keep-alive value must be greater than zero.</p></td>
<td class="tableblock halign-left valign-top"><p>55000</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.client.keep-alive-timeout-ms</p></td>
<td class="tableblock halign-left valign-top"><p>The keep-alive timeout value of client channel. The timeout value must be greater than zero.</p></td>
<td class="tableblock halign-left valign-top"><p>20000</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.client.rpc-deadline-ms</p></td>
<td class="tableblock halign-left valign-top"><p>Deadline for how long you are willing to wait for a reply from the server. With a deadline setting, the client will wait when encounter fast RPC fail caused by network fluctuations. The deadline value must be larger than or equal to zero.</p></td>
<td class="tableblock halign-left valign-top"><p>0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.client.client-key-path</p></td>
<td class="tableblock halign-left valign-top"><p>The client.key path for tls two-way authentication, only takes effect when "secure" is true</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.client.client-pem-path</p></td>
<td class="tableblock halign-left valign-top"><p>The client.pem path for tls two-way authentication, only takes effect when "secure" is true</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.client.ca-pem-path</p></td>
<td class="tableblock halign-left valign-top"><p>The ca.pem path for tls two-way authentication, only takes effect when "secure" is true</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.client.server-pem-path</p></td>
<td class="tableblock halign-left valign-top"><p>server.pem path for tls one-way authentication, only takes effect when "secure" is true.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.client.server-name</p></td>
<td class="tableblock halign-left valign-top"><p>Sets the target name override for SSL host name checking, only takes effect when "secure" is True. Note: this value is passed to grpc.ssl_target_name_override</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.client.secure</p></td>
<td class="tableblock halign-left valign-top"><p>Secure the authorization for this connection, set to True to enable TLS.</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.client.idle-timeout-ms</p></td>
<td class="tableblock halign-left valign-top"><p>Idle timeout value of client channel. The timeout value must be larger than zero.</p></td>
<td class="tableblock halign-left valign-top"><p>24h</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.client.username</p></td>
<td class="tableblock halign-left valign-top"><p>The username and password for this connection.</p></td>
<td class="tableblock halign-left valign-top"><p>root</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vectorstore.milvus.client.password</p></td>
<td class="tableblock halign-left valign-top"><p>The password for this connection.</p></td>
<td class="tableblock halign-left valign-top"><p>milvus</p></td>
</tr>
</tbody>
</table>

## Starting Milvus Store

From within the `src/test/resources/` folder run:

    docker-compose up

To clean the environment:

    docker-compose down; rm -Rf ./volumes

Then connect to the vector store on http://localhost:19530 or for management http://localhost:9001 (user: `minioadmin`, pass: `minioadmin`)

## Troubleshooting

If Docker complains about resources, then execute:

    docker system prune --all --force --volumes

## Accessing the Native Client

The Milvus Vector Store implementation provides access to the underlying native Milvus client (`MilvusServiceClient`) through the `getNativeClient()` method:

    MilvusVectorStore vectorStore = context.getBean(MilvusVectorStore.class);
    Optional<MilvusServiceClient> nativeClient = vectorStore.getNativeClient();

    if (nativeClient.isPresent()) {
        MilvusServiceClient client = nativeClient.get();
        // Use the native client for Milvus-specific operations
    }

The native client gives you access to Milvus-specific features and operations that might not be exposed through the `VectorStore` interface.

MariaDB Vector Store MongoDB Atlas

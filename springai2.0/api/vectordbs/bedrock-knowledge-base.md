Search

# Amazon Bedrock Knowledge Base

This section walks you through setting up the Amazon Bedrock Knowledge Base `VectorStore` to perform similarity searches against a pre-configured Knowledge Base.

Amazon Bedrock Knowledge Bases is a fully managed RAG (Retrieval-Augmented Generation) capability that allows you to connect foundation models to your data sources. Unlike other vector stores, Bedrock Knowledge Base handles document ingestion, chunking, and embedding internally.

## Prerequisites

1.  AWS Account with Bedrock access enabled

2.  A configured Bedrock Knowledge Base with at least one data source synced

3.  AWS credentials configured (via environment variables, AWS config file, or IAM role)

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the Bedrock Knowledge Base Vector Store. To enable it, add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-vector-store-bedrock-knowledgebase</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file:

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-vector-store-bedrock-knowledgebase'
    }

To connect to your Knowledge Base, provide the Knowledge Base ID via Spring Boot’s `application.properties`:

    spring.ai.vectorstore.bedrock-knowledge-base.knowledge-base-id=YOUR_KNOWLEDGE_BASE_ID
    spring.ai.vectorstore.bedrock-knowledge-base.region=us-east-1

Or via environment variables:

    export SPRING_AI_VECTORSTORE_BEDROCK_KNOWLEDGE_BASE_KNOWLEDGE_BASE_ID=YOUR_KNOWLEDGE_BASE_ID

Now you can auto-wire the Vector Store in your application:

    @Autowired VectorStore vectorStore;

    // ...

    // Retrieve documents similar to a query
    List<Document> results = vectorStore.similaritySearch(
        SearchRequest.builder()
            .query("What is the return policy?")
            .topK(5)
            .build());

### Configuration Properties

You can use the following properties in your Spring Boot configuration to customize the Bedrock Knowledge Base vector store.

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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.bedrock-knowledge-base.knowledge-base-id</code></p></td>
<td class="tableblock halign-left valign-top"><p>The ID of the Bedrock Knowledge Base to query</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.bedrock-knowledge-base.region</code></p></td>
<td class="tableblock halign-left valign-top"><p>AWS region for the Bedrock service</p></td>
<td class="tableblock halign-left valign-top"><p>SDK default</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.bedrock-knowledge-base.top-k</code></p></td>
<td class="tableblock halign-left valign-top"><p>Number of results to return</p></td>
<td class="tableblock halign-left valign-top"><p>5</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.bedrock-knowledge-base.similarity-threshold</code></p></td>
<td class="tableblock halign-left valign-top"><p>Minimum similarity score (0.0 to 1.0)</p></td>
<td class="tableblock halign-left valign-top"><p>0.0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.bedrock-knowledge-base.search-type</code></p></td>
<td class="tableblock halign-left valign-top"><p>Search type: SEMANTIC or HYBRID</p></td>
<td class="tableblock halign-left valign-top"><p>null (KB default)</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.bedrock-knowledge-base.reranking-model-arn</code></p></td>
<td class="tableblock halign-left valign-top"><p>ARN of Bedrock reranking model</p></td>
<td class="tableblock halign-left valign-top"><p>null (disabled)</p></td>
</tr>
</tbody>
</table>

## Search Types

Bedrock Knowledge Base supports two search types:

- `SEMANTIC` - Vector similarity search only (default)

- `HYBRID` - Combines semantic search with keyword search

    spring.ai.vectorstore.bedrock-knowledge-base.search-type=HYBRID

## Reranking

You can improve search relevance by enabling a Bedrock reranking model:

    spring.ai.vectorstore.bedrock-knowledge-base.reranking-model-arn=arn:aws:bedrock:us-west-2::foundation-model/amazon.rerank-v1:0

Available reranking models:

- Amazon Rerank 1.0 - Available in us-west-2, ap-northeast-1, ca-central-1, eu-central-1

- Cohere Rerank 3.5 - Requires AWS Marketplace subscription

## Metadata Filtering

You can leverage the generic, portable metadata filters with the Bedrock Knowledge Base store.

For example, you can use the text expression language:

    vectorStore.similaritySearch(
        SearchRequest.builder()
            .query("travel policy")
            .topK(5)
            .similarityThreshold(0.5)
            .filterExpression("department == 'HR' && year >= 2024")
            .build());

or programmatically using the `Filter.Expression` DSL:

    FilterExpressionBuilder b = new FilterExpressionBuilder();

    vectorStore.similaritySearch(
        SearchRequest.builder()
            .query("travel policy")
            .topK(5)
            .filterExpression(b.and(
                b.eq("department", "HR"),
                b.gte("year", 2024)).build())
            .build());

### Supported Filter Operators

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Spring AI</th>
<th class="tableblock halign-left valign-top">Bedrock</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>EQ</p></td>
<td class="tableblock halign-left valign-top"><p>equals</p></td>
<td class="tableblock halign-left valign-top"><p>Equal to</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>NE</p></td>
<td class="tableblock halign-left valign-top"><p>notEquals</p></td>
<td class="tableblock halign-left valign-top"><p>Not equal to</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>GT</p></td>
<td class="tableblock halign-left valign-top"><p>greaterThan</p></td>
<td class="tableblock halign-left valign-top"><p>Greater than</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>GTE</p></td>
<td class="tableblock halign-left valign-top"><p>greaterThanOrEquals</p></td>
<td class="tableblock halign-left valign-top"><p>Greater than or equal</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>LT</p></td>
<td class="tableblock halign-left valign-top"><p>lessThan</p></td>
<td class="tableblock halign-left valign-top"><p>Less than</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>LTE</p></td>
<td class="tableblock halign-left valign-top"><p>lessThanOrEquals</p></td>
<td class="tableblock halign-left valign-top"><p>Less than or equal</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>IN</p></td>
<td class="tableblock halign-left valign-top"><p>in</p></td>
<td class="tableblock halign-left valign-top"><p>Value in list</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>NIN</p></td>
<td class="tableblock halign-left valign-top"><p>notIn</p></td>
<td class="tableblock halign-left valign-top"><p>Value not in list</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>AND</p></td>
<td class="tableblock halign-left valign-top"><p>andAll</p></td>
<td class="tableblock halign-left valign-top"><p>Logical AND</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>OR</p></td>
<td class="tableblock halign-left valign-top"><p>orAll</p></td>
<td class="tableblock halign-left valign-top"><p>Logical OR</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>NOT</p></td>
<td class="tableblock halign-left valign-top"><p>(negation)</p></td>
<td class="tableblock halign-left valign-top"><p>Logical NOT</p></td>
</tr>
</tbody>
</table>

## Manual Configuration

If you prefer to configure the vector store manually, you can do so by creating the beans directly.

Add this dependency to your project:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-bedrock-knowledgebase-store</artifactId>
    </dependency>

### Sample Code

    @Bean
    public BedrockAgentRuntimeClient bedrockAgentRuntimeClient() {
        return BedrockAgentRuntimeClient.builder()
            .region(Region.US_EAST_1)
            .build();
    }

    @Bean
    public VectorStore vectorStore(BedrockAgentRuntimeClient client) {
        return BedrockKnowledgeBaseVectorStore.builder(client, "YOUR_KNOWLEDGE_BASE_ID")
            .topK(10)
            .similarityThreshold(0.5)
            .searchType(SearchType.SEMANTIC)
            .build();
    }

Then use the vector store:

    List<Document> results = vectorStore.similaritySearch(
        SearchRequest.builder()
            .query("What are the company holidays?")
            .topK(3)
            .build());

    for (Document doc : results) {
        System.out.println("Content: " + doc.getText());
        System.out.println("Score: " + doc.getScore());
        System.out.println("Source: " + doc.getMetadata().get("source"));
    }

## Accessing the Native Client

The Bedrock Knowledge Base Vector Store provides access to the underlying native client through the `getNativeClient()` method:

    BedrockKnowledgeBaseVectorStore vectorStore = context.getBean(BedrockKnowledgeBaseVectorStore.class);
    Optional<BedrockAgentRuntimeClient> nativeClient = vectorStore.getNativeClient();

    if (nativeClient.isPresent()) {
        BedrockAgentRuntimeClient client = nativeClient.get();
        // Use the native client for Bedrock-specific operations
    }

## Limitations

- **Read-only**: The `add()` and `delete()` methods throw `UnsupportedOperationException`. Documents are managed through the Knowledge Base’s data source sync process.

- **HYBRID search**: Only available with OpenSearch-based vector stores.

- **Reranking availability**: Model availability varies by AWS region.

## Supported Data Sources

Bedrock Knowledge Base supports multiple data source types. The source location is included in document metadata:

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Data Source</th>
<th class="tableblock halign-left valign-top">Metadata Field</th>
<th class="tableblock halign-left valign-top">Example</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>S3</p></td>
<td class="tableblock halign-left valign-top"><p><code>source</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>s3://bucket/path/document.pdf</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Confluence</p></td>
<td class="tableblock halign-left valign-top"><p><code>source</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>confluence.example.com/page/123</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>SharePoint</p></td>
<td class="tableblock halign-left valign-top"><p><code>source</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>sharepoint.example.com/doc/456</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Salesforce</p></td>
<td class="tableblock halign-left valign-top"><p><code>source</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>salesforce.example.com/record/789</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Web Crawler</p></td>
<td class="tableblock halign-left valign-top"><p><code>source</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>example.com/page</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Custom</p></td>
<td class="tableblock halign-left valign-top"><p><code>source</code></p></td>
<td class="tableblock halign-left valign-top"><p>Custom document ID</p></td>
</tr>
</tbody>
</table>

Azure Cosmos DB Apache Cassandra Vector Store

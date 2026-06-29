Search

# Azure AI Service

This section will walk you through setting up the `AzureVectorStore` to store document embeddings and perform similarity searches using the Azure AI Search Service.

Azure AI Search is a versatile cloud-hosted cloud information retrieval system that is part of Microsoft’s larger AI platform. Among other features, it allows users to query information using vector-based storage and retrieval.

## Prerequisites

1.  Azure Subscription: You will need an Azure subscription to use any Azure service.

2.  Azure AI Search Service: Create an AI Search service. Once the service is created, obtain the admin apiKey from the `Keys` section under `Settings` and retrieve the endpoint from the `Url` field under the `Overview` section.

3.  (Optional) Azure OpenAI Service: Create an Azure OpenAI service. **NOTE:** You may have to fill out a separate form to gain access to Azure Open AI services. Once the service is created, obtain the endpoint and apiKey from the `Keys and Endpoint` section under `Resource Management`.

## Configuration

On startup, the `AzureVectorStore` can attempt to create a new index within your AI Search service instance if you’ve opted in by setting the relevant `initialize-schema` `boolean` property to `true` in the constructor or, if using Spring Boot, setting `…​initialize-schema=true` in your `application.properties` file.

Alternatively, you can create the index manually.

To set up an AzureVectorStore, you will need the settings retrieved from the prerequisites above along with your index name:

- Azure AI Search Endpoint

- Azure AI Search Key

- (optional) Azure OpenAI API Endpoint

- (optional) Azure OpenAI API Key

You can provide these values as OS environment variables.

    export AZURE_AI_SEARCH_API_KEY=<My AI Search API Key>
    export AZURE_AI_SEARCH_ENDPOINT=<My AI Search Index>
    export OPENAI_API_KEY=<My Azure AI API Key> (Optional)

## Dependencies

Add these dependencies to your project:

### 1. Select an Embeddings interface implementation. You can choose between:

### 2. Azure (AI Search) Vector Store

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-azure-store</artifactId>
    </dependency>

## Configuration Properties

You can use the following properties in your Spring Boot configuration to customize the Azure vector store.

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Property</th>
<th class="tableblock halign-left valign-top">Default value</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.azure.url</code></p></td>
<td class="tableblock halign-left valign-top"></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.azure.api-key</code></p></td>
<td class="tableblock halign-left valign-top"></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.azure.use-keyless-auth</code></p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.azure.initialize-schema</code></p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.azure.index-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>spring_ai_azure_vector_store</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.azure.default-top-k</code></p></td>
<td class="tableblock halign-left valign-top"><p>4</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.azure.default-similarity-threshold</code></p></td>
<td class="tableblock halign-left valign-top"><p>0.0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.azure.content-field-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>content</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.azure.embedding-field-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>embedding</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.azure.metadata-field-name</code></p></td>
<td class="tableblock halign-left valign-top"><p>metadata</p></td>
</tr>
</tbody>
</table>

## Sample Code

To configure an Azure `SearchIndexClient` in your application, you can use the following code:

    @Bean
    public SearchIndexClient searchIndexClient() {
      return new SearchIndexClientBuilder().endpoint(System.getenv("AZURE_AI_SEARCH_ENDPOINT"))
        .credential(new AzureKeyCredential(System.getenv("AZURE_AI_SEARCH_API_KEY")))
        .buildClient();
    }

To create a vector store, you can use the following code by injecting the `SearchIndexClient` bean created in the above sample along with an `EmbeddingModel` provided by the Spring AI library that implements the desired Embeddings interface.

    @Bean
    public VectorStore vectorStore(SearchIndexClient searchIndexClient, EmbeddingModel embeddingModel) {

      return AzureVectorStore.builder(searchIndexClient, embeddingModel)
        .initializeSchema(true)
        // Define the metadata fields to be used
        // in the similarity search filters.
        .filterMetadataFields(List.of(MetadataField.text("country"), MetadataField.int64("year"),
                MetadataField.date("activationDate")))
        .defaultTopK(5)
        .defaultSimilarityThreshold(0.7)
        .indexName("spring-ai-document-index")
        .build();
    }

In your main code, create some documents:

    List<Document> documents = List.of(
        new Document("Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!! Spring AI rocks!!", Map.of("country", "BG", "year", 2020)),
        new Document("The World is Big and Salvation Lurks Around the Corner"),
        new Document("You walk forward facing the past and you turn back toward the future.", Map.of("country", "NL", "year", 2023)));

Add the documents to your vector store:

    vectorStore.add(documents);

And finally, retrieve documents similar to a query:

    List<Document> results = vectorStore.similaritySearch(
        SearchRequest.builder()
          .query("Spring")
          .topK(5).build());

If all goes well, you should retrieve the document containing the text "Spring AI rocks!!".

### Metadata filtering

You can leverage the generic, portable metadata filters with AzureVectorStore as well.

For example, you can use either the text expression language:

    vectorStore.similaritySearch(
       SearchRequest.builder()
          .query("The World")
          .topK(TOP_K)
          .similarityThreshold(SIMILARITY_THRESHOLD)
          .filterExpression("country in ['UK', 'NL'] && year >= 2020").build());

or programmatically using the expression DSL:

    FilterExpressionBuilder b = new FilterExpressionBuilder();

    vectorStore.similaritySearch(
        SearchRequest.builder()
          .query("The World")
          .topK(TOP_K)
          .similarityThreshold(SIMILARITY_THRESHOLD)
          .filterExpression(b.and(
             b.in("country", "UK", "NL"),
             b.gte("year", 2020)).build()).build());

The portable filter expressions get automatically converted into the proprietary Azure Search OData filters. For example, the following portable filter expression:

    country in ['UK', 'NL'] && year >= 2020

is converted into the following Azure OData filter expression:

    $filter search.in(meta_country, 'UK,NL', ',') and meta_year ge 2020

## Custom Field Names

By default, the Azure Vector Store uses the following field names in the Azure AI Search index:

- `content` - for document text

- `embedding` - for vector embeddings

- `metadata` - for document metadata

However, when working with existing Azure AI Search indexes that use different field names, you can configure custom field names to match your index schema. This allows you to integrate Spring AI with pre-existing indexes without needing to modify them.

### Use Cases

Custom field names are particularly useful when:

- **Integrating with existing indexes**: Your organization already has Azure AI Search indexes with established field naming conventions (e.g., `chunk_text`, `vector`, `meta_data`).

- **Following naming standards**: Your team follows specific naming conventions that differ from the defaults.

- **Migrating from other systems**: You’re migrating from another vector database or search system and want to maintain consistent field names.

### Configuration via Properties

You can configure custom field names using Spring Boot application properties:

    spring.ai.vectorstore.azure.url=${AZURE_AI_SEARCH_ENDPOINT}
    spring.ai.vectorstore.azure.api-key=${AZURE_AI_SEARCH_API_KEY}
    spring.ai.vectorstore.azure.index-name=my-existing-index
    spring.ai.vectorstore.azure.initialize-schema=false

    # Custom field names to match existing index schema
    spring.ai.vectorstore.azure.content-field-name=chunk_text
    spring.ai.vectorstore.azure.embedding-field-name=vector
    spring.ai.vectorstore.azure.metadata-field-name=meta_data

### Configuration via Builder API

Alternatively, you can configure custom field names programmatically using the builder API:

    @Bean
    public VectorStore vectorStore(SearchIndexClient searchIndexClient, EmbeddingModel embeddingModel) {

        return AzureVectorStore.builder(searchIndexClient, embeddingModel)
            .indexName("my-existing-index")
            .initializeSchema(false) // Don't create schema - use existing index
            // Configure custom field names to match existing index
            .contentFieldName("chunk_text")
            .embeddingFieldName("vector")
            .metadataFieldName("meta_data")
            .filterMetadataFields(List.of(
                MetadataField.text("category"),
                MetadataField.text("source")))
            .build();
    }

### Complete Example: Working with Existing Index

Here’s a complete example showing how to use Spring AI with an existing Azure AI Search index that has custom field names:

    @Configuration
    public class VectorStoreConfig {

        @Bean
        public SearchIndexClient searchIndexClient() {
            return new SearchIndexClientBuilder()
                .endpoint(System.getenv("AZURE_AI_SEARCH_ENDPOINT"))
                .credential(new AzureKeyCredential(System.getenv("AZURE_AI_SEARCH_API_KEY")))
                .buildClient();
        }

        @Bean
        public VectorStore vectorStore(SearchIndexClient searchIndexClient,
                EmbeddingModel embeddingModel) {

            return AzureVectorStore.builder(searchIndexClient, embeddingModel)
                .indexName("production-documents-index")
                .initializeSchema(false) // Use existing index
                // Map to existing index field names
                .contentFieldName("document_text")
                .embeddingFieldName("text_vector")
                .metadataFieldName("document_metadata")
                // Define filterable metadata fields from existing schema
                .filterMetadataFields(List.of(
                    MetadataField.text("department"),
                    MetadataField.int64("year"),
                    MetadataField.date("created_date")))
                .defaultTopK(10)
                .defaultSimilarityThreshold(0.75)
                .build();
        }
    }

You can then use the vector store as normal:

    // Search using the existing index with custom field names
    List<Document> results = vectorStore.similaritySearch(
        SearchRequest.builder()
            .query("artificial intelligence")
            .topK(5)
            .filterExpression("department == 'Engineering' && year >= 2023")
            .build());

    // The results contain documents with text from the 'document_text' field
    results.forEach(doc -> System.out.println(doc.getText()));

### Creating New Index with Custom Field Names

You can also create a new index with custom field names by setting `initializeSchema=true`:

    @Bean
    public VectorStore vectorStore(SearchIndexClient searchIndexClient,
            EmbeddingModel embeddingModel) {

        return AzureVectorStore.builder(searchIndexClient, embeddingModel)
            .indexName("new-custom-index")
            .initializeSchema(true) // Create new index with custom field names
            .contentFieldName("text_content")
            .embeddingFieldName("content_vector")
            .metadataFieldName("doc_metadata")
            .filterMetadataFields(List.of(
                MetadataField.text("category"),
                MetadataField.text("author")))
            .build();
    }

This will create a new Azure AI Search index with your custom field names, allowing you to establish your own naming conventions from the start.

## Accessing the Native Client

The Azure Vector Store implementation provides access to the underlying native Azure Search client (`SearchClient`) through the `getNativeClient()` method:

    AzureVectorStore vectorStore = context.getBean(AzureVectorStore.class);
    Optional<SearchClient> nativeClient = vectorStore.getNativeClient();

    if (nativeClient.isPresent()) {
        SearchClient client = nativeClient.get();
        // Use the native client for Azure Search-specific operations
    }

The native client gives you access to Azure Search-specific features and operations that might not be exposed through the `VectorStore` interface.

Vector Databases Azure Cosmos DB

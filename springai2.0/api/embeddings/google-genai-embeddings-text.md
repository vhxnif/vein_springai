Search

# Google GenAI Text Embeddings

The Google GenAI Embeddings API provides text embedding generation using Google’s embedding models through either the Gemini Developer API or Vertex AI. This document describes how to create text embeddings using the Google GenAI Text embeddings API.

Google GenAI text embeddings API uses dense vector representations. Unlike sparse vectors, which tend to directly map words to numbers, dense vectors are designed to better represent the meaning of a piece of text. The benefit of using dense vector embeddings in generative AI is that instead of searching for direct word or syntax matches, you can better search for passages that align to the meaning of the query, even if the passages don’t use the same language.

This implementation provides two authentication modes:

- **Gemini Developer API**: Use an API key for quick prototyping and development

- **Vertex AI**: Use Google Cloud credentials for production deployments with enterprise features

## Prerequisites

Choose one of the following authentication methods:

### Option 1: Gemini Developer API (API Key)

- Obtain an API key from the Google AI Studio

- Set the API key as an environment variable or in your application properties

### Option 2: Vertex AI (Google Cloud)

- Install the gcloud CLI, appropriate for your OS.

- Authenticate by running the following command. Replace `PROJECT_ID` with your Google Cloud project ID and `ACCOUNT` with your Google Cloud username.

    gcloud config set project <PROJECT_ID> &&
    gcloud auth application-default login <ACCOUNT>

### Add Repositories and BOM

Spring AI artifacts are published in Maven Central and Spring Snapshot repositories. Refer to the Artifact Repositories section to add these repositories to your build system.

To help with dependency management, Spring AI provides a BOM (bill of materials) to ensure that a consistent version of Spring AI is used throughout the entire project. Refer to the Dependency Management section to add the Spring AI BOM to your build system.

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the Google GenAI Embedding Model. To enable it add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-google-genai-embedding</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-model-google-genai-embedding'
    }

### Embedding Properties

#### Connection Properties

The prefix `spring.ai.google.genai.embedding` is used as the property prefix that lets you connect to Google GenAI Embedding API.

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 33%" />
<col style="width: 55%" />
<col style="width: 11%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Property</th>
<th class="tableblock halign-left valign-top">Description</th>
<th class="tableblock halign-left valign-top">Default</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.embedding.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>API key for Gemini Developer API. When provided, the client uses the Gemini Developer API instead of Vertex AI.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.embedding.project-id</p></td>
<td class="tableblock halign-left valign-top"><p>Google Cloud Platform project ID (required for Vertex AI mode)</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.embedding.location</p></td>
<td class="tableblock halign-left valign-top"><p>Google Cloud region (required for Vertex AI mode)</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.embedding.credentials-uri</p></td>
<td class="tableblock halign-left valign-top"><p>URI to Google Cloud credentials. When provided it is used to create a <code>GoogleCredentials</code> instance for authentication.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

#### Text Embedding Properties

The prefix `spring.ai.google.genai.embedding.text` is the property prefix that lets you configure the embedding model implementation for Google GenAI Text Embedding.

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 33%" />
<col style="width: 55%" />
<col style="width: 11%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Property</th>
<th class="tableblock halign-left valign-top">Description</th>
<th class="tableblock halign-left valign-top">Default</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.model.embedding.text</p></td>
<td class="tableblock halign-left valign-top"><p>Enable Google GenAI Embedding API model.</p></td>
<td class="tableblock halign-left valign-top"><p>google-genai</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.embedding.text.model</p></td>
<td class="tableblock halign-left valign-top"><p>The Google GenAI Text Embedding model to use. Supported models include <code>text-embedding-004</code> and <code>text-multilingual-embedding-002</code></p></td>
<td class="tableblock halign-left valign-top"><p>text-embedding-004</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.embedding.text.task-type</p></td>
<td class="tableblock halign-left valign-top"><p>The intended downstream application to help the model produce better quality embeddings. Available task-types: <code>RETRIEVAL_QUERY</code>, <code>RETRIEVAL_DOCUMENT</code>, <code>SEMANTIC_SIMILARITY</code>, <code>CLASSIFICATION</code>, <code>CLUSTERING</code>, <code>QUESTION_ANSWERING</code>, <code>FACT_VERIFICATION</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>RETRIEVAL_DOCUMENT</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.embedding.text.title</p></td>
<td class="tableblock halign-left valign-top"><p>Optional title, only valid with task_type=RETRIEVAL_DOCUMENT.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.embedding.text.dimensions</p></td>
<td class="tableblock halign-left valign-top"><p>The number of dimensions the resulting output embeddings should have. Supported for model version 004 and later. You can use this parameter to reduce the embedding size, for example, for storage optimization.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.embedding.text.auto-truncate</p></td>
<td class="tableblock halign-left valign-top"><p>When set to true, input text will be truncated. When set to false, an error is returned if the input text is longer than the maximum length supported by the model.</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
</tbody>
</table>

## Sample Controller

Create a new Spring Boot project and add the `spring-ai-starter-model-google-genai-embedding` to your pom (or gradle) dependencies.

Add a `application.properties` file, under the `src/main/resources` directory, to enable and configure the Google GenAI embedding model:

### Using Gemini Developer API (API Key)

    spring.ai.google.genai.embedding.api-key=YOUR_API_KEY
    spring.ai.google.genai.embedding.text.model=text-embedding-004

### Using Vertex AI

    spring.ai.google.genai.embedding.project-id=YOUR_PROJECT_ID
    spring.ai.google.genai.embedding.location=YOUR_PROJECT_LOCATION
    spring.ai.google.genai.embedding.text.model=text-embedding-004

This will create a `GoogleGenAiTextEmbeddingModel` implementation that you can inject into your class. Here is an example of a simple `@Controller` class that uses the embedding model for embeddings generations.

    @RestController
    public class EmbeddingController {

        private final EmbeddingModel embeddingModel;

        @Autowired
        public EmbeddingController(EmbeddingModel embeddingModel) {
            this.embeddingModel = embeddingModel;
        }

        @GetMapping("/ai/embedding")
        public Map embed(@RequestParam(value = "message", defaultValue = "Tell me a joke") String message) {
            EmbeddingResponse embeddingResponse = this.embeddingModel.embedForResponse(List.of(message));
            return Map.of("embedding", embeddingResponse);
        }
    }

## Manual Configuration

The GoogleGenAiTextEmbeddingModel implements the `EmbeddingModel`.

Add the `spring-ai-google-genai-embedding` dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-google-genai-embedding</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-google-genai-embedding'
    }

Next, create a `GoogleGenAiTextEmbeddingModel` and use it for text embeddings:

### Using API Key

    GoogleGenAiEmbeddingConnectionDetails connectionDetails =
        GoogleGenAiEmbeddingConnectionDetails.builder()
            .apiKey(System.getenv("GOOGLE_API_KEY"))
            .build();

    GoogleGenAiTextEmbeddingOptions options = GoogleGenAiTextEmbeddingOptions.builder()
        .model(GoogleGenAiTextEmbeddingOptions.DEFAULT_MODEL_NAME)
        .taskType(TaskType.RETRIEVAL_DOCUMENT)
        .build();

    var embeddingModel = new GoogleGenAiTextEmbeddingModel(connectionDetails, options);

    EmbeddingResponse embeddingResponse = embeddingModel
        .embedForResponse(List.of("Hello World", "World is big and salvation is near"));

### Using Vertex AI

    GoogleGenAiEmbeddingConnectionDetails connectionDetails =
        GoogleGenAiEmbeddingConnectionDetails.builder()
            .projectId(System.getenv("GOOGLE_CLOUD_PROJECT"))
            .location(System.getenv("GOOGLE_CLOUD_LOCATION"))
            .build();

    GoogleGenAiTextEmbeddingOptions options = GoogleGenAiTextEmbeddingOptions.builder()
        .model(GoogleGenAiTextEmbeddingOptions.DEFAULT_MODEL_NAME)
        .taskType(TaskType.RETRIEVAL_DOCUMENT)
        .build();

    var embeddingModel = new GoogleGenAiTextEmbeddingModel(connectionDetails, options);

    EmbeddingResponse embeddingResponse = embeddingModel
        .embedForResponse(List.of("Hello World", "World is big and salvation is near"));

## Task Types

The Google GenAI embeddings API supports different task types to optimize embeddings for specific use cases:

- `RETRIEVAL_QUERY`: Optimized for search queries in retrieval systems

- `RETRIEVAL_DOCUMENT`: Optimized for documents in retrieval systems

- `SEMANTIC_SIMILARITY`: Optimized for measuring semantic similarity between texts

- `CLASSIFICATION`: Optimized for text classification tasks

- `CLUSTERING`: Optimized for clustering similar texts

- `QUESTION_ANSWERING`: Optimized for question-answering systems

- `FACT_VERIFICATION`: Optimized for fact verification tasks

Example of using different task types:

    // For indexing documents
    GoogleGenAiTextEmbeddingOptions docOptions = GoogleGenAiTextEmbeddingOptions.builder()
        .model("text-embedding-004")
        .taskType(TaskType.RETRIEVAL_DOCUMENT)
        .title("Product Documentation")  // Optional title for documents
        .build();

    // For search queries
    GoogleGenAiTextEmbeddingOptions queryOptions = GoogleGenAiTextEmbeddingOptions.builder()
        .model("text-embedding-004")
        .taskType(TaskType.RETRIEVAL_QUERY)
        .build();

## Dimension Reduction

For model version 004 and later, you can reduce the embedding dimensions for storage optimization:

    GoogleGenAiTextEmbeddingOptions options = GoogleGenAiTextEmbeddingOptions.builder()
        .model("text-embedding-004")
        .dimensions(256)  // Reduce from default 768 to 256 dimensions
        .build();

## Migration from Vertex AI Text Embeddings

If you’re currently using the Vertex AI Text Embeddings implementation (`spring-ai-vertex-ai-embedding`), you can migrate to Google GenAI with minimal changes:

Key Differences:

1.  **SDK**: Google GenAI uses the new `com.google.genai.Client` instead of Vertex AI SDK

2.  **Authentication**: Supports both API key and Google Cloud credentials (Vertex AI mode)

3.  **Package Names**: Classes are in `org.springframework.ai.google.genai.text` instead of `org.springframework.ai.vertexai.embedding`

4.  **Property Prefix**: Uses `spring.ai.google.genai.embedding` instead of `spring.ai.vertex.ai.embedding`

5.  **Connection Details**: Uses `GoogleGenAiEmbeddingConnectionDetails` instead of `VertexAiEmbeddingConnectionDetails`

Google GenAI supports both quick prototyping with API keys and production deployments using Vertex AI through Google Cloud credentials.

Azure OpenAI Mistral AI

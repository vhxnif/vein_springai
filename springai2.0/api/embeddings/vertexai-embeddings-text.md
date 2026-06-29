Search

# Google VertexAI Text Embeddings

Vertex AI supports two types of embeddings models, text and multimodal. This document describes how to create a text embedding using the Vertex AI Text embeddings API.

Vertex AI text embeddings API uses dense vector representations. Unlike sparse vectors, which tend to directly map words to numbers, dense vectors are designed to better represent the meaning of a piece of text. The benefit of using dense vector embeddings in generative AI is that instead of searching for direct word or syntax matches, you can better search for passages that align to the meaning of the query, even if the passages don’t use the same language.

## Prerequisites

- Install the gcloud CLI, appropriate for you OS.

- Authenticate by running the following command. Replace `PROJECT_ID` with your Google Cloud project ID and `ACCOUNT` with your Google Cloud username.

    gcloud config set project <PROJECT_ID> &&
    gcloud auth application-default login <ACCOUNT>

### Add Repositories and BOM

Spring AI artifacts are published in Maven Central and Spring Snapshot repositories. Refer to the Artifact Repositories section to add these repositories to your build system.

To help with dependency management, Spring AI provides a BOM (bill of materials) to ensure that a consistent version of Spring AI is used throughout the entire project. Refer to the Dependency Management section to add the Spring AI BOM to your build system.

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the VertexAI Embedding Model. To enable it add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-vertex-ai-embedding</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-model-vertex-ai-embedding'
    }

### Embedding Properties

The prefix `spring.ai.vertex.ai.embedding` is used as the property prefix that lets you connect to VertexAI Embedding API.

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
<td class="tableblock halign-left valign-top"><p>spring.ai.vertex.ai.embedding.project-id</p></td>
<td class="tableblock halign-left valign-top"><p>Google Cloud Platform project ID</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vertex.ai.embedding.location</p></td>
<td class="tableblock halign-left valign-top"><p>Region</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vertex.ai.embedding.api-endpoint</p></td>
<td class="tableblock halign-left valign-top"><p>Vertex AI Embedding API endpoint.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

The prefix `spring.ai.vertex.ai.embedding.text` is the property prefix that lets you configure the embedding model implementation for VertexAI Text Embedding.

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
<td class="tableblock halign-left valign-top"><p>spring.ai.vertex.ai.embedding.text.enabled (Removed and no longer valid)</p></td>
<td class="tableblock halign-left valign-top"><p>Enable Vertex AI Embedding API model.</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.model.embedding.text</p></td>
<td class="tableblock halign-left valign-top"><p>Enable Vertex AI Embedding API model.</p></td>
<td class="tableblock halign-left valign-top"><p>vertexai</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vertex.ai.embedding.text.model</p></td>
<td class="tableblock halign-left valign-top"><p>This is the Vertex Text Embedding model to use</p></td>
<td class="tableblock halign-left valign-top"><p>text-embedding-004</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vertex.ai.embedding.text.task-type</p></td>
<td class="tableblock halign-left valign-top"><p>The intended downstream application to help the model produce better quality embeddings. Available task-types</p></td>
<td class="tableblock halign-left valign-top"><p><code>RETRIEVAL_DOCUMENT</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vertex.ai.embedding.text.title</p></td>
<td class="tableblock halign-left valign-top"><p>Optional title, only valid with task_type=RETRIEVAL_DOCUMENT.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vertex.ai.embedding.text.dimensions</p></td>
<td class="tableblock halign-left valign-top"><p>The number of dimensions the resulting output embeddings should have. Supported for model version 004 and later. You can use this parameter to reduce the embedding size, for example, for storage optimization.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vertex.ai.embedding.text.auto-truncate</p></td>
<td class="tableblock halign-left valign-top"><p>When set to true, input text will be truncated. When set to false, an error is returned if the input text is longer than the maximum length supported by the model.</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
</tbody>
</table>

## Sample Controller

Create a new Spring Boot project and add the `spring-ai-starter-model-vertex-ai-embedding` to your pom (or gradle) dependencies.

Add a `application.properties` file, under the `src/main/resources` directory, to enable and configure the VertexAi chat model:

    spring.ai.vertex.ai.embedding.project-id=<YOUR_PROJECT_ID>
    spring.ai.vertex.ai.embedding.location=<YOUR_PROJECT_LOCATION>
    spring.ai.vertex.ai.embedding.text.model=text-embedding-004

This will create a `VertexAiTextEmbeddingModel` implementation that you can inject into your class. Here is an example of a simple `@Controller` class that uses the embedding model for embeddings generations.

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

The VertexAiTextEmbeddingModel implements the `EmbeddingModel`.

Add the `spring-ai-vertex-ai-embedding` dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-vertex-ai-embedding</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-vertex-ai-embedding'
    }

Next, create a `VertexAiTextEmbeddingModel` and use it for text generations:

    VertexAiEmbeddingConnectionDetails connectionDetails =
        VertexAiEmbeddingConnectionDetails.builder()
            .projectId(System.getenv(<VERTEX_AI_GEMINI_PROJECT_ID>))
            .location(System.getenv(<VERTEX_AI_GEMINI_LOCATION>))
            .build();

    VertexAiTextEmbeddingOptions options = VertexAiTextEmbeddingOptions.builder()
        .model(VertexAiTextEmbeddingOptions.DEFAULT_MODEL_NAME)
        .build();

    var embeddingModel = new VertexAiTextEmbeddingModel(this.connectionDetails, this.options);

    EmbeddingResponse embeddingResponse = this.embeddingModel
        .embedForResponse(List.of("Hello World", "World is big and salvation is near"));

### Load credentials from a Google Service Account

To programmatically load the GoogleCredentials from a Service Account json file, you can use the following:

    GoogleCredentials credentials = GoogleCredentials.fromStream(<INPUT_STREAM_TO_CREDENTIALS_JSON>)
            .createScoped("https://www.googleapis.com/auth/cloud-platform");
    credentials.refreshIfExpired();

    VertexAiEmbeddingConnectionDetails connectionDetails =
        VertexAiEmbeddingConnectionDetails.builder()
            .projectId(System.getenv(<VERTEX_AI_GEMINI_PROJECT_ID>))
            .location(System.getenv(<VERTEX_AI_GEMINI_LOCATION>))
            .apiEndpoint(endpoint)
            .predictionServiceSettings(
                PredictionServiceSettings.newBuilder()
                    .setEndpoint(endpoint)
                    .setCredentialsProvider(FixedCredentialsProvider.create(credentials))
                    .build());

PostgresML Multimodal Embedding

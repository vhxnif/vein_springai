Search

# Google VertexAI Multimodal Embeddings

Vertex AI supports two types of embeddings models, text and multimodal. This document describes how to create a multimodal embedding using the Vertex AI Multimodal embeddings API.

The multimodal embeddings model generates 1408-dimension vectors based on the input you provide, which can include a combination of image, text, and video data. The embedding vectors can then be used for subsequent tasks like image classification or video content moderation.

The image embedding vector and text embedding vector are in the same semantic space with the same dimensionality. Consequently, these vectors can be used interchangeably for use cases like searching image by text, or searching video by image.

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

The prefix `spring.ai.vertex.ai.embedding.multimodal` is the property prefix that lets you configure the embedding model implementation for VertexAI Multimodal Embedding.

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
<td class="tableblock halign-left valign-top"><p>spring.ai.vertex.ai.embedding.multimodal.enabled (Removed and no longer valid)</p></td>
<td class="tableblock halign-left valign-top"><p>Enable Vertex AI Embedding API model.</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.model.embedding.multimodal=vertexai</p></td>
<td class="tableblock halign-left valign-top"><p>Enable Vertex AI Embedding API model.</p></td>
<td class="tableblock halign-left valign-top"><p>vertexai</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vertex.ai.embedding.multimodal.model</p></td>
<td class="tableblock halign-left valign-top"><p>You can get multimodal embeddings by using the following model:</p></td>
<td class="tableblock halign-left valign-top"><p>multimodalembedding@001</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vertex.ai.embedding.multimodal.dimensions</p></td>
<td class="tableblock halign-left valign-top"><p>Specify lower-dimension embeddings. By default, an embedding request returns a 1408 float vector for a data type. You can also specify lower-dimension embeddings (128, 256, or 512 float vectors) for text and image data.</p></td>
<td class="tableblock halign-left valign-top"><p>1408</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vertex.ai.embedding.multimodal.video-start-offset-sec</p></td>
<td class="tableblock halign-left valign-top"><p>The start offset of the video segment in seconds. If not specified, it’s calculated with max(0, endOffsetSec - 120).</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vertex.ai.embedding.multimodal.video-end-offset-sec</p></td>
<td class="tableblock halign-left valign-top"><p>The end offset of the video segment in seconds. If not specified, it’s calculated with min(video length, startOffSec + 120). If both startOffSec and endOffSec are specified, endOffsetSec is adjusted to min(startOffsetSec+120, endOffsetSec).</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.vertex.ai.embedding.multimodal.video-interval-sec</p></td>
<td class="tableblock halign-left valign-top"><p>The interval of the video the embedding will be generated. The minimum value for interval_sec is 4. If the interval is less than 4, an InvalidArgumentError is returned. There are no limitations on the maximum value of the interval. However, if the interval is larger than min(video length, 120s), it impacts the quality of the generated embeddings. Default value: 16.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

## Manual Configuration

The VertexAiMultimodalEmbeddingModel implements the `DocumentEmbeddingModel`.

Add the `spring-ai-vertex-ai-embedding` dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-vertex-ai-embedding</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-vertex-ai-embedding'
    }

Next, create a `VertexAiMultimodalEmbeddingModel` and use it for embeddings generations:

    VertexAiEmbeddingConnectionDetails connectionDetails =
        VertexAiEmbeddingConnectionDetails.builder()
            .projectId(System.getenv(<VERTEX_AI_GEMINI_PROJECT_ID>))
            .location(System.getenv(<VERTEX_AI_GEMINI_LOCATION>))
            .build();

    VertexAiMultimodalEmbeddingOptions options = VertexAiMultimodalEmbeddingOptions.builder()
        .model(VertexAiMultimodalEmbeddingOptions.DEFAULT_MODEL_NAME)
        .build();

    var embeddingModel = new VertexAiMultimodalEmbeddingModel(this.connectionDetails, this.options);

    Media imageMedial = new Media(MimeTypeUtils.IMAGE_PNG, new ClassPathResource("/test.image.png"));
    Media videoMedial = new Media(new MimeType("video", "mp4"), new ClassPathResource("/test.video.mp4"));

    var document = new Document("Explain what do you see on this video?", List.of(this.imageMedial, this.videoMedial), Map.of());

    EmbeddingResponse embeddingResponse = this.embeddingModel
        .embedForResponse(List.of("Hello World", "World is big and salvation is near"));

    DocumentEmbeddingRequest embeddingRequest = new DocumentEmbeddingRequest(List.of(this.document),
            EmbeddingOptions.EMPTY);

    EmbeddingResponse embeddingResponse = multiModelEmbeddingModel.call(this.embeddingRequest);

    assertThat(embeddingResponse.getResults()).hasSize(3);

Text Embedding Image Models

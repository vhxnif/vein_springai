Search

# Mistral AI Embeddings

Spring AI supports the Mistral AI’s text embeddings models. Embeddings are vectorial representations of text that capture the semantic meaning of paragraphs through their position in a high dimensional vector space. Mistral AI Embeddings API offers cutting-edge, state-of-the-art embeddings for text, which can be used for many NLP tasks.

## Available Models

Mistral AI provides two embedding models, each optimized for different use cases:

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 22%" />
<col style="width: 22%" />
<col style="width: 11%" />
<col style="width: 44%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Model</th>
<th class="tableblock halign-left valign-top">Dimensions</th>
<th class="tableblock halign-left valign-top">Use Case</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>mistral-embed</code></p></td>
<td class="tableblock halign-left valign-top"><p>1024</p></td>
<td class="tableblock halign-left valign-top"><p>General text</p></td>
<td class="tableblock halign-left valign-top"><p>General-purpose embedding model suitable for semantic search, clustering, and text similarity tasks. Ideal for natural language content.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>codestral-embed</code></p></td>
<td class="tableblock halign-left valign-top"><p>1536</p></td>
<td class="tableblock halign-left valign-top"><p>Code</p></td>
<td class="tableblock halign-left valign-top"><p>Specialized embedding model optimized for code similarity, code search, and retrieval-augmented generation (RAG) with code repositories. Provides higher-dimensional embeddings specifically designed for understanding code semantics.</p></td>
</tr>
</tbody>
</table>

When choosing a model:

- Use `mistral-embed` for general text content such as documents, articles, or user queries

- Use `codestral-embed` when working with code, technical documentation, or building code-aware RAG systems

## Prerequisites

You will need to create an API with MistralAI to access MistralAI embeddings models.

Create an account at MistralAI registration page and generate the token on the API Keys page.

The Spring AI project defines a configuration property named `spring.ai.mistralai.api-key` that you should set to the value of the `API Key` obtained from console.mistral.ai.

You can set this configuration property in your `application.properties` file:

    spring.ai.mistralai.api-key=<your-mistralai-api-key>

For enhanced security when handling sensitive information like API keys, you can use Spring Expression Language (SpEL) to reference an environment variable:

    # In application.yml
    spring:
      ai:
        mistralai:
          api-key: ${MISTRALAI_API_KEY}

    # In your environment or .env file
    export MISTRALAI_API_KEY=<your-mistralai-api-key>

You can also set this configuration programmatically in your application code:

    // Retrieve API key from a secure source or environment variable
    String apiKey = System.getenv("MISTRALAI_API_KEY");

### Add Repositories and BOM

Spring AI artifacts are published in Maven Central and Spring Snapshot repositories. Refer to the Artifact Repositories section to add these repositories to your build system.

To help with dependency management, Spring AI provides a BOM (bill of materials) to ensure that a consistent version of Spring AI is used throughout the entire project. Refer to the Dependency Management section to add the Spring AI BOM to your build system.

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the MistralAI Embedding Model. To enable it add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-mistral-ai</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-model-mistral-ai'
    }

### Embedding Properties

#### Retry Properties

The prefix `spring.ai.retry` is used as the property prefix that lets you configure the retry mechanism for the Mistral AI Embedding model.

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
<td class="tableblock halign-left valign-top"><p>spring.ai.retry.max-attempts</p></td>
<td class="tableblock halign-left valign-top"><p>Maximum number of retry attempts.</p></td>
<td class="tableblock halign-left valign-top"><p>10</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.retry.backoff.initial-interval</p></td>
<td class="tableblock halign-left valign-top"><p>Initial sleep duration for the exponential backoff policy.</p></td>
<td class="tableblock halign-left valign-top"><p>2 sec.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.retry.backoff.multiplier</p></td>
<td class="tableblock halign-left valign-top"><p>Backoff interval multiplier.</p></td>
<td class="tableblock halign-left valign-top"><p>5</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.retry.backoff.max-interval</p></td>
<td class="tableblock halign-left valign-top"><p>Maximum backoff duration.</p></td>
<td class="tableblock halign-left valign-top"><p>3 min.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.retry.on-client-errors</p></td>
<td class="tableblock halign-left valign-top"><p>If false, throw a NonTransientAiException, and do not attempt retry for <code>4xx</code> client error codes</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.retry.exclude-on-http-codes</p></td>
<td class="tableblock halign-left valign-top"><p>List of HTTP status codes that should not trigger a retry (e.g. to throw NonTransientAiException).</p></td>
<td class="tableblock halign-left valign-top"><p>empty</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.retry.on-http-codes</p></td>
<td class="tableblock halign-left valign-top"><p>List of HTTP status codes that should trigger a retry (e.g. to throw TransientAiException).</p></td>
<td class="tableblock halign-left valign-top"><p>empty</p></td>
</tr>
</tbody>
</table>

#### Connection Properties

The prefix `spring.ai.mistralai` is used as the property prefix that lets you connect to MistralAI.

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
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.base-url</p></td>
<td class="tableblock halign-left valign-top"><p>The URL to connect to</p></td>
<td class="tableblock halign-left valign-top"><p>api.mistral.ai</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>The API Key</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

#### Configuration Properties

The prefix `spring.ai.mistralai.embedding` is property prefix that configures the `EmbeddingModel` implementation for MistralAI.

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
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.embedding.enabled (Removed and no longer valid)</p></td>
<td class="tableblock halign-left valign-top"><p>Enable OpenAI embedding model.</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.model.embedding</p></td>
<td class="tableblock halign-left valign-top"><p>Enable OpenAI embedding model.</p></td>
<td class="tableblock halign-left valign-top"><p>mistral</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.embedding.base-url</p></td>
<td class="tableblock halign-left valign-top"><p>Optional overrides the spring.ai.mistralai.base-url to provide embedding specific url</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.embedding.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>Optional overrides the spring.ai.mistralai.api-key to provide embedding specific api-key</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.embedding.metadata-mode</p></td>
<td class="tableblock halign-left valign-top"><p>Document content extraction mode.</p></td>
<td class="tableblock halign-left valign-top"><p>EMBED</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.embedding.model</p></td>
<td class="tableblock halign-left valign-top"><p>The model to use</p></td>
<td class="tableblock halign-left valign-top"><p>mistral-embed</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.embedding.encoding-format</p></td>
<td class="tableblock halign-left valign-top"><p>The format to return the embeddings in. Can be either float or base64.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

## Runtime Options

The MistralAiEmbeddingOptions.java provides the MistralAI configurations, such as the model to use and etc.

The default options can be configured using the `spring.ai.mistralai.embedding` properties as well.

At start-time use the `MistralAiEmbeddingModel` constructor to set the default options used for all embedding requests. At run-time you can override the default options, using a `MistralAiEmbeddingOptions` instance as part of your `EmbeddingRequest`.

For example to override the default model name for a specific request:

    // Using mistral-embed for general text
    EmbeddingResponse textEmbeddingResponse = embeddingModel.call(
        new EmbeddingRequest(List.of("Hello World", "World is big and salvation is near"),
            MistralAiEmbeddingOptions.builder()
                .withModel("mistral-embed")
            .build()));

    // Using codestral-embed for code
    EmbeddingResponse codeEmbeddingResponse = embeddingModel.call(
        new EmbeddingRequest(List.of("public class HelloWorld {}", "def hello_world():"),
            MistralAiEmbeddingOptions.builder()
                .withModel("codestral-embed")
            .build()));

## Sample Controller

This will create a `EmbeddingModel` implementation that you can inject into your class. Here is an example of a simple `@Controller` class that uses the `EmbeddingModel` implementation.

    spring.ai.mistralai.api-key=YOUR_API_KEY
    spring.ai.mistralai.embedding.model=mistral-embed

    @RestController
    public class EmbeddingController {

        private final EmbeddingModel embeddingModel;

        @Autowired
        public EmbeddingController(EmbeddingModel embeddingModel) {
            this.embeddingModel = embeddingModel;
        }

        @GetMapping("/ai/embedding")
        public Map embed(@RequestParam(value = "message", defaultValue = "Tell me a joke") String message) {
            var embeddingResponse = this.embeddingModel.embedForResponse(List.of(message));
            return Map.of("embedding", embeddingResponse);
        }
    }

## Manual Configuration

If you are not using Spring Boot, you can manually configure the OpenAI Embedding Model. For this add the `spring-ai-mistral-ai` dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-mistral-ai</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-mistral-ai'
    }

Next, create an `MistralAiEmbeddingModel` instance and use it to compute the similarity between two input texts:

    var mistralAiApi = new MistralAiApi(System.getenv("MISTRAL_AI_API_KEY"));

    var embeddingModel = new MistralAiEmbeddingModel(this.mistralAiApi,
            MistralAiEmbeddingOptions.builder()
                    .withModel("mistral-embed")
                    .withEncodingFormat("float")
                    .build());

    EmbeddingResponse embeddingResponse = this.embeddingModel
            .embedForResponse(List.of("Hello World", "World is big and salvation is near"));

The `MistralAiEmbeddingOptions` provides the configuration information for the embedding requests. The options class offers a `builder()` for easy options creation.

Google GenAI Text Embedding OCI GenAI

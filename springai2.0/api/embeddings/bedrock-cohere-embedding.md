Search

# Cohere Embeddings

Provides Bedrock Cohere Embedding model. Integrate generative AI capabilities into essential apps and workflows that improve business outcomes.

The AWS Bedrock Cohere Model Page and Amazon Bedrock User Guide contains detailed information on how to use the AWS hosted model.

## Prerequisites

Refer to the Spring AI documentation on Amazon Bedrock for setting up API access.

### Add Repositories and BOM

Spring AI artifacts are published in Maven Central and Spring Snapshot repositories. Refer to the Artifact Repositories section to add these repositories to your build system.

To help with dependency management, Spring AI provides a BOM (bill of materials) to ensure that a consistent version of Spring AI is used throughout the entire project. Refer to the Dependency Management section to add the Spring AI BOM to your build system.

## Auto-configuration

Add the `spring-ai-starter-model-bedrock` dependency to your project’s Maven `pom.xml` file:

    <dependency>
      <groupId>org.springframework.ai</groupId>
      <artifactId>spring-ai-starter-model-bedrock</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-model-bedrock'
    }

### Enable Cohere Embedding Support

By default, the Cohere embedding model is disabled. To enable it, set the `spring.ai.model.embedding` property to `bedrock-cohere` in your application configuration:

    spring.ai.model.embedding=bedrock-cohere

Alternatively, you can use Spring Expression Language (SpEL) to reference an environment variable:

    # In application.yml
    spring:
      ai:
        model:
          embedding: ${AI_MODEL_EMBEDDING}

    # In your environment or .env file
    export AI_MODEL_EMBEDDING=bedrock-cohere

You can also set this property using Java system properties when starting your application:

    java -Dspring.ai.model.embedding=bedrock-cohere -jar your-application.jar

### Embedding Properties

The prefix `spring.ai.bedrock.aws` is the property prefix to configure the connection to AWS Bedrock.

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 37%" />
<col style="width: 50%" />
<col style="width: 12%" />
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
<td class="tableblock halign-left valign-top"><p>spring.ai.bedrock.aws.region</p></td>
<td class="tableblock halign-left valign-top"><p>AWS region to use.</p></td>
<td class="tableblock halign-left valign-top"><p>us-east-1</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.bedrock.aws.access-key</p></td>
<td class="tableblock halign-left valign-top"><p>AWS access key.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.bedrock.aws.secret-key</p></td>
<td class="tableblock halign-left valign-top"><p>AWS secret key.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.bedrock.aws.profile.name</p></td>
<td class="tableblock halign-left valign-top"><p>AWS profile name.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.bedrock.aws.profile.credentials-path</p></td>
<td class="tableblock halign-left valign-top"><p>AWS credentials file path.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.bedrock.aws.profile.configuration-path</p></td>
<td class="tableblock halign-left valign-top"><p>AWS config file path.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

The prefix `spring.ai.bedrock.cohere.embedding` (defined in `BedrockCohereEmbeddingProperties`) is the property prefix that configures the embedding model implementation for Cohere.

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 37%" />
<col style="width: 50%" />
<col style="width: 12%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Property</p></td>
<td class="tableblock halign-left valign-top"><p>Description</p></td>
<td class="tableblock halign-left valign-top"><p>Default</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.model.embedding</p></td>
<td class="tableblock halign-left valign-top"><p>Enable or disable support for Cohere</p></td>
<td class="tableblock halign-left valign-top"><p>bedrock-cohere</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.bedrock.cohere.embedding.enabled (Removed and no longer valid)</p></td>
<td class="tableblock halign-left valign-top"><p>Enable or disable support for Cohere</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.bedrock.cohere.embedding.model</p></td>
<td class="tableblock halign-left valign-top"><p>The model id to use. See the CohereEmbeddingModel for the supported models.</p></td>
<td class="tableblock halign-left valign-top"><p>cohere.embed-multilingual-v3</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.bedrock.cohere.embedding.input-type</p></td>
<td class="tableblock halign-left valign-top"><p>Prepends special tokens to differentiate each type from one another. You should not mix different types together, except when mixing types for search and retrieval. In this case, embed your corpus with the search_document type and embedded queries with type search_query type.</p></td>
<td class="tableblock halign-left valign-top"><p>SEARCH_DOCUMENT</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.bedrock.cohere.embedding.truncate</p></td>
<td class="tableblock halign-left valign-top"><p>Specifies how the API handles inputs longer than the maximum token length. If you specify LEFT or RIGHT, the model discards the input until the remaining input is exactly the maximum input token length for the model.</p></td>
<td class="tableblock halign-left valign-top"><p>NONE</p></td>
</tr>
</tbody>
</table>

Look at the CohereEmbeddingModel for other model IDs. Supported values are: `cohere.embed-multilingual-v3` and `cohere.embed-english-v3`. Model ID values can also be found in the AWS Bedrock documentation for base model IDs.

## Runtime Options

The BedrockCohereEmbeddingOptions.java provides model configurations, such as `input-type` or `truncate`.

On start-up, the default options can be configured with the `BedrockCohereEmbeddingModel(api, options)` constructor or the `spring.ai.bedrock.cohere.embedding.*` properties.

At runtime you can override the default options by adding new, request-specific, options to the `EmbeddingRequest` call. For example to override the default input type for a specific request:

    EmbeddingResponse embeddingResponse = embeddingModel.call(
        new EmbeddingRequest(List.of("Hello World", "World is big and salvation is near"),
            BedrockCohereEmbeddingOptions.builder()
            .inputType(InputType.SEARCH_DOCUMENT)
            .build()));

## Sample Controller

Create a new Spring Boot project and add the `spring-ai-starter-model-bedrock` to your pom (or gradle) dependencies.

Add a `application.properties` file, under the `src/main/resources` directory, to enable and configure the Cohere Embedding model:

    spring.ai.bedrock.aws.region=eu-central-1
    spring.ai.bedrock.aws.access-key=${AWS_ACCESS_KEY_ID}
    spring.ai.bedrock.aws.secret-key=${AWS_SECRET_ACCESS_KEY}

    spring.ai.model.embedding=bedrock-cohere
    spring.ai.bedrock.cohere.embedding.input-type=search-document

This will create a `BedrockCohereEmbeddingModel` implementation that you can inject into your class. Here is an example of a simple `@Controller` class that uses the chat model for text generations.

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

The BedrockCohereEmbeddingModel implements the `EmbeddingModel` and uses the Low-level CohereEmbeddingBedrockApi Client to connect to the Bedrock Cohere service.

Add the `spring-ai-bedrock` dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-bedrock</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-bedrock'
    }

Next, create an BedrockCohereEmbeddingModel and use it for text embeddings:

    var cohereEmbeddingApi =new CohereEmbeddingBedrockApi(
            CohereEmbeddingModel.COHERE_EMBED_MULTILINGUAL_V1.id(),
            EnvironmentVariableCredentialsProvider.create(), Region.US_EAST_1.id(), new JsonMapper());


    var embeddingModel = new BedrockCohereEmbeddingModel(this.cohereEmbeddingApi);

    EmbeddingResponse embeddingResponse = this.embeddingModel
        .embedForResponse(List.of("Hello World", "World is big and salvation is near"));

## Low-level CohereEmbeddingBedrockApi Client

The CohereEmbeddingBedrockApi provides is lightweight Java client on top of AWS Bedrock Cohere Command models.

Following class diagram illustrates the CohereEmbeddingBedrockApi interface and building blocks:

The CohereEmbeddingBedrockApi supports the `cohere.embed-english-v3` and `cohere.embed-multilingual-v3` models for single and batch embedding computation.

Here is a simple snippet how to use the api programmatically:

    CohereEmbeddingBedrockApi api = new CohereEmbeddingBedrockApi(
            CohereEmbeddingModel.COHERE_EMBED_MULTILINGUAL_V1.id(),
            EnvironmentVariableCredentialsProvider.create(),
            Region.US_EAST_1.id(), new JsonMapper());

    CohereEmbeddingRequest request = new CohereEmbeddingRequest(
            List.of("I like to eat apples", "I like to eat oranges"),
            CohereEmbeddingRequest.InputType.search_document,
            CohereEmbeddingRequest.Truncate.NONE);

    CohereEmbeddingResponse response = this.api.embedding(this.request);

Amazon Bedrock Titan

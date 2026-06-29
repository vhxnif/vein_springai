Search

# Titan Embeddings

Provides Bedrock Titan Embedding model. Amazon Titan foundation models (FMs) provide customers with a breadth of high-performing image, multimodal embeddings, and text model choices, via a fully managed API. Amazon Titan models are created by AWS and pretrained on large datasets, making them powerful, general-purpose models built to support a variety of use cases, while also supporting the responsible use of AI. Use them as is or privately customize them with your own data.

The AWS Bedrock Titan Model Page and Amazon Bedrock User Guide contains detailed information on how to use the AWS hosted model.

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

### Enable Titan Embedding Support

By default, the Titan embedding model is disabled. To enable it, set the `spring.ai.model.embedding` property to `bedrock-titan` in your application configuration:

    spring.ai.model.embedding=bedrock-titan

Alternatively, you can use Spring Expression Language (SpEL) to reference an environment variable:

    # In application.yml
    spring:
      ai:
        model:
          embedding: ${AI_MODEL_EMBEDDING}

    # In your environment or .env file
    export AI_MODEL_EMBEDDING=bedrock-titan

You can also set this property using Java system properties when starting your application:

    java -Dspring.ai.model.embedding=bedrock-titan -jar your-application.jar

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

The prefix `spring.ai.bedrock.titan.embedding` (defined in `BedrockTitanEmbeddingProperties`) is the property prefix that configures the embedding model implementation for Titan.

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
<td class="tableblock halign-left valign-top"><p>spring.ai.bedrock.titan.embedding.enabled (Removed and no longer valid)</p></td>
<td class="tableblock halign-left valign-top"><p>Enable or disable support for Titan embedding</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.model.embedding</p></td>
<td class="tableblock halign-left valign-top"><p>Enable or disable support for Titan embedding</p></td>
<td class="tableblock halign-left valign-top"><p>bedrock-titan</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.bedrock.titan.embedding.model</p></td>
<td class="tableblock halign-left valign-top"><p>The model id to use. See the <code>TitanEmbeddingModel</code> for the supported models.</p></td>
<td class="tableblock halign-left valign-top"><p>amazon.titan-embed-image-v1</p></td>
</tr>
</tbody>
</table>

Supported values are: `amazon.titan-embed-image-v1`, `amazon.titan-embed-text-v1` and `amazon.titan-embed-text-v2:0`. Model ID values can also be found in the AWS Bedrock documentation for base model IDs.

## Runtime Options

The BedrockTitanEmbeddingOptions.java provides model configurations, such as `input-type`. On start-up, the default options can be configured with the `BedrockTitanEmbeddingOptions.builder().inputType(type).build()` method or the `spring.ai.bedrock.titan.embedding.input-type` properties.

At run-time you can override the default options by adding new, request specific, options to the `EmbeddingRequest` call. For example to override the default temperature for a specific request:

    EmbeddingResponse embeddingResponse = embeddingModel.call(
        new EmbeddingRequest(List.of("Hello World", "World is big and salvation is near"),
            BedrockTitanEmbeddingOptions.builder()
            .inputType(InputType.TEXT)
            .build()));

## Sample Controller

Create a new Spring Boot project and add the `spring-ai-starter-model-bedrock` to your pom (or gradle) dependencies.

Add a `application.properties` file, under the `src/main/resources` directory, to enable and configure the Titan Embedding model:

    spring.ai.bedrock.aws.region=eu-central-1
    spring.ai.bedrock.aws.access-key=${AWS_ACCESS_KEY_ID}
    spring.ai.bedrock.aws.secret-key=${AWS_SECRET_ACCESS_KEY}

    spring.ai.model.embedding=bedrock-titan

This will create a `EmbeddingController` implementation that you can inject into your class. Here is an example of a simple `@Controller` class that uses the chat model for text generations.

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

The BedrockTitanEmbeddingModel implements the `EmbeddingModel` and uses the Low-level TitanEmbeddingBedrockApi Client to connect to the Bedrock Titan service.

Add the `spring-ai-bedrock` dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-bedrock</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-bedrock'
    }

Next, create an BedrockTitanEmbeddingModel and use it for text embeddings:

    var titanEmbeddingApi = new TitanEmbeddingBedrockApi(
        TitanEmbeddingModel.TITAN_EMBED_IMAGE_V1.id(), Region.US_EAST_1.id());

    var embeddingModel = new BedrockTitanEmbeddingModel(this.titanEmbeddingApi);

    EmbeddingResponse embeddingResponse = this.embeddingModel
        .embedForResponse(List.of("Hello World")); // NOTE titan does not support batch embedding.

## Low-level TitanEmbeddingBedrockApi Client

The TitanEmbeddingBedrockApi provides is lightweight Java client on top of AWS Bedrock Titan Embedding models.

Following class diagram illustrates the TitanEmbeddingBedrockApi interface and building blocks:

The TitanEmbeddingBedrockApi supports the `amazon.titan-embed-image-v1` and `amazon.titan-embed-image-v1` models for single and batch embedding computation.

Here is a simple snippet how to use the api programmatically:

    TitanEmbeddingBedrockApi titanEmbedApi = new TitanEmbeddingBedrockApi(
            TitanEmbeddingModel.TITAN_EMBED_TEXT_V1.id(), Region.US_EAST_1.id());

    TitanEmbeddingRequest request = TitanEmbeddingRequest.builder()
        .withInputText("I like to eat apples.")
        .build();

    TitanEmbeddingResponse response = this.titanEmbedApi.embedding(this.request);

To embed an image you need to convert it into `base64` format:

    TitanEmbeddingBedrockApi titanEmbedApi = new TitanEmbeddingBedrockApi(
            TitanEmbeddingModel.TITAN_EMBED_IMAGE_V1.id(), Region.US_EAST_1.id());

    byte[] image = new DefaultResourceLoader()
        .getResource("classpath:/spring_framework.png")
        .getContentAsByteArray();


    TitanEmbeddingRequest request = TitanEmbeddingRequest.builder()
        .withInputImage(Base64.getEncoder().encodeToString(this.image))
        .build();

    TitanEmbeddingResponse response = this.titanEmbedApi.embedding(this.request);

Cohere Azure OpenAI

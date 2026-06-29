Search

# PostgresML Embeddings

Spring AI supports the PostgresML text embeddings models.

Embeddings are a numeric representation of text. They are used to represent words and sentences as vectors, an array of numbers. Embeddings can be used to find similar pieces of text, by comparing the similarity of the numeric vectors using a distance measure, or they can be used as input features for other machine learning models, since most algorithms can’t use text directly.

Many pre-trained LLMs can be used to generate embeddings from text within PostgresML. You can browse all the models available to find the best solution on Hugging Face.

## Add Repositories and BOM

Spring AI artifacts are published in Maven Central and Spring Snapshot repositories. Refer to the Artifact Repositories section to add these repositories to your build system.

To help with dependency management, Spring AI provides a BOM (bill of materials) to ensure that a consistent version of Spring AI is used throughout the entire project. Refer to the Dependency Management section to add the Spring AI BOM to your build system.

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the PostgresML Embedding Model. To enable it add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-postgresml-embedding</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-model-postgresml-embedding'
    }

Use the `spring.ai.postgresml.embedding.*` properties to configure your `PostgresMlEmbeddingModel`. links

### Embedding Properties

The prefix `spring.ai.postgresml.embedding` is property prefix that configures the `EmbeddingModel` implementation for PostgresML embeddings.

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 33%" />
<col style="width: 55%" />
<col style="width: 11%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Property</p></td>
<td class="tableblock halign-left valign-top"><p>Description</p></td>
<td class="tableblock halign-left valign-top"><p>Default</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.postgresml.embedding.enabled (Removed and no longer valid)</p></td>
<td class="tableblock halign-left valign-top"><p>Enable PostgresML embedding model.</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.model.embedding</p></td>
<td class="tableblock halign-left valign-top"><p>Enable PostgresML embedding model.</p></td>
<td class="tableblock halign-left valign-top"><p>postgresml</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.postgresml.embedding.create-extension</p></td>
<td class="tableblock halign-left valign-top"><p>Execute the SQL 'CREATE EXTENSION IF NOT EXISTS pgml' to enable the extension</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.postgresml.embedding.transformer</p></td>
<td class="tableblock halign-left valign-top"><p>The Hugging Face transformer model to use for the embedding.</p></td>
<td class="tableblock halign-left valign-top"><p>distilbert-base-uncased</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.postgresml.embedding.kwargs</p></td>
<td class="tableblock halign-left valign-top"><p>Additional transformer specific options.</p></td>
<td class="tableblock halign-left valign-top"><p>empty map</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.postgresml.embedding.vector-type</p></td>
<td class="tableblock halign-left valign-top"><p>PostgresML vector type to use for the embedding. Two options are supported: <code>PG_ARRAY</code> and <code>PG_VECTOR</code>.</p></td>
<td class="tableblock halign-left valign-top"><p>PG_ARRAY</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.postgresml.embedding.metadata-mode</p></td>
<td class="tableblock halign-left valign-top"><p>Document metadata aggregation mode</p></td>
<td class="tableblock halign-left valign-top"><p>EMBED</p></td>
</tr>
</tbody>
</table>

## Runtime Options

Use the PostgresMlEmbeddingOptions.java to configure the `PostgresMlEmbeddingModel` with options, such as the model to use and etc.

On start you can pass a `PostgresMlEmbeddingOptions` to the `PostgresMlEmbeddingModel` constructor to configure the default options used for all embedding requests.

At run-time you can override the default options, using a `PostgresMlEmbeddingOptions` in your `EmbeddingRequest`.

For example to override the default model name for a specific request:

    EmbeddingResponse embeddingResponse = embeddingModel.call(
        new EmbeddingRequest(List.of("Hello World", "World is big and salvation is near"),
                PostgresMlEmbeddingOptions.builder()
                    .transformer("intfloat/e5-small")
                    .vectorType(VectorType.PG_ARRAY)
                    .kwargs(Map.of("device", "gpu"))
                    .build()));

## Sample Controller

This will create a `EmbeddingModel` implementation that you can inject into your class. Here is an example of a simple `@Controller` class that uses the `EmbeddingModel` implementation.

    spring.ai.postgresml.embedding.transformer=distilbert-base-uncased
    spring.ai.postgresml.embedding.vector-type=PG_ARRAY
    spring.ai.postgresml.embedding.metadata-mode=EMBED
    spring.ai.postgresml.embedding.kwargs.device=cpu

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

## Manual configuration

Instead of using the Spring Boot auto-configuration, you can create the `PostgresMlEmbeddingModel` manually. For this add the `spring-ai-postgresml` dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-postgresml</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-postgresml'
    }

Next, create an `PostgresMlEmbeddingModel` instance and use it to compute the similarity between two input texts:

    var jdbcTemplate = new JdbcTemplate(dataSource); // your posgresml data source

    PostgresMlEmbeddingModel embeddingModel = new PostgresMlEmbeddingModel(this.jdbcTemplate,
            PostgresMlEmbeddingOptions.builder()
                .transformer("distilbert-base-uncased") // huggingface transformer model name.
                .vectorType(VectorType.PG_VECTOR) //vector type in PostgreSQL.
                .kwargs(Map.of("device", "cpu")) // optional arguments.
                .metadataMode(MetadataMode.EMBED) // Document metadata mode.
                .build());

    embeddingModel.afterPropertiesSet(); // initialize the jdbc template and database.

    EmbeddingResponse embeddingResponse = this.embeddingModel
        .embedForResponse(List.of("Hello World", "World is big and salvation is near"));

    @Bean
    public EmbeddingModel embeddingModel(JdbcTemplate jdbcTemplate) {
        return new PostgresMlEmbeddingModel(jdbcTemplate,
            PostgresMlEmbeddingOptions.builder()
                 ....
                .build());
    }

OpenAI Text Embedding

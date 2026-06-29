Search

# Ollama Embeddings

With Ollama you can run various AI Models locally and generate embeddings from them. An embedding is a vector (list) of floating point numbers. The distance between two vectors measures their relatedness. Small distances suggest high relatedness and large distances suggest low relatedness.

The `OllamaEmbeddingModel` implementation leverages the Ollama Embeddings API endpoint.

## Prerequisites

You first need access to an Ollama instance. There are a few options, including the following:

- Download and install Ollama on your local machine.

- Configure and run Ollama via Testcontainers.

You can pull the models you want to use in your application from the Ollama model library:

    ollama pull <model-name>

You can also pull any of the thousands, free, GGUF Hugging Face Models:

    ollama pull hf.co/<username>/<model-repository>

Alternatively, you can enable the option to download automatically any needed model: Auto-pulling Models.

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the Ollama Embedding Model. To enable it add the following dependency to your Maven `pom.xml` or Gradle `build.gradle` build files:

### Base Properties

The prefix `spring.ai.ollama` is the property prefix to configure the connection to Ollama

<table class="tableblock frame-all grid-all stretch" style="width:100%;">
<colgroup>
<col style="width: 30%" />
<col style="width: 60%" />
<col style="width: 10%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Property</p></td>
<td class="tableblock halign-left valign-top"><p>Description</p></td>
<td class="tableblock halign-left valign-top"><p>Default</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.base-url</p></td>
<td class="tableblock halign-left valign-top"><p>Base URL where Ollama API server is running.</p></td>
<td class="tableblock halign-left valign-top"><p><code>http://localhost:11434</code></p></td>
</tr>
</tbody>
</table>

Here are the properties for initializing the Ollama integration and auto-pulling models.

<table class="tableblock frame-all grid-all stretch" style="width:100%;">
<colgroup>
<col style="width: 30%" />
<col style="width: 60%" />
<col style="width: 10%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Property</p></td>
<td class="tableblock halign-left valign-top"><p>Description</p></td>
<td class="tableblock halign-left valign-top"><p>Default</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.init.pull-model-strategy</p></td>
<td class="tableblock halign-left valign-top"><p>Whether to pull models at startup-time and how.</p></td>
<td class="tableblock halign-left valign-top"><p><code>never</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.init.timeout</p></td>
<td class="tableblock halign-left valign-top"><p>How long to wait for a model to be pulled.</p></td>
<td class="tableblock halign-left valign-top"><p><code>5m</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.init.max-retries</p></td>
<td class="tableblock halign-left valign-top"><p>Maximum number of retries for the model pull operation.</p></td>
<td class="tableblock halign-left valign-top"><p><code>0</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.init.embedding.include</p></td>
<td class="tableblock halign-left valign-top"><p>Include this type of models in the initialization task.</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.init.embedding.additional-models</p></td>
<td class="tableblock halign-left valign-top"><p>Additional models to initialize besides the ones configured via default properties.</p></td>
<td class="tableblock halign-left valign-top"><p><code>[]</code></p></td>
</tr>
</tbody>
</table>

### Embedding Properties

The prefix `spring.ai.ollama.embedding` is the property prefix that configures the Ollama embedding model. It includes the Ollama request (advanced) parameters such as the `model`, `keep-alive`, and `truncate` as well as the Ollama model properties.

Here are the advanced request parameter for the Ollama embedding model:

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 40%" />
<col style="width: 50%" />
<col style="width: 10%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Property</p></td>
<td class="tableblock halign-left valign-top"><p>Description</p></td>
<td class="tableblock halign-left valign-top"><p>Default</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.enabled (Removed and no longer valid)</p></td>
<td class="tableblock halign-left valign-top"><p>Enables the Ollama embedding model auto-configuration.</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.model.embedding</p></td>
<td class="tableblock halign-left valign-top"><p>Enables the Ollama embedding model auto-configuration.</p></td>
<td class="tableblock halign-left valign-top"><p>ollama</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.model</p></td>
<td class="tableblock halign-left valign-top"><p>The name of the supported model to use. You can use dedicated Embedding Model types</p></td>
<td class="tableblock halign-left valign-top"><p>mxbai-embed-large</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.keep_alive</p></td>
<td class="tableblock halign-left valign-top"><p>Controls how long the model will stay loaded into memory following the request</p></td>
<td class="tableblock halign-left valign-top"><p>5m</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.truncate</p></td>
<td class="tableblock halign-left valign-top"><p>Truncates the end of each input to fit within context length. Returns error if false and context length is exceeded.</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
</tbody>
</table>

The remaining `options` properties are based on the Ollama Valid Parameters and Values and Ollama Types. The default values are based on: Ollama type defaults.

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 40%" />
<col style="width: 50%" />
<col style="width: 10%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Property</p></td>
<td class="tableblock halign-left valign-top"><p>Description</p></td>
<td class="tableblock halign-left valign-top"><p>Default</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.numa</p></td>
<td class="tableblock halign-left valign-top"><p>Whether to use NUMA.</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.num-ctx</p></td>
<td class="tableblock halign-left valign-top"><p>Sets the size of the context window used to generate the next token.</p></td>
<td class="tableblock halign-left valign-top"><p>2048</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.num-batch</p></td>
<td class="tableblock halign-left valign-top"><p>Prompt processing maximum batch size.</p></td>
<td class="tableblock halign-left valign-top"><p>512</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.num-gpu</p></td>
<td class="tableblock halign-left valign-top"><p>The number of layers to send to the GPU(s). On macOS it defaults to 1 to enable metal support, 0 to disable. 1 here indicates that NumGPU should be set dynamically</p></td>
<td class="tableblock halign-left valign-top"><p>-1</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.main-gpu</p></td>
<td class="tableblock halign-left valign-top"><p>When using multiple GPUs this option controls which GPU is used for small tensors for which the overhead of splitting the computation across all GPUs is not worthwhile. The GPU in question will use slightly more VRAM to store a scratch buffer for temporary results.</p></td>
<td class="tableblock halign-left valign-top"><p>0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.low-vram</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.f16-kv</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.logits-all</p></td>
<td class="tableblock halign-left valign-top"><p>Return logits for all the tokens, not just the last one. To enable completions to return logprobs, this must be true.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.vocab-only</p></td>
<td class="tableblock halign-left valign-top"><p>Load only the vocabulary, not the weights.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.use-mmap</p></td>
<td class="tableblock halign-left valign-top"><p>By default, models are mapped into memory, which allows the system to load only the necessary parts of the model as needed. However, if the model is larger than your total amount of RAM or if your system is low on available memory, using mmap might increase the risk of pageouts, negatively impacting performance. Disabling mmap results in slower load times but may reduce pageouts if you’re not using mlock. Note that if the model is larger than the total amount of RAM, turning off mmap would prevent the model from loading at all.</p></td>
<td class="tableblock halign-left valign-top"><p>null</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.use-mlock</p></td>
<td class="tableblock halign-left valign-top"><p>Lock the model in memory, preventing it from being swapped out when memory-mapped. This can improve performance but trades away some of the advantages of memory-mapping by requiring more RAM to run and potentially slowing down load times as the model loads into RAM.</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.num-thread</p></td>
<td class="tableblock halign-left valign-top"><p>Sets the number of threads to use during computation. By default, Ollama will detect this for optimal performance. It is recommended to set this value to the number of physical CPU cores your system has (as opposed to the logical number of cores). 0 = let the runtime decide</p></td>
<td class="tableblock halign-left valign-top"><p>0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.num-keep</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
<td class="tableblock halign-left valign-top"><p>4</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.seed</p></td>
<td class="tableblock halign-left valign-top"><p>Sets the random number seed to use for generation. Setting this to a specific number will make the model generate the same text for the same prompt.</p></td>
<td class="tableblock halign-left valign-top"><p>-1</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.num-predict</p></td>
<td class="tableblock halign-left valign-top"><p>Maximum number of tokens to predict when generating text. (-1 = infinite generation, -2 = fill context)</p></td>
<td class="tableblock halign-left valign-top"><p>-1</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.top-k</p></td>
<td class="tableblock halign-left valign-top"><p>Reduces the probability of generating nonsense. A higher value (e.g., 100) will give more diverse answers, while a lower value (e.g., 10) will be more conservative.</p></td>
<td class="tableblock halign-left valign-top"><p>40</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.top-p</p></td>
<td class="tableblock halign-left valign-top"><p>Works together with top-k. A higher value (e.g., 0.95) will lead to more diverse text, while a lower value (e.g., 0.5) will generate more focused and conservative text.</p></td>
<td class="tableblock halign-left valign-top"><p>0.9</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.min-p</p></td>
<td class="tableblock halign-left valign-top"><p>Alternative to the top_p, and aims to ensure a balance of quality and variety. The parameter p represents the minimum probability for a token to be considered, relative to the probability of the most likely token. For example, with p=0.05 and the most likely token having a probability of 0.9, logits with a value less than 0.045 are filtered out.</p></td>
<td class="tableblock halign-left valign-top"><p>0.0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.tfs-z</p></td>
<td class="tableblock halign-left valign-top"><p>Tail-free sampling is used to reduce the impact of less probable tokens from the output. A higher value (e.g., 2.0) will reduce the impact more, while a value of 1.0 disables this setting.</p></td>
<td class="tableblock halign-left valign-top"><p>1.0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.typical-p</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
<td class="tableblock halign-left valign-top"><p>1.0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.repeat-last-n</p></td>
<td class="tableblock halign-left valign-top"><p>Sets how far back for the model to look back to prevent repetition. (Default: 64, 0 = disabled, -1 = num_ctx)</p></td>
<td class="tableblock halign-left valign-top"><p>64</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.temperature</p></td>
<td class="tableblock halign-left valign-top"><p>The temperature of the model. Increasing the temperature will make the model answer more creatively.</p></td>
<td class="tableblock halign-left valign-top"><p>0.8</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.repeat-penalty</p></td>
<td class="tableblock halign-left valign-top"><p>Sets how strongly to penalize repetitions. A higher value (e.g., 1.5) will penalize repetitions more strongly, while a lower value (e.g., 0.9) will be more lenient.</p></td>
<td class="tableblock halign-left valign-top"><p>1.1</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.presence-penalty</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
<td class="tableblock halign-left valign-top"><p>0.0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.frequency-penalty</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
<td class="tableblock halign-left valign-top"><p>0.0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.mirostat</p></td>
<td class="tableblock halign-left valign-top"><p>Enable Mirostat sampling for controlling perplexity. (default: 0, 0 = disabled, 1 = Mirostat, 2 = Mirostat 2.0)</p></td>
<td class="tableblock halign-left valign-top"><p>0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.mirostat-tau</p></td>
<td class="tableblock halign-left valign-top"><p>Controls the balance between coherence and diversity of the output. A lower value will result in more focused and coherent text.</p></td>
<td class="tableblock halign-left valign-top"><p>5.0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.mirostat-eta</p></td>
<td class="tableblock halign-left valign-top"><p>Influences how quickly the algorithm responds to feedback from the generated text. A lower learning rate will result in slower adjustments, while a higher learning rate will make the algorithm more responsive.</p></td>
<td class="tableblock halign-left valign-top"><p>0.1</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.penalize-newline</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.stop</p></td>
<td class="tableblock halign-left valign-top"><p>Sets the stop sequences to use. When this pattern is encountered the LLM will stop generating text and return. Multiple stop patterns may be set by specifying multiple separate stop parameters in a modelfile.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.embedding.functions</p></td>
<td class="tableblock halign-left valign-top"><p>List of functions, identified by their names, to enable for function calling in a single prompt requests. Functions with those names must exist in the toolCallbacks registry.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

## Runtime Options

The OllamaEmbeddingOptions.java provides the Ollama configurations, such as the model to use, the low level GPU and CPU tuning, etc.

The default options can be configured using the `spring.ai.ollama.embedding` properties as well.

At start-time use the `OllamaEmbeddingModel(OllamaApi ollamaApi, OllamaEmbeddingOptions options)` to configure the default options used for all embedding requests. At run-time you can override the default options, using a `OllamaEmbeddingOptions` instance as part of your `EmbeddingRequest`.

For example to override the default model name for a specific request:

    EmbeddingResponse embeddingResponse = embeddingModel.call(
        new EmbeddingRequest(List.of("Hello World", "World is big and salvation is near"),
            OllamaEmbeddingOptions.builder()
                .model("Different-Embedding-Model-Deployment-Name"))
                .truncates(false)
                .build());

## Auto-pulling Models

Spring AI Ollama can automatically pull models when they are not available in your Ollama instance. This feature is particularly useful for development and testing as well as for deploying your applications to new environments.

There are three strategies for pulling models:

- `always` (defined in `PullModelStrategy.ALWAYS`): Always pull the model, even if it’s already available. Useful to ensure you’re using the latest version of the model.

- `when_missing` (defined in `PullModelStrategy.WHEN_MISSING`): Only pull the model if it’s not already available. This may result in using an older version of the model.

- `never` (defined in `PullModelStrategy.NEVER`): Never pull the model automatically.

All models defined via configuration properties and default options can be automatically pulled at startup time. You can configure the pull strategy, timeout, and maximum number of retries using configuration properties:

    spring:
      ai:
        ollama:
          init:
            pull-model-strategy: always
            timeout: 60s
            max-retries: 1

You can initialize additional models at startup, which is useful for models used dynamically at runtime:

    spring:
      ai:
        ollama:
          init:
            pull-model-strategy: always
            embedding:
              additional-models:
                - mxbai-embed-large
                - nomic-embed-text

If you want to apply the pulling strategy only to specific types of models, you can exclude embedding models from the initialization task:

    spring:
      ai:
        ollama:
          init:
            pull-model-strategy: always
            embedding:
              include: false

This configuration will apply the pulling strategy to all models except embedding models.

## HuggingFace Models

Ollama can access, out of the box, all GGUF Hugging Face Embedding models. You can pull any of these models by name: `ollama pull hf.co/<username>/<model-repository>` or configure the auto-pulling strategy: Auto-pulling Models:

    spring.ai.ollama.embedding.model=hf.co/mixedbread-ai/mxbai-embed-large-v1
    spring.ai.ollama.init.pull-model-strategy=always

- `spring.ai.ollama.embedding.model`: Specifies the Hugging Face GGUF model to use.

- `spring.ai.ollama.init.pull-model-strategy=always`: (optional) Enables automatic model pulling at startup time. For production, you should pre-download the models to avoid delays: `ollama pull hf.co/mixedbread-ai/mxbai-embed-large-v1`.

## Sample Controller

This will create a `EmbeddingModel` implementation that you can inject into your class. Here is an example of a simple `@Controller` class that uses the `EmbeddingModel` implementation.

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

If you are not using Spring Boot, you can manually configure the `OllamaEmbeddingModel`. For this add the spring-ai-ollama dependency to your project’s Maven pom.xml or Gradle `build.gradle` build files:

Next, create an `OllamaEmbeddingModel` instance and use it to compute the embeddings for two input texts using a dedicated `chroma/all-minilm-l6-v2-f32` embedding models:

    var ollamaApi = OllamaApi.builder().build();

    var embeddingModel = new OllamaEmbeddingModel(this.ollamaApi,
            OllamaEmbeddingOptions.builder()
                .model(OllamaModel.MISTRAL.id())
                .build());

    EmbeddingResponse embeddingResponse = this.embeddingModel.call(
        new EmbeddingRequest(List.of("Hello World", "World is big and salvation is near"),
            OllamaEmbeddingOptions.builder()
                .model("chroma/all-minilm-l6-v2-f32"))
                .truncate(false)
                .build());

The `OllamaEmbeddingOptions` provides the configuration information for all embedding requests.

OCI GenAI (ONNX) Transformers

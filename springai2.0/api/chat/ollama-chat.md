Search

# Ollama Chat

With Ollama you can run various Large Language Models (LLMs) locally and generate text from them. Spring AI supports the Ollama chat completion capabilities with the `OllamaChatModel` API.

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

Spring AI provides Spring Boot auto-configuration for the Ollama chat integration. To enable it add the following dependency to your project’s Maven `pom.xml` or Gradle `build.gradle` build files:

### Base Properties

The prefix `spring.ai.ollama` is the property prefix to configure the connection to Ollama.

<table class="tableblock frame-all grid-all stripes-even stretch" style="width:100%;">
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
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.init.chat.include</p></td>
<td class="tableblock halign-left valign-top"><p>Include this type of models in the initialization task.</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.init.chat.additional-models</p></td>
<td class="tableblock halign-left valign-top"><p>Additional models to initialize besides the ones configured via default properties.</p></td>
<td class="tableblock halign-left valign-top"><p><code>[]</code></p></td>
</tr>
</tbody>
</table>

### Chat Properties

The prefix `spring.ai.ollama.chat` is the property prefix that configures the Ollama chat model. It includes the Ollama request (advanced) parameters such as the `model`, `keep-alive`, and `format` as well as the Ollama model `options` properties.

Here are the advanced request parameter for the Ollama chat model:

<table class="tableblock frame-all grid-all stripes-even stretch" style="width:100%;">
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
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.enabled (Removed and no longer valid)</p></td>
<td class="tableblock halign-left valign-top"><p>Enable Ollama chat model.</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.model.chat</p></td>
<td class="tableblock halign-left valign-top"><p>Enable Ollama chat model.</p></td>
<td class="tableblock halign-left valign-top"><p>ollama</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.model</p></td>
<td class="tableblock halign-left valign-top"><p>The name of the supported model to use.</p></td>
<td class="tableblock halign-left valign-top"><p>mistral</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.format</p></td>
<td class="tableblock halign-left valign-top"><p>The format to return a response in. Accepts either <code>"json"</code> (any JSON structure) or a JSON Schema object (enforced structure). See Structured Outputs for details.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.keep_alive</p></td>
<td class="tableblock halign-left valign-top"><p>Controls how long the model will stay loaded into memory following the request</p></td>
<td class="tableblock halign-left valign-top"><p>5m</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.think</p></td>
<td class="tableblock halign-left valign-top"><p>Controls whether models emit their reasoning trace before the final answer.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

The remaining `options` properties are based on the Ollama Valid Parameters and Values and Ollama Types. The default values are based on the Ollama Types Defaults.

<table class="tableblock frame-all grid-all stripes-even stretch" style="width:100%;">
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
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.numa</p></td>
<td class="tableblock halign-left valign-top"><p>Whether to use NUMA.</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.num-ctx</p></td>
<td class="tableblock halign-left valign-top"><p>Sets the size of the context window used to generate the next token.</p></td>
<td class="tableblock halign-left valign-top"><p>2048</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.num-batch</p></td>
<td class="tableblock halign-left valign-top"><p>Prompt processing maximum batch size.</p></td>
<td class="tableblock halign-left valign-top"><p>512</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.num-gpu</p></td>
<td class="tableblock halign-left valign-top"><p>The number of layers to send to the GPU(s). On macOS it defaults to 1 to enable metal support, 0 to disable. 1 here indicates that NumGPU should be set dynamically</p></td>
<td class="tableblock halign-left valign-top"><p>-1</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.main-gpu</p></td>
<td class="tableblock halign-left valign-top"><p>When using multiple GPUs this option controls which GPU is used for small tensors for which the overhead of splitting the computation across all GPUs is not worthwhile. The GPU in question will use slightly more VRAM to store a scratch buffer for temporary results.</p></td>
<td class="tableblock halign-left valign-top"><p>0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.low-vram</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.f16-kv</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.logits-all</p></td>
<td class="tableblock halign-left valign-top"><p>Return logits for all the tokens, not just the last one. To enable completions to return logprobs, this must be true.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.vocab-only</p></td>
<td class="tableblock halign-left valign-top"><p>Load only the vocabulary, not the weights.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.use-mmap</p></td>
<td class="tableblock halign-left valign-top"><p>By default, models are mapped into memory, which allows the system to load only the necessary parts of the model as needed. However, if the model is larger than your total amount of RAM or if your system is low on available memory, using mmap might increase the risk of pageouts, negatively impacting performance. Disabling mmap results in slower load times but may reduce pageouts if you’re not using mlock. Note that if the model is larger than the total amount of RAM, turning off mmap would prevent the model from loading at all.</p></td>
<td class="tableblock halign-left valign-top"><p>null</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.use-mlock</p></td>
<td class="tableblock halign-left valign-top"><p>Lock the model in memory, preventing it from being swapped out when memory-mapped. This can improve performance but trades away some of the advantages of memory-mapping by requiring more RAM to run and potentially slowing down load times as the model loads into RAM.</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.num-thread</p></td>
<td class="tableblock halign-left valign-top"><p>Sets the number of threads to use during computation. By default, Ollama will detect this for optimal performance. It is recommended to set this value to the number of physical CPU cores your system has (as opposed to the logical number of cores). 0 = let the runtime decide</p></td>
<td class="tableblock halign-left valign-top"><p>0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.num-keep</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
<td class="tableblock halign-left valign-top"><p>4</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.seed</p></td>
<td class="tableblock halign-left valign-top"><p>Sets the random number seed to use for generation. Setting this to a specific number will make the model generate the same text for the same prompt.</p></td>
<td class="tableblock halign-left valign-top"><p>-1</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.num-predict</p></td>
<td class="tableblock halign-left valign-top"><p>Maximum number of tokens to predict when generating text. (-1 = infinite generation, -2 = fill context)</p></td>
<td class="tableblock halign-left valign-top"><p>-1</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.top-k</p></td>
<td class="tableblock halign-left valign-top"><p>Reduces the probability of generating nonsense. A higher value (e.g., 100) will give more diverse answers, while a lower value (e.g., 10) will be more conservative.</p></td>
<td class="tableblock halign-left valign-top"><p>40</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.top-p</p></td>
<td class="tableblock halign-left valign-top"><p>Works together with top-k. A higher value (e.g., 0.95) will lead to more diverse text, while a lower value (e.g., 0.5) will generate more focused and conservative text.</p></td>
<td class="tableblock halign-left valign-top"><p>0.9</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.min-p</p></td>
<td class="tableblock halign-left valign-top"><p>Alternative to the top_p, and aims to ensure a balance of quality and variety. The parameter p represents the minimum probability for a token to be considered, relative to the probability of the most likely token. For example, with p=0.05 and the most likely token having a probability of 0.9, logits with a value less than 0.045 are filtered out.</p></td>
<td class="tableblock halign-left valign-top"><p>0.0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.tfs-z</p></td>
<td class="tableblock halign-left valign-top"><p>Tail-free sampling is used to reduce the impact of less probable tokens from the output. A higher value (e.g., 2.0) will reduce the impact more, while a value of 1.0 disables this setting.</p></td>
<td class="tableblock halign-left valign-top"><p>1.0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.typical-p</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
<td class="tableblock halign-left valign-top"><p>1.0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.repeat-last-n</p></td>
<td class="tableblock halign-left valign-top"><p>Sets how far back for the model to look back to prevent repetition. (Default: 64, 0 = disabled, -1 = num_ctx)</p></td>
<td class="tableblock halign-left valign-top"><p>64</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.temperature</p></td>
<td class="tableblock halign-left valign-top"><p>The temperature of the model. Increasing the temperature will make the model answer more creatively.</p></td>
<td class="tableblock halign-left valign-top"><p>0.8</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.repeat-penalty</p></td>
<td class="tableblock halign-left valign-top"><p>Sets how strongly to penalize repetitions. A higher value (e.g., 1.5) will penalize repetitions more strongly, while a lower value (e.g., 0.9) will be more lenient.</p></td>
<td class="tableblock halign-left valign-top"><p>1.1</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.presence-penalty</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
<td class="tableblock halign-left valign-top"><p>0.0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.frequency-penalty</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
<td class="tableblock halign-left valign-top"><p>0.0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.mirostat</p></td>
<td class="tableblock halign-left valign-top"><p>Enable Mirostat sampling for controlling perplexity. (default: 0, 0 = disabled, 1 = Mirostat, 2 = Mirostat 2.0)</p></td>
<td class="tableblock halign-left valign-top"><p>0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.mirostat-tau</p></td>
<td class="tableblock halign-left valign-top"><p>Controls the balance between coherence and diversity of the output. A lower value will result in more focused and coherent text.</p></td>
<td class="tableblock halign-left valign-top"><p>5.0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.mirostat-eta</p></td>
<td class="tableblock halign-left valign-top"><p>Influences how quickly the algorithm responds to feedback from the generated text. A lower learning rate will result in slower adjustments, while a higher learning rate will make the algorithm more responsive.</p></td>
<td class="tableblock halign-left valign-top"><p>0.1</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.penalize-newline</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.stop</p></td>
<td class="tableblock halign-left valign-top"><p>Sets the stop sequences to use. When this pattern is encountered the LLM will stop generating text and return. Multiple stop patterns may be set by specifying multiple separate stop parameters in a modelfile.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.ollama.chat.tool-callbacks</p></td>
<td class="tableblock halign-left valign-top"><p>Tool Callbacks to register with the ChatModel.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

## Runtime Options

The OllamaChatOptions.java class provides model configurations, such as the model to use, the temperature, thinking mode, etc.

On start-up, the default options can be configured with the `OllamaChatModel(api, options)` constructor or the `spring.ai.ollama.chat.*` properties.

At run-time, you can override the default options by adding new, request-specific options to the `Prompt` call. For example, to override the default model and temperature for a specific request:

    ChatResponse response = chatModel.call(
        new Prompt(
            "Generate the names of 5 famous pirates.",
            OllamaChatOptions.builder()
                .model(OllamaModel.LLAMA3_1)
                .temperature(0.4)
                .build()
        ));

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
            chat:
              additional-models:
                - llama3.2
                - qwen2.5

If you want to apply the pulling strategy only to specific types of models, you can exclude chat models from the initialization task:

    spring:
      ai:
        ollama:
          init:
            pull-model-strategy: always
            chat:
              include: false

This configuration will apply the pulling strategy to all models except chat models.

## Function Calling

You can register custom Java functions with the `OllamaChatModel` and have the Ollama model intelligently choose to output a JSON object containing arguments to call one or many of the registered functions. This is a powerful technique to connect the LLM capabilities with external tools and APIs. Read more about Tool Calling.

`OllamaChatModel` does not execute tool calls internally. Tool execution must be handled externally using one of two supported approaches:

- **ChatClient with ToolCallingAdvisor** — the recommended approach for most use cases. `ToolCallingAdvisor` manages the tool-call loop transparently.

- **User-controlled tool execution** — use `ToolCallingManager` directly when you need full control over the loop.

### Tool Calling via ChatClient (Recommended)

Use `ChatClient` with `ToolCallingAdvisor` for both synchronous and streaming tool execution.

    ToolCallback weatherCallback = FunctionToolCallback.builder("getCurrentWeather", new WeatherService())
        .description("Get the weather in location")
        .inputType(WeatherService.Request.class)
        .build();

    // Synchronous
    String response = ChatClient.create(chatModel)
        .prompt()
        .user("What's the weather in Paris, Tokyo, and New York?")
        .tools(weatherCallback)
        .call()
        .content();

    // Streaming
    Flux<String> stream = ChatClient.create(chatModel)
        .prompt()
        .user("What's the weather in Paris, Tokyo, and New York?")
        .tools(weatherCallback)
        .stream()
        .content();

### User-Controlled Tool Execution

Use this pattern when you need direct access to the `ChatModel` API and want full control over the tool-call loop. Invoke `ChatModel` directly without `ToolCallingAdvisor`; check for tool calls yourself and drive the loop using `ToolCallingManager`.

    ToolCallingManager toolCallingManager = ToolCallingManager.builder().build();

    OllamaChatOptions options = OllamaChatOptions.builder()
        .toolCallbacks(ToolCallbacks.from(new WeatherService()))
        .build();

    Prompt prompt = new Prompt("What's the weather in Paris, Tokyo, and New York?", options);
    ChatResponse response = chatModel.call(prompt);

    while (response.hasToolCalls()) {
        ToolExecutionResult result = toolCallingManager.executeToolCalls(prompt, response);
        prompt = new Prompt(result.conversationHistory(), options);
        response = chatModel.call(prompt);
    }

For streaming, use `flatMap` to detect tool calls and re-stream with the updated conversation history:

    ToolCallingManager toolCallingManager = ToolCallingManager.builder().build();
    Prompt prompt = new Prompt("What's the weather in Paris, Tokyo, and New York?", options);

    String content = chatModel.stream(prompt).flatMap(response -> {
        if (response.hasToolCalls()) {
            ToolExecutionResult result = toolCallingManager.executeToolCalls(prompt, response);
            return chatModel.stream(new Prompt(result.conversationHistory(), options));
        }
        return Flux.just(response);
    })
    .mapNotNull(r -> r.getResult() != null ? r.getResult().getOutput().getText() : null)
    .collect(Collectors.joining())
    .block();

## Thinking Mode (Reasoning)

Ollama supports thinking mode for reasoning models that can emit their internal reasoning process before providing a final answer. This feature is available for models like Qwen3, DeepSeek-v3.1, DeepSeek R1, and GPT-OSS.

### Enabling Thinking Mode

Most models (Qwen3, DeepSeek-v3.1, DeepSeek R1) support simple boolean enable/disable:

    ChatResponse response = chatModel.call(
        new Prompt(
            "How many letter 'r' are in the word 'strawberry'?",
            OllamaChatOptions.builder()
                .model("qwen3")
                .enableThinking()
                .build()
        ));

    // Access the thinking process
    String thinking = response.getResult().getMetadata().get("thinking");
    String answer = response.getResult().getOutput().getText();

You can also disable thinking explicitly:

    ChatResponse response = chatModel.call(
        new Prompt(
            "What is 2+2?",
            OllamaChatOptions.builder()
                .model("deepseek-r1")
                .disableThinking()
                .build()
        ));

### Thinking Levels (GPT-OSS Only)

The GPT-OSS model requires explicit thinking levels instead of boolean values:

    // Low thinking level
    ChatResponse response = chatModel.call(
        new Prompt(
            "Generate a short headline",
            OllamaChatOptions.builder()
                .model("gpt-oss")
                .thinkLow()
                .build()
        ));

    // Medium thinking level
    ChatResponse response = chatModel.call(
        new Prompt(
            "Analyze this dataset",
            OllamaChatOptions.builder()
                .model("gpt-oss")
                .thinkMedium()
                .build()
        ));

    // High thinking level
    ChatResponse response = chatModel.call(
        new Prompt(
            "Solve this complex problem",
            OllamaChatOptions.builder()
                .model("gpt-oss")
                .thinkHigh()
                .build()
        ));

### Accessing Thinking Content

The thinking content is available in the response metadata:

    ChatResponse response = chatModel.call(
        new Prompt(
            "Calculate 17 × 23",
            OllamaChatOptions.builder()
                .model("deepseek-r1")
                .enableThinking()
                .build()
        ));

    // Get the reasoning process
    String thinking = response.getResult().getMetadata().get("thinking");
    System.out.println("Reasoning: " + thinking);
    // Output: "17 × 20 = 340, 17 × 3 = 51, 340 + 51 = 391"

    // Get the final answer
    String answer = response.getResult().getOutput().getText();
    System.out.println("Answer: " + answer);
    // Output: "The answer is 391"

### Streaming with Thinking

Thinking mode works with streaming responses as well:

    Flux<ChatResponse> stream = chatModel.stream(
        new Prompt(
            "Explain quantum entanglement",
            OllamaChatOptions.builder()
                .model("qwen3")
                .enableThinking()
                .build()
        ));

    stream.subscribe(response -> {
        String thinking = response.getResult().getMetadata().get("thinking");
        String content = response.getResult().getOutput().getText();

        if (thinking != null && !thinking.isEmpty()) {
            System.out.println("[Thinking] " + thinking);
        }
        if (content != null && !content.isEmpty()) {
            System.out.println("[Response] " + content);
        }
    });

## Multimodal

Multimodality refers to a model’s ability to simultaneously understand and process information from various sources, including text, images, audio, and other data formats.

Some of the models available in Ollama with multimodality support are LLaVA and BakLLaVA (see the full list). For further details, refer to the LLaVA: Large Language and Vision Assistant.

The Ollama Message API provides an "images" parameter to incorporate a list of base64-encoded images with the message.

Spring AI’s Message interface facilitates multimodal AI models by introducing the Media type. This type encompasses data and details regarding media attachments in messages, utilizing Spring’s `org.springframework.util.MimeType` and a `org.springframework.core.io.Resource` for the raw media data.

Below is a straightforward code example excerpted from OllamaChatModelMultimodalIT.java, illustrating the fusion of user text with an image.

    var imageResource = new ClassPathResource("/multimodal.test.png");

    var userMessage = new UserMessage("Explain what do you see on this picture?",
            new Media(MimeTypeUtils.IMAGE_PNG, this.imageResource));

    ChatResponse response = chatModel.call(new Prompt(this.userMessage,
            OllamaChatOptions.builder().model(OllamaModel.LLAVA)).build());

The example shows a model taking as an input the `multimodal.test.png` image:

along with the text message "Explain what do you see on this picture?", and generating a response like this:

    The image shows a small metal basket filled with ripe bananas and red apples. The basket is placed on a surface,
    which appears to be a table or countertop, as there's a hint of what seems like a kitchen cabinet or drawer in
    the background. There's also a gold-colored ring visible behind the basket, which could indicate that this
    photo was taken in an area with metallic decorations or fixtures. The overall setting suggests a home environment
    where fruits are being displayed, possibly for convenience or aesthetic purposes.

## Structured Outputs

Ollama provides custom Structured Outputs APIs that ensure your model generates responses conforming strictly to your provided `JSON Schema`. In addition to the existing Spring AI model-agnostic Structured Output Converter, these APIs offer enhanced control and precision.

### Two Modes for Structured Output

Ollama supports two different modes for structured output through the `format` parameter:

1.  **Simple "json" Format**: Instructs Ollama to return any valid JSON structure (unpredictable schema)

2.  **JSON Schema Format**: Instructs Ollama to return JSON conforming to a specific schema (predictable structure)

#### Simple "json" Format

Use this when you want JSON output but don’t need a specific structure:

    ChatResponse response = chatModel.call(
        new Prompt(
            "List 3 countries in Europe",
            OllamaChatOptions.builder()
                .model("llama3.2")
                .format("json")  // Any valid JSON
                .build()
        ));

The model can return any JSON structure it chooses:

    ["France", "Germany", "Italy"]
    // or
    {"countries": ["France", "Germany", "Italy"]}
    // or
    {"data": {"european_countries": ["France", "Germany", "Italy"]}}

#### JSON Schema Format (Recommended for Production)

Use this when you need a guaranteed, predictable structure:

    String jsonSchema = """
    {
        "type": "object",
        "properties": {
            "countries": {
                "type": "array",
                "items": { "type": "string" }
            }
        },
        "required": ["countries"]
    }
    """;

    ChatResponse response = chatModel.call(
        new Prompt(
            "List 3 countries in Europe",
            OllamaChatOptions.builder()
                .model("llama3.2")
                .outputSchema(jsonSchema)  // Enforced schema
                .build()
        ));

The model **must** return this exact structure:

    {"countries": ["France", "Germany", "Italy"]}

### Configuration

Spring AI allows you to configure your response format programmatically using the `OllamaChatOptions` builder.

#### Using the Chat Options Builder with JSON Schema

You can set the response format programmatically with the `OllamaChatOptions` builder:

    String jsonSchema = """
            {
                "type": "object",
                "properties": {
                    "steps": {
                        "type": "array",
                        "items": {
                            "type": "object",
                            "properties": {
                                "explanation": { "type": "string" },
                                "output": { "type": "string" }
                            },
                            "required": ["explanation", "output"],
                            "additionalProperties": false
                        }
                    },
                    "final_answer": { "type": "string" }
                },
                "required": ["steps", "final_answer"],
                "additionalProperties": false
            }
            """;

    Prompt prompt = new Prompt("how can I solve 8x + 7 = -23",
            OllamaChatOptions.builder()
                .model(OllamaModel.LLAMA3_2.getName())
                .outputSchema(jsonSchema)  // Pass JSON Schema as string
                .build());

    ChatResponse response = this.ollamaChatModel.call(this.prompt);

#### Integrating with BeanOutputConverter Utilities

You can leverage existing BeanOutputConverter utilities to automatically generate the JSON Schema from your domain objects and later convert the structured response into domain-specific instances:

    record MathReasoning(
        @JsonProperty(required = true, value = "steps") Steps steps,
        @JsonProperty(required = true, value = "final_answer") String finalAnswer) {

        record Steps(
            @JsonProperty(required = true, value = "items") Items[] items) {

            record Items(
                @JsonProperty(required = true, value = "explanation") String explanation,
                @JsonProperty(required = true, value = "output") String output) {
            }
        }
    }

    var outputConverter = new BeanOutputConverter<>(MathReasoning.class);

    Prompt prompt = new Prompt("how can I solve 8x + 7 = -23",
            OllamaChatOptions.builder()
                .model(OllamaModel.LLAMA3_2.getName())
                .outputSchema(outputConverter.getJsonSchema())  // Get JSON Schema as string
                .build());

    ChatResponse response = this.ollamaChatModel.call(this.prompt);
    String content = this.response.getResult().getOutput().getText();

    MathReasoning mathReasoning = this.outputConverter.convert(this.content);

### API Methods: `.format()` vs `.outputSchema()`

Spring AI provides two methods for configuring structured output:

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 25%" />
<col style="width: 37%" />
<col style="width: 37%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Method</th>
<th class="tableblock halign-left valign-top">Use Case</th>
<th class="tableblock halign-left valign-top">Example</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>.format("json")</code></p></td>
<td class="tableblock halign-left valign-top"><p>Simple JSON mode - any structure</p></td>
<td class="tableblock halign-left valign-top"><p><code>.format("json")</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>.outputSchema(jsonSchemaString)</code></p></td>
<td class="tableblock halign-left valign-top"><p>JSON Schema mode - enforced structure</p></td>
<td class="tableblock halign-left valign-top"><p><code>.outputSchema("{\"type\":\"object\",…​}")</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>.format(mapObject)</code></p></td>
<td class="tableblock halign-left valign-top"><p>JSON Schema mode - alternative API</p></td>
<td class="tableblock halign-left valign-top"><p><code>.format(new JsonMapper().readValue(schema, Map.class))</code></p></td>
</tr>
</tbody>
</table>

## OpenAI API Compatibility

Ollama is OpenAI API-compatible and you can use the Spring AI OpenAI client to talk to Ollama and use tools. For this, you need to configure the OpenAI base URL to your Ollama instance: `spring.ai.openai.chat.base-url=http://localhost:11434/v1` and select one of the provided Ollama models: `spring.ai.openai.chat.model=mistral`.

### Reasoning Content via OpenAI Compatibility

Ollama’s OpenAI-compatible endpoint supports the `reasoning_content` field for thinking-capable models (such as `qwen3:*-thinking`, `deepseek-r1`, `deepseek-v3.1`). When using the Spring AI OpenAI client with Ollama, the model’s reasoning process is automatically captured and made available through the response metadata.

Here’s an example of accessing reasoning content from Ollama through the OpenAI client:

    // Configure Spring AI OpenAI client to point to Ollama
    @Configuration
    class OllamaConfig {
        @Bean
        OpenAiChatModel ollamaChatModel() {
            return OpenAiChatModel.builder()
                .options(OpenAiChatOptions.builder()
                    .baseUrl("http://localhost:11434/v1")
                    .apiKey("ollama")
                    .model("deepseek-r1")  // or qwen3, deepseek-v3.1, etc.
                    .build())
                .build();
        }
    }

    // Use the model with thinking-capable models
    ChatResponse response = chatModel.call(
        new Prompt("How many letter 'r' are in the word 'strawberry'?"));

    // Access the reasoning process from metadata
    String reasoning = response.getResult().getMetadata().get("reasoningContent");
    if (reasoning != null && !reasoning.isEmpty()) {
        System.out.println("Model's reasoning process:");
        System.out.println(reasoning);
    }

    // Get the final answer
    String answer = response.getResult().getOutput().getText();
    System.out.println("Answer: " + answer);

Check the OllamaWithOpenAiChatModelIT.java tests for examples of using Ollama over Spring AI OpenAI.

## HuggingFace Models

Ollama can access, out of the box, all GGUF Hugging Face Chat Models. You can pull any of these models by name: `ollama pull hf.co/<username>/<model-repository>` or configure the auto-pulling strategy: Auto-pulling Models:

    spring.ai.ollama.chat.model=hf.co/bartowski/gemma-2-2b-it-GGUF
    spring.ai.ollama.init.pull-model-strategy=always

- `spring.ai.ollama.chat.model`: Specifies the Hugging Face GGUF model to use.

- `spring.ai.ollama.init.pull-model-strategy=always`: (optional) Enables automatic model pulling at startup time. For production, you should pre-download the models to avoid delays: `ollama pull hf.co/bartowski/gemma-2-2b-it-GGUF`.

## Sample Controller

Create a new Spring Boot project and add the `spring-ai-starter-model-ollama` to your pom (or gradle) dependencies.

Add a `application.yaml` file, under the `src/main/resources` directory, to enable and configure the Ollama chat model:

    spring:
      ai:
        ollama:
          base-url: http://localhost:11434
          chat:
            options:
              model: mistral
              temperature: 0.7

This will create an `OllamaChatModel` implementation that you can inject into your classes. Here is an example of a simple `@RestController` class that uses the chat model for text generations.

    @RestController
    public class ChatController {

        private final OllamaChatModel chatModel;

        @Autowired
        public ChatController(OllamaChatModel chatModel) {
            this.chatModel = chatModel;
        }

        @GetMapping("/ai/generate")
        public Map<String,String> generate(@RequestParam(value = "message", defaultValue = "Tell me a joke") String message) {
            return Map.of("generation", this.chatModel.call(message));
        }

        @GetMapping("/ai/generateStream")
        public Flux<ChatResponse> generateStream(@RequestParam(value = "message", defaultValue = "Tell me a joke") String message) {
            Prompt prompt = new Prompt(new UserMessage(message));
            return this.chatModel.stream(prompt);
        }

    }

## Manual Configuration

If you don’t want to use the Spring Boot auto-configuration, you can manually configure the `OllamaChatModel` in your application. The OllamaChatModel implements the `ChatModel` and `StreamingChatModel` and uses the Low-level OllamaApi Client to connect to the Ollama service.

To use it, add the `spring-ai-ollama` dependency to your project’s Maven `pom.xml` or Gradle `build.gradle` build files:

Next, create an `OllamaChatModel` instance and use it to send requests for text generation:

    var ollamaApi = OllamaApi.builder().build();

    var chatModel = OllamaChatModel.builder()
                        .ollamaApi(ollamaApi)
                        .options(
                            OllamaChatOptions.builder()
                                .model(OllamaModel.MISTRAL)
                                .temperature(0.9)
                                .build())
                        .build();

    ChatResponse response = this.chatModel.call(
        new Prompt("Generate the names of 5 famous pirates."));

    // Or with streaming responses
    Flux<ChatResponse> response = this.chatModel.stream(
        new Prompt("Generate the names of 5 famous pirates."));

The `OllamaChatOptions` provides the configuration information for all chat requests.

## Low-level OllamaApi Client

The OllamaApi provides a lightweight Java client for the Ollama Chat Completion API Ollama Chat Completion API.

The following class diagram illustrates the `OllamaApi` chat interfaces and building blocks:

Here is a simple snippet showing how to use the API programmatically:

    OllamaApi ollamaApi = new OllamaApi("YOUR_HOST:YOUR_PORT");

    // Sync request
    var request = ChatRequest.builder("orca-mini")
        .stream(false) // not streaming
        .messages(List.of(
                Message.builder(Role.SYSTEM)
                    .content("You are a geography teacher. You are talking to a student.")
                    .build(),
                Message.builder(Role.USER)
                    .content("What is the capital of Bulgaria and what is the size? "
                            + "What is the national anthem?")
                    .build()))
        .options(OllamaChatOptions.builder().temperature(0.9).build())
        .build();

    ChatResponse response = this.ollamaApi.chat(this.request);

    // Streaming request
    var request2 = ChatRequest.builder("orca-mini")
        .ttream(true) // streaming
        .messages(List.of(Message.builder(Role.USER)
            .content("What is the capital of Bulgaria and what is the size? " + "What is the national anthem?")
            .build()))
        .options(OllamaChatOptions.builder().temperature(0.9).build().toMap())
        .build();

    Flux<ChatResponse> streamingResponse = this.ollamaApi.streamingChat(this.request2);

NVIDIA Perplexity AI

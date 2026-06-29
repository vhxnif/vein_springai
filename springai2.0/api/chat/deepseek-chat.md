Search

# DeepSeek Chat

Spring AI supports the various AI language models from DeepSeek. You can interact with DeepSeek language models and create a multilingual conversational assistant based on DeepSeek models.

## Prerequisites

You will need to create an API key with DeepSeek to access DeepSeek language models.

Create an account at DeepSeek registration page and generate a token on the API Keys page.

The Spring AI project defines a configuration property named `spring.ai.deepseek.api-key` that you should set to the value of the `API Key` obtained from the API Keys page.

You can set this configuration property in your `application.properties` file:

    spring.ai.deepseek.api-key=<your-deepseek-api-key>

For enhanced security when handling sensitive information like API keys, you can use Spring Expression Language (SpEL) to reference a custom environment variable:

    # In application.yml
    spring:
      ai:
        deepseek:
          api-key: ${DEEPSEEK_API_KEY}

    # In your environment or .env file
    export DEEPSEEK_API_KEY=<your-deepseek-api-key>

You can also set this configuration programmatically in your application code:

    // Retrieve API key from a secure source or environment variable
    String apiKey = System.getenv("DEEPSEEK_API_KEY");

### Add Repositories and BOM

Spring AI artifacts are published in the Spring Milestone and Snapshot repositories. Refer to the Artifact Repositories section to add these repositories to your build system.

To help with dependency management, Spring AI provides a BOM (bill of materials) to ensure that a consistent version of Spring AI is used throughout your entire project. Refer to the Dependency Management section to add the Spring AI BOM to your build system.

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the DeepSeek Chat Model. To enable it, add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-deepseek</artifactId>
    </dependency>

or to your Gradle `build.gradle` file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-model-deepseek'
    }

### Chat Properties

#### Retry Properties

The prefix `spring.ai.retry` is used as the property prefix that lets you configure the retry mechanism for the DeepSeek Chat model.

<table class="tableblock frame-all grid-all stretch">
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
<td class="tableblock halign-left valign-top"><p>If false, throws a NonTransientAiException, and does not attempt a retry for <code>4xx</code> client error codes</p></td>
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

The prefix `spring.ai.deepseek` is used as the property prefix that lets you connect to DeepSeek.

<table class="tableblock frame-all grid-all stretch">
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
<td class="tableblock halign-left valign-top"><p>spring.ai.deepseek.base-url</p></td>
<td class="tableblock halign-left valign-top"><p>The URL to connect to</p></td>
<td class="tableblock halign-left valign-top"><p><code>https://api.deepseek.com</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.deepseek.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>The API Key</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

#### Configuration Properties

The prefix `spring.ai.deepseek.chat` is the property prefix that lets you configure the chat model implementation for DeepSeek.

<table class="tableblock frame-all grid-all stretch">
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
<td class="tableblock halign-left valign-top"><p>spring.ai.deepseek.chat.enabled (Removed and no longer valid)</p></td>
<td class="tableblock halign-left valign-top"><p>Enables the DeepSeek chat model.</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.model.chat</p></td>
<td class="tableblock halign-left valign-top"><p>Enable DeepSeek chat model.</p></td>
<td class="tableblock halign-left valign-top"><p>deepseek</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.deepseek.chat.base-url</p></td>
<td class="tableblock halign-left valign-top"><p>Optionally overrides the spring.ai.deepseek.base-url to provide a chat-specific URL</p></td>
<td class="tableblock halign-left valign-top"><p><code>https://api.deepseek.com/</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.deepseek.chat.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>Optionally overrides the spring.ai.deepseek.api-key to provide a chat-specific API key</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.deepseek.chat.completions-path</p></td>
<td class="tableblock halign-left valign-top"><p>The path to the chat completions endpoint</p></td>
<td class="tableblock halign-left valign-top"><p><code>/chat/completions</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.deepseek.chat.beta-prefix-path</p></td>
<td class="tableblock halign-left valign-top"><p>The prefix path to the beta feature endpoint</p></td>
<td class="tableblock halign-left valign-top"><p><code>/beta</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.deepseek.chat.model</p></td>
<td class="tableblock halign-left valign-top"><p>ID of the model to use. You can use deepseek-v4-flash, deepseek-v4-pro, deepseek-chat or deepseek-reasoner.</p></td>
<td class="tableblock halign-left valign-top"><p>deepseek-v4-flash</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.deepseek.chat.frequency-penalty</p></td>
<td class="tableblock halign-left valign-top"><p>Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model’s likelihood to repeat the same line verbatim.</p></td>
<td class="tableblock halign-left valign-top"><p>0.0f</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.deepseek.chat.max-tokens</p></td>
<td class="tableblock halign-left valign-top"><p>The maximum number of tokens to generate in the chat completion. The total length of input tokens and generated tokens is limited by the model’s context length.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.deepseek.chat.presence-penalty</p></td>
<td class="tableblock halign-left valign-top"><p>Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model’s likelihood to talk about new topics.</p></td>
<td class="tableblock halign-left valign-top"><p>0.0f</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.deepseek.chat.stop</p></td>
<td class="tableblock halign-left valign-top"><p>Up to 4 sequences where the API will stop generating further tokens.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.deepseek.chat.temperature</p></td>
<td class="tableblock halign-left valign-top"><p>Which sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p, but not both.</p></td>
<td class="tableblock halign-left valign-top"><p>1.0F</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.deepseek.chat.top-p</p></td>
<td class="tableblock halign-left valign-top"><p>An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or temperature, but not both.</p></td>
<td class="tableblock halign-left valign-top"><p>1.0F</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.deepseek.chat.logprobs</p></td>
<td class="tableblock halign-left valign-top"><p>Whether to return log probabilities of the output tokens or not. If true, returns the log probabilities of each output token returned in the content of the message.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.deepseek.chat.top-logprobs</p></td>
<td class="tableblock halign-left valign-top"><p>An integer between 0 and 20 specifying the number of most likely tokens to return at each token position, each with an associated log probability. logprobs must be set to true if this parameter is used.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.deepseek.chat.tool-callbacks</p></td>
<td class="tableblock halign-left valign-top"><p>Tool Callbacks to register with the ChatModel.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

## Runtime Options

The DeepSeekChatOptions.java provides model configurations, such as the model to use, the temperature, the frequency penalty, etc.

On startup, the default options can be configured with the `DeepSeekChatModel(api, options)` constructor or the `spring.ai.deepseek.chat.*` properties.

At runtime, you can override the default options by adding new, request-specific options to the `Prompt` call. For example, to override the default model and temperature for a specific request:

    ChatResponse response = chatModel.call(
        new Prompt(
            "Generate the names of 5 famous pirates. Please provide the JSON response without any code block markers such as ```json```.",
            DeepSeekChatOptions.builder()
                .withModel(DeepSeekApi.ChatModel.DEEPSEEK_V4_PRO.getValue())
                .withTemperature(0.8f)
            .build()
        ));

## Sample Controller (Auto-configuration)

Create a new Spring Boot project and add the `spring-ai-starter-model-deepseek` to your pom (or gradle) dependencies.

Add an `application.properties` file under the `src/main/resources` directory to enable and configure the DeepSeek Chat model:

    spring.ai.deepseek.api-key=YOUR_API_KEY
    spring.ai.deepseek.chat.model=deepseek-v4-pro
    spring.ai.deepseek.chat.temperature=0.8

This will create a `DeepSeekChatModel` implementation that you can inject into your class. Here is an example of a simple `@Controller` class that uses the chat model for text generation.

    @RestController
    public class ChatController {

        private final DeepSeekChatModel chatModel;

        @Autowired
        public ChatController(DeepSeekChatModel chatModel) {
            this.chatModel = chatModel;
        }

        @GetMapping("/ai/generate")
        public Map generate(@RequestParam(value = "message", defaultValue = "Tell me a joke") String message) {
            return Map.of("generation", chatModel.call(message));
        }

        @GetMapping("/ai/generateStream")
        public Flux<ChatResponse> generateStream(@RequestParam(value = "message", defaultValue = "Tell me a joke") String message) {
            var prompt = new Prompt(new UserMessage(message));
            return chatModel.stream(prompt);
        }
    }

## Tool Calling

You can register custom Java functions with the `DeepSeekChatModel` and have the DeepSeek model intelligently choose to output a JSON object containing arguments to call one or many of the registered functions. This is a powerful technique to connect the LLM capabilities with external tools and APIs. Read more about Tool Calling.

`DeepSeekChatModel` does not execute tool calls internally. Tool execution must be handled externally using one of two supported approaches:

- **ChatClient with ToolCallingAdvisor** — the recommended approach for most use cases. `ToolCallingAdvisor` is automatically registered when tools are present and manages the tool-call loop transparently.

- **User-controlled tool execution** — use `DefaultToolCallingManager` directly when you need full control over the loop (for example, when combining tool calling with direct `ChatModel` access).

### Tool Calling via ChatClient (Recommended)

Use `ChatClient` for both synchronous and streaming tool execution. `ToolCallingAdvisor` is auto-registered when tools are present, so no explicit advisor configuration is required.

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

    DeepSeekChatOptions options = DeepSeekChatOptions.builder()
        .toolCallbacks(ToolCallbacks.from(new WeatherService()))
        .build();

    Prompt prompt = new Prompt("What's the weather in Paris, Tokyo, and New York?", options);
    ChatResponse response = chatModel.call(prompt);

    while (response.hasToolCalls()) {
        ToolExecutionResult result = toolCallingManager.executeToolCalls(prompt, response);
        prompt = new Prompt(result.conversationHistory(), options);
        response = chatModel.call(prompt);
    }

For streaming, aggregate each streaming response with `MessageAggregator` to detect tool calls across chunks:

    AtomicReference<ChatResponse> aggregatedRef = new AtomicReference<>();
    new MessageAggregator()
        .aggregate(chatModel.stream(prompt), aggregatedRef::set)
        .collectList().block();

    while (aggregatedRef.get().hasToolCalls()) {
        ToolExecutionResult result = toolCallingManager.executeToolCalls(prompt, aggregatedRef.get());
        prompt = new Prompt(result.conversationHistory(), options);
        aggregatedRef.set(null);
        new MessageAggregator()
            .aggregate(chatModel.stream(prompt), aggregatedRef::set)
            .collectList().block();
    }

    String content = aggregatedRef.get().getResult().getOutput().getText();

## Chat Prefix Completion

The chat prefix completion follows the Chat Completion API, where users provide an assistant’s prefix message for the model to complete the rest of the message.

When using prefix completion, the user must ensure that the last message in the messages list is a DeepSeekAssistantMessage.

Below is a complete Java code example for chat prefix completion. In this example, we set the prefix message of the assistant to "\`\`\`python\n" to force the model to output Python code, and set the stop parameter to \[‘\`’\] to prevent additional explanations from the model.

    @RestController
    public class CodeGenerateController {

        private final DeepSeekChatModel chatModel;

        @Autowired
        public ChatController(DeepSeekChatModel chatModel) {
            this.chatModel = chatModel;
        }

        @GetMapping("/ai/generatePythonCode")
        public String generate(@RequestParam(value = "message", defaultValue = "Please write quick sort code") String message) {
            UserMessage userMessage = new UserMessage(message);
            Message assistantMessage = DeepSeekAssistantMessage.builder().content("```python\\n").prefix(true).build();
            Prompt prompt = new Prompt(List.of(userMessage, assistantMessage), ChatOptions.builder().stopSequences(List.of("```")).build());
            ChatResponse response = chatModel.call(prompt);
            return response.getResult().getOutput().getText();
        }
    }

## Reasoning support

You can use the `DeepSeekAssistantMessage` to get the CoT content generated by models supporting that feature.

    public void deepSeekReasoningExample() {
        DeepSeekChatOptions promptOptions = DeepSeekChatOptions.builder()
                .build();
        Prompt prompt = new Prompt("9.11 and 9.8, which is greater?", promptOptions);
        ChatResponse response = chatModel.call(prompt);

        // Get the CoT content generated by the model
        DeepSeekAssistantMessage deepSeekAssistantMessage = (DeepSeekAssistantMessage) response.getResult().getOutput();
        String reasoningContent = deepSeekAssistantMessage.getReasoningContent();
        String text = deepSeekAssistantMessage.getText();
    }

## Reasoning Model Multi-round Conversation

In each round of the conversation, the model outputs the CoT (`reasoning_content`) and the final answer (`content`). In the next round of the conversation, the CoT from previous rounds is not concatenated into the context, as illustrated in the following diagram:

## Manual Configuration

The DeepSeekChatModel implements the `ChatModel` and `StreamingChatModel` and uses the Low-level DeepSeekApi Client to connect to the DeepSeek service.

Add the `spring-ai-deepseek` dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-deepseek</artifactId>
    </dependency>

or to your Gradle `build.gradle` file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-deepseek'
    }

Next, create a `DeepSeekChatModel` and use it for text generation:

    DeepSeekApi deepSeekApi = DeepSeekApi.builder()
            .apiKey(System.getenv("DEEPSEEK_API_KEY"))
            .build();
    DeepSeekChatOptions options = DeepSeekChatOptions.builder()
            .model(DeepSeekApi.ChatModel.DEEPSEEK_V4_PRO.getValue())
            .temperature(0.4)
            .maxTokens(200)
            .build();
    DeepSeekChatModel chatModel = DeepSeekChatModel.builder()
            .deepSeekApi(deepSeekApi)
            .options(options)
            .build();
    ChatResponse response = chatModel.call(
        new Prompt("Generate the names of 5 famous pirates."));

    // Or with streaming responses
    Flux<ChatResponse> streamResponse = chatModel.stream(
        new Prompt("Generate the names of 5 famous pirates."));

The `DeepSeekChatOptions` provides the configuration information for the chat requests. The `DeepSeekChatOptions.Builder` is a fluent options builder.

### Low-level DeepSeekApi Client

The DeepSeekApi is a lightweight Java client for DeepSeek API.

Here is a simple snippet showing how to use the API programmatically:

    DeepSeekApi deepSeekApi =
        new DeepSeekApi(System.getenv("DEEPSEEK_API_KEY"));

    ChatCompletionMessage chatCompletionMessage =
        new ChatCompletionMessage("Hello world", Role.USER);

    // Sync request
    ResponseEntity<ChatCompletion> response = deepSeekApi.chatCompletionEntity(
        new ChatCompletionRequest(List.of(chatCompletionMessage), DeepSeekApi.ChatModel.DEEPSEEK_V4_FLASH.getValue(), 0.7, false));

    // Streaming request
    Flux<ChatCompletionChunk> streamResponse = deepSeekApi.chatCompletionStream(
        new ChatCompletionRequest(List.of(chatCompletionMessage), DeepSeekApi.ChatModel.DEEPSEEK_V4_FLASH.getValue(), 0.7, true));

Follow the DeepSeekApi.java's JavaDoc for further information.

#### DeepSeekApi Samples

- The DeepSeekApiIT.java test provides some general examples of how to use the lightweight library.

Azure OpenAI Docker Model Runner

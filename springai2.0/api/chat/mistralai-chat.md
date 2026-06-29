Search

# Mistral AI Chat

Spring AI supports the various AI language models from Mistral AI. You can interact with Mistral AI language models and create a multilingual conversational assistant based on Mistral models.

## Prerequisites

You will need to create an API with Mistral AI to access Mistral AI language models.

Create an account at Mistral AI registration page and generate the token on the API Keys page.

The Spring AI project defines a configuration property named `spring.ai.mistralai.api-key` that you should set to the value of the `API Key` obtained from console.mistral.ai.

You can set this configuration property in your `application.properties` file:

    spring.ai.mistralai.api-key=<your-mistralai-api-key>

For enhanced security when handling sensitive information like API keys, you can use Spring Expression Language (SpEL) to reference a custom environment variable:

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

Spring AI provides Spring Boot auto-configuration for the Mistral AI Chat Client. To enable it add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-mistral-ai</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-model-mistral-ai'
    }

### Chat Properties

#### Retry Properties

The prefix `spring.ai.retry` is used as the property prefix that lets you configure the retry mechanism for the Mistral AI chat model.

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

The prefix `spring.ai.mistralai` is used as the property prefix that lets you connect to OpenAI.

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

The prefix `spring.ai.mistralai.chat` is the property prefix that lets you configure the chat model implementation for Mistral AI.

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
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.chat.enabled (Removed and no longer valid)</p></td>
<td class="tableblock halign-left valign-top"><p>Enable Mistral AI chat model.</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.model.chat</p></td>
<td class="tableblock halign-left valign-top"><p>Enable Mistral AI chat model.</p></td>
<td class="tableblock halign-left valign-top"><p>mistral</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.chat.base-url</p></td>
<td class="tableblock halign-left valign-top"><p>Optional override for the <code>spring.ai.mistralai.base-url</code> property to provide chat-specific URL.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.chat.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>Optional override for the <code>spring.ai.mistralai.api-key</code> to provide chat-specific API Key.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.chat.model</p></td>
<td class="tableblock halign-left valign-top"><p>This is the Mistral AI Chat model to use</p></td>
<td class="tableblock halign-left valign-top"><p><code>open-mistral-7b</code>, <code>open-mixtral-8x7b</code>, <code>open-mixtral-8x22b</code>, <code>mistral-small-latest</code>, <code>mistral-large-latest</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.chat.temperature</p></td>
<td class="tableblock halign-left valign-top"><p>The sampling temperature to use that controls the apparent creativity of generated completions. Higher values will make output more random while lower values will make results more focused and deterministic. It is not recommended to modify <code>temperature</code> and <code>top_p</code> for the same completions request as the interaction of these two settings is difficult to predict.</p></td>
<td class="tableblock halign-left valign-top"><p>0.8</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.chat.max-tokens</p></td>
<td class="tableblock halign-left valign-top"><p>The maximum number of tokens to generate in the chat completion. The total length of input tokens and generated tokens is limited by the model’s context length.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.chat.safe-prompt</p></td>
<td class="tableblock halign-left valign-top"><p>Indicates whether to inject a security prompt before all conversations.</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.chat.random-seed</p></td>
<td class="tableblock halign-left valign-top"><p>This feature is in Beta. If specified, our system will make a best effort to sample deterministically, such that repeated requests with the same seed and parameters should return the same result.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.chat.stop</p></td>
<td class="tableblock halign-left valign-top"><p>Stop generation if this token is detected. Or if one of these tokens is detected when providing an array.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.chat.top-p</p></td>
<td class="tableblock halign-left valign-top"><p>An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or <code>temperature</code> but not both.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.chat.response-format</p></td>
<td class="tableblock halign-left valign-top"><p>An object specifying the format that the model must output. Setting to <code>{ "type": "json_object" }</code> enables JSON mode, which guarantees the message the model generates is valid JSON. Setting to <code>{ "type": "json_schema" }</code> with a supplied schema enables native structured outputs, which guarantees the model will match your supplied JSON schema. See the Structured Output section for more details.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.chat.reasoning-effort</p></td>
<td class="tableblock halign-left valign-top"><p>Controls the reasoning effort level for adjustable reasoning models. Valid values include <code>high</code> or <code>none</code>.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.chat.tools</p></td>
<td class="tableblock halign-left valign-top"><p>A list of tools the model may call. Currently, only functions are supported as a tool. Use this to provide a list of functions the model may generate JSON inputs for.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.chat.tool-choice</p></td>
<td class="tableblock halign-left valign-top"><p>Controls which (if any) function is called by the model. <code>none</code> means the model will not call a function and instead generates a message. <code>auto</code> means the model can pick between generating a message or calling a function. Specifying a particular function via <code>{"type: "function", "function": {"name": "my_function"}}</code> forces the model to call that function. <code>none</code> is the default when no functions are present. <code>auto</code> is the default if functions are present.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.chat.tool-callbacks</p></td>
<td class="tableblock halign-left valign-top"><p>Tool Callbacks to register with the ChatModel.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

## Runtime Options

The MistralAiChatOptions.java provides model configurations, such as the model to use, the temperature, the frequency penalty, etc.

On start-up, the default options can be configured with the `MistralAiChatModel(api, options)` constructor or the `spring.ai.mistralai.chat.*` properties.

At run-time, you can override the default options by adding new, request-specific options to the `Prompt` call. For example, to override the default model and temperature for a specific request:

    ChatResponse response = chatModel.call(
        new Prompt(
            "Generate the names of 5 famous pirates.",
            MistralAiChatOptions.builder()
                .model(MistralAiApi.ChatModel.MISTRAL_LARGE.getValue())
                .temperature(0.5)
            .build()
        ));

## Function Calling

You can register custom Java functions with the `MistralAiChatModel` and have the Mistral AI model intelligently choose to output a JSON object containing arguments to call one or many of the registered functions. This is a powerful technique to connect the LLM capabilities with external tools and APIs. Read more about Tool Calling.

`MistralAiChatModel` does not execute tool calls internally. Tool execution must be handled externally using one of two supported approaches:

- **ChatClient with ToolCallingAdvisor** — the recommended approach for most use cases. `ToolCallingAdvisor` is automatically registered and manages the tool-call loop transparently.

- **User-controlled tool execution** — use `DefaultToolCallingManager` directly when you need full control over the loop.

### Tool Calling via ChatClient (Recommended)

Use `ChatClient` with `ToolCallingAdvisor` for both synchronous and streaming tool execution. `ToolCallingAdvisor` is auto-registered when tools are present, so no explicit advisor configuration is required.

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

    MistralAiChatOptions options = MistralAiChatOptions.builder()
        .toolCallbacks(ToolCallbacks.from(new WeatherService()))
        .build();

    Prompt prompt = new Prompt("What's the weather in Paris, Tokyo, and New York?", options);
    ChatResponse response = chatModel.call(prompt);

    while (response.hasToolCalls()) {
        ToolExecutionResult result = toolCallingManager.executeToolCalls(prompt, response);
        prompt = new Prompt(result.conversationHistory(), options);
        response = chatModel.call(prompt);
    }

## Structured Output

Mistral AI supports native structured outputs through JSON Schema, ensuring the model generates responses that strictly conform to your specified structure. This feature is available for Mistral Small and later models.

### Using ChatClient with Native Structured Output

The simplest way to use structured output is with the `ChatClient` high-level API and the `ENABLE_NATIVE_STRUCTURED_OUTPUT` advisor:

    record ActorsFilms(String actor, List<String> movies) {}

    ActorsFilms actorsFilms = ChatClient.create(chatModel).prompt()
        .advisors(AdvisorParams.ENABLE_NATIVE_STRUCTURED_OUTPUT)
        .user("Generate the filmography of 5 movies for Tom Hanks.")
        .call()
        .entity(ActorsFilms.class);

This approach automatically: - Generates a JSON schema from your Java class - Configures the model to use native structured output - Parses the response into your specified type

### Using ResponseFormat Directly

For more control, you can use the `ResponseFormat` class with `MistralAiChatOptions`:

    record MovieRecommendation(String title, String director, int year, String plotSummary) {}

    var options = MistralAiChatOptions.builder()
        .model(MistralAiApi.ChatModel.MISTRAL_SMALL.getValue())
        .responseFormat(ResponseFormat.jsonSchema(MovieRecommendation.class))
        .build();

    ChatResponse response = chatModel.call(
        new Prompt("Recommend a classic science fiction movie.", options));

The `ResponseFormat` class provides several factory methods:

- `ResponseFormat.text()` - Returns plain text output (default)

- `ResponseFormat.jsonObject()` - Returns valid JSON (no schema enforcement)

- `ResponseFormat.jsonSchema(Class<?>)` - Generates schema from a Java class

- `ResponseFormat.jsonSchema(String)` - Uses a JSON schema string

- `ResponseFormat.jsonSchema(Map)` - Uses a JSON schema map

### JSON Mode vs Structured Output

Mistral AI supports two JSON-related modes:

- **JSON Mode** (`json_object`): Guarantees valid JSON output, but doesn’t enforce a specific structure

- **Structured Output** (`json_schema`): Guarantees output matching your JSON schema

    // JSON Mode - any valid JSON
    var jsonMode = MistralAiChatOptions.builder()
        .responseFormat(ResponseFormat.jsonObject())
        .build();

    // Structured Output - specific schema enforced
    var structuredOutput = MistralAiChatOptions.builder()
        .responseFormat(ResponseFormat.jsonSchema(MyClass.class))
        .build();

For more information about structured outputs, see the Structured Output Converter documentation.

## Reasoning Models

Mistral offers two approaches to reasoning:

- Adjustable: Available on Mistral Small 4 and Mistral Medium 3.5 via the `reasoning_effort` parameter. Enables the model to think to varying degrees.

- Native: Available for the Magistral model family. These models always generate reasoning traces and are purpose-built for deep reasoning tasks.

### Reasoning Effort

You can configure the reasoning effort using the `reasoningEffort` property in `MistralAiChatOptions`. This allows you to adjust the amount of computational effort the model spends on reasoning before generating a response.

    var options = MistralAiChatOptions.builder()
        .model(MistralAiApi.ChatModel.MISTRAL_SMALL.getValue()) // Or any adjustable reasoning model
        .reasoningEffort(MistralAiApi.ChatCompletionRequest.ReasoningEffort.HIGH)
        .build();

    ChatResponse response = chatModel.call(
        new Prompt("Solve this complex math problem...", options));

### Reasoning Content

Mistral reasoning models expose their internal chain of thought and references. Spring AI maps these from the API responses to the message metadata.

You can access the following metadata keys from the `AssistantMessage`:

- `reference_content`: The unique keys linking model responses to their source documents for traceability and citations.

- `thinking_content`: The step-by-step reasoning process the model used to arrive at its final answer (accessible only for reasoning models).

- `reference_thinking_content`: The unique keys linking the model’s reasoning steps to their source documents for traceability and citations (possibly accessible only for reasoning models).

    ChatResponse response = chatModel.call(new Prompt("Solve this complex math problem..."));

    AssistantMessage message = response.getResult().getOutput();

    // Access the thinking content from metadata
    String thinking = (String) message.getMetadata().get(MistralAiChatModel.THINKING_CONTENT_METADATA);
    if (thinking != null && !thinking.isEmpty()) {
        System.out.println("Model's thinking process:");
        System.out.println(thinking);
    }

## Multimodal

Multimodality refers to a model’s ability to simultaneously understand and process information from various sources, including text, images, audio, and other data formats. Mistral AI supports text and vision modalities.

### Vision

Mistral AI models offer vision multimodal support. Refer to the Vision guide for more information.

The Mistral AI User Message API can incorporate a list of base64-encoded images or image urls with the message. Spring AI’s Message interface facilitates multimodal AI models by introducing the Media type. This type encompasses data and details regarding media attachments in messages, utilizing Spring’s `org.springframework.util.MimeType` and a `org.springframework.core.io.Resource` for the raw media data.

Below is a code example excerpted from `MistralAiChatModelIT.java`, illustrating the fusion of user text with an image.

    var imageResource = new ClassPathResource("/multimodal.test.png");

    var userMessage = new UserMessage("Explain what do you see on this picture?",
            new Media(MimeTypeUtils.IMAGE_PNG, this.imageResource));

    ChatResponse response = chatModel.call(new Prompt(this.userMessage,
            ChatOptions.builder().model(MistralAiApi.ChatModel.MISTRAL_LARGE.getValue()).build()));

or the image URL equivalent:

    var userMessage = new UserMessage("Explain what do you see on this picture?",
            new Media(MimeTypeUtils.IMAGE_PNG,
                    URI.create("https://docs.spring.io/spring-ai/reference/_images/multimodal.test.png")));

    ChatResponse response = chatModel.call(new Prompt(this.userMessage,
            ChatOptions.builder().model(MistralAiApi.ChatModel.MISTRAL_LARGE.getValue()).build()));

The example shows a model taking as an input the `multimodal.test.png` image:

along with the text message "Explain what do you see on this picture?", and generating a response like this:

    This is an image of a fruit bowl with a simple design. The bowl is made of metal with curved wire edges that
    create an open structure, allowing the fruit to be visible from all angles. Inside the bowl, there are two
    yellow bananas resting on top of what appears to be a red apple. The bananas are slightly overripe, as
    indicated by the brown spots on their peels. The bowl has a metal ring at the top, likely to serve as a handle
    for carrying. The bowl is placed on a flat surface with a neutral-colored background that provides a clear
    view of the fruit inside.

## OpenAI API Compatibility

Mistral is OpenAI API-compatible and you can use the Spring AI OpenAI client to talk to Mistrial. For this, you need to configure the OpenAI base URL to the Mistral AI platform: `spring.ai.openai.chat.base-url=https://api.mistral.ai/v1`, and select a Mistral model: `spring.ai.openai.chat.model=mistral-small-latest` and set the Mistral AI API key: `spring.ai.openai.chat.api-key=<YOUR MISTRAL API KEY`.

Check the MistralWithOpenAiChatModelIT.java tests for examples of using Mistral over Spring AI OpenAI.

## Sample Controller (Auto-configuration)

Create a new Spring Boot project and add the `spring-ai-starter-model-mistral-ai` to your pom (or gradle) dependencies.

Add a `application.properties` file under the `src/main/resources` directory to enable and configure the Mistral AI chat model:

    spring.ai.mistralai.api-key=YOUR_API_KEY
    spring.ai.mistralai.chat.model=mistral-small-latest
    spring.ai.mistralai.chat.temperature=0.7

This will create a `MistralAiChatModel` implementation that you can inject into your classes. Here is an example of a simple `@RestController` class that uses the chat model for text generations.

    @RestController
    public class ChatController {

        private final MistralAiChatModel chatModel;

        @Autowired
        public ChatController(MistralAiChatModel chatModel) {
            this.chatModel = chatModel;
        }

        @GetMapping("/ai/generate")
        public Map<String,String> generate(@RequestParam(value = "message", defaultValue = "Tell me a joke") String message) {
            return Map.of("generation", this.chatModel.call(message));
        }

        @GetMapping("/ai/generateStream")
        public Flux<ChatResponse> generateStream(@RequestParam(value = "message", defaultValue = "Tell me a joke") String message) {
            var prompt = new Prompt(new UserMessage(message));
            return this.chatModel.stream(prompt);
        }
    }

## Manual Configuration

The MistralAiChatModel implements the `ChatModel` and `StreamingChatModel` and uses the Low-level MistralAiApi Client to connect to the Mistral AI service.

Add the `spring-ai-mistral-ai` dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-mistral-ai</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-mistral-ai'
    }

Next, create a `MistralAiChatModel` and use it for text generations:

    var mistralAiApi = new MistralAiApi(System.getenv("MISTRAL_AI_API_KEY"));

    var chatModel = new MistralAiChatModel(this.mistralAiApi, MistralAiChatOptions.builder()
                    .model(MistralAiApi.ChatModel.MISTRAL_LARGE.getValue())
                    .temperature(0.4)
                    .maxTokens(200)
                    .build());

    ChatResponse response = this.chatModel.call(
        new Prompt("Generate the names of 5 famous pirates."));

    // Or with streaming responses
    Flux<ChatResponse> response = this.chatModel.stream(
        new Prompt("Generate the names of 5 famous pirates."));

The `MistralAiChatOptions` provides the configuration information for the chat requests. The `MistralAiChatOptions.Builder` is a fluent options-builder.

### Low-level MistralAiApi Client

The MistralAiApi provides is lightweight Java client for Mistral AI API.

Here is a simple snippet showing how to use the API programmatically:

    MistralAiApi mistralAiApi = new MistralAiApi(System.getenv("MISTRAL_AI_API_KEY"));

    ChatCompletionMessage chatCompletionMessage =
        new ChatCompletionMessage("Hello world", Role.USER);

    // Sync request
    ResponseEntity<ChatCompletion> response = this.mistralAiApi.chatCompletionEntity(
        new ChatCompletionRequest(List.of(this.chatCompletionMessage), MistralAiApi.ChatModel.MISTRAL_LARGE.getValue(), 0.8, false));

    // Streaming request
    Flux<ChatCompletionChunk> streamResponse = this.mistralAiApi.chatCompletionStream(
            new ChatCompletionRequest(List.of(this.chatCompletionMessage), MistralAiApi.ChatModel.MISTRAL_LARGE.getValue(), 0.8, true));

Follow the MistralAiApi.java's JavaDoc for further information.

#### MistralAiApi Samples

- The MistralAiApiIT.java tests provide some general examples of how to use the lightweight library.

- The PaymentStatusFunctionCallingIT.java tests show how to use the low-level API to call tool functions. Based on the Mistral AI Function Calling tutorial.

## Mistral AI OCR

Spring AI supports Optical Character Recognition (OCR) with Mistral AI. This allows you to extract text and image data from documents.

## Prerequisites

You will need to create an API with Mistral AI to access Mistral AI language models. Create an account at Mistral AI registration page and generate the token on the API Keys page.

### Add Dependencies

To use the Mistral AI OCR API, you will need to add the `spring-ai-mistral-ai` dependency to your project.

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-mistral-ai</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-mistral-ai'
    }

### Low-level MistralOcrApi Client

The MistralOcrApi provides a lightweight Java client for Mistral AI OCR API.

Here is a simple snippet showing how to use the API programmatically:

    MistralOcrApi mistralAiApi = new MistralOcrApi(System.getenv("MISTRAL_AI_API_KEY"));

    String documentUrl = "https://arxiv.org/pdf/2201.04234";
    MistralOcrApi.OCRRequest request = new MistralOcrApi.OCRRequest(
            MistralOcrApi.OCRModel.MISTRAL_OCR_LATEST.getValue(), "test_id",
            new MistralOcrApi.OCRRequest.DocumentURLChunk(documentUrl), List.of(0, 1, 2), true, 5, 50);

    ResponseEntity<MistralOcrApi.OCRResponse> response = mistralAiApi.ocr(request);

Follow the MistralOcrApi.java's JavaDoc for further information.

#### MistralOcrApi Sample

- The MistralOcrApiIT.java tests provide some general examples of how to use the lightweight library.

Groq MiniMax

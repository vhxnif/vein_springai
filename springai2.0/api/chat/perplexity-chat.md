Search

# Perplexity Chat

Perplexity AI provides a unique AI service that integrates its language models with real-time search capabilities. It offers a variety of models and supports streaming responses for conversational AI.

Spring AI integrates with Perplexity AI by reusing the existing OpenAI client. To get started, you’ll need to obtain a Perplexity API Key, configure the base URL, and select one of the supported models.

Check the PerplexityWithOpenAiChatModelIT.java tests for examples of using Perplexity with Spring AI.

## Prerequisites

- **Create an API Key**: Visit here to create an API Key. Configure it using the `spring.ai.openai.api-key` property in your Spring AI project.

- **Set the Perplexity Base URL**: Set the `spring.ai.openai.base-url` property to `https://api.perplexity.ai`.

- **Select a Perplexity Model**: Use the `spring.ai.openai.chat.model=<model name>` property to specify the model. Refer to Supported Models for available options.

You can set these configuration properties in your `application.properties` file:

    spring.ai.openai.api-key=<your-perplexity-api-key>
    spring.ai.openai.base-url=https://api.perplexity.ai
    spring.ai.openai.chat.model=llama-3.1-sonar-small-128k-online

For enhanced security when handling sensitive information like API keys, you can use Spring Expression Language (SpEL) to reference custom environment variables:

    # In application.yml
    spring:
      ai:
        openai:
          api-key: ${PERPLEXITY_API_KEY}
          base-url: ${PERPLEXITY_BASE_URL}
          chat:
            model: ${PERPLEXITY_MODEL}

    # In your environment or .env file
    export PERPLEXITY_API_KEY=<your-perplexity-api-key>
    export PERPLEXITY_BASE_URL=https://api.perplexity.ai
    export PERPLEXITY_MODEL=llama-3.1-sonar-small-128k-online

You can also set these configurations programmatically in your application code:

    // Retrieve configuration from secure sources or environment variables
    String apiKey = System.getenv("PERPLEXITY_API_KEY");
    String baseUrl = System.getenv("PERPLEXITY_BASE_URL");
    String model = System.getenv("PERPLEXITY_MODEL");

### Add Repositories and BOM

Spring AI artifacts are published in Maven Central and Spring Snapshot repositories. Refer to the Artifact Repositories section to add these repositories to your build system.

To help with dependency management, Spring AI provides a BOM (bill of materials) to ensure that a consistent version of Spring AI is used throughout the entire project. Refer to the Dependency Management section to add the Spring AI BOM to your build system.

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the OpenAI Chat Client. To enable it add the following dependency to your project’s Maven `pom.xml` or Gradle `build.gradle` build files:

### Chat Properties

#### Retry Properties

The prefix `spring.ai.retry` is used as the property prefix that lets you configure the retry mechanism for the OpenAI chat model.

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

The prefix `spring.ai.openai` is used as the property prefix that lets you connect to OpenAI.

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
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.base-url</p></td>
<td class="tableblock halign-left valign-top"><p>The URL to connect to. Must be set to <code>https://api.perplexity.ai</code></p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>Your Perplexity API Key</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

#### Configuration Properties

The prefix `spring.ai.openai.chat` is the property prefix that lets you configure the chat model implementation for OpenAI.

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
<td class="tableblock halign-left valign-top"><p>spring.ai.model.chat</p></td>
<td class="tableblock halign-left valign-top"><p>Enable OpenAI chat model.</p></td>
<td class="tableblock halign-left valign-top"><p>openai</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.model</p></td>
<td class="tableblock halign-left valign-top"><p>One of the supported Perplexity models. Example: <code>llama-3.1-sonar-small-128k-online</code>.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.base-url</p></td>
<td class="tableblock halign-left valign-top"><p>Optional overrides the spring.ai.openai.base-url to provide chat specific url. Must be set to <code>https://api.perplexity.ai</code></p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.temperature</p></td>
<td class="tableblock halign-left valign-top"><p>The amount of randomness in the response, valued between 0 inclusive and 2 exclusive. Higher values are more random, and lower values are more deterministic. Required range: <code>0 &lt; x &lt; 2</code>.</p></td>
<td class="tableblock halign-left valign-top"><p>0.2</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.frequency-penalty</p></td>
<td class="tableblock halign-left valign-top"><p>A multiplicative penalty greater than 0. Values greater than 1.0 penalize new tokens based on their existing frequency in the text so far, decreasing the model’s likelihood to repeat the same line verbatim. A value of 1.0 means no penalty. Incompatible with presence_penalty. Required range: <code>x &gt; 0</code>.</p></td>
<td class="tableblock halign-left valign-top"><p>1</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.max-tokens</p></td>
<td class="tableblock halign-left valign-top"><p>The maximum number of completion tokens returned by the API. The total number of tokens requested in max_tokens plus the number of prompt tokens sent in messages must not exceed the context window token limit of model requested. If left unspecified, then the model will generate tokens until either it reaches its stop token or the end of its context window.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.presence-penalty</p></td>
<td class="tableblock halign-left valign-top"><p>A value between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model’s likelihood to talk about new topics. Incompatible with <code>frequency_penalty</code>. Required range: <code>-2 &lt; x &lt; 2</code></p></td>
<td class="tableblock halign-left valign-top"><p>0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.top-p</p></td>
<td class="tableblock halign-left valign-top"><p>The nucleus sampling threshold, valued between 0 and 1 inclusive. For each subsequent token, the model considers the results of the tokens with top_p probability mass. We recommend either altering top_k or top_p, but not both. Required range: <code>0 &lt; x &lt; 1</code></p></td>
<td class="tableblock halign-left valign-top"><p>0.9</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.stream-usage</p></td>
<td class="tableblock halign-left valign-top"><p>(For streaming only) Set to add an additional chunk with token usage statistics for the entire request. The <code>choices</code> field for this chunk is an empty array and all other chunks will also include a usage field, but with a null value.</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
</tbody>
</table>

## Runtime Options

The OpenAiChatOptions.java provides model configurations, such as the model to use, the temperature, the frequency penalty, etc.

On start-up, the default options can be configured with the `OpenAiChatModel(api, options)` constructor or the `spring.ai.openai.chat.*` properties.

At run-time you can override the default options by adding new, request specific, options to the `Prompt` call. For example to override the default model and temperature for a specific request:

    ChatResponse response = chatModel.call(
        new Prompt(
            "Generate the names of 5 famous pirates.",
            OpenAiChatOptions.builder()
                .model("llama-3.1-sonar-large-128k-online")
                .temperature(0.4)
            .build()
        ));

## Function Calling

## Multimodal

## Sample Controller

Create a new Spring Boot project and add the `spring-ai-starter-model-openai` to your pom (or gradle) dependencies.

Add a `application.properties` file, under the `src/main/resources` directory, to enable and configure the OpenAi chat model:

    spring.ai.openai.api-key=<PERPLEXITY_API_KEY>
    spring.ai.openai.base-url=https://api.perplexity.ai
    spring.ai.openai.chat.model=llama-3.1-sonar-small-128k-online
    spring.ai.openai.chat.temperature=0.7

    # The Perplexity API doesn't support embeddings, so we need to disable it.
    spring.ai.model.embedding=none

This will create a `OpenAiChatModel` implementation that you can inject into your class. Here is an example of a simple `@Controller` class that uses the chat model for text generations.

    @RestController
    public class ChatController {

        private final OpenAiChatModel chatModel;

        @Autowired
        public ChatController(OpenAiChatModel chatModel) {
            this.chatModel = chatModel;
        }

        @GetMapping("/ai/generate")
        public Map generate(@RequestParam(value = "message", defaultValue = "Tell me a joke") String message) {
            return Map.of("generation", this.chatModel.call(message));
        }

        @GetMapping("/ai/generateStream")
        public Flux<ChatResponse> generateStream(@RequestParam(value = "message", defaultValue = "Tell me a joke") String message) {
            Prompt prompt = new Prompt(new UserMessage(message));
            return this.chatModel.stream(prompt);
        }
    }

## Supported Models

Perplexity supports several models optimized for search-enhanced conversational AI. Refer to Supported Models for details.

## References

- Documentation Home

- API Reference

- Getting Started

- Rate Limits

Ollama OCI Generative AI

Search

# OpenAI Chat

Spring AI supports the various AI language models from OpenAI, the company behind ChatGPT, which has been instrumental in sparking interest in AI-driven text generation thanks to its creation of industry-leading text generation models and embeddings.

## Prerequisites

You will need to create an API with OpenAI to access ChatGPT models.

Create an account at OpenAI signup page and generate the token on the API Keys page.

The Spring AI project defines a configuration property named `spring.ai.openai.api-key` that you should set to the value of the `API Key` obtained from openai.com.

You can set this configuration property in your `application.properties` file:

    spring.ai.openai.api-key=<your-openai-api-key>

For enhanced security when handling sensitive information like API keys, you can use Spring Expression Language (SpEL) to reference a custom environment variable:

    # In application.yml
    spring:
      ai:
        openai:
          api-key: ${OPENAI_API_KEY}

    # In your environment or .env file
    export OPENAI_API_KEY=<your-openai-api-key>

You can also set this configuration programmatically in your application code:

    // Retrieve API key from a secure source or environment variable
    String apiKey = System.getenv("OPENAI_API_KEY");

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
<td class="tableblock halign-left valign-top"><p>The URL to connect to</p></td>
<td class="tableblock halign-left valign-top"><p>api.openai.com</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>The API Key</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.organization-id</p></td>
<td class="tableblock halign-left valign-top"><p>Optionally, you can specify which organization to use for an API request.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.project-id</p></td>
<td class="tableblock halign-left valign-top"><p>Optionally, you can specify which project to use for an API request.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

#### User-Agent Header

Spring AI automatically sends a `User-Agent: spring-ai` header with all requests to OpenAI. This helps OpenAI identify requests originating from Spring AI for analytics and support purposes. This header is sent automatically and requires no configuration from Spring AI users.

If you are an API provider building an OpenAI-compatible service, you can track Spring AI usage by reading the `User-Agent` HTTP header from incoming requests on your server.

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
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.enabled (Removed and no longer valid)</p></td>
<td class="tableblock halign-left valign-top"><p>Enable OpenAI chat model.</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.model.chat</p></td>
<td class="tableblock halign-left valign-top"><p>Enable OpenAI chat model.</p></td>
<td class="tableblock halign-left valign-top"><p>openai</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.base-url</p></td>
<td class="tableblock halign-left valign-top"><p>Optional override for the <code>spring.ai.openai.base-url</code> property to provide a chat-specific URL.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>Optional override for the <code>spring.ai.openai.api-key</code> to provide a chat-specific API Key.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.organization-id</p></td>
<td class="tableblock halign-left valign-top"><p>Optionally, you can specify which organization to use for an API request.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.project-id</p></td>
<td class="tableblock halign-left valign-top"><p>Optionally, you can specify which project to use for an API request.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.model</p></td>
<td class="tableblock halign-left valign-top"><p>Name of the OpenAI chat model to use. You can select between models such as: <code>gpt-5-mini</code>, <code>gpt-4o</code>, <code>gpt-4o-mini</code>, <code>gpt-4-turbo</code>, <code>gpt-3.5-turbo</code>, and more. See the models page for more information.</p></td>
<td class="tableblock halign-left valign-top"><p><code>gpt-5-mini</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.temperature</p></td>
<td class="tableblock halign-left valign-top"><p>The sampling temperature to use that controls the apparent creativity of generated completions. Higher values will make output more random while lower values will make results more focused and deterministic. It is not recommended to modify <code>temperature</code> and <code>top_p</code> for the same completions request as the interaction of these two settings is difficult to predict.</p></td>
<td class="tableblock halign-left valign-top"><p>0.8</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.frequency-penalty</p></td>
<td class="tableblock halign-left valign-top"><p>Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model’s likelihood to repeat the same line verbatim.</p></td>
<td class="tableblock halign-left valign-top"><p>0.0f</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.logit-bias</p></td>
<td class="tableblock halign-left valign-top"><p>Modify the likelihood of specified tokens appearing in the completion.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.max-tokens</p></td>
<td class="tableblock halign-left valign-top"><p>The maximum number of tokens to generate in the chat completion. The total length of input tokens and generated tokens is limited by the model’s context length. <strong>Use for non-reasoning models</strong> (e.g., gpt-4o, gpt-3.5-turbo). <strong>Cannot be used with reasoning models</strong> (e.g., o1, o3, o4-mini series). <strong>Mutually exclusive with maxCompletionTokens</strong> - setting both will result in an API error.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.max-completion-tokens</p></td>
<td class="tableblock halign-left valign-top"><p>An upper bound for the number of tokens that can be generated for a completion, including visible output tokens and reasoning tokens. <strong>Required for reasoning models</strong> (e.g., o1, o3, o4-mini series). <strong>Cannot be used with non-reasoning models</strong> (e.g., gpt-4o, gpt-3.5-turbo). <strong>Mutually exclusive with maxTokens</strong> - setting both will result in an API error.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.n</p></td>
<td class="tableblock halign-left valign-top"><p>How many chat completion choices to generate for each input message. Note that you will be charged based on the number of generated tokens across all of the choices. Keep <code>n</code> as 1 to minimize costs.</p></td>
<td class="tableblock halign-left valign-top"><p>1</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.store</p></td>
<td class="tableblock halign-left valign-top"><p>Whether to store the output of this chat completion request for use in our model</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.metadata</p></td>
<td class="tableblock halign-left valign-top"><p>Developer-defined tags and values used for filtering completions in the chat completion dashboard</p></td>
<td class="tableblock halign-left valign-top"><p>empty map</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.output-modalities</p></td>
<td class="tableblock halign-left valign-top"><p>Output types that you would like the model to generate for this request. Most models are capable of generating text, which is the default. The <code>gpt-audio</code> model can also be used to generate audio. To request that this model generate both text and audio responses, you can use: <code>text</code>, <code>audio</code>. Not supported for streaming.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.output-audio</p></td>
<td class="tableblock halign-left valign-top"><p>Audio parameters for the audio generation. Required when audio output is requested with <code>output-modalities</code>: <code>audio</code>. Requires the <code>gpt-audio</code> model and is is not supported for streaming completions.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.presence-penalty</p></td>
<td class="tableblock halign-left valign-top"><p>Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model’s likelihood to talk about new topics.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.response-format.type</p></td>
<td class="tableblock halign-left valign-top"><p>Compatible with <code>GPT-4o</code>, <code>GPT-4o mini</code>, <code>GPT-4 Turbo</code> and all <code>GPT-3.5 Turbo</code> models newer than <code>gpt-3.5-turbo-1106</code>. The <code>JSON_OBJECT</code> type enables JSON mode, which guarantees the message the model generates is valid JSON. The <code>JSON_SCHEMA</code> type enables Structured Outputs which guarantees the model will match your supplied JSON schema. The JSON_SCHEMA type requires setting the <code>responseFormat.schema</code> property as well.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.response-format.name</p></td>
<td class="tableblock halign-left valign-top"><p>Response format schema name. Applicable only for <code>responseFormat.type=JSON_SCHEMA</code></p></td>
<td class="tableblock halign-left valign-top"><p>custom_schema</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.response-format.schema</p></td>
<td class="tableblock halign-left valign-top"><p>Response format JSON schema. Applicable only for <code>responseFormat.type=JSON_SCHEMA</code></p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.response-format.strict</p></td>
<td class="tableblock halign-left valign-top"><p>Response format JSON schema adherence strictness. Applicable only for <code>responseFormat.type=JSON_SCHEMA</code></p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.seed</p></td>
<td class="tableblock halign-left valign-top"><p>This feature is in Beta. If specified, our system will make a best effort to sample deterministically, such that repeated requests with the same seed and parameters should return the same result.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.stop</p></td>
<td class="tableblock halign-left valign-top"><p>Up to 4 sequences where the API will stop generating further tokens.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.top-p</p></td>
<td class="tableblock halign-left valign-top"><p>An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with <code>top_p</code> probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or <code>temperature</code> but not both.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.tools</p></td>
<td class="tableblock halign-left valign-top"><p>A list of tools the model may call. Currently, only functions are supported as a tool. Use this to provide a list of functions the model may generate JSON inputs for.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.tool-choice</p></td>
<td class="tableblock halign-left valign-top"><p>Controls which (if any) function is called by the model. <code>none</code> means the model will not call a function and instead generates a message. <code>auto</code> means the model can pick between generating a message or calling a function. Specifying a particular function via <code>{"type: "function", "function": {"name": "my_function"}}</code> forces the model to call that function. <code>none</code> is the default when no functions are present. <code>auto</code> is the default if functions are present.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.user</p></td>
<td class="tableblock halign-left valign-top"><p>A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.stream-usage</p></td>
<td class="tableblock halign-left valign-top"><p>(For streaming only) Set to add an additional chunk with token usage statistics for the entire request. The <code>choices</code> field for this chunk is an empty array and all other chunks will also include a usage field, but with a null value.</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.parallel-tool-calls</p></td>
<td class="tableblock halign-left valign-top"><p>Whether to enable parallel function calling during tool use.</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.prompt-cache-key</p></td>
<td class="tableblock halign-left valign-top"><p>A cache key used by OpenAI to optimize cache hit rates for similar requests. Improves latency and reduces costs. Replaces the deprecated <code>user</code> field for caching purposes. Learn more.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.safety-identifier</p></td>
<td class="tableblock halign-left valign-top"><p>A stable identifier to help OpenAI detect users violating usage policies. Should be a hashed value (e.g., hashed username or email). Replaces the deprecated <code>user</code> field for safety tracking. Learn more.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.http-headers</p></td>
<td class="tableblock halign-left valign-top"><p>Optional HTTP headers to be added to the chat completion request. To override the <code>api-key</code> you need to use an <code>Authorization</code> header key, and you have to prefix the key value with the <code>Bearer</code> prefix.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.tool-callbacks</p></td>
<td class="tableblock halign-left valign-top"><p>Tool Callbacks to register with the ChatModel.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.service-tier</p></td>
<td class="tableblock halign-left valign-top"><p>Specifies the processing type used for serving the request.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.extra-body</p></td>
<td class="tableblock halign-left valign-top"><p>Additional parameters to include in the request. Accepts any key-value pairs that are flattened to the top level of the JSON request. Intended for use with OpenAI-compatible servers (vLLM, Ollama, etc.) that support parameters beyond the standard OpenAI API. The official OpenAI API rejects unknown parameters with a 400 error. See Using Extra Parameters with OpenAI-Compatible Servers for details.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

### Token Limit Parameters: Model-Specific Usage

OpenAI provides two mutually exclusive parameters for controlling token generation limits:

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 25%" />
<col style="width: 37%" />
<col style="width: 37%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Parameter</th>
<th class="tableblock halign-left valign-top">Use Case</th>
<th class="tableblock halign-left valign-top">Compatible Models</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>maxTokens</code></p></td>
<td class="tableblock halign-left valign-top"><p>Non-reasoning models</p></td>
<td class="tableblock halign-left valign-top"><p>gpt-4o, gpt-4o-mini, gpt-4-turbo, gpt-3.5-turbo</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>maxCompletionTokens</code></p></td>
<td class="tableblock halign-left valign-top"><p>Reasoning models</p></td>
<td class="tableblock halign-left valign-top"><p>o1, o1-mini, o1-preview, o3, o4-mini series</p></td>
</tr>
</tbody>
</table>

#### Usage Examples

**For non-reasoning models (gpt-4o, gpt-3.5-turbo):**

    ChatResponse response = chatModel.call(
        new Prompt(
            "Explain quantum computing in simple terms.",
            OpenAiChatOptions.builder()
                .model("gpt-4o")
                .maxTokens(150)  // Use maxTokens for non-reasoning models
            .build()
        ));

**For reasoning models (o1, o3 series):**

    ChatResponse response = chatModel.call(
        new Prompt(
            "Solve this complex math problem step by step: ...",
            OpenAiChatOptions.builder()
                .model("o1-preview")
                .maxCompletionTokens(1000)  // Use maxCompletionTokens for reasoning models
            .build()
        ));

**Builder Pattern Validation:** The OpenAI ChatOptions builder automatically enforces mutual exclusivity with a "last-set-wins" approach:

    // This will automatically clear maxTokens and use maxCompletionTokens
    OpenAiChatOptions options = OpenAiChatOptions.builder()
        .maxTokens(100)           // Set first
        .maxCompletionTokens(200) // This clears maxTokens and logs a warning
        .build();

    // Result: maxTokens = null, maxCompletionTokens = 200

## Runtime Options

The OpenAiChatOptions.java class provides model configurations such as the model to use, the temperature, the frequency penalty, etc.

On start-up, the default options can be configured with the `OpenAiChatModel(api, options)` constructor or the `spring.ai.openai.chat.*` properties.

At run-time, you can override the default options by adding new, request-specific options to the `Prompt` call. For example, to override the default model and temperature for a specific request:

    ChatResponse response = chatModel.call(
        new Prompt(
            "Generate the names of 5 famous pirates.",
            OpenAiChatOptions.builder()
                .model("gpt-4o")
                .temperature(0.4)
            .build()
        ));

## Function Calling

You can register custom Java functions with the `OpenAiChatModel` and have the OpenAI model intelligently choose to output a JSON object containing arguments to call one or many of the registered functions. This is a powerful technique to connect the LLM capabilities with external tools and APIs. Read more about Tool Calling.

`OpenAiChatModel` does not execute tool calls internally. Tool execution must be handled externally using one of two supported approaches:

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

    OpenAiChatOptions options = OpenAiChatOptions.builder()
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

## Multimodal

Multimodality refers to a model’s ability to simultaneously understand and process information from various sources, including text, images, audio, and other data formats. OpenAI supports text, vision, and audio input modalities.

### Vision

OpenAI models that offer vision multimodal support include `gpt-4`, `gpt-4o`, and `gpt-4o-mini`. Refer to the Vision guide for more information.

The OpenAI User Message API can incorporate a list of base64-encoded images or image urls with the message. Spring AI’s Message interface facilitates multimodal AI models by introducing the Media type. This type encompasses data and details regarding media attachments in messages, utilizing Spring’s `org.springframework.util.MimeType` and a `org.springframework.core.io.Resource` for the raw media data.

Below is a code example excerpted from OpenAiChatModelIT.java, illustrating the fusion of user text with an image using the `gpt-4o` model.

    var imageResource = new ClassPathResource("/multimodal.test.png");

    var userMessage = new UserMessage("Explain what do you see on this picture?",
            new Media(MimeTypeUtils.IMAGE_PNG, this.imageResource));

    ChatResponse response = chatModel.call(new Prompt(this.userMessage,
            OpenAiChatOptions.builder().model("gpt-4o").build()));

or the image URL equivalent using the `gpt-4o` model:

    var userMessage = new UserMessage("Explain what do you see on this picture?",
            new Media(MimeTypeUtils.IMAGE_PNG,
                    URI.create("https://docs.spring.io/spring-ai/reference/_images/multimodal.test.png")));

    ChatResponse response = chatModel.call(new Prompt(this.userMessage,
            OpenAiChatOptions.builder().model("gpt-4o").build()));

The example shows a model taking as an input the `multimodal.test.png` image:

along with the text message "Explain what do you see on this picture?", and generating a response like this:

    This is an image of a fruit bowl with a simple design. The bowl is made of metal with curved wire edges that
    create an open structure, allowing the fruit to be visible from all angles. Inside the bowl, there are two
    yellow bananas resting on top of what appears to be a red apple. The bananas are slightly overripe, as
    indicated by the brown spots on their peels. The bowl has a metal ring at the top, likely to serve as a handle
    for carrying. The bowl is placed on a flat surface with a neutral-colored background that provides a clear
    view of the fruit inside.

### Audio

OpenAI models that offer input audio multimodal support include `gpt-audio`. Refer to the Audio guide for more information.

The OpenAI User Message API can incorporate a list of base64-encoded audio files with the message. Spring AI’s Message interface facilitates multimodal AI models by introducing the Media type. This type encompasses data and details regarding media attachments in messages, utilizing Spring’s `org.springframework.util.MimeType` and a `org.springframework.core.io.Resource` for the raw media data. Currently, OpenAI support only the following media types: `audio/mp3` and `audio/wav`.

Below is a code example excerpted from OpenAiChatModelIT.java, illustrating the fusion of user text with an audio file using the `gpt-audio` model.

    var audioResource = new ClassPathResource("speech1.mp3");

    var userMessage = new UserMessage("What is this recording about?",
            List.of(new Media(MimeTypeUtils.parseMimeType("audio/mp3"), audioResource)));

    ChatResponse response = chatModel.call(new Prompt(List.of(userMessage),
            OpenAiChatOptions.builder().model("gpt-audio").build()));

### Output Audio

OpenAI models that offer input audio multimodal support include `gpt-audio`. Refer to the Audio guide for more information.

The OpenAI Assistant Message API can contain a list of base64-encoded audio files with the message. Spring AI’s Message interface facilitates multimodal AI models by introducing the Media type. This type encompasses data and details regarding media attachments in messages, utilizing Spring’s `org.springframework.util.MimeType` and a `org.springframework.core.io.Resource` for the raw media data. Currently, OpenAI support only the following audio types: `audio/mp3` and `audio/wav`.

Below is a code example, illustrating the response of user text along with an audio byte array, using the `gpt-audio` model:

    var userMessage = new UserMessage("Tell me joke about Spring Framework");

    ChatResponse response = chatModel.call(new Prompt(List.of(userMessage),
            OpenAiChatOptions.builder()
                .model("gpt-audio")
                .outputModalities(List.of("text", "audio"))
                .outputAudio(new AudioParameters(Voice.ALLOY, AudioResponseFormat.WAV))
                .build()));

    String text = response.getResult().getOutput().getText(); // audio transcript

    byte[] waveAudio = response.getResult().getOutput().getMedia().get(0).getDataAsByteArray(); // audio data

You have to specify an `audio` modality in the `OpenAiChatOptions` to generate audio output. The `AudioParameters` class provides the voice and audio format for the audio output.

## Structured Outputs

OpenAI provides custom Structured Outputs APIs that ensure your model generates responses conforming strictly to your provided `JSON Schema`. In addition to the existing Spring AI model-agnostic Structured Output Converter, these APIs offer enhanced control and precision.

### Configuration

Spring AI allows you to configure your response format either programmatically using the `OpenAiChatOptions` builder or through application properties.

#### Using the Chat Options Builder

You can set the response format programmatically with the `OpenAiChatOptions` builder as shown below:

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
            OpenAiChatOptions.builder()
                .model(ChatModel.GPT_4_O_MINI)
                .responseFormat(new ResponseFormat(ResponseFormat.Type.JSON_SCHEMA, this.jsonSchema))
                .build());

    ChatResponse response = this.openAiChatModel.call(this.prompt);

#### Integrating with BeanOutputConverter Utilities

You can leverage existing BeanOutputConverter utilities to automatically generate the JSON Schema from your domain objects and later convert the structured response into domain-specific instances:

#### Configuring via Application Properties

Alternatively, when using the OpenAI auto-configuration, you can configure the desired response format through the following application properties:

    spring.ai.openai.api-key=YOUR_API_KEY
    spring.ai.openai.chat.model=gpt-4o-mini

    spring.ai.openai.chat.response-format.type=JSON_SCHEMA
    spring.ai.openai.chat.response-format.name=MySchemaName
    spring.ai.openai.chat.response-format.schema={"type":"object","properties":{"steps":{"type":"array","items":{"type":"object","properties":{"explanation":{"type":"string"},"output":{"type":"string"}},"required":["explanation","output"],"additionalProperties":false}},"final_answer":{"type":"string"}},"required":["steps","final_answer"],"additionalProperties":false}
    spring.ai.openai.chat.response-format.strict=true

## Sample Controller

Create a new Spring Boot project and add the `spring-ai-starter-model-openai` to your pom (or gradle) dependencies.

Add an `application.properties` file under the `src/main/resources` directory to enable and configure the OpenAi chat model:

    spring.ai.openai.api-key=YOUR_API_KEY
    spring.ai.openai.chat.model=gpt-4o
    spring.ai.openai.chat.temperature=0.7

This will create an `OpenAiChatModel` implementation that you can inject into your classes. Here is an example of a simple `@RestController` class that uses the chat model for text generations.

    @RestController
    public class ChatController {

        private final OpenAiChatModel chatModel;

        @Autowired
        public ChatController(OpenAiChatModel chatModel) {
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

The OpenAiChatModel implements the `ChatModel` and `StreamingChatModel` and uses the \[low-level-api\] to connect to the OpenAI service.

Add the `spring-ai-openai` dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-openai</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-openai'
    }

Next, create an `OpenAiChatModel` and use it for text generations:

    var chatModel = OpenAiChatModel.builder()
        .options(OpenAiChatOptions.builder()
            .apiKey(System.getenv("OPENAI_API_KEY"))
            .model("gpt-3.5-turbo")
            .temperature(0.4)
            .maxTokens(200)
            .build())
        .build();

    ChatResponse response = this.chatModel.call(
        new Prompt("Generate the names of 5 famous pirates."));

    // Or with streaming responses
    Flux<ChatResponse> response = this.chatModel.stream(
        new Prompt("Generate the names of 5 famous pirates."));

The `OpenAiChatOptions` provides the configuration information for the chat requests. The `OpenAiChatOptions.Builder` is a fluent options-builder for the chat config.

## API Key Management

Spring AI provides flexible API key management through the `ApiKey` interface and its implementations. The default implementation, `SimpleApiKey`, is suitable for most use cases, but you can also create custom implementations for more complex scenarios.

### Default Configuration

By default, Spring Boot auto-configuration will create an API key bean using the `spring.ai.openai.api-key` property:

    spring.ai.openai.api-key=your-api-key-here

### Custom API Key Configuration

You can create a custom instance of `OpenAiChatModel` with your own `ApiKey` implementation using the builder pattern:

    ApiKey customApiKey = new ApiKey() {
        @Override
        public String getValue() {
            // Custom logic to retrieve API key
            return "your-api-key-here";
        }
    };

    // Create a chat model with the custom API key
    OpenAiChatModel chatModel = OpenAiChatModel.builder()
        .options(OpenAiChatOptions.builder()
            .apiKey(customApiKey.getValue())
            .build())
        .build();
    // Build the ChatClient using the custom chat model
    ChatClient openAiChatClient = ChatClient.builder(chatModel).build();

This is useful when you need to:

- Retrieve the API key from a secure key store

- Rotate API keys dynamically

- Implement custom API key selection logic

## Observability

Spring AI emits Micrometer observations at two layers for every OpenAI call:

- **Chat-model layer.** A `gen_ai.client.operation` observation wraps every call to `OpenAiChatModel.call(…​)` or `.stream(…​)`, carrying request parameters, response metadata, and token usage. See the observability reference for the full set of tags and metrics.

- **HTTP layer.** An `okhttp.requests` observation wraps every HTTP attempt to the OpenAI API, carrying HTTP method, URI, status code, and exception tags. Each request also propagates `traceparent` on the wire to any downstream services (AI gateways, OpenAI-compatible inference servers, proxies).

In a Spring Boot application with `spring-boot-starter-actuator` and a tracing bridge (`micrometer-tracing-bridge-otel` or `micrometer-tracing-bridge-brave`), both layers are wired automatically — no opt-in required. For non-Boot applications, pass an `ObservationRegistry` to `OpenAiChatModel.builder()`:

    OpenAiChatModel chatModel = OpenAiChatModel.builder()
        .options(...)
        .observationRegistry(observationRegistry)
        .build();

### Connection-pool metrics (opt-in)

Spring AI can additionally bind OkHttp connection-pool gauges (`okhttp.pool.connection.count` with `state=active|idle` and `client.kind=sync|async`) to the application’s `MeterRegistry`. These are secondary telemetry — useful for capacity tuning but not required for tracing or per-request latency — so they’re disabled by default.

To enable them in a Spring Boot application:

    spring.ai.openai.chat.connection-pool-metrics-enabled=true

For non-Boot applications, pass a `MeterRegistry` directly to the builder; the gauges bind whenever a registry is supplied:

    OpenAiChatModel chatModel = OpenAiChatModel.builder()
        .options(...)
        .observationRegistry(observationRegistry)
        .meterRegistry(meterRegistry)
        .build();

### HTTP dispatcher executor (advanced)

By default Spring AI manages the OkHttp dispatcher’s executor — an unbounded pool of platform threads, replicating the SDK’s stock behavior. For workloads with high HTTP concurrency, or to take advantage of Java 21+ virtual threads, you can supply your own `ExecutorService`:

    OpenAiChatModel chatModel = OpenAiChatModel.builder()
        .options(...)
        .dispatcherExecutor(Executors.newVirtualThreadPerTaskExecutor())
        .build();

The same executor backs both the sync and async (streaming) clients. When you supply your own executor, you own its lifecycle — Spring AI will never call `shutdown()` on it. When omitted, the internal executor is created and cleaned up automatically.

## Customizing the HTTP Client

Spring AI uses the official `openai-java` SDK under the hood and configures its HTTP transport with a custom OkHttp client built by `SpringAiOpenAiHttpClient.Builder`. You can intercept that builder before the underlying `OkHttpClient` is created by exposing one or more `OpenAiHttpClientBuilderCustomizer` beans. Each customizer receives the same builder used by every OpenAI model (chat, embedding, image, audio, moderation), so the customization applies uniformly.

    @FunctionalInterface
    public interface OpenAiHttpClientBuilderCustomizer {
        void customize(SpringAiOpenAiHttpClient.Builder builder);
    }

Typical use cases include:

- registering OkHttp `Interceptor` instances (authentication, propagation headers, custom logging);

- swapping the dispatcher `ExecutorService` (for example, to route async I/O through virtual threads);

- configuring proxy, SSL, hostname verification, or the connection-pool sizing exposed by the builder.

When several customizers are present, they are applied in `@Order` / `Ordered` order, after Spring AI’s own defaults, so user code wins.

The same hook is available when wiring a model manually via the `OpenAi*Model.Builder`:

    var chatModel = OpenAiChatModel.builder()
        .options(OpenAiChatOptions.builder().model("gpt-4o").build())
        .httpClientBuilderCustomizer(myCustomizer)
        .build();

## Using Extra Parameters with OpenAI-Compatible Servers

OpenAI-compatible inference servers like vLLM, Ollama, and others often support additional parameters beyond those defined in OpenAI’s standard API. For example, these servers may accept parameters such as `top_k`, `repetition_penalty`, or other sampling controls that the official OpenAI API does not recognize.

The `extraBody` option allows you to pass arbitrary parameters to these servers. Any key-value pairs provided in `extraBody` are included at the top level of the JSON request, enabling you to leverage server-specific features while using Spring AI’s OpenAI client.

### Configuration with Properties

You can configure extra parameters using Spring Boot properties. Each property under `spring.ai.openai.chat.extra-body` becomes a top-level parameter in the request:

    spring.ai.openai.base-url=http://localhost:8000
    spring.ai.openai.chat.model=meta-llama/Llama-3-8B-Instruct
    spring.ai.openai.chat.temperature=0.7
    spring.ai.openai.chat.extra-body.top_k=50
    spring.ai.openai.chat.extra-body.repetition_penalty=1.1

This configuration would produce a JSON request like:

    {
      "model": "meta-llama/Llama-3-8B-Instruct",
      "temperature": 0.7,
      "top_k": 50,
      "repetition_penalty": 1.1,
      "messages": [...]
    }

### Runtime Configuration with Builder

You can also specify extra parameters at runtime using the options builder:

    ChatResponse response = chatModel.call(
        new Prompt(
            "Tell me a creative story",
            OpenAiChatOptions.builder()
                .model("meta-llama/Llama-3-8B-Instruct")
                .temperature(0.7)
                .extraBody(Map.of(
                    "top_k", 50,
                    "repetition_penalty", 1.1,
                    "frequency_penalty", 0.5
                ))
                .build()
        ));

### Example: vLLM Server

When running vLLM with a Llama model, you might want to use sampling parameters specific to vLLM:

    spring.ai.openai.base-url=http://localhost:8000
    spring.ai.openai.chat.model=meta-llama/Llama-3-70B-Instruct
    spring.ai.openai.chat.extra-body.top_k=40
    spring.ai.openai.chat.extra-body.top_p=0.95
    spring.ai.openai.chat.extra-body.repetition_penalty=1.05
    spring.ai.openai.chat.extra-body.min_p=0.05

Refer to the vLLM documentation for a complete list of supported sampling parameters.

### Example: Ollama Server

When using Ollama through the OpenAI-compatible endpoint, you can pass Ollama-specific parameters:

    OpenAiChatOptions options = OpenAiChatOptions.builder()
        .model("llama3.2")
        .extraBody(Map.of(
            "num_predict", 100,
            "top_k", 40,
            "repeat_penalty", 1.1
        ))
        .build();

    ChatResponse response = chatModel.call(new Prompt("Generate text", options));

Consult the Ollama API documentation for available parameters.

### Reasoning Content from Reasoning Models

Some OpenAI-compatible servers that support reasoning models (such as DeepSeek R1, vLLM with reasoning parsers) expose the model’s internal chain of thought via a `reasoning_content` field in their API responses. This field contains the step-by-step reasoning process the model used to arrive at its final answer.

Spring AI maps this field from the JSON response to the `reasoningContent` key in the AssistantMessage metadata.

#### Accessing Reasoning Content

When using a compatible server, you can access the reasoning content from the response metadata.

**Using ChatModel directly:**

    // Configure to use DeepSeek R1 or vLLM with a reasoning model
    ChatResponse response = chatModel.call(
        new Prompt("Which number is larger: 9.11 or 9.8?")
    );

    // Get the assistant message
    AssistantMessage message = response.getResult().getOutput();

    // Access the reasoning content from metadata
    String reasoning = message.getMetadata().get("reasoningContent");
    if (reasoning != null && !reasoning.isEmpty()) {
        System.out.println("Model's reasoning process:");
        System.out.println(reasoning);
    }

    // The final answer is in the regular content
    System.out.println("\nFinal answer:");
    System.out.println(message.getContent());

**Using ChatClient:**

    ChatClient chatClient = ChatClient.create(chatModel);

    String result = chatClient.prompt()
        .user("Which number is larger: 9.11 or 9.8?")
        .call()
        .chatResponse()
        .getResult()
        .getOutput()
        .getContent();

    // To access reasoning content with ChatClient, retrieve the full response
    ChatResponse response = chatClient.prompt()
        .user("Which number is larger: 9.11 or 9.8?")
        .call()
        .chatResponse();

    AssistantMessage message = response.getResult().getOutput();
    String reasoning = message.getMetadata().get("reasoningContent");

#### Streaming Reasoning Content

When using streaming responses, reasoning content is accumulated across chunks just like regular message content:

    Flux<ChatResponse> responseFlux = chatModel.stream(
        new Prompt("Solve this logic puzzle...")
    );

    StringBuilder reasoning = new StringBuilder();
    StringBuilder answer = new StringBuilder();

    responseFlux.subscribe(chunk -> {
        AssistantMessage message = chunk.getResult().getOutput();

        // Accumulate reasoning if present
        String reasoningChunk = message.getMetadata().get("reasoningContent");
        if (reasoningChunk != null) {
            reasoning.append(reasoningChunk);
        }

        // Accumulate the final answer
        if (message.getContent() != null) {
            answer.append(message.getContent());
        }
    });

#### Example: DeepSeek R1

DeepSeek R1 is a reasoning model that exposes its internal reasoning process:

    spring.ai.openai.api-key=${DEEPSEEK_API_KEY}
    spring.ai.openai.base-url=https://api.deepseek.com
    spring.ai.openai.chat.model=deepseek-reasoner

When you make requests to DeepSeek R1, responses will include both the reasoning content (the model’s thought process) and the final answer.

Refer to the DeepSeek API documentation for more details on reasoning models.

#### Example: vLLM with Reasoning Parser

vLLM supports reasoning models when configured with a reasoning parser:

    vllm serve deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B \
        --enable-reasoning \
        --reasoning-parser deepseek_r1

    spring.ai.openai.base-url=http://localhost:8000
    spring.ai.openai.chat.model=deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B

Consult the vLLM reasoning outputs documentation for supported reasoning models and parsers.

### Tool Call Additional Properties for OpenAI-Compatible Providers

Some OpenAI-compatible providers attach extra fields to tool-call objects in their responses. A common example is Google Gemini’s OpenAI-compatible endpoint, which returns a `thought_signature` field required for multi-turn tool calling:

    {
      "tool_calls": [
        {
          "id": "call_1",
          "type": "function",
          "function": { "name": "get_weather", "arguments": "{\"location\":\"Seoul\"}" },
          "extra_content": { "google": { "thought_signature": "..." } }
        }
      ]
    }

Without these provider-specific fields present in the follow-up request, some models reject the tool-call history.

Spring AI automatically captures any extra fields present on tool-call objects in the provider response and replays them verbatim when the assistant message is included in a subsequent request. No configuration is required — the behavior is transparent for both blocking and streaming flows.

OCI Generative AI Embedding Models

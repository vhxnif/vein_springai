Search

# Google GenAI Chat

The Google GenAI API allows developers to build generative AI applications using Google’s Gemini models through either the Gemini Developer API or Vertex AI. The Google GenAI API supports multimodal prompts as input and outputs text or code. A multimodal model is capable of processing information from multiple modalities, including images, videos, and text. For example, you can send the model a photo of a plate of cookies and ask it to give you a recipe for those cookies.

Gemini is a family of generative AI models developed by Google DeepMind that is designed for multimodal use cases. The Gemini API gives you access to various models like Gemini Flash-Lite, Gemini Flash or Gemini Pro.

This implementation provides two authentication modes:

- **Gemini Developer API**: Use an API key for quick prototyping and development

- **Vertex AI**: Use Google Cloud credentials for production deployments with enterprise features

Gemini API Reference

## Prerequisites

Choose one of the following authentication methods:

### Option 1: Gemini Developer API (API Key)

- Obtain an API key from the Google AI Studio

- Set the API key as an environment variable or in your application properties

### Option 2: Vertex AI (Google Cloud)

- Install the gcloud CLI, appropriate for your OS.

- Authenticate by running the following command. Replace `PROJECT_ID` with your Google Cloud project ID and `ACCOUNT` with your Google Cloud username.

    gcloud config set project <PROJECT_ID> &&
    gcloud auth application-default login <ACCOUNT>

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the Google GenAI Chat Client. To enable it add the following dependency to your project’s Maven `pom.xml` or Gradle `build.gradle` build files:

### Chat Properties

#### Connection Properties

The prefix `spring.ai.google.genai` is used as the property prefix that lets you connect to Google GenAI.

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
<td class="tableblock halign-left valign-top"><p>Enable Chat Model client</p></td>
<td class="tableblock halign-left valign-top"><p>google-genai</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>API key for Gemini Developer API. When provided, the client uses the Gemini Developer API instead of Vertex AI.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.project-id</p></td>
<td class="tableblock halign-left valign-top"><p>Google Cloud Platform project ID (required for Vertex AI mode)</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.location</p></td>
<td class="tableblock halign-left valign-top"><p>Google Cloud region (required for Vertex AI mode)</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.credentials-uri</p></td>
<td class="tableblock halign-left valign-top"><p>URI to Google Cloud credentials. When provided it is used to create a <code>GoogleCredentials</code> instance for authentication.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

#### Chat Model Properties

The prefix `spring.ai.google.genai.chat` is the property prefix that lets you configure the chat model implementation for Google GenAI Chat.

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
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.model</p></td>
<td class="tableblock halign-left valign-top"><p>Supported Google GenAI Chat models to use, includes <code>gemini-2.5-flash</code>, <code>gemini-2.5-flash-lite</code>, <code>gemini-2.5-pro</code>, <code>gemini-3.1-pro-preview</code>, <code>gemini-3.1-flash-lite</code> and <code>gemini-3.5-flash</code>.</p></td>
<td class="tableblock halign-left valign-top"><p>gemini-2.5-flash</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.response-mime-type</p></td>
<td class="tableblock halign-left valign-top"><p>Output response mimetype of the generated candidate text.</p></td>
<td class="tableblock halign-left valign-top"><p><code>text/plain</code>: (default) Text output or <code>application/json</code>: JSON response.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.google-search-retrieval</p></td>
<td class="tableblock halign-left valign-top"><p>Use Google search Grounding feature</p></td>
<td class="tableblock halign-left valign-top"><p><code>true</code> or <code>false</code>, default <code>false</code>.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.include-server-side-tool-invocations</p></td>
<td class="tableblock halign-left valign-top"><p>When true, the API response includes server-side tool calls and responses (e.g., Google Search invocations) in the response metadata, allowing observation of the server’s tool usage. Only supported with Gemini Developer API (MLDev), not Vertex AI. See Server-Side Tool Invocations.</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.temperature</p></td>
<td class="tableblock halign-left valign-top"><p>Controls the randomness of the output. Values can range over [0.0,1.0], inclusive. A value closer to 1.0 will produce responses that are more varied, while a value closer to 0.0 will typically result in less surprising responses from the generative.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.top-k</p></td>
<td class="tableblock halign-left valign-top"><p>The maximum number of tokens to consider when sampling. The generative uses combined Top-k and nucleus sampling. Top-k sampling considers the set of topK most probable tokens.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.top-p</p></td>
<td class="tableblock halign-left valign-top"><p>The maximum cumulative probability of tokens to consider when sampling. The generative uses combined Top-k and nucleus sampling. Nucleus sampling considers the smallest set of tokens whose probability sum is at least topP.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.candidate-count</p></td>
<td class="tableblock halign-left valign-top"><p>The number of generated response messages to return. This value must be between [1, 8], inclusive. Defaults to 1.</p></td>
<td class="tableblock halign-left valign-top"><p>1</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.max-output-tokens</p></td>
<td class="tableblock halign-left valign-top"><p>The maximum number of tokens to generate.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.frequency-penalty</p></td>
<td class="tableblock halign-left valign-top"><p>Frequency penalties for reducing repetition.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.presence-penalty</p></td>
<td class="tableblock halign-left valign-top"><p>Presence penalties for reducing repetition.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.thinking-budget</p></td>
<td class="tableblock halign-left valign-top"><p>Thinking budget for the thinking process. See Thinking Configuration.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.thinking-level</p></td>
<td class="tableblock halign-left valign-top"><p>The level of thinking tokens the model should generate. Valid values: <code>LOW</code>, <code>HIGH</code>, <code>THINKING_LEVEL_UNSPECIFIED</code>. See Thinking Configuration.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.include-thoughts</p></td>
<td class="tableblock halign-left valign-top"><p>Enable thought signatures for function calling. <strong>Required</strong> for Gemini 3 Pro to avoid validation errors during the tool-call loop. See Thought Signatures.</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.tool-callbacks</p></td>
<td class="tableblock halign-left valign-top"><p>Tool Callbacks to register with the ChatModel.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.safety-settings</p></td>
<td class="tableblock halign-left valign-top"><p>List of safety settings to control safety filters, as defined by Google GenAI Safety Settings. Each safety setting can have a method, threshold, and category.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.cached-content-name</p></td>
<td class="tableblock halign-left valign-top"><p>The name of cached content to use for this request. When set along with <code>use-cached-content=true</code>, the cached content will be used as context. See Cached Content.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.use-cached-content</p></td>
<td class="tableblock halign-left valign-top"><p>Whether to use cached content if available. When true and <code>cached-content-name</code> is set, the system will use the cached content.</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.auto-cache-threshold</p></td>
<td class="tableblock halign-left valign-top"><p>Automatically cache prompts that exceed this token threshold. When set, prompts larger than this value will be automatically cached for reuse. Set to null to disable auto-caching.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.auto-cache-ttl</p></td>
<td class="tableblock halign-left valign-top"><p>Time-to-live (Duration) for auto-cached content in ISO-8601 format (e.g., <code>PT1H</code> for 1 hour). Used when auto-caching is enabled.</p></td>
<td class="tableblock halign-left valign-top"><p>PT1H</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.enable-cached-content</p></td>
<td class="tableblock halign-left valign-top"><p>Enable the <code>GoogleGenAiCachedContentService</code> bean for managing cached content.</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.google.genai.chat.service-tier</p></td>
<td class="tableblock halign-left valign-top"><p>The service tier to use for the request. Valid values: <code>STANDARD</code>, <code>PRIORITY</code>, <code>FLEX</code>.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

## Runtime options

The GoogleGenAiChatOptions.java provides model configurations, such as the temperature, the topK, etc.

On start-up, the default options can be configured with the `GoogleGenAiChatModel(client, options)` constructor or the `spring.ai.google.genai.chat.*` properties.

At runtime, you can override the default options by adding new, request specific, options to the `Prompt` call. For example, to override the default temperature for a specific request:

    ChatResponse response = chatModel.call(
        new Prompt(
            "Generate the names of 5 famous pirates.",
            GoogleGenAiChatOptions.builder()
                .temperature(0.4)
            .build()
        ));

## Tool Calling

`GoogleGenAiChatModel` does not execute tool calls internally. Tool execution must be handled externally using one of the two supported approaches below.

### Tool Calling via ChatClient (Recommended)

The recommended approach is to use `ChatClient` with the `ToolCallingAdvisor`, which is automatically registered and manages the tool-call loop transparently for both synchronous and streaming scenarios.

    public class WeatherService {

        @Tool(description = "Get the weather in location")
        public String weatherByLocation(@ToolParam(description= "City or state name") String location) {
            ...
        }
    }

    String response = ChatClient.create(this.chatModel)
            .prompt("What's the weather like in Boston?")
            .tools(new WeatherService())
            .call()
            .content();

You can also register a `ToolCallback` bean and pass it directly:

    @Bean
    ToolCallback weatherFunction() {
        return FunctionToolCallback.builder("weatherFunction", new MockWeatherService())
            .description("Get the weather in location. Return temperature in 36°F or 36°C format.")
            .inputType(Request.class)
            .build();
    }

    String response = ChatClient.create(this.chatModel)
            .prompt("What's the weather like in Boston?")
            .tools(weatherFunction)
            .call()
            .content();

### User-Controlled Tool Execution

Use this pattern when you need direct access to the `ChatModel` API and want full control over the tool-call loop. Invoke `ChatModel` directly without `ToolCallingAdvisor`; check for tool calls yourself and drive the loop using `ToolCallingManager`.

    ToolCallingManager toolCallingManager = ToolCallingManager.builder().build();

    GoogleGenAiChatOptions options = GoogleGenAiChatOptions.builder()
            .toolCallbacks(ToolCallbacks.from(new WeatherService()))
            .build();

    Prompt prompt = new Prompt("What's the weather like in Boston?", options);
    ChatResponse response = chatModel.call(prompt);

    while (response.hasToolCalls()) {
        ToolExecutionResult toolExecutionResult = toolCallingManager.executeToolCalls(prompt, response);
        prompt = new Prompt(toolExecutionResult.conversationHistory(), options);
        response = chatModel.call(prompt);
    }

Find more in Tools documentation.

## Server-Side Tool Invocations

When Google Search or other server-side tools are enabled via `googleSearchRetrieval(true)`, the model executes these tools on the server. By default, these invocations are invisible to the client — you only see the final text response. Setting `includeServerSideToolInvocations(true)` makes the API include the server’s tool calls and responses in the response content, allowing you to observe what the model searched for and what results it received.

### Configuration

Enable via application properties:

    spring.ai.google.genai.chat.google-search-retrieval=true
    spring.ai.google.genai.chat.include-server-side-tool-invocations=true

Or programmatically at runtime:

    ChatResponse response = chatModel.call(
        new Prompt(
            "What are the latest developments in quantum computing?",
            GoogleGenAiChatOptions.builder()
                .model("gemini-2.0-flash")
                .googleSearchRetrieval(true)
                .includeServerSideToolInvocations(true)
                .build()
        ));

### Accessing Server-Side Tool Invocation Metadata

When enabled, server-side tool invocations are available in the response message metadata under the `serverSideToolInvocations` key:

    ChatResponse response = chatModel.call(prompt);

    Map<String, Object> metadata = response.getResult().getOutput().getMetadata();

    List<Map<String, Object>> invocations =
        (List<Map<String, Object>>) metadata.get("serverSideToolInvocations");

    if (invocations != null) {
        for (Map<String, Object> invocation : invocations) {
            String type = (String) invocation.get("type");       // "toolCall" or "toolResponse"
            String id = (String) invocation.get("id");            // Unique invocation ID
            String toolType = (String) invocation.get("toolType"); // e.g., "GOOGLE_SEARCH_WEB"

            if ("toolCall".equals(type)) {
                Map<String, Object> args = (Map<String, Object>) invocation.get("args");
                // Inspect what the model searched for
            } else if ("toolResponse".equals(type)) {
                Map<String, Object> responseData = (Map<String, Object>) invocation.get("response");
                // Inspect what search results the model received
            }
        }
    }

Each entry in the list contains:

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 25%" />
<col style="width: 75%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Field</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>type</code></p></td>
<td class="tableblock halign-left valign-top"><p>Either <code>"toolCall"</code> (the model’s invocation request) or <code>"toolResponse"</code> (the server’s result)</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>id</code></p></td>
<td class="tableblock halign-left valign-top"><p>Unique identifier linking a <code>toolCall</code> to its corresponding <code>toolResponse</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>toolType</code></p></td>
<td class="tableblock halign-left valign-top"><p>The type of server-side tool (e.g., <code>GOOGLE_SEARCH_WEB</code>, <code>GOOGLE_SEARCH_IMAGE</code>, <code>URL_CONTEXT</code>, <code>GOOGLE_MAPS</code>)</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>args</code></p></td>
<td class="tableblock halign-left valign-top"><p>(toolCall only) The arguments passed to the tool</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>response</code></p></td>
<td class="tableblock halign-left valign-top"><p>(toolResponse only) The results returned by the tool</p></td>
</tr>
</tbody>
</table>

### Combined with Function Calling

Server-side tool invocations work alongside client-side function calling. You can enable both Google Search (server-side) and custom functions (client-side) in the same request:

    ChatResponse response = chatModel.call(
        new Prompt(
            "What's the weather in San Francisco? Also search for the latest news about the city.",
            GoogleGenAiChatOptions.builder()
                .model("gemini-2.0-flash")
                .googleSearchRetrieval(true)
                .includeServerSideToolInvocations(true)
                .toolCallbacks(List.of(
                    FunctionToolCallback.builder("get_current_weather", new WeatherService())
                        .description("Get the current weather in a given location")
                        .inputType(WeatherRequest.class)
                        .build()))
                .build()
        ));

    // The response contains:
    // - Weather data from the client-side function call (executed locally)
    // - Google Search invocations visible in metadata (executed server-side)

## Thinking Configuration

Gemini models support a "thinking" capability that allows the model to perform deeper reasoning before generating responses. This is controlled through the `ThinkingConfig` which includes three related options: `thinkingBudget`, `thinkingLevel`, and `includeThoughts`.

### Thinking Level

The `thinkingLevel` option controls the depth of reasoning tokens the model generates. This is available for models that support thinking (e.g., Gemini 3 Pro Preview).

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 25%" />
<col style="width: 75%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Value</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>THINKING_LEVEL_UNSPECIFIED</code></p></td>
<td class="tableblock halign-left valign-top"><p>The model uses its default behavior.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>MINIMAL</code></p></td>
<td class="tableblock halign-left valign-top"><p>Matches the "no thinking" setting for most queries. Minimizes latency.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>LOW</code></p></td>
<td class="tableblock halign-left valign-top"><p>Low thinking. Minimal reasoning tokens.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>MEDIUM</code></p></td>
<td class="tableblock halign-left valign-top"><p>Balanced thinking for most tasks.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>HIGH</code></p></td>
<td class="tableblock halign-left valign-top"><p>Extensive thinking. Use for complex problems requiring deep analysis and step-by-step reasoning.</p></td>
</tr>
</tbody>
</table>

#### Configuration via Properties

    spring.ai.google.genai.chat.model=gemini-3.1-pro-preview
    spring.ai.google.genai.chat.thinking-level=HIGH

#### Programmatic Configuration

    import org.springframework.ai.google.genai.common.GoogleGenAiThinkingLevel;

    ChatResponse response = chatModel.call(
        new Prompt(
            "Explain the theory of relativity in simple terms.",
            GoogleGenAiChatOptions.builder()
                .model("gemini-3.1-pro-preview")
                .thinkingLevel(GoogleGenAiThinkingLevel.HIGH)
                .build()
        ));

### Thinking Budget

The `thinkingBudget` option sets a token budget for the thinking process:

- **Positive value**: Maximum number of tokens for thinking (e.g., `8192`)

- **Zero (`0`)**: Disables thinking entirely

- **Not set**: Model decides automatically based on query complexity

    ChatResponse response = chatModel.call(
        new Prompt(
            "Solve this complex math problem step by step.",
            GoogleGenAiChatOptions.builder()
                .model("gemini-2.5-pro")
                .thinkingBudget(8192)
                .build()
        ));

### Option Compatibility

You can combine `includeThoughts` with either `thinkingLevel` or `thinkingBudget` (but not both):

    // For Gemini 3.x (e.g. Pro): use thinkingLevel + includeThoughts
    ChatResponse response = chatModel.call(
        new Prompt(
            "Analyze this complex scenario.",
            GoogleGenAiChatOptions.builder()
                .model("gemini-3.1-pro-preview")
                .thinkingLevel(GoogleGenAiThinkingLevel.HIGH)
                .includeThoughts(true)
                .build()
        ));

    // For Gemini 2.5: use thinkingBudget + includeThoughts
    ChatResponse response = chatModel.call(
        new Prompt(
            "Analyze this complex scenario.",
            GoogleGenAiChatOptions.builder()
                .model("gemini-2.5-pro")
                .thinkingBudget(8192)
                .includeThoughts(true)
                .build()
        ));

### Model Support

The thinking configuration options are model-specific:

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 12%" />
<col style="width: 12%" />
<col style="width: 25%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Model</th>
<th class="tableblock halign-left valign-top">Model ID</th>
<th class="tableblock halign-left valign-top">thinkingLevel</th>
<th class="tableblock halign-left valign-top">thinkingBudget</th>
<th class="tableblock halign-left valign-top">Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Gemini 3 Pro Preview</p></td>
<td class="tableblock halign-left valign-top"><p><code>gemini-3.1-pro-preview</code></p></td>
<td class="tableblock halign-left valign-top"><p>✅ Only <code>LOW</code> and <code>HIGH</code></p></td>
<td class="tableblock halign-left valign-top"><p>⚠️ Backwards compatible only</p></td>
<td class="tableblock halign-left valign-top"><p>Use <code>thinkingLevel</code>. Cannot disable thinking. Requires <strong>global</strong> endpoint.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Gemini 3.5 Flash</p></td>
<td class="tableblock halign-left valign-top"><p><code>gemini-3.5-flash</code></p></td>
<td class="tableblock halign-left valign-top"><p>✅ All levels</p></td>
<td class="tableblock halign-left valign-top"><p>❌ Not supported</p></td>
<td class="tableblock halign-left valign-top"><p>Use <code>thinkingLevel</code> with any level including <code>MINIMAL</code> and <code>MEDIUM</code>.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Gemini 3.1 Flash-Lite</p></td>
<td class="tableblock halign-left valign-top"><p><code>gemini-3.1-flash-lite</code></p></td>
<td class="tableblock halign-left valign-top"><p>✅ All levels</p></td>
<td class="tableblock halign-left valign-top"><p>❌ Not supported</p></td>
<td class="tableblock halign-left valign-top"><p>Use <code>thinkingLevel</code> with any level including <code>MINIMAL</code> and <code>MEDIUM</code>.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Gemini 2.5 Pro</p></td>
<td class="tableblock halign-left valign-top"><p><code>gemini-2.5-pro</code></p></td>
<td class="tableblock halign-left valign-top"><p>❌ Not supported</p></td>
<td class="tableblock halign-left valign-top"><p>✅ Supported</p></td>
<td class="tableblock halign-left valign-top"><p>Use <code>thinkingBudget</code>. Set to 0 to disable, -1 for dynamic.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Gemini 2.5 Flash</p></td>
<td class="tableblock halign-left valign-top"><p><code>gemini-2.5-flash</code></p></td>
<td class="tableblock halign-left valign-top"><p>❌ Not supported</p></td>
<td class="tableblock halign-left valign-top"><p>✅ Supported</p></td>
<td class="tableblock halign-left valign-top"><p>Use <code>thinkingBudget</code>. Set to 0 to disable, -1 for dynamic.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Gemini 2.5 Flash-Lite</p></td>
<td class="tableblock halign-left valign-top"><p><code>gemini-2.5-flash-lite</code></p></td>
<td class="tableblock halign-left valign-top"><p>❌ Not supported</p></td>
<td class="tableblock halign-left valign-top"><p>✅ Supported</p></td>
<td class="tableblock halign-left valign-top"><p>Thinking disabled by default. Set <code>thinkingBudget</code> to enable.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Gemini 2.0 Flash</p></td>
<td class="tableblock halign-left valign-top"><p><code>gemini-2.0-flash-001</code></p></td>
<td class="tableblock halign-left valign-top"><p>❌ Not supported</p></td>
<td class="tableblock halign-left valign-top"><p>❌ Not supported</p></td>
<td class="tableblock halign-left valign-top"><p>Thinking not available.</p></td>
</tr>
</tbody>
</table>

## Thought Signatures

Gemini 3 Pro introduces thought signatures, which are opaque byte arrays that preserve the model’s reasoning context during function calling. When `includeThoughts` is enabled, the model returns thought signatures that must be passed back within the **same turn** during the tool-call loop.

### When Thought Signatures Matter

**IMPORTANT**: Thought signature validation only applies to the **current turn** - specifically during the tool-call loop when the model makes function calls (both parallel and sequential). The API does **not** validate thought signatures for previous turns in conversation history.

Per Google’s documentation:

- Validation is enforced for function calls within the current turn only

- Previous turn signatures do not need to be preserved

- Missing signatures in the current turn’s function calls result in HTTP 400 errors for Gemini 3 Pro

- For parallel function calls, only the first `functionCall` part carries the signature

For Gemini 2.5 Pro and earlier models, thought signatures are optional and the API is lenient.

### Configuration

Enable thought signatures using configuration properties:

    spring.ai.google.genai.chat.model=gemini-3.1-pro-preview
    spring.ai.google.genai.chat.include-thoughts=true

Or programmatically at runtime:

    ChatResponse response = chatModel.call(
        new Prompt(
            "Your question here",
            GoogleGenAiChatOptions.builder()
                .model("gemini-3.1-pro-preview")
                .includeThoughts(true)
                .toolCallbacks(callbacks)
                .build()
        ));

### Automatic Handling via ChatClient (Recommended)

When using `ChatClient` with `ToolCallingAdvisor` (the recommended approach), Spring AI automatically handles thought signatures:

1.  **Extracts** thought signatures from model responses

2.  **Attaches** them to the correct `functionCall` parts when sending back function responses

3.  **Propagates** them correctly during function calls within a single turn (both parallel and sequential)

    @Bean
    ToolCallback weatherFunction() {
        return FunctionToolCallback.builder("weatherFunction", new WeatherService())
            .description("Get the weather in a location")
            .inputType(WeatherRequest.class)
            .build();
    }

    // Enable includeThoughts for Gemini 3 Pro with function calling
    String response = ChatClient.create(this.chatModel)
            .prompt("What's the weather like in Boston?")
            .options(GoogleGenAiChatOptions.builder()
                .model("gemini-3.1-pro-preview")
                .includeThoughts(true)
                .build())
            .tools(weatherFunction)
            .call()
            .content();

### User-Controlled Tool Execution with Thought Signatures

When using a manual tool execution loop, you must preserve thought signatures by keeping the original `AssistantMessage` (with its metadata) in the conversation history. Spring AI automatically attaches the signatures to the correct `functionCall` parts when converting messages.

**Requirements for manual tool execution with thought signatures:**

1.  Extract thought signatures from the response metadata:

        AssistantMessage assistantMessage = response.getResult().getOutput();
        Map<String, Object> metadata = assistantMessage.getMetadata();
        List<byte[]> thoughtSignatures = (List<byte[]>) metadata.get("thoughtSignatures");

2.  When sending back function responses, include the original `AssistantMessage` with its metadata intact in your message history. Spring AI will automatically attach the thought signatures to the correct `functionCall` parts.

3.  For Gemini 3 Pro, failing to preserve thought signatures during the current turn will result in HTTP 400 errors from the API.

## Multimodal

Multimodality refers to a model’s ability to simultaneously understand and process information from various (input) sources, including `text`, `pdf`, `images`, `audio`, and other data formats.

### Image, Audio, Video

Google’s Gemini AI models support this capability by comprehending and integrating text, code, audio, images, and video. For more details, refer to the blog post Introducing Gemini.

Spring AI’s `Message` interface supports multimodal AI models by introducing the Media type. This type contains data and information about media attachments in messages, using Spring’s `org.springframework.util.MimeType` and a `java.lang.Object` for the raw media data.

Below is a simple code example extracted from GoogleGenAiChatModelIT.java, demonstrating the combination of user text with an image.

    byte[] data = new ClassPathResource("/vertex-test.png").getContentAsByteArray();

    var userMessage = UserMessage.builder()
                .text("Explain what do you see o this picture?")
                .media(List.of(new Media(MimeTypeUtils.IMAGE_PNG, data)))
                .build();

    ChatResponse response = chatModel.call(new Prompt(List.of(this.userMessage)));

### PDF

Google GenAI provides support for PDF input types. Use the `application/pdf` media type to attach a PDF file to the message:

    var pdfData = new ClassPathResource("/spring-ai-reference-overview.pdf");

    var userMessage = UserMessage.builder()
                .text("You are a very professional document summarization specialist. Please summarize the given document.")
                .media(List.of(new Media(new MimeType("application", "pdf"), pdfData)))
                .build();

    var response = this.chatModel.call(new Prompt(List.of(userMessage)));

## Cached Content

Google GenAI’s Context Caching allows you to cache large amounts of content (such as long documents, code repositories, or media) and reuse it across multiple requests. This significantly reduces API costs and improves response latency for repeated queries on the same content.

### Benefits

- **Cost Reduction**: Cached tokens are billed at a much lower rate than regular input tokens (typically 75-90% cheaper)

- **Improved Performance**: Reusing cached content reduces processing time for large contexts

- **Consistency**: Same cached context ensures consistent responses across multiple requests

### Cache Requirements

- Minimum cache size: 32,768 tokens (approximately 25,000 words)

- Maximum cache duration: 1 hour by default (configurable via TTL)

- Cached content must include either system instructions or conversation history

### Using Cached Content Service

Spring AI provides `GoogleGenAiCachedContentService` for programmatic cache management. The service is automatically configured when using the Spring Boot auto-configuration.

#### Creating Cached Content

    @Autowired
    private GoogleGenAiCachedContentService cachedContentService;

    // Create cached content with a large document
    String largeDocument = "... your large context here (>32k tokens) ...";

    CachedContentRequest request = CachedContentRequest.builder()
        .model("gemini-2.5-flash")
        .contents(List.of(
            Content.builder()
                .role("user")
                .parts(List.of(Part.fromText(largeDocument)))
                .build()
        ))
        .displayName("My Large Document Cache")
        .ttl(Duration.ofHours(1))
        .build();

    GoogleGenAiCachedContent cachedContent = cachedContentService.create(request);
    String cacheName = cachedContent.getName(); // Save this for reuse

#### Using Cached Content in Chat Requests

Once you’ve created cached content, reference it in your chat requests:

    ChatResponse response = chatModel.call(
        new Prompt(
            "Summarize the key points from the document",
            GoogleGenAiChatOptions.builder()
                .useCachedContent(true)
                .cachedContentName(cacheName) // Use the cached content name
                .build()
        ));

Or via configuration properties:

    spring.ai.google.genai.chat.use-cached-content=true
    spring.ai.google.genai.chat.cached-content-name=cachedContent/your-cache-name

#### Managing Cached Content

The `GoogleGenAiCachedContentService` provides comprehensive cache management:

    // Retrieve cached content
    GoogleGenAiCachedContent content = cachedContentService.get(cacheName);

    // Update cache TTL
    CachedContentUpdateRequest updateRequest = CachedContentUpdateRequest.builder()
        .ttl(Duration.ofHours(2))
        .build();
    GoogleGenAiCachedContent updated = cachedContentService.update(cacheName, updateRequest);

    // List all cached content
    List<GoogleGenAiCachedContent> allCaches = cachedContentService.listAll();

    // Delete cached content
    boolean deleted = cachedContentService.delete(cacheName);

    // Extend cache TTL
    GoogleGenAiCachedContent extended = cachedContentService.extendTtl(cacheName, Duration.ofMinutes(30));

    // Cleanup expired caches
    int removedCount = cachedContentService.cleanupExpired();

#### Asynchronous Operations

All operations have asynchronous variants:

    CompletableFuture<GoogleGenAiCachedContent> futureCache =
        cachedContentService.createAsync(request);

    CompletableFuture<GoogleGenAiCachedContent> futureGet =
        cachedContentService.getAsync(cacheName);

    CompletableFuture<Boolean> futureDelete =
        cachedContentService.deleteAsync(cacheName);

### Auto-Caching

Spring AI can automatically cache large prompts when they exceed a specified token threshold:

    # Automatically cache prompts larger than 100,000 tokens
    spring.ai.google.genai.chat.auto-cache-threshold=100000
    # Set auto-cache TTL to 1 hour
    spring.ai.google.genai.chat.auto-cache-ttl=PT1H

Or programmatically:

    ChatResponse response = chatModel.call(
        new Prompt(
            largePrompt,
            GoogleGenAiChatOptions.builder()
                .autoCacheThreshold(100000)
                .autoCacheTtl(Duration.ofHours(1))
                .build()
        ));

### Monitoring Cache Usage

Cached content includes usage metadata accessible via the service:

    GoogleGenAiCachedContent content = cachedContentService.get(cacheName);

    // Check if cache is expired
    boolean expired = content.isExpired();

    // Get remaining TTL
    Duration remaining = content.getRemainingTtl();

    // Get usage metadata
    CachedContentUsageMetadata metadata = content.getUsageMetadata();
    if (metadata != null) {
        System.out.println("Total tokens: " + metadata.totalTokenCount().orElse(0));
    }

### Best Practices

1.  **Cache Lifetime**: Set appropriate TTL based on your use case. Shorter TTLs for frequently changing content, longer for static content.

2.  **Cache Naming**: Use descriptive display names to identify cached content easily.

3.  **Cleanup**: Periodically clean up expired caches to maintain organization.

4.  **Token Threshold**: Only cache content that exceeds the minimum threshold (32,768 tokens).

5.  **Cost Optimization**: Reuse cached content across multiple requests to maximize cost savings.

### Configuration Example

Complete configuration example:

    # Enable cached content service (enabled by default)
    spring.ai.google.genai.chat.enable-cached-content=true

    # Use a specific cached content
    spring.ai.google.genai.chat.use-cached-content=true
    spring.ai.google.genai.chat.cached-content-name=cachedContent/my-cache-123

    # Auto-caching configuration
    spring.ai.google.genai.chat.auto-cache-threshold=50000
    spring.ai.google.genai.chat.auto-cache-ttl=PT30M

## Sample Controller

Create a new Spring Boot project and add the `spring-ai-starter-model-google-genai` to your pom (or gradle) dependencies.

Add a `application.properties` file, under the `src/main/resources` directory, to enable and configure the Google GenAI chat model:

### Using Gemini Developer API (API Key)

    spring.ai.google.genai.api-key=YOUR_API_KEY
    spring.ai.google.genai.chat.model=gemini-2.5-flash
    spring.ai.google.genai.chat.temperature=0.5

### Using Vertex AI

    spring.ai.google.genai.project-id=PROJECT_ID
    spring.ai.google.genai.location=LOCATION
    spring.ai.google.genai.chat.model=gemini-2.5-flash
    spring.ai.google.genai.chat.temperature=0.5

This will create a `GoogleGenAiChatModel` implementation that you can inject into your class. Here is an example of a simple `@Controller` class that uses the chat model for text generations.

    @RestController
    public class ChatController {

        private final GoogleGenAiChatModel chatModel;

        @Autowired
        public ChatController(GoogleGenAiChatModel chatModel) {
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

## Manual Configuration

The GoogleGenAiChatModel implements the `ChatModel` and uses the `com.google.genai.Client` to connect to the Google GenAI service.

Add the `spring-ai-google-genai` dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-google-genai</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-google-genai'
    }

Next, create a `GoogleGenAiChatModel` and use it for text generations:

### Using API Key

    Client genAiClient = Client.builder()
        .apiKey(System.getenv("GOOGLE_API_KEY"))
        .build();

    var chatModel = new GoogleGenAiChatModel(genAiClient,
        GoogleGenAiChatOptions.builder()
            .model(ChatModel.GEMINI_2_0_FLASH)
            .temperature(0.4)
        .build());

    ChatResponse response = this.chatModel.call(
        new Prompt("Generate the names of 5 famous pirates."));

### Using Vertex AI

    Client genAiClient = Client.builder()
        .project(System.getenv("GOOGLE_CLOUD_PROJECT"))
        .location(System.getenv("GOOGLE_CLOUD_LOCATION"))
        .vertexAI(true)
        .build();

    var chatModel = new GoogleGenAiChatModel(genAiClient,
        GoogleGenAiChatOptions.builder()
            .model(ChatModel.GEMINI_2_0_FLASH)
            .temperature(0.4)
        .build());

    ChatResponse response = this.chatModel.call(
        new Prompt("Generate the names of 5 famous pirates."));

The `GoogleGenAiChatOptions` provides the configuration information for the chat requests. The `GoogleGenAiChatOptions.Builder` is fluent options builder.

## Migration from Vertex AI Gemini

If you were previously using the Vertex AI Gemini implementation (`spring-ai-vertex-ai-gemini`), which has been removed, migrate to Google GenAI:

Key Differences:

1.  **SDK**: Google GenAI uses the new `com.google.genai.Client` instead of `com.google.cloud.vertexai.VertexAI`

2.  **Authentication**: Supports both API key and Google Cloud credentials (Vertex AI mode)

3.  **Package Names**: Classes are in `org.springframework.ai.google.genai` instead of `org.springframework.ai.vertexai.gemini`

4.  **Property Prefix**: Uses `spring.ai.google.genai` instead of `spring.ai.vertex.ai.gemini`

Google GenAI supports both quick prototyping with API keys and production deployments using Vertex AI through Google Cloud credentials.

## Low-level Java Client

The Google GenAI implementation is built on the new Google GenAI Java SDK, which provides a modern, streamlined API for accessing Gemini models.

Docker Model Runner Groq

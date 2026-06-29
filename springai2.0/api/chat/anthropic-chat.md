Search

# Anthropic Chat

Spring AI supports Anthropic’s Claude models through the official Anthropic Java SDK, providing access to Claude through Anthropic’s API.

## Prerequisites

Create an account at the Anthropic Console and generate an API key on the API Keys page.

### Add Repositories and BOM

Spring AI artifacts are published in Maven Central and Spring Snapshot repositories. Refer to the Artifact Repositories section to add these repositories to your build system.

To help with dependency management, Spring AI provides a BOM (bill of materials) to ensure that a consistent version of Spring AI is used throughout the entire project. Refer to the Dependency Management section to add the Spring AI BOM to your build system.

## Auto-Configuration

Spring Boot auto-configuration is available via the `spring-ai-starter-model-anthropic` starter.

### Configuration Properties

Use the `spring.ai.anthropic.*` properties to configure the Anthropic connection and chat options:

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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.api-key</code></p></td>
<td class="tableblock halign-left valign-top"><p>Anthropic API key</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.base-url</code></p></td>
<td class="tableblock halign-left valign-top"><p>API base URL</p></td>
<td class="tableblock halign-left valign-top"><p><code>api.anthropic.com</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.timeout</code></p></td>
<td class="tableblock halign-left valign-top"><p>Request timeout for the Anthropic client</p></td>
<td class="tableblock halign-left valign-top"><p><code>60s</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.max-retries</code></p></td>
<td class="tableblock halign-left valign-top"><p>Maximum number of retries for failed requests</p></td>
<td class="tableblock halign-left valign-top"><p><code>2</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.custom-headers.*</code></p></td>
<td class="tableblock halign-left valign-top"><p>Custom HTTP headers to add to all Anthropic client requests</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.chat.model</code></p></td>
<td class="tableblock halign-left valign-top"><p>Model name</p></td>
<td class="tableblock halign-left valign-top"><p><code>claude-haiku-4-5</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.chat.max-tokens</code></p></td>
<td class="tableblock halign-left valign-top"><p>Maximum tokens</p></td>
<td class="tableblock halign-left valign-top"><p><code>4096</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.chat.temperature</code></p></td>
<td class="tableblock halign-left valign-top"><p>Sampling temperature</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.chat.top-p</code></p></td>
<td class="tableblock halign-left valign-top"><p>Top-p sampling</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.chat.top-k</code></p></td>
<td class="tableblock halign-left valign-top"><p>Top-k sampling</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.chat.cache-options.strategy</code></p></td>
<td class="tableblock halign-left valign-top"><p>Caching strategy to use</p></td>
<td class="tableblock halign-left valign-top"><p><code>NONE</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.chat.cache-options.multi-block-system-caching</code></p></td>
<td class="tableblock halign-left valign-top"><p>Use separate blocks for each system message</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.chat.http-headers</code></p></td>
<td class="tableblock halign-left valign-top"><p>Per-request HTTP headers to pass to individual API calls.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.chat.inference-geo</code></p></td>
<td class="tableblock halign-left valign-top"><p>Geographic region where the request is processed (<code>us</code> or <code>eu</code>)</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.chat.web-search-tool.max-uses</code></p></td>
<td class="tableblock halign-left valign-top"><p>Maximum number of web searches per request</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.chat.web-search-tool.allowed-domains</code></p></td>
<td class="tableblock halign-left valign-top"><p>Comma-separated list of domains to restrict search results to</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.chat.web-search-tool.blocked-domains</code></p></td>
<td class="tableblock halign-left valign-top"><p>Comma-separated list of domains to exclude from search results</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.chat.web-search-tool.user-location.city</code></p></td>
<td class="tableblock halign-left valign-top"><p>City for localizing search results</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.chat.web-search-tool.user-location.country</code></p></td>
<td class="tableblock halign-left valign-top"><p>ISO 3166-1 alpha-2 country code</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.chat.web-search-tool.user-location.region</code></p></td>
<td class="tableblock halign-left valign-top"><p>Region or state</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.chat.web-search-tool.user-location.timezone</code></p></td>
<td class="tableblock halign-left valign-top"><p>IANA timezone identifier</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.anthropic.chat.service-tier</code></p></td>
<td class="tableblock halign-left valign-top"><p>Capacity routing: <code>auto</code> (use priority if available) or <code>standard_only</code> (always standard). See Service Tiers.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

## Manual Configuration

The AnthropicChatModel implements the `ChatModel` interface and uses the official Anthropic Java SDK to connect to Claude.

### Authentication

Configure your API key either programmatically or via environment variable:

    var chatOptions = AnthropicChatOptions.builder()
        .model("claude-sonnet-4-20250514")
        .maxTokens(1024)
        .apiKey(System.getenv("ANTHROPIC_API_KEY"))
        .build();

    var chatModel = AnthropicChatModel.builder()
        .options(chatOptions)
        .build();

Or set the environment variable and let the SDK auto-detect it:

    export ANTHROPIC_API_KEY=<your-api-key>

    // API key will be detected from ANTHROPIC_API_KEY environment variable
    var chatModel = AnthropicChatModel.builder()
        .options(AnthropicChatOptions.builder()
            .model("claude-sonnet-4-20250514")
            .maxTokens(1024)
            .build())
        .build();

### Basic Usage

    ChatResponse response = chatModel.call(
        new Prompt("Generate the names of 5 famous pirates."));

    // Or with streaming responses
    Flux<ChatResponse> stream = chatModel.stream(
        new Prompt("Generate the names of 5 famous pirates."));

## Runtime Options

The AnthropicChatOptions.java class provides model configurations such as the model to use, temperature, max tokens, etc.

On start-up, configure default options with the `AnthropicChatModel.builder().defaultOptions(options).build()` constructor.

At run-time, you can override the default options by adding new, request-specific options to the `Prompt` call. For example, to override the default model and temperature for a specific request:

    ChatResponse response = chatModel.call(
        new Prompt(
            "Generate the names of 5 famous pirates.",
            AnthropicChatOptions.builder()
                .model("claude-sonnet-4-20250514")
                .temperature(0.4)
            .build()
        ));

### Chat Options

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 33%" />
<col style="width: 55%" />
<col style="width: 11%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Option</th>
<th class="tableblock halign-left valign-top">Description</th>
<th class="tableblock halign-left valign-top">Default</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>model</p></td>
<td class="tableblock halign-left valign-top"><p>Name of the Claude model to use. Models include: <code>claude-sonnet-4-20250514</code>, <code>claude-opus-4-20250514</code>, <code>claude-3-5-sonnet-20241022</code>, <code>claude-3-5-haiku-20241022</code>, etc. See Claude Models.</p></td>
<td class="tableblock halign-left valign-top"><p><code>claude-sonnet-4-20250514</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>maxTokens</p></td>
<td class="tableblock halign-left valign-top"><p>The maximum number of tokens to generate in the response.</p></td>
<td class="tableblock halign-left valign-top"><p>4096</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>temperature</p></td>
<td class="tableblock halign-left valign-top"><p>Controls randomness in the response. Higher values make output more random, lower values make it more deterministic. Range: 0.0-1.0</p></td>
<td class="tableblock halign-left valign-top"><p>1.0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>topP</p></td>
<td class="tableblock halign-left valign-top"><p>Nucleus sampling parameter. The model considers tokens with top_p probability mass. <strong>Supported on Claude Opus 4.6 and earlier models only. Deprecated by Anthropic for models released after Claude Opus 4.6 (e.g. <code>claude-opus-4-7</code>); values <code>&lt; 0.99</code> are rejected with HTTP 400, and values <code>&gt;= 0.99</code> are accepted as a backward-compatibility no-op (no actual filtering applied).</strong></p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>topK</p></td>
<td class="tableblock halign-left valign-top"><p>Only sample from the top K options for each token. <strong>Supported on Claude Opus 4.6 and earlier models only. Deprecated by Anthropic for models released after Claude Opus 4.6 (e.g. <code>claude-opus-4-7</code>); any value is rejected with HTTP 400 on those models.</strong></p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>stopSequences</p></td>
<td class="tableblock halign-left valign-top"><p>Custom sequences that will cause the model to stop generating.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>apiKey</p></td>
<td class="tableblock halign-left valign-top"><p>The API key for authentication. Auto-detects from <code>ANTHROPIC_API_KEY</code> environment variable if not set.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>baseUrl</p></td>
<td class="tableblock halign-left valign-top"><p>The base URL for the Anthropic API.</p></td>
<td class="tableblock halign-left valign-top"><p>api.anthropic.com</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>timeout</p></td>
<td class="tableblock halign-left valign-top"><p>Request timeout duration.</p></td>
<td class="tableblock halign-left valign-top"><p>60 seconds</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>maxRetries</p></td>
<td class="tableblock halign-left valign-top"><p>Maximum number of retry attempts for failed requests.</p></td>
<td class="tableblock halign-left valign-top"><p>2</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>proxy</p></td>
<td class="tableblock halign-left valign-top"><p>Proxy settings for the HTTP client.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>customHeaders</p></td>
<td class="tableblock halign-left valign-top"><p>Custom HTTP headers to include on all requests (client-level).</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>httpHeaders</p></td>
<td class="tableblock halign-left valign-top"><p>Per-request HTTP headers. These are added to individual API calls via <code>MessageCreateParams.putAdditionalHeader()</code>. Useful for request-level tracking, beta API headers, or routing.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>cacheOptions</p></td>
<td class="tableblock halign-left valign-top"><p>Options for configuring prompt caching behavior. Includes caching strategy, multi-block caching, TTL, and content length requirements.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>thinking</p></td>
<td class="tableblock halign-left valign-top"><p>Thinking configuration. Use the convenience builders <code>thinkingEnabled(budgetTokens)</code>, <code>thinkingEnabled(budgetTokens, display)</code>, <code>thinkingAdaptive()</code>, <code>thinkingAdaptive(display)</code>, or <code>thinkingDisabled()</code>, or pass a raw <code>ThinkingConfigParam</code>. The <code>display</code> parameter controls how thinking content appears in the response: <code>SUMMARIZED</code> (condensed summary) or <code>OMITTED</code> (redacted, signature only).</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>outputConfig</p></td>
<td class="tableblock halign-left valign-top"><p>Output configuration for structured output (JSON schema) and effort control. Use <code>outputConfig(OutputConfig)</code> for full control, or the convenience methods <code>outputSchema(String)</code> and <code>effort(OutputConfig.Effort)</code>. Requires <code>claude-sonnet-4-6</code> or newer.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>inferenceGeo</p></td>
<td class="tableblock halign-left valign-top"><p>Controls the geographic region where the request is processed. Supported values: <code>us</code>, <code>eu</code>. Used for data residency compliance. Configurable via <code>spring.ai.anthropic.chat.inference-geo</code>.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>serviceTier</p></td>
<td class="tableblock halign-left valign-top"><p>Controls capacity routing for the request. Use <code>MessageCreateParams.ServiceTier.AUTO</code> to opportunistically use priority capacity, or <code>STANDARD_ONLY</code> to always use standard capacity. See Service Tiers.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

### Tool Calling Options

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 33%" />
<col style="width: 55%" />
<col style="width: 11%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Option</th>
<th class="tableblock halign-left valign-top">Description</th>
<th class="tableblock halign-left valign-top">Default</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>toolChoice</p></td>
<td class="tableblock halign-left valign-top"><p>Controls which tool (if any) is called by the model. Use <code>ToolChoiceAuto</code>, <code>ToolChoiceAny</code>, <code>ToolChoiceTool</code>, or <code>ToolChoiceNone</code>.</p></td>
<td class="tableblock halign-left valign-top"><p>AUTO</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>toolCallbacks</p></td>
<td class="tableblock halign-left valign-top"><p>List of tool callbacks to register with the model.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>disableParallelToolUse</p></td>
<td class="tableblock halign-left valign-top"><p>When true, the model will use at most one tool per response.</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
</tbody>
</table>

## Rate Limit Metadata

The Anthropic API includes rate limit headers on every response that report your current request and token budgets along with when each window resets. Spring AI exposes this data through the standard `ChatResponseMetadata#getRateLimit()` accessor, which returns an `AnthropicRateLimit` populated from the response headers.

The portable `RateLimit` interface exposes the request and token families:

    ChatResponse response = chatModel.call(prompt);

    RateLimit rateLimit = response.getMetadata().getRateLimit();
    rateLimit.getRequestsLimit();      // overall request ceiling
    rateLimit.getRequestsRemaining();  // requests left in the current window
    rateLimit.getRequestsReset();      // time until the request window resets

    rateLimit.getTokensLimit();        // overall token ceiling
    rateLimit.getTokensRemaining();    // tokens left in the current window
    rateLimit.getTokensReset();        // time until the token window resets

Anthropic also reports separate buckets for input tokens and output tokens. These are exposed by the `AnthropicRateLimit` concrete type:

    if (response.getMetadata().getRateLimit() instanceof AnthropicRateLimit anthropic) {
        anthropic.getInputTokensLimit();
        anthropic.getInputTokensRemaining();
        anthropic.getInputTokensReset();

        anthropic.getOutputTokensLimit();
        anthropic.getOutputTokensRemaining();
        anthropic.getOutputTokensReset();
    }

If Anthropic does not return any rate-limit headers on a given response, `getRateLimit()` returns an `EmptyRateLimit` instance instead, matching the convention used by other Spring AI providers.

Rate-limit metadata is populated on both the synchronous `call(Prompt)` and the streaming `stream(Prompt)` paths. For streaming responses the headers are read once at stream start and attached to the response chunk that carries the final usage, so `getRateLimit()` resolves to a populated `AnthropicRateLimit` there.

## Tool Calling

You can register custom Java functions or methods with the `AnthropicChatModel` and have Claude intelligently choose to output a JSON object containing arguments to call one or many of the registered functions/tools. This is a powerful technique to connect the LLM capabilities with external tools and APIs. Read more about Tool Calling.

`AnthropicChatModel` does not execute tool calls internally. Tool execution must be handled externally using one of two supported approaches:

- **ChatClient with ToolCallingAdvisor** — the recommended approach for most use cases. `ToolCallingAdvisor` is automatically registered and manages the tool-call loop transparently.

- **User-controlled tool execution** — use `DefaultToolCallingManager` directly when you need full control over the loop (for example, when combining tool calling with prompt caching).

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

Use this pattern when you need direct access to the `ChatModel` API — for example, when combining tool calling with prompt caching. Invoke `ChatModel` directly without `ToolCallingAdvisor`; check for tool calls yourself and drive the loop using `ToolCallingManager`.

    ToolCallingManager toolCallingManager = ToolCallingManager.builder().build();

    AnthropicChatOptions options = AnthropicChatOptions.builder()
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

### Tool Choice Options

Control which tool Claude selects with the `toolChoice` option:

    import com.anthropic.models.messages.ToolChoiceAny;
    import com.anthropic.models.messages.ToolChoiceTool;
    import com.anthropic.models.messages.ToolChoiceNone;

    // Force Claude to use any available tool
    var options = AnthropicChatOptions.builder()
        .toolChoice(ToolChoiceAny.builder().build())
        .toolCallbacks(...)
        .build();

    // Force Claude to use a specific tool
    var options = AnthropicChatOptions.builder()
        .toolChoice(ToolChoiceTool.builder().name("getCurrentWeather").build())
        .toolCallbacks(...)
        .build();

    // Prevent tool use entirely
    var options = AnthropicChatOptions.builder()
        .toolChoice(ToolChoiceNone.builder().build())
        .toolCallbacks(...)
        .build();

## Streaming

The Anthropic SDK module supports both synchronous and streaming responses. Streaming allows Claude to return responses incrementally as they’re generated.

    Flux<ChatResponse> stream = chatModel.stream(new Prompt("Tell me a story"));

    stream.subscribe(response -> {
        String content = response.getResult().getOutput().getContent();
        if (content != null) {
            System.out.print(content);
        }
    });

## Extended Thinking

Anthropic Claude models support a "thinking" feature that allows the model to show its reasoning process before providing a final answer. This is especially useful for complex questions that require step-by-step reasoning, such as math, logic, and analysis tasks.

### Thinking Configuration

To enable thinking, configure the following:

1.  **Set a thinking budget**: The `budgetTokens` must be &gt;= 1024 and less than `maxTokens`.

2.  **Set temperature to 1.0**: Required when thinking is enabled.

### Convenience Builder Methods

`AnthropicChatOptions.Builder` provides convenience methods for thinking configuration:

    // Enable thinking with a specific token budget
    var options = AnthropicChatOptions.builder()
        .model("claude-sonnet-4-20250514")
        .temperature(1.0)
        .maxTokens(16000)
        .thinkingEnabled(10000L)    // budget must be >= 1024 and < maxTokens
        .build();

    // Let Claude adaptively decide whether to think
    var options = AnthropicChatOptions.builder()
        .model("claude-sonnet-4-20250514")
        .thinkingAdaptive()
        .build();

    // Explicitly disable thinking
    var options = AnthropicChatOptions.builder()
        .model("claude-sonnet-4-20250514")
        .thinkingDisabled()
        .build();

You can also use the raw SDK `ThinkingConfigParam` directly:

    import com.anthropic.models.messages.ThinkingConfigParam;
    import com.anthropic.models.messages.ThinkingConfigEnabled;

    var options = AnthropicChatOptions.builder()
        .thinking(ThinkingConfigParam.ofEnabled(
            ThinkingConfigEnabled.builder().budgetTokens(10000L).build()))
        .build();

### Thinking Display Setting

By default, full thinking output is returned in the response. You can control this with the `display` parameter to reduce token costs:

- **`SUMMARIZED`** — Claude still thinks fully, but returns a condensed summary instead of the raw chain-of-thought. Reduces output tokens while still providing insight into the reasoning.

- **`OMITTED`** — Thinking is performed but completely redacted from the response. Only a cryptographic signature is returned (needed for multi-turn continuity). Lowest output token cost.

    import com.anthropic.models.messages.ThinkingConfigEnabled;
    import com.anthropic.models.messages.ThinkingConfigAdaptive;

    // Enabled thinking with summarized display
    var options = AnthropicChatOptions.builder()
        .model("claude-sonnet-4-20250514")
        .temperature(1.0)
        .maxTokens(16000)
        .thinkingEnabled(10000L, ThinkingConfigEnabled.Display.SUMMARIZED)
        .build();

    // Enabled thinking with omitted display
    var options = AnthropicChatOptions.builder()
        .model("claude-sonnet-4-20250514")
        .temperature(1.0)
        .maxTokens(16000)
        .thinkingEnabled(10000L, ThinkingConfigEnabled.Display.OMITTED)
        .build();

    // Adaptive thinking with summarized display
    var options = AnthropicChatOptions.builder()
        .model("claude-sonnet-4-20250514")
        .temperature(1.0)
        .maxTokens(16000)
        .thinkingAdaptive(ThinkingConfigAdaptive.Display.SUMMARIZED)
        .build();

### Non-streaming Example

    var options = AnthropicChatOptions.builder()
        .model("claude-sonnet-4-20250514")
        .temperature(1.0)
        .maxTokens(16000)
        .thinkingEnabled(10000L)
        .build();

    ChatResponse response = chatModel.call(
        new Prompt("Are there an infinite number of prime numbers such that n mod 4 == 3?", options));

    // The response contains multiple generations:
    // - ThinkingBlock generations (with "signature" in metadata)
    // - TextBlock generations (with the final answer)
    for (Generation generation : response.getResults()) {
        AssistantMessage message = generation.getOutput();
        if (message.getMetadata().containsKey("signature")) {
            // This is a thinking block - contains Claude's reasoning
            System.out.println("Thinking: " + message.getText());
            System.out.println("Signature: " + message.getMetadata().get("signature"));
        }
        else if (message.getMetadata().containsKey("data")) {
            // This is a redacted thinking block (safety-redacted reasoning)
            System.out.println("Redacted thinking data: " + message.getMetadata().get("data"));
        }
        else if (message.getText() != null && !message.getText().isBlank()) {
            // This is the final text response
            System.out.println("Answer: " + message.getText());
        }
    }

### Streaming Example

Thinking is fully supported in streaming mode. Thinking deltas and signature deltas are emitted as they arrive:

    var options = AnthropicChatOptions.builder()
        .model("claude-sonnet-4-20250514")
        .temperature(1.0)
        .maxTokens(16000)
        .thinkingEnabled(10000L)
        .build();

    Flux<ChatResponse> stream = chatModel.stream(
        new Prompt("Are there an infinite number of prime numbers such that n mod 4 == 3?", options));

    stream.subscribe(response -> {
        Generation generation = response.getResult();
        AssistantMessage message = generation.getOutput();

        if (message.getMetadata().containsKey("thinking")) {
            // Incremental thinking content
            System.out.print(message.getText());
        }
        else if (message.getMetadata().containsKey("signature")) {
            // Thinking block signature (emitted at end of thinking)
            System.out.println("\nSignature: " + message.getMetadata().get("signature"));
        }
        else if (message.getText() != null) {
            // Final text content
            System.out.print(message.getText());
        }
    });

### Response Structure

When thinking is enabled, the response contains different types of content:

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 25%" />
<col style="width: 37%" />
<col style="width: 37%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Content Type</th>
<th class="tableblock halign-left valign-top">Metadata Key</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><strong>Thinking Block</strong></p></td>
<td class="tableblock halign-left valign-top"><p><code>signature</code></p></td>
<td class="tableblock halign-left valign-top"><p>Claude’s reasoning text with a cryptographic signature. In sync mode, the thinking text is in <code>getText()</code> and the signature is in <code>getMetadata().get("signature")</code>.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><strong>Redacted Thinking</strong></p></td>
<td class="tableblock halign-left valign-top"><p><code>data</code></p></td>
<td class="tableblock halign-left valign-top"><p>Safety-redacted reasoning. Contains only a <code>data</code> marker, no visible text.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><strong>Signature (streaming)</strong></p></td>
<td class="tableblock halign-left valign-top"><p><code>signature</code></p></td>
<td class="tableblock halign-left valign-top"><p>In streaming mode, the signature arrives as a separate delta at the end of a thinking block.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><strong>Thinking Delta (streaming)</strong></p></td>
<td class="tableblock halign-left valign-top"><p><code>thinking</code></p></td>
<td class="tableblock halign-left valign-top"><p>Incremental thinking text chunks during streaming. The <code>thinking</code> metadata key is set to <code>true</code>.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><strong>Text Block</strong></p></td>
<td class="tableblock halign-left valign-top"><p><em>(none)</em></p></td>
<td class="tableblock halign-left valign-top"><p>The final answer text in <code>getText()</code>.</p></td>
</tr>
</tbody>
</table>

## Multi-Modal Support

The Anthropic SDK module supports multi-modal inputs, allowing you to send images and PDF documents alongside text in your prompts.

### Image Input

Send images to Claude for analysis using the `Media` class:

    var imageResource = new ClassPathResource("/test-image.png");

    var userMessage = UserMessage.builder()
        .text("What do you see in this image?")
        .media(List.of(new Media(MimeTypeUtils.IMAGE_PNG, imageResource)))
        .build();

    ChatResponse response = chatModel.call(new Prompt(List.of(userMessage)));

Supported image formats: PNG, JPEG, GIF, WebP. Images can be provided as:

- Byte arrays (automatically base64-encoded)

- HTTPS URLs (passed directly to the API)

### PDF Document Input

Send PDF documents for Claude to analyze:

    var pdfResource = new ClassPathResource("/document.pdf");

    var userMessage = UserMessage.builder()
        .text("Please summarize this document.")
        .media(List.of(new Media(new MimeType("application", "pdf"), pdfResource)))
        .build();

    ChatResponse response = chatModel.call(new Prompt(List.of(userMessage)));

### Multiple Media Items

You can include multiple images or documents in a single message:

    var userMessage = UserMessage.builder()
        .text("Compare these two images.")
        .media(List.of(
            new Media(MimeTypeUtils.IMAGE_PNG, image1Resource),
            new Media(MimeTypeUtils.IMAGE_PNG, image2Resource)))
        .build();

## Citations

Anthropic’s Citations API allows Claude to reference specific parts of provided documents when generating responses. When citation documents are included in a prompt, Claude can cite the source material, and citation metadata (character ranges, page numbers, or content blocks) is returned in the response metadata.

Citations help improve:

- **Accuracy verification**: Users can verify Claude’s responses against source material

- **Transparency**: See exactly which parts of documents informed the response

- **Compliance**: Meet requirements for source attribution in regulated industries

- **Trust**: Build confidence by showing where information came from

### Creating Citation Documents

Use the `AnthropicCitationDocument` builder to create documents that can be cited:

#### Plain Text Documents

    AnthropicCitationDocument document = AnthropicCitationDocument.builder()
        .plainText("The Eiffel Tower was completed in 1889 in Paris, France. " +
                   "It stands 330 meters tall and was designed by Gustave Eiffel.")
        .title("Eiffel Tower Facts")
        .citationsEnabled(true)
        .build();

#### PDF Documents

    // From file path
    AnthropicCitationDocument document = AnthropicCitationDocument.builder()
        .pdfFile("path/to/document.pdf")
        .title("Technical Specification")
        .citationsEnabled(true)
        .build();

    // From byte array
    byte[] pdfBytes = loadPdfBytes();
    AnthropicCitationDocument document = AnthropicCitationDocument.builder()
        .pdf(pdfBytes)
        .title("Product Manual")
        .citationsEnabled(true)
        .build();

#### Custom Content Blocks

For fine-grained citation control, use custom content blocks:

    AnthropicCitationDocument document = AnthropicCitationDocument.builder()
        .customContent(
            "The Great Wall of China is approximately 21,196 kilometers long.",
            "It was built over many centuries, starting in the 7th century BC.",
            "The wall was constructed to protect Chinese states from invasions."
        )
        .title("Great Wall Facts")
        .citationsEnabled(true)
        .build();

### Using Citations in Requests

Include citation documents in your chat options:

    ChatResponse response = chatModel.call(
        new Prompt(
            "When was the Eiffel Tower built and how tall is it?",
            AnthropicChatOptions.builder()
                .model("claude-sonnet-4-20250514")
                .maxTokens(1024)
                .citationDocuments(document)
                .build()
        )
    );

#### Multiple Documents

You can provide multiple documents for Claude to reference:

    AnthropicCitationDocument parisDoc = AnthropicCitationDocument.builder()
        .plainText("Paris is the capital city of France with a population of 2.1 million.")
        .title("Paris Information")
        .citationsEnabled(true)
        .build();

    AnthropicCitationDocument eiffelDoc = AnthropicCitationDocument.builder()
        .plainText("The Eiffel Tower was designed by Gustave Eiffel for the 1889 World's Fair.")
        .title("Eiffel Tower History")
        .citationsEnabled(true)
        .build();

    ChatResponse response = chatModel.call(
        new Prompt(
            "What is the capital of France and who designed the Eiffel Tower?",
            AnthropicChatOptions.builder()
                .model("claude-sonnet-4-20250514")
                .citationDocuments(parisDoc, eiffelDoc)
                .build()
        )
    );

### Accessing Citations

Citations are returned in the response metadata:

    ChatResponse response = chatModel.call(prompt);

    // Get citations from metadata
    List<Citation> citations = (List<Citation>) response.getMetadata().get("citations");

    // Optional: Get citation count directly from metadata
    Integer citationCount = (Integer) response.getMetadata().get("citationCount");
    System.out.println("Total citations: " + citationCount);

    // Process each citation
    for (Citation citation : citations) {
        System.out.println("Document: " + citation.getDocumentTitle());
        System.out.println("Location: " + citation.getLocationDescription());
        System.out.println("Cited text: " + citation.getCitedText());
        System.out.println("Document index: " + citation.getDocumentIndex());
        System.out.println();
    }

### Citation Types

Citations contain different location information depending on the document type:

#### Character Location (Plain Text)

For plain text documents, citations include character indices:

    Citation citation = citations.get(0);
    if (citation.getType() == Citation.LocationType.CHAR_LOCATION) {
        int start = citation.getStartCharIndex();
        int end = citation.getEndCharIndex();
        String text = citation.getCitedText();
        System.out.println("Characters " + start + "-" + end + ": " + text);
    }

#### Page Location (PDF)

For PDF documents, citations include page numbers:

    Citation citation = citations.get(0);
    if (citation.getType() == Citation.LocationType.PAGE_LOCATION) {
        int startPage = citation.getStartPageNumber();
        int endPage = citation.getEndPageNumber();
        System.out.println("Pages " + startPage + "-" + endPage);
    }

#### Content Block Location (Custom Content)

For custom content, citations reference specific content blocks:

    Citation citation = citations.get(0);
    if (citation.getType() == Citation.LocationType.CONTENT_BLOCK_LOCATION) {
        int startBlock = citation.getStartBlockIndex();
        int endBlock = citation.getEndBlockIndex();
        System.out.println("Content blocks " + startBlock + "-" + endBlock);
    }

### Complete Example

Here’s a complete example demonstrating citation usage:

    // Create a citation document
    AnthropicCitationDocument document = AnthropicCitationDocument.builder()
        .plainText("Spring AI is an application framework for AI engineering. " +
                   "It provides a Spring-friendly API for developing AI applications. " +
                   "The framework includes abstractions for chat models, embedding models, " +
                   "and vector databases.")
        .title("Spring AI Overview")
        .citationsEnabled(true)
        .build();

    // Call the model with the document
    ChatResponse response = chatModel.call(
        new Prompt(
            "What is Spring AI?",
            AnthropicChatOptions.builder()
                .model("claude-sonnet-4-20250514")
                .maxTokens(1024)
                .citationDocuments(document)
                .build()
        )
    );

    // Display the response
    System.out.println("Response: " + response.getResult().getOutput().getText());
    System.out.println("\nCitations:");

    // Process citations
    List<Citation> citations = (List<Citation>) response.getMetadata().get("citations");

    if (citations != null && !citations.isEmpty()) {
        for (int i = 0; i < citations.size(); i++) {
            Citation citation = citations.get(i);
            System.out.println("\n[" + (i + 1) + "] " + citation.getDocumentTitle());
            System.out.println("    Location: " + citation.getLocationDescription());
            System.out.println("    Text: " + citation.getCitedText());
        }
    } else {
        System.out.println("No citations were provided in the response.");
    }

### Best Practices

1.  **Use descriptive titles**: Provide meaningful titles for citation documents to help users identify sources in the citations.

2.  **Check for null citations**: Not all responses will include citations, so always validate the citations metadata exists before accessing it.

3.  **Consider document size**: Larger documents provide more context but consume more input tokens and may affect response time.

4.  **Leverage multiple documents**: When answering questions that span multiple sources, provide all relevant documents in a single request rather than making multiple calls.

5.  **Use appropriate document types**: Choose plain text for simple content, PDF for existing documents, and custom content blocks when you need fine-grained control over citation granularity.

### Citation Document Options

#### Context Field

Optionally provide context about the document that won’t be cited but can guide Claude’s understanding:

    AnthropicCitationDocument document = AnthropicCitationDocument.builder()
        .plainText("...")
        .title("Legal Contract")
        .context("This is a merger agreement dated January 2024 between Company A and Company B")
        .build();

#### Controlling Citations

By default, citations are disabled for all documents (opt-in behavior). To enable citations, explicitly set `citationsEnabled(true)`:

    AnthropicCitationDocument document = AnthropicCitationDocument.builder()
        .plainText("The Eiffel Tower was completed in 1889...")
        .title("Historical Facts")
        .citationsEnabled(true)  // Explicitly enable citations for this document
        .build();

You can also provide documents without citations for background context:

    AnthropicCitationDocument backgroundDoc = AnthropicCitationDocument.builder()
        .plainText("Background information about the industry...")
        .title("Context Document")
        // citationsEnabled defaults to false - Claude will use this but not cite it
        .build();

## Prompt Caching

Anthropic’s Prompt Caching reduces costs and latency by caching repeated context across API calls. The Anthropic SDK module supports prompt caching with configurable strategies, TTL, and per-message-type settings.

### Caching Strategies

Five caching strategies are available via `AnthropicCacheStrategy`:

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 28%" />
<col style="width: 71%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Strategy</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>NONE</code></p></td>
<td class="tableblock halign-left valign-top"><p>No caching (default). No cache control headers are added.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>SYSTEM_ONLY</code></p></td>
<td class="tableblock halign-left valign-top"><p>Cache system message content. Uses 1 cache breakpoint.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>TOOLS_ONLY</code></p></td>
<td class="tableblock halign-left valign-top"><p>Cache tool definitions only. Uses 1 cache breakpoint.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>SYSTEM_AND_TOOLS</code></p></td>
<td class="tableblock halign-left valign-top"><p>Cache both system messages and tool definitions. Uses 2 cache breakpoints.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>CONVERSATION_HISTORY</code></p></td>
<td class="tableblock halign-left valign-top"><p>Cache system messages, tool definitions, and conversation messages. Uses up to 4 cache breakpoints.</p></td>
</tr>
</tbody>
</table>

### Basic Usage

    var options = AnthropicChatOptions.builder()
        .model("claude-sonnet-4-20250514")
        .maxTokens(1024)
        .cacheOptions(AnthropicCacheOptions.builder()
            .strategy(AnthropicCacheStrategy.SYSTEM_ONLY)
            .build())
        .build();

    ChatResponse response = chatModel.call(
        new Prompt(List.of(
            new SystemMessage("You are an expert assistant with deep domain knowledge..."),
            new UserMessage("What is the capital of France?")),
            options));

### Cache Configuration Options

`AnthropicCacheOptions` provides fine-grained control over caching behavior:

    var cacheOptions = AnthropicCacheOptions.builder()
        .strategy(AnthropicCacheStrategy.SYSTEM_AND_TOOLS)
        .messageTypeTtl(MessageType.SYSTEM, AnthropicCacheTtl.ONE_HOUR)     // 1 hour TTL
        .messageTypeMinContentLength(MessageType.SYSTEM, 100)                   // Min 100 chars
        .multiBlockSystemCaching(true)                                          // Per-block caching
        .build();

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 33%" />
<col style="width: 55%" />
<col style="width: 11%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Option</th>
<th class="tableblock halign-left valign-top">Description</th>
<th class="tableblock halign-left valign-top">Default</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>strategy</code></p></td>
<td class="tableblock halign-left valign-top"><p>The caching strategy to use.</p></td>
<td class="tableblock halign-left valign-top"><p><code>NONE</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>messageTypeTtl</code></p></td>
<td class="tableblock halign-left valign-top"><p>TTL per message type. Available values: <code>FIVE_MINUTES</code>, <code>ONE_HOUR</code>.</p></td>
<td class="tableblock halign-left valign-top"><p><code>FIVE_MINUTES</code> for all types</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>messageTypeMinContentLength</code></p></td>
<td class="tableblock halign-left valign-top"><p>Minimum content length required before caching a message type.</p></td>
<td class="tableblock halign-left valign-top"><p><code>1</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>contentLengthFunction</code></p></td>
<td class="tableblock halign-left valign-top"><p>Custom function to compute content length (e.g., token counting).</p></td>
<td class="tableblock halign-left valign-top"><p><code>String::length</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>multiBlockSystemCaching</code></p></td>
<td class="tableblock halign-left valign-top"><p>When <code>true</code>, each system message becomes a separate cacheable block; cache control is applied to the second-to-last block (static prefix pattern). When <code>false</code>, all system messages are joined into one block.</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>cacheToolResults</code></p></td>
<td class="tableblock halign-left valign-top"><p>When <code>true</code>, a cache breakpoint is placed on the last tool result message of a request so tool outputs are cached across tool-calling rounds. Takes effect with <code>CONVERSATION_HISTORY</code>.</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
</tbody>
</table>

### Caching Tool Results

When a turn triggers tool calls, each round appends an assistant `tool_use` message and a user `tool_result` message, and the growing history is sent back to Anthropic on every round. By default the `CONVERSATION_HISTORY` breakpoint lands on the last user message, so tool results — which are appended after it — fall outside every breakpoint and are billed as uncached input on each round. This is wasteful when tool outputs are large.

Enable `cacheToolResults` to place a breakpoint on the last tool result block of the request. On the next round Anthropic reads the previous round’s tool results from cache instead of reprocessing them:

    var cacheOptions = AnthropicCacheOptions.builder()
        .strategy(AnthropicCacheStrategy.CONVERSATION_HISTORY)
        .cacheToolResults(true)
        .build();

The breakpoint moves to the latest tool result on each round, so the previous rounds' tool outputs are read from cache while the newest is written. This consumes one additional cache breakpoint (Anthropic allows up to four per request), leaving room for the tool, system, and last-user breakpoints under `CONVERSATION_HISTORY`. The TTL and minimum content length are configurable via `messageTypeTtl(MessageType.TOOL, …​)` and `messageTypeMinContentLength(MessageType.TOOL, …​)`.

### Multi-Block System Caching

When you have both a static system prompt and dynamic instructions, use multi-block system caching to cache only the static portion:

    var cacheOptions = AnthropicCacheOptions.builder()
        .strategy(AnthropicCacheStrategy.SYSTEM_ONLY)
        .multiBlockSystemCaching(true)
        .build();

    ChatResponse response = chatModel.call(
        new Prompt(List.of(
            new SystemMessage("You are an expert knowledge base assistant..."),  // Static (cached)
            new SystemMessage("Today's date is 2025-02-23. User timezone: PST"), // Dynamic
            new UserMessage("What are the latest updates?")),
            AnthropicChatOptions.builder()
                .model("claude-sonnet-4-20250514")
                .cacheOptions(cacheOptions)
                .build()));

### Spring Boot Configuration

Configure prompt caching via `application.properties` or `application.yml`:

    spring.ai.anthropic.chat.cache-options.strategy=SYSTEM_AND_TOOLS
    spring.ai.anthropic.chat.cache-options.multi-block-system-caching=true

### Accessing Cache Token Usage

Cache token metrics are available through the native SDK `Usage` object:

    ChatResponse response = chatModel.call(prompt);

    com.anthropic.models.messages.Usage sdkUsage =
        (com.anthropic.models.messages.Usage) response.getMetadata().getUsage().getNativeUsage();
    long cacheCreation = sdkUsage.cacheCreationInputTokens().orElse(0L);
    long cacheRead = sdkUsage.cacheReadInputTokens().orElse(0L);

    System.out.println("Cache creation tokens: " + cacheCreation);
    System.out.println("Cache read tokens: " + cacheRead);

On the first request, `cacheCreationInputTokens` will be non-zero (tokens written to cache). On subsequent requests with the same cached prefix, `cacheReadInputTokens` will be non-zero (tokens read from cache at reduced cost).

### Conversation History Caching

The `CONVERSATION_HISTORY` strategy caches the entire conversation context, including system messages, tool definitions, and the last user message. This is useful for multi-turn conversations where the growing context would otherwise be re-processed on every request:

    var cacheOptions = AnthropicCacheOptions.builder()
        .strategy(AnthropicCacheStrategy.CONVERSATION_HISTORY)
        .build();

    var options = AnthropicChatOptions.builder()
        .model("claude-sonnet-4-20250514")
        .cacheOptions(cacheOptions)
        .build();

    // First turn
    ChatResponse response1 = chatModel.call(
        new Prompt(List.of(
            new SystemMessage("You are a helpful assistant."),
            new UserMessage("What is machine learning?")),
            options));

    // Second turn - previous context is cached
    ChatResponse response2 = chatModel.call(
        new Prompt(List.of(
            new SystemMessage("You are a helpful assistant."),
            new UserMessage("What is machine learning?"),
            new AssistantMessage(response1.getResult().getOutput().getText()),
            new UserMessage("Can you give me an example?")),
            options));

## Structured Output

Structured output constrains Claude to produce responses conforming to a JSON schema. The Anthropic SDK module also supports Anthropic’s effort control for tuning response quality vs speed.

### JSON Schema Output

Constrain Claude’s responses to a specific JSON schema using the `outputSchema` convenience method:

    var options = AnthropicChatOptions.builder()
        .model("claude-sonnet-4-6")
        .outputSchema("""
            {
                "type": "object",
                "properties": {
                    "name": {"type": "string"},
                    "capital": {"type": "string"},
                    "population": {"type": "integer"}
                },
                "required": ["name", "capital"],
                "additionalProperties": false
            }
            """)
        .build();

    ChatResponse response = chatModel.call(new Prompt("Tell me about France.", options));
    // Response text will be valid JSON conforming to the schema

### Effort Control

Control how much compute Claude spends on its response. Lower effort means faster, cheaper responses; higher effort means more thorough reasoning.

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 28%" />
<col style="width: 71%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Effort Level</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>LOW</code></p></td>
<td class="tableblock halign-left valign-top"><p>Fast and concise responses with minimal reasoning</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>MEDIUM</code></p></td>
<td class="tableblock halign-left valign-top"><p>Balanced trade-off between speed and thoroughness</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>HIGH</code></p></td>
<td class="tableblock halign-left valign-top"><p>More thorough reasoning and detailed responses</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>MAX</code></p></td>
<td class="tableblock halign-left valign-top"><p>Maximum compute for the most thorough possible responses</p></td>
</tr>
</tbody>
</table>

    var options = AnthropicChatOptions.builder()
        .model("claude-sonnet-4-6")
        .effort(OutputConfig.Effort.LOW)
        .build();

    ChatResponse response = chatModel.call(new Prompt("What is the capital of France?", options));

### Combined Schema and Effort

You can combine JSON schema output with effort control:

    var options = AnthropicChatOptions.builder()
        .model("claude-sonnet-4-6")
        .outputSchema("""
            {
                "type": "object",
                "properties": {
                    "answer": {"type": "integer"},
                    "explanation": {"type": "string"}
                },
                "required": ["answer", "explanation"],
                "additionalProperties": false
            }
            """)
        .effort(OutputConfig.Effort.HIGH)
        .build();

    ChatResponse response = chatModel.call(
        new Prompt("What is 15 * 23? Show your reasoning.", options));

### Direct OutputConfig

For full control, use the SDK’s `OutputConfig` directly:

    import com.anthropic.models.messages.OutputConfig;
    import com.anthropic.models.messages.JsonOutputFormat;
    import com.anthropic.core.JsonValue;

    var outputConfig = OutputConfig.builder()
        .effort(OutputConfig.Effort.HIGH)
        .format(JsonOutputFormat.builder()
            .schema(JsonOutputFormat.Schema.builder()
                .putAdditionalProperty("type", JsonValue.from("object"))
                .putAdditionalProperty("properties", JsonValue.from(Map.of(
                    "name", Map.of("type", "string"))))
                .putAdditionalProperty("additionalProperties", JsonValue.from(false))
                .build())
            .build())
        .build();

    var options = AnthropicChatOptions.builder()
        .model("claude-sonnet-4-6")
        .outputConfig(outputConfig)
        .build();

    ChatResponse response = chatModel.call(new Prompt("Tell me about France.", options));

### StructuredOutputChatOptions Interface

`AnthropicChatOptions` implements the `StructuredOutputChatOptions` interface, which provides portable `getOutputSchema()` method. This allows structured output to work with Spring AI’s generic structured output infrastructure.

## Service Tier

Anthropic offers different service tiers that control capacity routing for API requests. You can use `AnthropicServiceTier.AUTO` to opportunistically use priority capacity (lower latency) when available, or `STANDARD_ONLY` to always use standard capacity.

Via Spring Boot properties:

    spring.ai.anthropic.chat.service-tier=auto

Or programmatically per-request:

    var options = AnthropicChatOptions.builder()
        .serviceTier(AnthropicServiceTier.AUTO)
        .build();

    ChatResponse response = chatModel.call(new Prompt("Hello", options));

## Per-Request HTTP Headers

The Anthropic SDK module supports per-request HTTP headers, which are injected into individual API calls. This is distinct from `customHeaders` (which are set at the client level for all requests).

Per-request headers are useful for:

- **Request tracking**: Adding correlation IDs or trace headers per request

- **Beta API access**: Including beta feature headers for specific requests

- **Routing**: Adding routing or priority headers for load balancing

    var options = AnthropicChatOptions.builder()
        .httpHeaders(Map.of(
            "X-Request-Id", "req-12345",
            "X-Custom-Tracking", "my-tracking-value"))
        .build();

    ChatResponse response = chatModel.call(new Prompt("Hello", options));

## Sample Controller

Here is an example of a simple `@RestController` class that uses the chat model for text generations:

    @RestController
    public class ChatController {

        private final AnthropicChatModel chatModel;

        public ChatController() {
            var options = AnthropicChatOptions.builder()
                .model("claude-sonnet-4-20250514")
                .maxTokens(1024)
                .apiKey(System.getenv("ANTHROPIC_API_KEY"))
                .build();
            this.chatModel = AnthropicChatModel.builder()
                .options(options)
                .build();
        }

        @GetMapping("/ai/generate")
        public Map<String, String> generate(
                @RequestParam(value = "message", defaultValue = "Tell me a joke") String message) {
            return Map.of("generation", chatModel.call(message));
        }

        @GetMapping("/ai/generateStream")
        public Flux<ChatResponse> generateStream(
                @RequestParam(value = "message", defaultValue = "Tell me a joke") String message) {
            Prompt prompt = new Prompt(new UserMessage(message));
            return chatModel.stream(prompt);
        }
    }

## Accessing the Raw Response

The full Anthropic SDK `Message` object is available in the response metadata under the `"anthropic-response"` key. This provides access to any fields not explicitly mapped by Spring AI’s abstraction:

    ChatResponse response = chatModel.call(new Prompt("Hello"));

    com.anthropic.models.messages.Message rawMessage =
        (com.anthropic.models.messages.Message) response.getMetadata().get("anthropic-response");

    // Access native SDK fields
    rawMessage.stopReason();    // Optional<StopReason>
    rawMessage.content();       // List<ContentBlock>
    rawMessage.usage();         // Usage with cache token details

## Skills

Anthropic’s Skills API extends Claude’s capabilities with specialized, pre-packaged abilities for document generation. Skills enable Claude to create actual downloadable files — Excel spreadsheets, PowerPoint presentations, Word documents, and PDFs — rather than just describing what these documents might contain.

### Pre-built Anthropic Skills

Spring AI provides type-safe access to Anthropic’s pre-built skills through the `AnthropicSkill` enum:

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 22%" />
<col style="width: 33%" />
<col style="width: 44%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Skill</th>
<th class="tableblock halign-left valign-top">Description</th>
<th class="tableblock halign-left valign-top">Generated File Type</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>XLSX</code></p></td>
<td class="tableblock halign-left valign-top"><p>Excel spreadsheet generation and manipulation</p></td>
<td class="tableblock halign-left valign-top"><p><code>.xlsx</code> (Microsoft Excel)</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>PPTX</code></p></td>
<td class="tableblock halign-left valign-top"><p>PowerPoint presentation creation</p></td>
<td class="tableblock halign-left valign-top"><p><code>.pptx</code> (Microsoft PowerPoint)</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>DOCX</code></p></td>
<td class="tableblock halign-left valign-top"><p>Word document generation</p></td>
<td class="tableblock halign-left valign-top"><p><code>.docx</code> (Microsoft Word)</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>PDF</code></p></td>
<td class="tableblock halign-left valign-top"><p>PDF document creation</p></td>
<td class="tableblock halign-left valign-top"><p><code>.pdf</code> (Portable Document Format)</p></td>
</tr>
</tbody>
</table>

### Basic Usage

Enable skills by adding them to your `AnthropicChatOptions`:

    ChatResponse response = chatModel.call(
        new Prompt(
            "Create an Excel spreadsheet with Q1 2025 sales data. " +
            "Include columns for Month, Revenue, and Expenses with 3 rows of sample data.",
            AnthropicChatOptions.builder()
                .model(Model.CLAUDE_SONNET_4_5)
                .maxTokens(4096)
                .skill(AnthropicSkill.XLSX)
                .build()
        )
    );

    // Claude will generate an actual Excel file
    String responseText = response.getResult().getOutput().getText();
    System.out.println(responseText);
    // Output: "I've created an Excel spreadsheet with your Q1 2025 sales data..."

### Multiple Skills

You can enable multiple skills in a single request (up to 8):

    ChatResponse response = chatModel.call(
        new Prompt(
            "Create a sales report with both an Excel file containing the raw data " +
            "and a PowerPoint presentation summarizing the key findings.",
            AnthropicChatOptions.builder()
                .model(Model.CLAUDE_SONNET_4_5)
                .maxTokens(8192)
                .skill(AnthropicSkill.XLSX)
                .skill(AnthropicSkill.PPTX)
                .build()
        )
    );

### Using AnthropicSkillContainer for Advanced Configuration

For more control over skill types and versions, use `AnthropicSkillContainer` directly:

    AnthropicSkillContainer container = AnthropicSkillContainer.builder()
        .skill(AnthropicSkill.XLSX)
        .skill(AnthropicSkill.PPTX, "20251013") // Specific version
        .build();

    ChatResponse response = chatModel.call(
        new Prompt(
            "Generate the quarterly report",
            AnthropicChatOptions.builder()
                .model(Model.CLAUDE_SONNET_4_5)
                .maxTokens(4096)
                .skillContainer(container)
                .build()
        )
    );

### Downloading Generated Files

When Claude generates files using Skills, the response contains file IDs that can be used to download the actual files via the Files API. Spring AI provides the `AnthropicSkillsResponseHelper` utility class for extracting file IDs and downloading files.

#### Extracting File IDs

    import org.springframework.ai.anthropic.AnthropicSkillsResponseHelper;

    ChatResponse response = chatModel.call(prompt);

    // Extract all file IDs from the response
    List<String> fileIds = AnthropicSkillsResponseHelper.extractFileIds(response);

    for (String fileId : fileIds) {
        System.out.println("Generated file ID: " + fileId);
    }

#### Downloading All Files

The `AnthropicSkillsResponseHelper` provides a convenience method to download all generated files at once. This requires the `AnthropicClient` instance (the same one used to create the chat model):

    import com.anthropic.client.AnthropicClient;

    @Autowired
    private AnthropicClient anthropicClient;

    // Download all files to a target directory
    Path targetDir = Path.of("generated-files");
    Files.createDirectories(targetDir);

    List<Path> savedFiles = AnthropicSkillsResponseHelper.downloadAllFiles(
            response, anthropicClient, targetDir);

    for (Path file : savedFiles) {
        System.out.println("Downloaded: " + file.getFileName() +
                           " (" + Files.size(file) + " bytes)");
    }

#### Extracting Container ID

For multi-turn conversations with Skills, you can extract the container ID for reuse:

    String containerId = AnthropicSkillsResponseHelper.extractContainerId(response);

    if (containerId != null) {
        System.out.println("Container ID for reuse: " + containerId);
    }

### Complete Example

Here’s a complete example showing Skills usage with file download:

    @Service
    public class DocumentGenerationService {

        private final AnthropicChatModel chatModel;
        private final AnthropicClient anthropicClient;

        public DocumentGenerationService(AnthropicChatModel chatModel,
                                         AnthropicClient anthropicClient) {
            this.chatModel = chatModel;
            this.anthropicClient = anthropicClient;
        }

        public Path generateSalesReport(String quarter, Path outputDir) throws IOException {
            // Generate Excel report using Skills
            ChatResponse response = chatModel.call(
                new Prompt(
                    "Create an Excel spreadsheet with " + quarter + " sales data. " +
                    "Include Month, Revenue, Expenses, and Profit columns.",
                    AnthropicChatOptions.builder()
                        .model(Model.CLAUDE_SONNET_4_5)
                        .maxTokens(4096)
                        .skill(AnthropicSkill.XLSX)
                        .build()
                )
            );

            // Extract file IDs from the response
            List<String> fileIds = AnthropicSkillsResponseHelper.extractFileIds(response);

            if (fileIds.isEmpty()) {
                throw new RuntimeException("No file was generated");
            }

            // Download all generated files
            List<Path> savedFiles = AnthropicSkillsResponseHelper.downloadAllFiles(
                    response, anthropicClient, outputDir);

            return savedFiles.get(0);
        }
    }

### Best Practices

1.  **Use appropriate models**: Skills work best with Claude Sonnet 4 and later models. Ensure you’re using a supported model.

2.  **Set sufficient max tokens**: Document generation can require significant tokens. Use `maxTokens(4096)` or higher for complex documents.

3.  **Be specific in prompts**: Provide clear, detailed instructions about document structure, content, and formatting.

4.  **Handle file downloads promptly**: Generated files expire after 24 hours. Download files soon after generation.

5.  **Check for file IDs**: Always verify that file IDs were returned before attempting downloads. Some prompts may result in text responses without file generation.

6.  **Use defensive error handling**: Wrap file operations in try-catch blocks to handle network issues or expired files gracefully.

    List<String> fileIds = AnthropicSkillsResponseHelper.extractFileIds(response);

    if (fileIds.isEmpty()) {
        // Claude may have responded with text instead of generating a file
        String text = response.getResult().getOutput().getText();
        log.warn("No files generated. Response: {}", text);
        return;
    }

    try {
        List<Path> files = AnthropicSkillsResponseHelper.downloadAllFiles(
                response, anthropicClient, targetDir);
        // Process files...
    } catch (IOException e) {
        log.error("Failed to download file: {}", e.getMessage());
    }

## Web Search

Anthropic’s Web Search tool allows Claude to search the web during a conversation and use the results to generate cited responses.

### Basic Usage

Enable web search by adding an `AnthropicWebSearchTool` to your chat options:

    var webSearch = AnthropicWebSearchTool.builder().build();

    ChatResponse response = chatModel.call(
        new Prompt("What is the latest released version of Spring AI?",
            AnthropicChatOptions.builder()
                .webSearchTool(webSearch)
                .build()));

    String answer = response.getResult().getOutput().getText();

### Configuration Options

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 33%" />
<col style="width: 55%" />
<col style="width: 11%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Option</th>
<th class="tableblock halign-left valign-top">Description</th>
<th class="tableblock halign-left valign-top">Default</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>maxUses</p></td>
<td class="tableblock halign-left valign-top"><p>Maximum number of web searches Claude can perform per request</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>allowedDomains</p></td>
<td class="tableblock halign-left valign-top"><p>Restrict search results to these domains only</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>blockedDomains</p></td>
<td class="tableblock halign-left valign-top"><p>Exclude these domains from search results</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>userLocation</p></td>
<td class="tableblock halign-left valign-top"><p>Approximate user location for localizing results (city, country, region, timezone)</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

### Domain Filtering

Restrict or exclude specific domains from search results:

    var webSearch = AnthropicWebSearchTool.builder()
        .allowedDomains(List.of("docs.spring.io", "github.com"))
        .blockedDomains(List.of("example.com"))
        .maxUses(5)
        .build();

### User Location

Provide approximate location to localize search results:

    var webSearch = AnthropicWebSearchTool.builder()
        .userLocation("San Francisco", "US", "California", "America/Los_Angeles")
        .build();

### Accessing Web Search Results

Web search results and citations are available in the response metadata:

    ChatResponse response = chatModel.call(
        new Prompt("What happened in tech news today?",
            AnthropicChatOptions.builder()
                .webSearchTool(AnthropicWebSearchTool.builder().build())
                .build()));

    // Get web search results
    List<AnthropicWebSearchResult> results =
        (List<AnthropicWebSearchResult>) response.getMetadata().get("web-search-results");

    if (results != null) {
        for (AnthropicWebSearchResult result : results) {
            System.out.println("Title: " + result.title());
            System.out.println("URL: " + result.url());
            System.out.println("Page age: " + result.pageAge());
        }
    }

    // Get web search citations
    List<Citation> citations =
        (List<Citation>) response.getMetadata().get("citations");

    if (citations != null) {
        for (Citation citation : citations) {
            if (citation.getType() == Citation.LocationType.WEB_SEARCH_RESULT_LOCATION) {
                System.out.println("Source: " + citation.getUrl());
                System.out.println("Title: " + citation.getDocumentTitle());
                System.out.println("Cited text: " + citation.getCitedText());
            }
        }
    }

### Spring Boot Configuration

Configure web search via `application.properties` or `application.yml`:

    spring.ai.anthropic.chat.web-search-tool.max-uses=5
    spring.ai.anthropic.chat.web-search-tool.allowed-domains=docs.spring.io,github.com
    spring.ai.anthropic.chat.web-search-tool.user-location.city=San Francisco
    spring.ai.anthropic.chat.web-search-tool.user-location.country=US

## Observability

Spring AI emits Micrometer observations at two layers for every Anthropic call:

- **Chat-model layer.** A `gen_ai.client.operation` observation wraps every call to `AnthropicChatModel.call(…​)` or `.stream(…​)`, carrying request parameters, response metadata, and token usage. See the observability reference for the full set of tags and metrics.

- **HTTP layer.** An `okhttp.requests` observation wraps every HTTP attempt to the Anthropic API, carrying HTTP method, URI, status code, and exception tags. Each request also propagates `traceparent` on the wire to any downstream services (AI gateways, OpenAI-compatible inference servers, proxies).

In a Spring Boot application with `spring-boot-starter-actuator` and a tracing bridge (`micrometer-tracing-bridge-otel` or `micrometer-tracing-bridge-brave`), both layers are wired automatically — no opt-in required. For non-Boot applications, pass an `ObservationRegistry` to `AnthropicChatModel.builder()`:

    AnthropicChatModel chatModel = AnthropicChatModel.builder()
        .options(...)
        .observationRegistry(observationRegistry)
        .build();

### Connection-pool metrics (opt-in)

Spring AI can additionally bind OkHttp connection-pool gauges (`okhttp.pool.connection.count` with `state=active|idle` and `client.kind=sync|async`) to the application’s `MeterRegistry`. These are secondary telemetry — useful for capacity tuning but not required for tracing or per-request latency — so they’re disabled by default.

To enable them in a Spring Boot application:

    spring.ai.anthropic.chat.connection-pool-metrics-enabled=true

For non-Boot applications, pass a `MeterRegistry` directly to the builder; the gauges bind whenever a registry is supplied:

    AnthropicChatModel chatModel = AnthropicChatModel.builder()
        .options(...)
        .observationRegistry(observationRegistry)
        .meterRegistry(meterRegistry)
        .build();

### HTTP dispatcher executor (advanced)

By default Spring AI manages the OkHttp dispatcher’s executor — an unbounded pool of platform threads, replicating the SDK’s stock behavior. For workloads with high HTTP concurrency, or to take advantage of Java 21+ virtual threads, you can supply your own `ExecutorService`:

    AnthropicChatModel chatModel = AnthropicChatModel.builder()
        .options(...)
        .dispatcherExecutor(Executors.newVirtualThreadPerTaskExecutor())
        .build();

The same executor backs both the sync and async (streaming) clients. When you supply your own executor, you own its lifecycle — Spring AI will never call `shutdown()` on it. When omitted, the internal executor is created and cleaned up automatically.

## Logging

Enable SDK logging by setting the environment variable:

    export ANTHROPIC_LOG=debug

## Limitations

The following features are not yet supported:

- Amazon Bedrock backend

- Google Vertex AI backend

These features are planned for future releases.

## Customizing the HTTP Client

Spring AI uses the official `anthropic-java` SDK under the hood and configures its HTTP transport with a custom OkHttp client built by `SpringAiAnthropicHttpClient.Builder`. You can intercept that builder before the underlying `OkHttpClient` is created by exposing one or more `AnthropicHttpClientBuilderCustomizer` beans.

    @FunctionalInterface
    public interface AnthropicHttpClientBuilderCustomizer {
        void customize(SpringAiAnthropicHttpClient.Builder builder);
    }

Typical use cases include:

- registering OkHttp `Interceptor` instances (authentication, propagation headers, custom logging);

- swapping the dispatcher `ExecutorService` (for example, to route async I/O through virtual threads);

- configuring proxy, SSL, hostname verification, or the connection-pool sizing exposed by the builder.

When several customizer beans are present in the application context, they are applied in `@Order` / `@Priority` order, after Spring AI’s own defaults, so user code wins.

The same hook is available when wiring the model manually via `AnthropicChatModel.Builder`. In that case the customizers are applied in registration order; `@Order` annotations have no effect outside of Spring’s bean container:

    var chatModel = AnthropicChatModel.builder()
        .options(AnthropicChatOptions.builder().model("claude-sonnet-4-20250514").build())
        .httpClientBuilderCustomizer(myCustomizer)
        .build();

## Additional Resources

- Official Anthropic Java SDK

- Anthropic API Documentation

- Claude Models

Amazon Bedrock Converse Azure OpenAI

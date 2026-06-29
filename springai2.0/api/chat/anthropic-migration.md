Search

# Migrating the Anthropic Module to the Official Java SDK

In `2.0.0-M3`, `spring-ai-anthropic` was rewritten on top of the official `com.anthropic:anthropic-java` SDK, replacing the hand-rolled `RestClient` / `WebClient` implementation. The previous `AnthropicApi` class was a 2,300-line file with 47 nested DTO records.

The new module is a thin adapter over the SDK rather than a parallel API. Spring AI’s value is in its own abstractions — `ChatModel`, `ChatClient`, advisors, observability, auto-config — and in features that work across providers. Where the SDK already covers a concern (cache-control modeling, streaming, rate-limit handling), the previous module’s wrapper was dropped instead of carried forward, so applications use the SDK’s type directly. This keeps the surface area small and avoids drift as Anthropic ships new SDK releases.

The Maven coordinates, the `spring-ai-starter-model-anthropic` Boot starter, and the `spring.ai.anthropic.*` configuration properties are all unchanged. The `ChatClient` API is unchanged. `ChatModel.call(Prompt)` and `ChatModel.stream(Prompt)` keep their signatures. `AnthropicChatOptions` keeps all existing fields, adding new ones for skills, web search, service tier, inference geo, and structured output.

## What Changed

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 25%" />
<col style="width: 75%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Area</th>
<th class="tableblock halign-left valign-top">Change</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>AnthropicChatModel</code> construction</p></td>
<td class="tableblock halign-left valign-top"><p>Public constructors removed. Use <code>AnthropicChatModel.builder()</code>.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.anthropic.api.AnthropicApi</code> and its nested DTOs</p></td>
<td class="tableblock halign-left valign-top"><p>Removed. For direct API access, use the SDK’s <code>com.anthropic.client.AnthropicClient</code>.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>AnthropicCacheOptions</code>, <code>AnthropicCacheStrategy</code>, <code>AnthropicCacheTtl</code>, <code>CacheBreakpointTracker</code>, <code>CacheEligibilityResolver</code></p></td>
<td class="tableblock halign-left valign-top"><p>Moved out of <code>org.springframework.ai.anthropic.api</code> (and <code>api.utils</code>) into the root <code>org.springframework.ai.anthropic</code> package. Enum values unchanged.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>CitationDocument</code></p></td>
<td class="tableblock halign-left valign-top"><p>Renamed to <code>AnthropicCitationDocument</code>.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>AnthropicCacheType</code>, <code>StreamHelper</code>, <code>metadata.AnthropicRateLimit</code></p></td>
<td class="tableblock halign-left valign-top"><p>Removed without direct replacement.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Default <code>maxTokens</code></p></td>
<td class="tableblock halign-left valign-top"><p>Changed from <code>500</code> to <code>4096</code>.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Transitive <code>com.squareup.okhttp3:okhttp</code></p></td>
<td class="tableblock halign-left valign-top"><p>New, pulled in by <code>com.anthropic:anthropic-java</code>.</p></td>
</tr>
</tbody>
</table>

## If You Use Only `ChatClient` or `ChatModel`

If your code looks like this, no migration is needed:

    @Autowired ChatClient.Builder builder;

    String response = builder.build()
        .prompt("Tell me a joke")
        .call()
        .content();

The auto-configuration produces an `AnthropicChatModel` bean wired to the new SDK-based implementation. Calling code is unaffected.

The one behavioral change to watch for is the new default `maxTokens` value (see Default `maxTokens` is now 4096).

## If You Construct `AnthropicChatModel` Programmatically

Replace direct constructor usage with the builder:

    // Before
    AnthropicApi anthropicApi = new AnthropicApi(apiKey);
    AnthropicChatModel chatModel = new AnthropicChatModel(anthropicApi,
        AnthropicChatOptions.builder().model("claude-haiku-4-5").maxTokens(2048).build(),
        retryTemplate,
        toolCallingManager);

    // After
    AnthropicChatModel chatModel = AnthropicChatModel.builder()
        .apiKey(apiKey)
        .defaultOptions(AnthropicChatOptions.builder()
            .model("claude-haiku-4-5")
            .maxTokens(2048)
            .build())
        .toolCallingManager(toolCallingManager)
        .build();

The builder also accepts `baseUrl`, `timeout`, `maxRetries`, `proxy`, `customHeaders`, `observationRegistry`, and `observationConvention`. There is no `retryTemplate` builder method; retry is now handled by the SDK (see Retry uses SDK `maxRetries`, not `RetryTemplate`).

## If You Imported Cache or Citation Types

The cache and citation helper classes moved out of the `api` (and `api.utils`) subpackage into the root `org.springframework.ai.anthropic` package. Update imports as follows:

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Old import</th>
<th class="tableblock halign-left valign-top">New import</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.anthropic.api.AnthropicCacheOptions</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.anthropic.AnthropicCacheOptions</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.anthropic.api.AnthropicCacheStrategy</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.anthropic.AnthropicCacheStrategy</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.anthropic.api.AnthropicCacheTtl</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.anthropic.AnthropicCacheTtl</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.anthropic.api.utils.CacheBreakpointTracker</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.anthropic.CacheBreakpointTracker</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.anthropic.api.utils.CacheEligibilityResolver</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.anthropic.CacheEligibilityResolver</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.anthropic.api.CitationDocument</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.anthropic.AnthropicCitationDocument</code></p></td>
</tr>
</tbody>
</table>

Enum values of `AnthropicCacheStrategy` (`NONE`, `TOOLS_ONLY`, `SYSTEM_ONLY`, `SYSTEM_AND_TOOLS`, `CONVERSATION_HISTORY`) and `AnthropicCacheTtl` (`FIVE_MINUTES`, `ONE_HOUR`) are unchanged. The `plainText(…​)`, `pdf(…​)`, and `customContent(…​)` factory methods still exist on the renamed `AnthropicCitationDocument`.

## If You Used `AnthropicApi` Directly

`AnthropicApi`, its nested DTO records, and `AnthropicCacheType` are gone. Before reaching for the SDK client, consider whether `AnthropicChatModel` covers what you were doing. It usually does, and you keep the framework integration.

`AnthropicChatModel` adds the following on top of a raw `AnthropicClient`:

- Provider-neutral request and response types (`Prompt`, `ChatResponse`, `Generation`, `Usage`), so application code doesn’t depend on `com.anthropic.*`.

- Tool calling integrated with `ToolCallback` and the `ToolCallingManager` loop, including automatic multi-turn execution.

- Streaming as a Reactor `Flux<ChatResponse>` rather than the SDK’s callback-based `AsyncStreamResponse`.

- Prompt caching with strategy modeling, TTL controls, and 4-breakpoint enforcement (`AnthropicCacheOptions`).

- `Citation` with four location variants surfaced under `ChatResponseMetadata`.

- Skills, built-in web search, service tier, inference geo, and structured output as `AnthropicChatOptions` fields, all bindable from `spring.ai.anthropic.chat.*`.

- Spring Boot auto-config and Micrometer observation.

- The `ChatClient` pipeline above the model (advisors, message templates, RAG, conversation memory, structured-output converter).

- Provider portability: the same `ChatClient` code runs against OpenAI, Bedrock, Google GenAI, and others.

For typical chat usage, switch to `AnthropicChatModel.builder()` (see If You Construct `AnthropicChatModel` Programmatically):

    // Before
    AnthropicApi api = new AnthropicApi(apiKey);
    AnthropicApi.ChatCompletionRequest req = new AnthropicApi.ChatCompletionRequest(
        AnthropicApi.ChatModel.CLAUDE_HAIKU_4_5.getValue(),
        List.of(new AnthropicApi.AnthropicMessage(List.of(new AnthropicApi.ContentBlock("hello")), AnthropicApi.Role.USER)),
        null, 1024, null, 0.7, null, null, null, null, false);
    ResponseEntity<AnthropicApi.ChatCompletionResponse> resp = api.chatCompletionEntity(req);

    // After
    AnthropicChatModel chatModel = AnthropicChatModel.builder()
        .apiKey(apiKey)
        .defaultOptions(AnthropicChatOptions.builder()
            .model("claude-haiku-4-5")
            .maxTokens(1024)
            .temperature(0.7)
            .build())
        .build();
    ChatResponse response = chatModel.call(new Prompt("hello"));

If you genuinely need an Anthropic API surface that `AnthropicChatModel` doesn’t expose (a beta endpoint, files API, custom skills CRUD), drop to the SDK client. You’re outside the framework at that point — no observability, no provider neutrality, no `ChatClient` pipeline:

    import com.anthropic.client.AnthropicClient;
    import com.anthropic.client.okhttp.AnthropicOkHttpClient;
    import com.anthropic.models.messages.MessageCreateParams;
    import com.anthropic.models.messages.Model;

    AnthropicClient client = AnthropicOkHttpClient.builder().apiKey(apiKey).build();
    MessageCreateParams params = MessageCreateParams.builder()
        .model(Model.CLAUDE_HAIKU_4_5)
        .maxTokens(1024)
        .temperature(0.7)
        .addUserMessage("hello")
        .build();
    com.anthropic.models.messages.Message message = client.messages().create(params);

The hand-rolled record types have direct analogues in the SDK under `com.anthropic.models.messages.*`:

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Removed type (old <code>AnthropicApi.*</code>)</th>
<th class="tableblock halign-left valign-top">SDK replacement (<code>com.anthropic.models.messages.*</code>)</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>ChatCompletionRequest</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>MessageCreateParams</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>ChatCompletionResponse</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>Message</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>AnthropicMessage</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>MessageParam</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>ContentBlock</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>ContentBlock</code> (sealed union: <code>TextBlock</code>, <code>ToolUseBlock</code>, <code>ThinkingBlock</code>, <code>RedactedThinkingBlock</code>, <code>ServerToolUseBlock</code>, <code>WebSearchToolResultBlock</code>, <code>ContainerUploadBlock</code>, …​)</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>Tool</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>Tool</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>ToolChoiceAuto</code> / <code>ToolChoiceAny</code> / <code>ToolChoiceTool</code> / <code>ToolChoiceNone</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>ToolChoice</code> (sealed union with <code>ToolChoiceAuto</code>, <code>ToolChoiceAny</code>, <code>ToolChoiceTool</code>, <code>ToolChoiceNone</code> variants)</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>Source</code> (image / PDF media)</p></td>
<td class="tableblock halign-left valign-top"><p><code>Base64ImageSource</code>, <code>UrlImageSource</code>, <code>Base64PdfSource</code>, <code>UrlPdfSource</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>MessageStartEvent</code>, <code>ContentBlockStartEvent</code>, <code>ContentBlockDeltaEvent</code>, <code>MessageDeltaEvent</code>, …​</p></td>
<td class="tableblock halign-left valign-top"><p><code>RawMessageStreamEvent</code> (sealed union)</p></td>
</tr>
</tbody>
</table>

## Removed in Favor of SDK Equivalents

These types were dropped because the SDK already exposes the same concept. Use the SDK type directly.

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 33%" />
<col style="width: 66%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Removed</th>
<th class="tableblock halign-left valign-top">Use instead</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.anthropic.api.AnthropicCacheType</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>com.anthropic.models.messages.CacheControlEphemeral</code>. The old enum carried only the literal <code>ephemeral</code> value, which is also the only cache-control type the API supports.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.anthropic.api.StreamHelper</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>com.anthropic.core.http.AsyncStreamResponse&lt;RawMessageStreamEvent&gt;</code>. <code>StreamHelper</code> was the internal SSE-merging helper for the old <code>WebClient</code> streaming path; the SDK now delivers stream events natively, and Spring AI bridges them to a Reactor <code>Flux</code> internally. Code calling <code>ChatModel.stream(Prompt)</code> is unaffected.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>org.springframework.ai.anthropic.metadata.AnthropicRateLimit</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>com.anthropic.errors.RateLimitException</code> (thrown by the SDK after retries are exhausted), plus the headers on the SDK’s response objects. Replace code that read rate-limit metadata off <code>ChatResponseMetadata</code> with exception handling.</p></td>
</tr>
</tbody>
</table>

## Behavior Changes

### Prompt-level options no longer merge with model defaults

The previous module merged prompt-level `AnthropicChatOptions` into the model-level defaults via `ModelOptionsUtils.copyToTarget(…​)` and `ModelOptionsUtils.merge(…​)`, so `model`, `temperature`, and any other unset fields were filled in from the model’s defaults:

    // Before: only maxTokens set; model + temperature inherited from defaults.
    Prompt prompt = new Prompt(
        "Tell me a joke",
        AnthropicChatOptions.builder().maxTokens(2048).build());
    chatModel.call(prompt);

The new module does not merge. A prompt-level options instance is used as-is; if the prompt has no options, the model defaults are used.

    // After: prompt-level options must be "full", or null.
    Prompt prompt = new Prompt(
        "Tell me a joke",
        chatModel.getOptions().mutate().maxTokens(2048).build());
    chatModel.call(prompt);

This is a forward port of the broader change in Upgrading to 2.0.0-M5 — ChatOptions Handling, landed early for Anthropic. `ChatClient` performs its own merging before reaching the model, so callers using `ChatClient` are not affected.

### Default `maxTokens` is now 4096

`AnthropicChatOptions` defaults `maxTokens` to `4096` instead of `500`. The previous default routinely truncated responses; the new value matches the other Spring AI chat modules.

If you relied on `500` to bound costs, set it explicitly:

    spring.ai.anthropic.chat.max-tokens=500

### Retry uses SDK `maxRetries`, not `RetryTemplate`

The previous module took a Spring Retry `RetryTemplate` in its constructor. Retries are now handled by the SDK and configured through `maxRetries` (default `2`):

    spring.ai.anthropic.max-retries=5

Any `RetryTemplate` bean wired specifically for the Anthropic module can be removed. For finer control, configure the SDK client through a custom `AnthropicSetup`.

### Streaming thinking events

Two changes affect anyone subscribed to the raw `Flux<ChatResponse>` stream (rather than letting `ChatClient` or `MessageAggregator` collapse it).

The previous module bundled the text and signature of a thinking block into a single `Generation`. The SDK delivers them as separate events, and the new module forwards them that way: a `Generation` with `properties.signature` arrives after the thinking-text deltas, before any subsequent text deltas. `MessageAggregator` and \`ChatClient’s built-in aggregation absorb the extra chunk transparently.

Thinking-text deltas now also include `properties.thinking = Boolean.TRUE`. The previous module emitted them as plain content, leaving callers no reliable way to distinguish thinking text from response text mid-stream.

The full set of streaming metadata keys:

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 33%" />
<col style="width: 66%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Block</th>
<th class="tableblock halign-left valign-top"><code>Generation</code> carries</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Thinking text delta</p></td>
<td class="tableblock halign-left valign-top"><p><code>content = &lt;thinking text&gt;</code>, <code>properties.thinking = true</code> (new in M3)</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Thinking signature delta</p></td>
<td class="tableblock halign-left valign-top"><p>empty <code>content</code>, <code>properties.signature = &lt;signature&gt;</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Redacted thinking block</p></td>
<td class="tableblock halign-left valign-top"><p>empty <code>content</code>, <code>properties.data = &lt;data&gt;</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Sync thinking block (non-streaming)</p></td>
<td class="tableblock halign-left valign-top"><p><code>content = &lt;thinking text&gt;</code>, <code>properties.signature = &lt;signature&gt;</code> (single <code>Generation</code>)</p></td>
</tr>
</tbody>
</table>

### Prompt caching changes

Three behaviors to know about if you configured `AnthropicCacheOptions`:

- **The 4-breakpoint limit is enforced in Spring AI, not at the API.** Anthropic permits at most 4 cache breakpoints per request. The previous module passed markers through and let the API reject excess. `CacheBreakpointTracker` now keeps count and silently skips additions past 4, logging a one-time `WARN`. The most likely way to hit the cap is `SYSTEM_AND_TOOLS` combined with multi-block system caching and citation documents. Requests that previously failed with an API error can now succeed with reduced caching, so check your cache hit rate after the upgrade.

- **`AnthropicCacheStrategy.NONE` means "unset", not "disabled".** Setting `NONE` at the prompt level falls back to the model default. To turn caching off when the model default has it on, build a second `AnthropicChatModel` with `AnthropicCacheOptions.disabled()` as its default.

- **Tool cache TTL is taken from `MessageType.SYSTEM`.** `resolveToolCacheControl` looks up `messageTypeTtl(MessageType.SYSTEM)` regardless of strategy. Setting `messageTypeTtl(MessageType.USER, ONE_HOUR)` has no effect on tool caching.

### Citation document consistency is validated client-side

The Anthropic API requires every `DocumentBlockParam` with citation configuration in a single request to share the same `citations.enabled` value. `AnthropicChatOptions.validateCitationConsistency()` now enforces this and throws `IllegalArgumentException` before the request is sent. The previous module let the API return an HTTP 400. Tests or call sites that mixed enabled and disabled citation documents will now fail at build time instead of on the network call.

## New OkHttp Transitive Dependency

`com.anthropic:anthropic-java` pulls in `com.squareup.okhttp3:okhttp`. Most applications will not notice; if you have strict dependency-convergence rules or an existing OkHttp pin, you may need a `<dependencyManagement>` entry.

## New Capabilities

The migration also enables several Anthropic features. See Anthropic Chat for the full reference.

- Native skills (`AnthropicSkill`, `AnthropicSkillContainer`).

- Built-in web search tool (`AnthropicWebSearchTool`).

- Service tier selection (`AnthropicServiceTier`).

- Inference geo for data residency (`us`, `eu`).

- Native structured output through `JsonOutputFormat` and `Effort` (requires `claude-sonnet-4-6` or newer).

- Extended-thinking display modes (summarized / omitted).

- `Citation` type with four location variants (`CHAR_LOCATION`, `PAGE_LOCATION`, `CONTENT_BLOCK_LOCATION`, `WEB_SEARCH_RESULT_LOCATION`).

- Per-request HTTP headers on `AnthropicChatOptions#httpHeaders`, distinct from client-level `customHeaders` on `AbstractAnthropicOptions`. `customHeaders` is set once on the client and applies to every request; `httpHeaders` is set per `Prompt` and merged in at request-build time. Useful for request tracing, beta-API toggles, and routing.

## Things That Fail Silently

The compile errors are easy. These don’t throw; they produce different output instead.

- **Partial prompt-level options.** `new Prompt(text, AnthropicChatOptions.builder().maxTokens(2048).build())` no longer inherits `model`, `temperature`, etc. from the model’s defaults (see Prompt-level options no longer merge with model defaults). No compile error, no exception; the request runs with different values. If output drifts after the upgrade and you call `ChatModel` directly, look here first.

- If costs climb after the upgrade, check whether you were relying on the old `500`-token `maxTokens` default to cap responses.

- **Cache breakpoints dropped past four.** Stacking multi-block system caching with tools and citation documents can push past Anthropic’s 4-breakpoint cap. `CacheBreakpointTracker` skips the extras and logs `WARN` once. Cache hit rate drops without an error.

- Stale `org.springframework.ai.anthropic.api.AnthropicCache*` imports are the source of most compile errors after the upgrade. A project-wide find-and-replace fixes them.

Migrating FunctionCallback to ToolCallback API

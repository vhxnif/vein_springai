Search

# OpenAI Text-to-Speech (TTS)

## Introduction

The Audio API provides a speech endpoint based on OpenAI’s TTS (text-to-speech) model, enabling users to:

- Narrate a written blog post.

- Produce spoken audio in multiple languages.

- Give real-time audio output using streaming.

## Prerequisites

1.  Create an OpenAI account and obtain an API key. You can sign up at the OpenAI signup page and generate an API key on the API Keys page.

2.  Add the `spring-ai-openai` dependency to your project’s build file. For more information, refer to the Dependency Management section.

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the OpenAI Text-to-Speech Client. To enable it add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-openai</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file:

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-model-openai'
    }

## Speech Properties

### Connection Properties

The prefix `spring.ai.openai` is used as the property prefix that lets you connect to OpenAI.

<table class="tableblock frame-all grid-all stretch">
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
<td class="tableblock halign-left valign-top"><p>Optionally you can specify which organization used for an API request.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.project-id</p></td>
<td class="tableblock halign-left valign-top"><p>Optionally, you can specify which project is used for an API request.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

### Configuration Properties

The prefix `spring.ai.openai.audio.speech` is used as the property prefix that lets you configure the OpenAI Text-to-Speech client.

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 30%" />
<col style="width: 50%" />
<col style="width: 20%" />
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
<td class="tableblock halign-left valign-top"><p>spring.ai.model.audio.speech</p></td>
<td class="tableblock halign-left valign-top"><p>Enable Audio Speech Model</p></td>
<td class="tableblock halign-left valign-top"><p>openai</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.audio.speech.base-url</p></td>
<td class="tableblock halign-left valign-top"><p>The URL to connect to</p></td>
<td class="tableblock halign-left valign-top"><p>api.openai.com</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.audio.speech.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>The API Key</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.audio.speech.organization-id</p></td>
<td class="tableblock halign-left valign-top"><p>Optionally you can specify which organization used for an API request.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.audio.speech.project-id</p></td>
<td class="tableblock halign-left valign-top"><p>Optionally, you can specify which project is used for an API request.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.audio.speech.model</p></td>
<td class="tableblock halign-left valign-top"><p>ID of the model to use for generating the audio. Available models: <code>gpt-4o-mini-tts</code> (default, optimized for speed and cost), <code>gpt-4o-tts</code> (higher quality), <code>tts-1</code> (legacy, optimized for speed), or <code>tts-1-hd</code> (legacy, optimized for quality).</p></td>
<td class="tableblock halign-left valign-top"><p>gpt-4o-mini-tts</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.audio.speech.voice</p></td>
<td class="tableblock halign-left valign-top"><p>The voice to use for synthesis. For OpenAI’s TTS API, One of the available voices for the chosen model: alloy, echo, fable, onyx, nova, and shimmer.</p></td>
<td class="tableblock halign-left valign-top"><p>alloy</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.audio.speech.response-format</p></td>
<td class="tableblock halign-left valign-top"><p>The format of the audio output. Supported formats are mp3, opus, aac, flac, wav, and pcm.</p></td>
<td class="tableblock halign-left valign-top"><p>mp3</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.audio.speech.speed</p></td>
<td class="tableblock halign-left valign-top"><p>The speed of the voice synthesis. The acceptable range is from 0.25 (slowest) to 4.0 (fastest).</p></td>
<td class="tableblock halign-left valign-top"><p>1.0</p></td>
</tr>
</tbody>
</table>

## Runtime Options

The `OpenAiAudioSpeechOptions` class provides the options to use when making a text-to-speech request. On start-up, the options specified by `spring.ai.openai.audio.speech` are used but you can override these at runtime.

The `OpenAiAudioSpeechOptions` class implements the `TextToSpeechOptions` interface, providing both portable and OpenAI-specific configuration options.

For example:

    OpenAiAudioSpeechOptions speechOptions = OpenAiAudioSpeechOptions.builder()
        .model("gpt-4o-mini-tts")
        .voice(OpenAiAudioApi.SpeechRequest.Voice.ALLOY)
        .responseFormat(OpenAiAudioApi.SpeechRequest.AudioResponseFormat.MP3)
        .speed(1.0)
        .build();

    TextToSpeechPrompt speechPrompt = new TextToSpeechPrompt("Hello, this is a text-to-speech example.", speechOptions);
    TextToSpeechResponse response = openAiAudioSpeechModel.call(speechPrompt);

## Manual Configuration

Add the `spring-ai-openai` dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-openai</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file:

    dependencies {
        implementation 'org.springframework.ai:spring-ai-openai'
    }

Next, create an `OpenAiAudioSpeechModel`:

    var openAiAudioApi = new OpenAiAudioApi()
        .apiKey(System.getenv("OPENAI_API_KEY"))
        .build();

    var openAiAudioSpeechModel = new OpenAiAudioSpeechModel(openAiAudioApi);

    var speechOptions = OpenAiAudioSpeechOptions.builder()
        .responseFormat(OpenAiAudioApi.SpeechRequest.AudioResponseFormat.MP3)
        .speed(1.0)
        .model(OpenAiAudioApi.TtsModel.GPT_4_O_MINI_TTS.value)
        .build();

    var speechPrompt = new TextToSpeechPrompt("Hello, this is a text-to-speech example.", speechOptions);
    TextToSpeechResponse response = openAiAudioSpeechModel.call(speechPrompt);

    // Accessing metadata (rate limit info)
    OpenAiAudioSpeechResponseMetadata metadata = (OpenAiAudioSpeechResponseMetadata) response.getMetadata();

    byte[] responseAsBytes = response.getResult().getOutput();

## Streaming Real-time Audio

The Speech API provides support for real-time audio streaming using chunk transfer encoding. This means that the audio is able to be played before the full file has been generated and made accessible.

The `OpenAiAudioSpeechModel` implements the `StreamingTextToSpeechModel` interface, providing both standard and streaming capabilities.

    var openAiAudioApi = new OpenAiAudioApi()
        .apiKey(System.getenv("OPENAI_API_KEY"))
        .build();

    var openAiAudioSpeechModel = new OpenAiAudioSpeechModel(openAiAudioApi);

    OpenAiAudioSpeechOptions speechOptions = OpenAiAudioSpeechOptions.builder()
        .voice(OpenAiAudioApi.SpeechRequest.Voice.ALLOY)
        .speed(1.0)
        .responseFormat(OpenAiAudioApi.SpeechRequest.AudioResponseFormat.MP3)
        .model(OpenAiAudioApi.TtsModel.GPT_4_O_MINI_TTS.value)
        .build();

    TextToSpeechPrompt speechPrompt = new TextToSpeechPrompt("Today is a wonderful day to build something people love!", speechOptions);

    Flux<TextToSpeechResponse> responseStream = openAiAudioSpeechModel.stream(speechPrompt);

    // You can also stream raw audio bytes directly
    Flux<byte[]> audioByteStream = openAiAudioSpeechModel.stream("Hello, world!");

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

## Migration Guide

If you’re upgrading from the deprecated `SpeechModel` and `SpeechPrompt` classes, this guide provides detailed instructions for migrating to the new shared interfaces.

### Breaking Changes Summary

This migration includes the following breaking changes:

1.  **Removed Classes**: Six deprecated classes have been removed from `org.springframework.ai.openai.audio.speech` package

2.  **Package Changes**: Core TTS classes moved to `org.springframework.ai.audio.tts` package

3.  **Type Changes**: The `speed` parameter changed from `Float` to `Double` across all OpenAI TTS components

4.  **Interface Hierarchy**: `TextToSpeechModel` now extends `StreamingTextToSpeechModel`

### Class Mapping Reference

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Deprecated (Removed)</th>
<th class="tableblock halign-left valign-top">New Interface</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>SpeechModel</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>TextToSpeechModel</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>StreamingSpeechModel</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>StreamingTextToSpeechModel</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>SpeechPrompt</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>TextToSpeechPrompt</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>SpeechResponse</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>TextToSpeechResponse</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>SpeechMessage</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>TextToSpeechMessage</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>Speech</code> (in <code>org.springframework.ai.openai.audio.speech</code>)</p></td>
<td class="tableblock halign-left valign-top"><p><code>Speech</code> (in <code>org.springframework.ai.audio.tts</code>)</p></td>
</tr>
</tbody>
</table>

### Step-by-Step Migration Instructions

#### Step 1: Update Imports

Replace all imports from the old `org.springframework.ai.openai.audio.speech` package with the new shared interfaces:

    Find:    import org.springframework.ai.openai.audio.speech.SpeechModel;
    Replace: import org.springframework.ai.audio.tts.TextToSpeechModel;

    Find:    import org.springframework.ai.openai.audio.speech.StreamingSpeechModel;
    Replace: import org.springframework.ai.audio.tts.StreamingTextToSpeechModel;

    Find:    import org.springframework.ai.openai.audio.speech.SpeechPrompt;
    Replace: import org.springframework.ai.audio.tts.TextToSpeechPrompt;

    Find:    import org.springframework.ai.openai.audio.speech.SpeechResponse;
    Replace: import org.springframework.ai.audio.tts.TextToSpeechResponse;

    Find:    import org.springframework.ai.openai.audio.speech.SpeechMessage;
    Replace: import org.springframework.ai.audio.tts.TextToSpeechMessage;

    Find:    import org.springframework.ai.openai.audio.speech.Speech;
    Replace: import org.springframework.ai.audio.tts.Speech;

#### Step 2: Update Type References

Replace all type references in your code:

    Find:    SpeechModel
    Replace: TextToSpeechModel

    Find:    StreamingSpeechModel
    Replace: StreamingTextToSpeechModel

    Find:    SpeechPrompt
    Replace: TextToSpeechPrompt

    Find:    SpeechResponse
    Replace: TextToSpeechResponse

    Find:    SpeechMessage
    Replace: TextToSpeechMessage

#### Step 3: Update Speed Parameter (Float → Double)

The `speed` parameter has changed from `Float` to `Double`. Update all occurrences:

    Find:    .speed(1.0f)
    Replace: .speed(1.0)

    Find:    .speed(0.5f)
    Replace: .speed(0.5)

    Find:    Float speed
    Replace: Double speed

If you have serialized data or configuration files with Float values, you’ll need to update those as well:

    // Before
    {
      "speed": 1.0
    }

    // After (no code change needed for JSON, but be aware of type change in Java)
    {
      "speed": 1.0
    }

#### Step 4: Update Bean Declarations

If you have Spring Boot auto-configuration or manual bean definitions:

    // Before
    @Bean
    public SpeechModel speechModel(OpenAiAudioApi audioApi) {
        return new OpenAiAudioSpeechModel(audioApi);
    }

    // After
    @Bean
    public TextToSpeechModel textToSpeechModel(OpenAiAudioApi audioApi) {
        return new OpenAiAudioSpeechModel(audioApi);
    }

### Code Migration Examples

#### Example 1: Basic Text-to-Speech Conversion

**Before (deprecated):**

    import org.springframework.ai.openai.audio.speech.*;

    @Service
    public class OldNarrationService {

        private final SpeechModel speechModel;

        public OldNarrationService(SpeechModel speechModel) {
            this.speechModel = speechModel;
        }

        public byte[] createNarration(String text) {
            SpeechPrompt prompt = new SpeechPrompt(text);
            SpeechResponse response = speechModel.call(prompt);
            return response.getResult().getOutput();
        }
    }

**After (using shared interfaces):**

    import org.springframework.ai.audio.tts.*;
    import org.springframework.ai.openai.OpenAiAudioSpeechModel;

    @Service
    public class NarrationService {

        private final TextToSpeechModel textToSpeechModel;

        public NarrationService(TextToSpeechModel textToSpeechModel) {
            this.textToSpeechModel = textToSpeechModel;
        }

        public byte[] createNarration(String text) {
            TextToSpeechPrompt prompt = new TextToSpeechPrompt(text);
            TextToSpeechResponse response = textToSpeechModel.call(prompt);
            return response.getResult().getOutput();
        }
    }

#### Example 2: Text-to-Speech with Custom Options

**Before (deprecated):**

    import org.springframework.ai.openai.audio.speech.*;
    import org.springframework.ai.openai.api.OpenAiAudioApi;

    SpeechModel model = new OpenAiAudioSpeechModel(audioApi);

    OpenAiAudioSpeechOptions options = OpenAiAudioSpeechOptions.builder()
        .model("tts-1")
        .voice(OpenAiAudioApi.SpeechRequest.Voice.NOVA)
        .speed(1.0f)  // Float value
        .responseFormat(OpenAiAudioApi.SpeechRequest.AudioResponseFormat.MP3)
        .build();

    SpeechPrompt prompt = new SpeechPrompt("Hello, world!", options);
    SpeechResponse response = model.call(prompt);
    byte[] audio = response.getResult().getOutput();

**After (using shared interfaces):**

    import org.springframework.ai.audio.tts.*;
    import org.springframework.ai.openai.OpenAiAudioSpeechModel;
    import org.springframework.ai.openai.OpenAiAudioSpeechOptions;
    import org.springframework.ai.openai.api.OpenAiAudioApi;

    TextToSpeechModel model = new OpenAiAudioSpeechModel(audioApi);

    OpenAiAudioSpeechOptions options = OpenAiAudioSpeechOptions.builder()
        .model("tts-1")
        .voice(OpenAiAudioApi.SpeechRequest.Voice.NOVA)
        .speed(1.0)  // Double value
        .responseFormat(OpenAiAudioApi.SpeechRequest.AudioResponseFormat.MP3)
        .build();

    TextToSpeechPrompt prompt = new TextToSpeechPrompt("Hello, world!", options);
    TextToSpeechResponse response = model.call(prompt);
    byte[] audio = response.getResult().getOutput();

#### Example 3: Streaming Text-to-Speech

**Before (deprecated):**

    import org.springframework.ai.openai.audio.speech.*;
    import reactor.core.publisher.Flux;

    StreamingSpeechModel model = new OpenAiAudioSpeechModel(audioApi);
    SpeechPrompt prompt = new SpeechPrompt("Stream this text");

    Flux<SpeechResponse> stream = model.stream(prompt);
    stream.subscribe(response -> {
        byte[] audioChunk = response.getResult().getOutput();
        // Process audio chunk
    });

**After (using shared interfaces):**

    import org.springframework.ai.audio.tts.*;
    import org.springframework.ai.openai.OpenAiAudioSpeechModel;
    import reactor.core.publisher.Flux;

    TextToSpeechModel model = new OpenAiAudioSpeechModel(audioApi);
    TextToSpeechPrompt prompt = new TextToSpeechPrompt("Stream this text");

    Flux<TextToSpeechResponse> stream = model.stream(prompt);
    stream.subscribe(response -> {
        byte[] audioChunk = response.getResult().getOutput();
        // Process audio chunk
    });

#### Example 4: Dependency Injection with Spring Boot

**Before (deprecated):**

    @RestController
    public class OldSpeechController {

        private final SpeechModel speechModel;

        @Autowired
        public OldSpeechController(SpeechModel speechModel) {
            this.speechModel = speechModel;
        }

        @PostMapping("/narrate")
        public ResponseEntity<byte[]> narrate(@RequestBody String text) {
            SpeechPrompt prompt = new SpeechPrompt(text);
            SpeechResponse response = speechModel.call(prompt);
            return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType("audio/mpeg"))
                .body(response.getResult().getOutput());
        }
    }

**After (using shared interfaces):**

    @RestController
    public class SpeechController {

        private final TextToSpeechModel textToSpeechModel;

        @Autowired
        public SpeechController(TextToSpeechModel textToSpeechModel) {
            this.textToSpeechModel = textToSpeechModel;
        }

        @PostMapping("/narrate")
        public ResponseEntity<byte[]> narrate(@RequestBody String text) {
            TextToSpeechPrompt prompt = new TextToSpeechPrompt(text);
            TextToSpeechResponse response = textToSpeechModel.call(prompt);
            return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType("audio/mpeg"))
                .body(response.getResult().getOutput());
        }
    }

### Spring Boot Configuration Changes

The Spring Boot auto-configuration properties remain the same. No changes are required to your `application.properties` or `application.yml` files.

However, if you have explicit bean references or qualifiers, update them:

    // Before
    @Qualifier("speechModel")

    // After
    @Qualifier("textToSpeechModel")

### Benefits of the Migration

- **Portability**: Write code once, switch between OpenAI, ElevenLabs, or other TTS providers easily

- **Consistency**: Same patterns as ChatModel and other Spring AI abstractions

- **Type Safety**: Improved type hierarchy with proper interface implementations

- **Future-Proof**: New TTS providers will automatically work with your existing code

- **Standardization**: Consistent `Double` type for speed parameter across all TTS providers

### Common Migration Issues and Solutions

#### Issue 1: Compilation Error - Cannot Find Symbol SpeechModel

**Error:**

    error: cannot find symbol SpeechModel

**Solution:** Update your imports as described in Step 1, changing `SpeechModel` to `TextToSpeechModel`.

#### Issue 2: Type Mismatch - Float Cannot Be Converted to Double

**Error:**

    error: incompatible types: float cannot be converted to Double

**Solution:** Remove the `f` suffix from floating-point literals (e.g., change `1.0f` to `1.0`).

#### Issue 3: Bean Creation Error at Runtime

**Error:**

    NoSuchBeanDefinitionException: No qualifying bean of type 'SpeechModel'

**Solution:** Update your dependency injection to use `TextToSpeechModel` instead of `SpeechModel`.

## Example Code

- The OpenAiSpeechModelIT.java test provides some general examples of how to use the library.

Text-To-Speech (TTS) API ElevenLabs

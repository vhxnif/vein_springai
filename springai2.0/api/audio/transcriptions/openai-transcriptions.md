Search

## OpenAI Transcriptions

Spring AI supports OpenAI’s Transcription model.

## Prerequisites

You will need to create an API key with OpenAI to access ChatGPT models. Create an account at OpenAI signup page and generate the token on the API Keys page. The Spring AI project defines a configuration property named `spring.ai.openai.api-key` that you should set to the value of the `API Key` obtained from openai.com. Exporting an environment variable is one way to set that configuration property:

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the OpenAI Transcription Client. To enable it add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-openai</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-model-openai'
    }

### Transcription Properties

#### Connection Properties

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

#### Configuration Properties

The prefix `spring.ai.openai.audio.transcription` is used as the property prefix that lets you configure the retry mechanism for the OpenAI transcription model.

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
<td class="tableblock halign-left valign-top"><p>spring.ai.model.audio.transcription</p></td>
<td class="tableblock halign-left valign-top"><p>Enable OpenAI Audio Transcription Model</p></td>
<td class="tableblock halign-left valign-top"><p>openai</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.audio.transcription.base-url</p></td>
<td class="tableblock halign-left valign-top"><p>The URL to connect to</p></td>
<td class="tableblock halign-left valign-top"><p>api.openai.com</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.audio.transcription.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>The API Key</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.audio.transcription.organization-id</p></td>
<td class="tableblock halign-left valign-top"><p>Optionally you can specify which organization used for an API request.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.audio.transcription.project-id</p></td>
<td class="tableblock halign-left valign-top"><p>Optionally, you can specify which project is used for an API request.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.audio.transcription.model</p></td>
<td class="tableblock halign-left valign-top"><p>ID of the model to use for transcription. Available models: <code>gpt-4o-transcribe</code> (speech-to-text powered by GPT-4o), <code>gpt-4o-mini-transcribe</code> (speech-to-text powered by GPT-4o mini), or <code>whisper-1</code> (general-purpose speech recognition model, default).</p></td>
<td class="tableblock halign-left valign-top"><p>whisper-1</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.audio.transcription.response-format</p></td>
<td class="tableblock halign-left valign-top"><p>The format of the transcript output, in one of these options: json, text, srt, verbose_json, or vtt.</p></td>
<td class="tableblock halign-left valign-top"><p>json</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.audio.transcription.prompt</p></td>
<td class="tableblock halign-left valign-top"><p>An optional text to guide the model’s style or continue a previous audio segment. The prompt should match the audio language.</p></td>
<td class="tableblock halign-left valign-top"></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.audio.transcription.language</p></td>
<td class="tableblock halign-left valign-top"><p>The language of the input audio. Supplying the input language in ISO-639-1 format will improve accuracy and latency.</p></td>
<td class="tableblock halign-left valign-top"></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.audio.transcription.temperature</p></td>
<td class="tableblock halign-left valign-top"><p>The sampling temperature, between 0 and 1. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. If set to 0, the model will use log probability to automatically increase the temperature until certain thresholds are hit.</p></td>
<td class="tableblock halign-left valign-top"><p>0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.audio.transcription.timestamp_granularities</p></td>
<td class="tableblock halign-left valign-top"><p>The timestamp granularities to populate for this transcription. response_format must be set verbose_json to use timestamp granularities. Either or both of these options are supported: word, or segment. Note: There is no additional latency for segment timestamps, but generating word timestamps incurs additional latency.</p></td>
<td class="tableblock halign-left valign-top"><p>segment</p></td>
</tr>
</tbody>
</table>

## Runtime Options

The `OpenAiAudioTranscriptionOptions` class provides the options to use when making a transcription. On start-up, the options specified by `spring.ai.openai.audio.transcription` are used but you can override these at runtime.

For example:

    OpenAiAudioApi.TranscriptResponseFormat responseFormat = OpenAiAudioApi.TranscriptResponseFormat.VTT;

    OpenAiAudioTranscriptionOptions transcriptionOptions = OpenAiAudioTranscriptionOptions.builder()
        .language("en")
        .prompt("Ask not this, but ask that")
        .temperature(0f)
        .responseFormat(this.responseFormat)
        .build();
    AudioTranscriptionPrompt transcriptionRequest = new AudioTranscriptionPrompt(audioFile, this.transcriptionOptions);
    AudioTranscriptionResponse response = openAiTranscriptionModel.call(this.transcriptionRequest);

## Manual Configuration

Add the `spring-ai-openai` dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-openai</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-openai'
    }

Next, create a `OpenAiAudioTranscriptionModel`

    var openAiAudioApi = new OpenAiAudioApi(System.getenv("OPENAI_API_KEY"));

    var openAiAudioTranscriptionModel = new OpenAiAudioTranscriptionModel(this.openAiAudioApi);

    var transcriptionOptions = OpenAiAudioTranscriptionOptions.builder()
        .responseFormat(TranscriptResponseFormat.TEXT)
        .temperature(0f)
        .build();

    var audioFile = new FileSystemResource("/path/to/your/resource/speech/jfk.flac");

    AudioTranscriptionPrompt transcriptionRequest = new AudioTranscriptionPrompt(this.audioFile, this.transcriptionOptions);
    AudioTranscriptionResponse response = openAiTranscriptionModel.call(this.transcriptionRequest);

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

## Example Code

- The OpenAiTranscriptionModelIT.java test provides some general examples how to use the library.

Azure OpenAI Text-To-Speech (TTS) API

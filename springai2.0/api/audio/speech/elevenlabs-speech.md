Search

# ElevenLabs Text-to-Speech (TTS)

## Introduction

ElevenLabs provides natural-sounding speech synthesis software using deep learning. Its AI audio models generate realistic, versatile, and contextually-aware speech, voices, and sound effects across 32 languages. The ElevenLabs Text-to-Speech API enables users to bring any book, article, PDF, newsletter, or text to life with ultra-realistic AI narration.

## Prerequisites

1.  Create an ElevenLabs account and obtain an API key. You can sign up at the ElevenLabs signup page. Your API key can be found on your profile page after logging in.

2.  Add the `spring-ai-elevenlabs` dependency to your project’s build file. For more information, refer to the Dependency Management section.

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the ElevenLabs Text-to-Speech Client. To enable it, add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-elevenlabs</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file:

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-model-elevenlabs'
    }

## Speech Properties

### Connection Properties

The prefix `spring.ai.elevenlabs` is used as the property prefix for **all** ElevenLabs related configurations (both connection and TTS specific settings). This is defined in `ElevenLabsConnectionProperties`.

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
<td class="tableblock halign-left valign-top"><p>spring.ai.elevenlabs.base-url</p></td>
<td class="tableblock halign-left valign-top"><p>The base URL for the ElevenLabs API.</p></td>
<td class="tableblock halign-left valign-top"><p>api.elevenlabs.io</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.elevenlabs.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>Your ElevenLabs API key.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

### Configuration Properties

The prefix `spring.ai.elevenlabs.tts` is used as the property prefix to configure the ElevenLabs Text-to-Speech client, specifically. This is defined in `ElevenLabsSpeechProperties`.

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
<td class="tableblock halign-left valign-top"><p>elevenlabs</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.elevenlabs.tts.model-id</p></td>
<td class="tableblock halign-left valign-top"><p>The ID of the model to use.</p></td>
<td class="tableblock halign-left valign-top"><p>eleven_turbo_v2_5</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.elevenlabs.tts.voice-id</p></td>
<td class="tableblock halign-left valign-top"><p>The ID of the voice to use. This is the <strong>voice ID</strong>, not the voice name.</p></td>
<td class="tableblock halign-left valign-top"><p>9BWtsMINqrJLrRacOk9x</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.elevenlabs.tts.output-format</p></td>
<td class="tableblock halign-left valign-top"><p>The output format for the generated audio. See Output Formats below.</p></td>
<td class="tableblock halign-left valign-top"><p>mp3_22050_32</p></td>
</tr>
</tbody>
</table>

<table id="output-formats" class="tableblock frame-all grid-all stretch">
<caption>Table 1. Available Output Formats</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Enum Value</p></td>
<td class="tableblock halign-left valign-top"><p>Description</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>MP3_22050_32</p></td>
<td class="tableblock halign-left valign-top"><p>MP3, 22.05 kHz, 32 kbps</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>MP3_44100_32</p></td>
<td class="tableblock halign-left valign-top"><p>MP3, 44.1 kHz, 32 kbps</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>MP3_44100_64</p></td>
<td class="tableblock halign-left valign-top"><p>MP3, 44.1 kHz, 64 kbps</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>MP3_44100_96</p></td>
<td class="tableblock halign-left valign-top"><p>MP3, 44.1 kHz, 96 kbps</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>MP3_44100_128</p></td>
<td class="tableblock halign-left valign-top"><p>MP3, 44.1 kHz, 128 kbps</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>MP3_44100_192</p></td>
<td class="tableblock halign-left valign-top"><p>MP3, 44.1 kHz, 192 kbps</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>PCM_8000</p></td>
<td class="tableblock halign-left valign-top"><p>PCM, 8 kHz</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>PCM_16000</p></td>
<td class="tableblock halign-left valign-top"><p>PCM, 16 kHz</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>PCM_22050</p></td>
<td class="tableblock halign-left valign-top"><p>PCM, 22.05 kHz</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>PCM_24000</p></td>
<td class="tableblock halign-left valign-top"><p>PCM, 24 kHz</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>PCM_44100</p></td>
<td class="tableblock halign-left valign-top"><p>PCM, 44.1 kHz</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>PCM_48000</p></td>
<td class="tableblock halign-left valign-top"><p>PCM, 48 kHz</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>ULAW_8000</p></td>
<td class="tableblock halign-left valign-top"><p>µ-law, 8 kHz</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>ALAW_8000</p></td>
<td class="tableblock halign-left valign-top"><p>A-law, 8 kHz</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>OPUS_48000_32</p></td>
<td class="tableblock halign-left valign-top"><p>Opus, 48 kHz, 32 kbps</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>OPUS_48000_64</p></td>
<td class="tableblock halign-left valign-top"><p>Opus, 48 kHz, 64 kbps</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>OPUS_48000_96</p></td>
<td class="tableblock halign-left valign-top"><p>Opus, 48 kHz, 96 kbps</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>OPUS_48000_128</p></td>
<td class="tableblock halign-left valign-top"><p>Opus, 48 kHz, 128 kbps</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>OPUS_48000_192</p></td>
<td class="tableblock halign-left valign-top"><p>Opus, 48 kHz, 192 kbps</p></td>
</tr>
</tbody>
</table>

## Runtime Options

The `ElevenLabsTextToSpeechOptions` class provides options to use when making a text-to-speech request. On start-up, the options specified by `spring.ai.elevenlabs.tts` are used, but you can override these at runtime. The following options are available:

- `modelId`: The ID of the model to use.

- `voiceId`: The ID of the voice to use.

- `outputFormat`: The output format of the generated audio.

- `voiceSettings`: An object containing voice settings such as `stability`, `similarityBoost`, `style`, `useSpeakerBoost`, and `speed`.

- `enableLogging`: A boolean to enable or disable logging.

- `languageCode`: The language code of the input text (e.g., "en" for English).

- `pronunciationDictionaryLocators`: A list of pronunciation dictionary locators.

- `seed`: A seed for random number generation, for reproducibility.

- `previousText`: Text before the main text, for context in multi-turn conversations.

- `nextText`: Text after the main text, for context in multi-turn conversations.

- `previousRequestIds`: Request IDs from previous turns in a conversation.

- `nextRequestIds`: Request IDs for subsequent turns in a conversation.

- `applyTextNormalization`: Apply text normalization ("auto", "on", or "off").

- `applyLanguageTextNormalization`: Apply language text normalization.

For example:

    ElevenLabsTextToSpeechOptions speechOptions = ElevenLabsTextToSpeechOptions.builder()
        .model("eleven_multilingual_v2")
        .voiceId("your_voice_id")
        .outputFormat(ElevenLabsApi.OutputFormat.MP3_44100_128.getValue())
        .build();

    TextToSpeechPrompt speechPrompt = new TextToSpeechPrompt("Hello, this is a text-to-speech example.", speechOptions);
    TextToSpeechResponse response = elevenLabsTextToSpeechModel.call(speechPrompt);

### Using Voice Settings

You can customize the voice output by providing `VoiceSettings` in the options. This allows you to control properties like stability and similarity.

    var voiceSettings = new ElevenLabsApi.SpeechRequest.VoiceSettings(0.75f, 0.75f, 0.0f, true);

    ElevenLabsTextToSpeechOptions speechOptions = ElevenLabsTextToSpeechOptions.builder()
        .model("eleven_multilingual_v2")
        .voiceId("your_voice_id")
        .voiceSettings(voiceSettings)
        .build();

    TextToSpeechPrompt speechPrompt = new TextToSpeechPrompt("This is a test with custom voice settings!", speechOptions);
    TextToSpeechResponse response = elevenLabsTextToSpeechModel.call(speechPrompt);

## Manual Configuration

Add the `spring-ai-elevenlabs` dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-elevenlabs</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file:

    dependencies {
        implementation 'org.springframework.ai:spring-ai-elevenlabs'
    }

Next, create an `ElevenLabsTextToSpeechModel`:

    ElevenLabsApi elevenLabsApi = ElevenLabsApi.builder()
            .apiKey(System.getenv("ELEVEN_LABS_API_KEY"))
            .build();

    ElevenLabsTextToSpeechModel elevenLabsTextToSpeechModel = ElevenLabsTextToSpeechModel.builder()
        .elevenLabsApi(elevenLabsApi)
        .options(ElevenLabsTextToSpeechOptions.builder()
            .model("eleven_turbo_v2_5")
            .voiceId("your_voice_id") // e.g. "9BWtsMINqrJLrRacOk9x"
            .outputFormat("mp3_44100_128")
            .build())
        .build();

    // The call will use the default options configured above.
    TextToSpeechPrompt speechPrompt = new TextToSpeechPrompt("Hello, this is a text-to-speech example.");
    TextToSpeechResponse response = elevenLabsTextToSpeechModel.call(speechPrompt);

    byte[] responseAsBytes = response.getResult().getOutput();

## Streaming Real-time Audio

The ElevenLabs Speech API supports real-time audio streaming using chunk transfer encoding. This allows audio playback to begin before the entire audio file is generated.

    ElevenLabsApi elevenLabsApi = ElevenLabsApi.builder()
            .apiKey(System.getenv("ELEVEN_LABS_API_KEY"))
            .build();

    ElevenLabsTextToSpeechModel elevenLabsTextToSpeechModel = ElevenLabsTextToSpeechModel.builder()
        .elevenLabsApi(elevenLabsApi)
        .build();

    ElevenLabsTextToSpeechOptions streamingOptions = ElevenLabsTextToSpeechOptions.builder()
        .model("eleven_turbo_v2_5")
        .voiceId("your_voice_id")
        .outputFormat("mp3_44100_128")
        .build();

    TextToSpeechPrompt speechPrompt = new TextToSpeechPrompt("Today is a wonderful day to build something people love!", streamingOptions);

    Flux<TextToSpeechResponse> responseStream = elevenLabsTextToSpeechModel.stream(speechPrompt);

    // Process the stream, e.g., play the audio chunks
    responseStream.subscribe(speechResponse -> {
        byte[] audioChunk = speechResponse.getResult().getOutput();
        // Play the audioChunk
    });

## Voices API

The ElevenLabs Voices API allows you to retrieve information about available voices, their settings, and default voice settings. You can use this API to discover the \`voiceId\`s to use in your speech requests.

To use the Voices API, you’ll need to create an instance of `ElevenLabsVoicesApi`:

    ElevenLabsVoicesApi voicesApi = ElevenLabsVoicesApi.builder()
            .apiKey(System.getenv("ELEVEN_LABS_API_KEY"))
            .build();

You can then use the following methods:

- `getVoices()`: Retrieves a list of all available voices.

- `getDefaultVoiceSettings()`: Gets the default settings for voices.

- `getVoiceSettings(String voiceId)`: Returns the settings for a specific voice.

- `getVoice(String voiceId)`: Returns metadata about a specific voice.

Example:

    // Get all voices
    ResponseEntity<ElevenLabsVoicesApi.Voices> voicesResponse = voicesApi.getVoices();
    List<ElevenLabsVoicesApi.Voice> voices = voicesResponse.getBody().voices();

    // Get default voice settings
    ResponseEntity<ElevenLabsVoicesApi.VoiceSettings> defaultSettingsResponse = voicesApi.getDefaultVoiceSettings();
    ElevenLabsVoicesApi.VoiceSettings defaultSettings = defaultSettingsResponse.getBody();

    // Get settings for a specific voice
    ResponseEntity<ElevenLabsVoicesApi.VoiceSettings> voiceSettingsResponse = voicesApi.getVoiceSettings(voiceId);
    ElevenLabsVoicesApi.VoiceSettings voiceSettings = voiceSettingsResponse.getBody();

    // Get details for a specific voice
    ResponseEntity<ElevenLabsVoicesApi.Voice> voiceDetailsResponse = voicesApi.getVoice(voiceId);
    ElevenLabsVoicesApi.Voice voiceDetails = voiceDetailsResponse.getBody();

## Example Code

- The ElevenLabsTextToSpeechModelIT.java test provides some general examples of how to use the library.

- The ElevenLabsApiIT.java test provides examples of using the low-level `ElevenLabsApi`.

OpenAI Moderation Models

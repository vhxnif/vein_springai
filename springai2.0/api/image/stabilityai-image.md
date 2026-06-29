Search

# Stability AI Image Generation

Spring AI supports Stability AI’s text to image generation model.

## Prerequisites

You will need to create an API key with Stability AI to access their AI models. Follow their Getting Started documentation to obtain your API key.

The Spring AI project defines a configuration property named `spring.ai.stabilityai.api-key` that you should set to the value of the `API Key` obtained from Stability AI.

You can set this configuration property in your `application.properties` file:

    spring.ai.stabilityai.api-key=<your-stabilityai-api-key>

For enhanced security when handling sensitive information like API keys, you can use Spring Expression Language (SpEL) to reference a custom environment variable:

    # In application.yml
    spring:
      ai:
        stabilityai:
          api-key: ${STABILITYAI_API_KEY}

    # In your environment or .env file
    export STABILITYAI_API_KEY=<your-stabilityai-api-key>

You can also set this configuration programmatically in your application code:

    // Retrieve API key from a secure source or environment variable
    String apiKey = System.getenv("STABILITYAI_API_KEY");

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the Stability AI Image Generation Client. To enable it add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-stability-ai</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-model-stability-ai'
    }

### Image Generation Properties

The prefix `spring.ai.stabilityai` is used as the property prefix that lets you connect to Stability AI.

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
<td class="tableblock halign-left valign-top"><p>spring.ai.stabilityai.base-url</p></td>
<td class="tableblock halign-left valign-top"><p>The URL to connect to</p></td>
<td class="tableblock halign-left valign-top"><p>api.stability.ai/v1</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.stabilityai.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>The API Key</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

The prefix `spring.ai.stabilityai.image` is the property prefix that lets you configure the `ImageModel` implementation for Stability AI.

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 25%" />
<col style="width: 62%" />
<col style="width: 12%" />
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
<td class="tableblock halign-left valign-top"><p>spring.ai.stabilityai.image.enabled (Removed and no longer valid)</p></td>
<td class="tableblock halign-left valign-top"><p>Enable Stability AI image model.</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.model.image</p></td>
<td class="tableblock halign-left valign-top"><p>Enable Stability AI image model.</p></td>
<td class="tableblock halign-left valign-top"><p>stabilityai</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.stabilityai.image.base-url</p></td>
<td class="tableblock halign-left valign-top"><p>Optional overrides the spring.ai.openai.base-url to provide a specific url</p></td>
<td class="tableblock halign-left valign-top"><p><code>https://api.stability.ai/v1</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.stabilityai.image.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>Optional overrides the spring.ai.openai.api-key to provide a specific api-key</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.stabilityai.image.n</p></td>
<td class="tableblock halign-left valign-top"><p>The number of images to be generated. Must be between 1 and 10.</p></td>
<td class="tableblock halign-left valign-top"><p>1</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.stabilityai.image.model</p></td>
<td class="tableblock halign-left valign-top"><p>The engine/model to use in Stability AI. The model is passed in the URL as a path parameter.</p></td>
<td class="tableblock halign-left valign-top"><p><code>stable-diffusion-v1-6</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.stabilityai.image.width</p></td>
<td class="tableblock halign-left valign-top"><p>Width of the image to generate, in pixels, in an increment divisible by 64. Engine-specific dimension validation applies.</p></td>
<td class="tableblock halign-left valign-top"><p>512</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.stabilityai.image.height</p></td>
<td class="tableblock halign-left valign-top"><p>Height of the image to generate, in pixels, in an increment divisible by 64. Engine-specific dimension validation applies.</p></td>
<td class="tableblock halign-left valign-top"><p>512</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.stabilityai.image.response-format</p></td>
<td class="tableblock halign-left valign-top"><p>The format in which the generated images are returned. Must be "application/json" or "image/png".</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.stabilityai.image.cfg_scale</p></td>
<td class="tableblock halign-left valign-top"><p>The strictness level of the diffusion process adherence to the prompt text. Range: 0 to 35.</p></td>
<td class="tableblock halign-left valign-top"><p>7</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.stabilityai.image.clip_guidance_preset</p></td>
<td class="tableblock halign-left valign-top"><p>Pass in a style preset to guide the image model towards a particular style. This list of style presets is subject to change.</p></td>
<td class="tableblock halign-left valign-top"><p><code>NONE</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.stabilityai.image.sampler</p></td>
<td class="tableblock halign-left valign-top"><p>Which sampler to use for the diffusion process. If this value is omitted, an appropriate sampler will be automatically selected.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.stabilityai.image.seed</p></td>
<td class="tableblock halign-left valign-top"><p>Random noise seed (omit this option or use 0 for a random seed). Valid range: 0 to 4294967295.</p></td>
<td class="tableblock halign-left valign-top"><p>0</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.stabilityai.image.steps</p></td>
<td class="tableblock halign-left valign-top"><p>Number of diffusion steps to run. Valid range: 10 to 50.</p></td>
<td class="tableblock halign-left valign-top"><p>30</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.stabilityai.image.style_preset</p></td>
<td class="tableblock halign-left valign-top"><p>Pass in a style preset to guide the image model towards a particular style. This list of style presets is subject to change.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

## Runtime Options

The StabilityAiImageOptions.java provides model configurations, such as the model to use, the style, the size, etc.

On start-up, the default options can be configured with the `StabilityAiImageModel(StabilityAiApi stabilityAiApi, StabilityAiImageOptions options)` constructor. Alternatively, use the `spring.ai.stabilityai.image.*` properties described previously.

At runtime, you can override the default options by adding new, request specific, options to the `ImagePrompt` call. For example to override the Stability AI specific options such as quality and the number of images to create, use the following code example:

    ImageResponse response = stabilityaiImageModel.call(
            new ImagePrompt("A light cream colored mini golden doodle",
            StabilityAiImageOptions.builder()
                    .stylePreset("cinematic")
                    .n(4)
                    .height(1024)
                    .width(1024).build())

    );

OpenAI Audio Models

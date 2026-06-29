Search

# OpenAI Image Generation

Spring AI supports DALL-E, the Image generation model from OpenAI.

## Prerequisites

You will need to create an API key with OpenAI to access ChatGPT models.

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

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the OpenAI Image Generation Client. To enable it add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-openai</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-model-openai'
    }

### Image Generation Properties

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

#### Retry Properties

The prefix `spring.ai.retry` is used as the property prefix that lets you configure the retry mechanism for the OpenAI Image client.

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

#### Configuration Properties

The prefix `spring.ai.openai.image` is the property prefix that lets you configure the `ImageModel` implementation for OpenAI.

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
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.image.enabled (Removed and no longer valid)</p></td>
<td class="tableblock halign-left valign-top"><p>Enable OpenAI image model.</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.model.image</p></td>
<td class="tableblock halign-left valign-top"><p>Enable OpenAI image model.</p></td>
<td class="tableblock halign-left valign-top"><p>openai</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.image.base-url</p></td>
<td class="tableblock halign-left valign-top"><p>Optional overrides the spring.ai.openai.base-url to provide chat specific url</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.image.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>Optional overrides the spring.ai.openai.api-key to provide chat specific api-key</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.image.organization-id</p></td>
<td class="tableblock halign-left valign-top"><p>Optionally you can specify which organization used for an API request.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.image.project-id</p></td>
<td class="tableblock halign-left valign-top"><p>Optionally, you can specify which project is used for an API request.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.image.n</p></td>
<td class="tableblock halign-left valign-top"><p>The number of images to generate. Must be between 1 and 10. For dall-e-3, only n=1 is supported.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.image.model</p></td>
<td class="tableblock halign-left valign-top"><p>The model to use for image generation.</p></td>
<td class="tableblock halign-left valign-top"><p>ImageModel.GPT_IMAGE_1_MINI.toString()</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.image.quality</p></td>
<td class="tableblock halign-left valign-top"><p>The quality of the image that will be generated. HD creates images with finer details and greater consistency across the image. This parameter is only supported for dall-e-3.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.image.response_format</p></td>
<td class="tableblock halign-left valign-top"><p>The format in which the generated images are returned. Must be one of URL or b64_json.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.openai.image.size</code></p></td>
<td class="tableblock halign-left valign-top"><p>The size of the generated images. Must be one of 256x256, 512x512, or 1024x1024 for dall-e-2. Must be one of 1024x1024, 1792x1024, or 1024x1792 for dall-e-3 models.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.openai.image.size_width</code></p></td>
<td class="tableblock halign-left valign-top"><p>The width of the generated images. Must be one of 256, 512, or 1024 for dall-e-2.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.openai.image.size_height</code></p></td>
<td class="tableblock halign-left valign-top"><p>The height of the generated images. Must be one of 256, 512, or 1024 for dall-e-2.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.openai.image.style</code></p></td>
<td class="tableblock halign-left valign-top"><p>The style of the generated images. Must be one of vivid or natural. Vivid causes the model to lean towards generating hyper-real and dramatic images. Natural causes the model to produce more natural, less hyper-real looking images. This parameter is only supported for dall-e-3.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.openai.image.user</code></p></td>
<td class="tableblock halign-left valign-top"><p>A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

## Runtime Options

The OpenAiImageOptions.java provides model configurations, such as the model to use, the quality, the size, etc.

On start-up, the default options can be configured by passing `OpenAiImageOptions` to the `OpenAiImageModel` constructor. Alternatively, use the `spring.ai.openai.image.*` properties described previously.

At runtime you can override the default options by adding new, request specific, options to the `ImagePrompt` call. For example to override the OpenAI specific options such as quality and the number of images to create, use the following code example:

    ImageResponse response = openaiImageModel.call(
            new ImagePrompt("A light cream colored mini golden doodle",
            OpenAiImageOptions.builder()
                    .quality("hd")
                    .n(4)
                    .height(1024)
                    .width(1024).build())

    );

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

Azure OpenAI Stability

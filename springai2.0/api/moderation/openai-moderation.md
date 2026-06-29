Search

# Moderation

## Introduction

Spring AI supports OpenAI’s Moderation model, which allows you to detect potentially harmful or sensitive content in text. Follow this guide to for more information on OpenAI’s moderation model.

## Prerequisites

1.  Create an OpenAI account and obtain an API key. You can sign up at the OpenAI signup page and generate an API key on the API Keys page.

2.  Add the `spring-ai-openai` dependency to your project’s build file. For more information, refer to the Dependency Management section.

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the OpenAI Moderation Model. To enable it add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-openai</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file:

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-model-openai'
    }

## Moderation Properties

### Connection Properties

The prefix spring.ai.openai is used as the property prefix that lets you connect to OpenAI.

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
<td class="tableblock halign-left valign-top"><p>Optionally you can specify which organization is used for an API request.</p></td>
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

The prefix spring.ai.openai.moderation is used as the property prefix for configuring the OpenAI moderation model.

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 30%" />
<col style="width: 50%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Property</p></td>
<td class="tableblock halign-left valign-top"><p>Description</p></td>
<td class="tableblock halign-left valign-top"><p>Default</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.model.moderation</p></td>
<td class="tableblock halign-left valign-top"><p>Enable Moderation model</p></td>
<td class="tableblock halign-left valign-top"><p>openai</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.moderation.base-url</p></td>
<td class="tableblock halign-left valign-top"><p>The URL to connect to</p></td>
<td class="tableblock halign-left valign-top"><p>api.openai.com</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.moderation.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>The API Key</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.moderation.organization-id</p></td>
<td class="tableblock halign-left valign-top"><p>Optionally you can specify which organization is used for an API request.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.moderation.project-id</p></td>
<td class="tableblock halign-left valign-top"><p>Optionally, you can specify which project is used for an API request.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.moderation.model</p></td>
<td class="tableblock halign-left valign-top"><p>ID of the model to use for moderation.</p></td>
<td class="tableblock halign-left valign-top"><p>omni-moderation-latest</p></td>
</tr>
</tbody>
</table>

## Runtime Options

The OpenAiModerationOptions class provides the options to use when making a moderation request. On start-up, the options specified by spring.ai.openai.moderation are used, but you can override these at runtime.

For example:

    OpenAiModerationOptions moderationOptions = OpenAiModerationOptions.builder()
        .model("omni-moderation-latest")
        .build();

    ModerationPrompt moderationPrompt = new ModerationPrompt("Text to be moderated", this.moderationOptions);
    ModerationResponse response = openAiModerationModel.call(this.moderationPrompt);

    // Access the moderation results
    Moderation moderation = moderationResponse.getResult().getOutput();

    // Print general information
    System.out.println("Moderation ID: " + moderation.getId());
    System.out.println("Model used: " + moderation.getModel());

    // Access the moderation results (there's usually only one, but it's a list)
    for (ModerationResult result : moderation.getResults()) {
        System.out.println("\nModeration Result:");
        System.out.println("Flagged: " + result.isFlagged());

        // Access categories
        Categories categories = this.result.getCategories();
        System.out.println("\nCategories:");
        System.out.println("Sexual: " + categories.isSexual());
        System.out.println("Hate: " + categories.isHate());
        System.out.println("Harassment: " + categories.isHarassment());
        System.out.println("Self-Harm: " + categories.isSelfHarm());
        System.out.println("Sexual/Minors: " + categories.isSexualMinors());
        System.out.println("Hate/Threatening: " + categories.isHateThreatening());
        System.out.println("Violence/Graphic: " + categories.isViolenceGraphic());
        System.out.println("Self-Harm/Intent: " + categories.isSelfHarmIntent());
        System.out.println("Self-Harm/Instructions: " + categories.isSelfHarmInstructions());
        System.out.println("Harassment/Threatening: " + categories.isHarassmentThreatening());
        System.out.println("Violence: " + categories.isViolence());

        // Access category scores
        CategoryScores scores = this.result.getCategoryScores();
        System.out.println("\nCategory Scores:");
        System.out.println("Sexual: " + scores.getSexual());
        System.out.println("Hate: " + scores.getHate());
        System.out.println("Harassment: " + scores.getHarassment());
        System.out.println("Self-Harm: " + scores.getSelfHarm());
        System.out.println("Sexual/Minors: " + scores.getSexualMinors());
        System.out.println("Hate/Threatening: " + scores.getHateThreatening());
        System.out.println("Violence/Graphic: " + scores.getViolenceGraphic());
        System.out.println("Self-Harm/Intent: " + scores.getSelfHarmIntent());
        System.out.println("Self-Harm/Instructions: " + scores.getSelfHarmInstructions());
        System.out.println("Harassment/Threatening: " + scores.getHarassmentThreatening());
        System.out.println("Violence: " + scores.getViolence());
    }

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

Next, create an OpenAiModerationModel:

    OpenAiModerationApi openAiModerationApi = new OpenAiModerationApi(System.getenv("OPENAI_API_KEY"));

    OpenAiModerationModel openAiModerationModel = new OpenAiModerationModel(this.openAiModerationApi);

    OpenAiModerationOptions moderationOptions = OpenAiModerationOptions.builder()
        .model("omni-moderation-latest")
        .build();

    ModerationPrompt moderationPrompt = new ModerationPrompt("Text to be moderated", this.moderationOptions);
    ModerationResponse response = this.openAiModerationModel.call(this.moderationPrompt);

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

The `OpenAiModerationModelIT` test provides some general examples of how to use the library. You can refer to this test for more detailed usage examples.

Moderation Models Mistral AI

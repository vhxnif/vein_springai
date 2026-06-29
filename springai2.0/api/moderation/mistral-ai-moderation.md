Search

# Moderation

## Introduction

Spring AI supports the new moderation service introduced by Mistral AI and powered by the Mistral Moderation model. It enables the detection of harmful text content along several policy dimensions. Follow this link for more information on the Mistral AI moderation model.

## Prerequisites

1.  Create an Mistral AI account and obtain an API key. You can sign up at Mistral AI registration page and generate an API key on the API Keys page.

2.  Add the `spring-ai-mistral-ai` dependency to your project’s build file. For more information, refer to the Dependency Management section.

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the Mistral AI Moderation Model. To enable it add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-mistral-ai</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file:

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-model-mistral-ai'
    }

## Moderation Properties

### Connection Properties

The prefix spring.ai.mistralai is used as the property prefix that lets you connect to Mistral AI.

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 42%" />
<col style="width: 42%" />
<col style="width: 14%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Property</p></td>
<td class="tableblock halign-left valign-top"><p>Description</p></td>
<td class="tableblock halign-left valign-top"><p>Default</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.base-url</p></td>
<td class="tableblock halign-left valign-top"><p>The URL to connect to</p></td>
<td class="tableblock halign-left valign-top"><p>api.mistral.ai</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>The API Key</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

### Configuration Properties

The prefix spring.ai.mistralai.moderation is used as the property prefix for configuring the Mistral AI moderation model.

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
<td class="tableblock halign-left valign-top"><p>spring.ai.model.moderation</p></td>
<td class="tableblock halign-left valign-top"><p>Enable Moderation model</p></td>
<td class="tableblock halign-left valign-top"><p>mistral</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.moderation.base-url</p></td>
<td class="tableblock halign-left valign-top"><p>The URL to connect to</p></td>
<td class="tableblock halign-left valign-top"><p>api.mistral.ai</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.moderation.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>The API Key</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.mistralai.moderation.model</p></td>
<td class="tableblock halign-left valign-top"><p>ID of the model to use for moderation.</p></td>
<td class="tableblock halign-left valign-top"><p>mistral-moderation-latest</p></td>
</tr>
</tbody>
</table>

## Runtime Options

The MistralAiModerationOptions class provides the options to use when making a moderation request. On start-up, the options specified by spring.ai.mistralai.moderation are used, but you can override these at runtime.

For example:

    MistralAiModerationOptions moderationOptions = MistralAiModerationOptions.builder()
        .model("mistral-moderation-latest")
        .build();

    ModerationPrompt moderationPrompt = new ModerationPrompt("Text to be moderated", this.moderationOptions);
    ModerationResponse response = mistralAiModerationModel.call(this.moderationPrompt);

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
        System.out.println("Law: " + categories.isLaw());
        System.out.println("Financial: " + categories.isFinancial());
        System.out.println("PII: " + categories.isPii());
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
        System.out.println("Law: " + scores.getLaw());
        System.out.println("Financial: " + scores.getFinancial());
        System.out.println("PII: " + scores.getPii());
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

Add the `spring-ai-mistral-ai` dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-mistral-ai</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file:

    dependencies {
        implementation 'org.springframework.ai:spring-ai-mistral-ai'
    }

Next, create an MistralAiModerationModel:

    MistralAiModerationApi mistralAiModerationApi = new MistralAiModerationApi(System.getenv("MISTRAL_AI_API_KEY"));

    MistralAiModerationModel mistralAiModerationModel = new MistralAiModerationModel(this.mistralAiModerationApi);

    MistralAiModerationOptions moderationOptions = MistralAiModerationOptions.builder()
        .model("mistral-moderation-latest")
        .build();

    ModerationPrompt moderationPrompt = new ModerationPrompt("Text to be moderated", this.moderationOptions);
    ModerationResponse response = this.mistralAiModerationModel.call(this.moderationPrompt);

## Example Code

The `MistralAiModerationModelIT` test provides some general examples of how to use the library. You can refer to this test for more detailed usage examples.

OpenAI Chat Memory

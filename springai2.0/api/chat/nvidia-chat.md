Search

# NVIDIA Chat

NVIDIA LLM API is a proxy AI Inference Engine offering a wide range of models from various providers.

Spring AI integrates with the NVIDIA LLM API by reusing the existing OpenAI client. For this you need to set the base-url to `https://integrate.api.nvidia.com`, select one of the provided LLM models and get an `api-key` for it.

Check the NvidiaWithOpenAiChatModelIT.java tests for examples of using NVIDIA LLM API with Spring AI.

## Prerequisite

- Create NVIDIA account with sufficient credits.

- Select a LLM Model to use. For example the `meta/llama-3.1-70b-instruct` in the screenshot below.

- From the selected model’s page, you can get the `api-key` for accessing this model.

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the OpenAI Chat Client. To enable it add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-openai</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-model-openai'
    }

### Chat Properties

#### Retry Properties

The prefix `spring.ai.retry` is used as the property prefix that lets you configure the retry mechanism for the OpenAI chat model.

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

#### Connection Properties

The prefix `spring.ai.openai` is used as the property prefix that lets you connect to OpenAI.

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
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.base-url</p></td>
<td class="tableblock halign-left valign-top"><p>The URL to connect to. Must be set to <code>https://integrate.api.nvidia.com</code></p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>The NVIDIA API Key</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

#### Configuration Properties

The prefix `spring.ai.openai.chat` is the property prefix that lets you configure the chat model implementation for OpenAI.

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
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.enabled (Removed and no longer valid)</p></td>
<td class="tableblock halign-left valign-top"><p>Enable OpenAI chat model.</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.model.chat</p></td>
<td class="tableblock halign-left valign-top"><p>Enable OpenAI chat model.</p></td>
<td class="tableblock halign-left valign-top"><p>openai</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.base-url</p></td>
<td class="tableblock halign-left valign-top"><p>Optional overrides the spring.ai.openai.base-url to provide chat specific url. Must be set to <code>https://integrate.api.nvidia.com</code></p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.api-key</p></td>
<td class="tableblock halign-left valign-top"><p>Optional overrides the spring.ai.openai.api-key to provide chat specific api-key</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.model</p></td>
<td class="tableblock halign-left valign-top"><p>The NVIDIA LLM model to use</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.temperature</p></td>
<td class="tableblock halign-left valign-top"><p>The sampling temperature to use that controls the apparent creativity of generated completions. Higher values will make output more random while lower values will make results more focused and deterministic. It is not recommended to modify temperature and top_p for the same completions request as the interaction of these two settings is difficult to predict.</p></td>
<td class="tableblock halign-left valign-top"><p>0.8</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.frequency-penalty</p></td>
<td class="tableblock halign-left valign-top"><p>Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model’s likelihood to repeat the same line verbatim.</p></td>
<td class="tableblock halign-left valign-top"><p>0.0f</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.max-tokens</p></td>
<td class="tableblock halign-left valign-top"><p>The maximum number of tokens to generate in the chat completion. The total length of input tokens and generated tokens is limited by the model’s context length.</p></td>
<td class="tableblock halign-left valign-top"><p>NOTE: NVIDIA LLM API requires the <code>max-tokens</code> parameter to be explicitly set or server error will be thrown.</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.n</p></td>
<td class="tableblock halign-left valign-top"><p>How many chat completion choices to generate for each input message. Note that you will be charged based on the number of generated tokens across all of the choices. Keep n as 1 to minimize costs.</p></td>
<td class="tableblock halign-left valign-top"><p>1</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.presence-penalty</p></td>
<td class="tableblock halign-left valign-top"><p>Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model’s likelihood to talk about new topics.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.response-format</p></td>
<td class="tableblock halign-left valign-top"><p>An object specifying the format that the model must output. Setting to <code>{ "type": "json_object" }</code> enables JSON mode, which guarantees the message the model generates is valid JSON.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.seed</p></td>
<td class="tableblock halign-left valign-top"><p>This feature is in Beta. If specified, our system will make a best effort to sample deterministically, such that repeated requests with the same seed and parameters should return the same result.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.stop</p></td>
<td class="tableblock halign-left valign-top"><p>Up to 4 sequences where the API will stop generating further tokens.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.top-p</p></td>
<td class="tableblock halign-left valign-top"><p>An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or temperature but not both.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.tools</p></td>
<td class="tableblock halign-left valign-top"><p>A list of tools the model may call. Currently, only functions are supported as a tool. Use this to provide a list of functions the model may generate JSON inputs for.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.tool-choice</p></td>
<td class="tableblock halign-left valign-top"><p>Controls which (if any) function is called by the model. none means the model will not call a function and instead generates a message. auto means the model can pick between generating a message or calling a function. Specifying a particular function via {"type: "function", "function": {"name": "my_function"}} forces the model to call that function. none is the default when no functions are present. auto is the default if functions are present.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.user</p></td>
<td class="tableblock halign-left valign-top"><p>A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.stream-usage</p></td>
<td class="tableblock halign-left valign-top"><p>(For streaming only) Set to add an additional chunk with token usage statistics for the entire request. The <code>choices</code> field for this chunk is an empty array and all other chunks will also include a usage field, but with a null value.</p></td>
<td class="tableblock halign-left valign-top"><p>false</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.openai.chat.tool-callbacks</p></td>
<td class="tableblock halign-left valign-top"><p>Tool Callbacks to register with the ChatModel.</p></td>
<td class="tableblock halign-left valign-top"><p>-</p></td>
</tr>
</tbody>
</table>

## Runtime Options

The OpenAiChatOptions.java provides model configurations, such as the model to use, the temperature, the frequency penalty, etc.

On start-up, the default options can be configured with the `OpenAiChatModel(api, options)` constructor or the `spring.ai.openai.chat.*` properties.

At run-time you can override the default options by adding new, request specific, options to the `Prompt` call. For example to override the default model and temperature for a specific request:

    ChatResponse response = chatModel.call(
        new Prompt(
            "Generate the names of 5 famous pirates.",
            OpenAiChatOptions.builder()
                .model("mixtral-8x7b-32768")
                .temperature(0.4)
            .build()
        ));

## Function Calling

NVIDIA LLM API supports Tool/Function calling when selecting a model that supports it.

You can register custom Java functions with your ChatModel and have the provided model intelligently choose to output a JSON object containing arguments to call one or many of the registered functions. This is a powerful technique to connect the LLM capabilities with external tools and APIs.

### Tool Example

Here’s a simple example of how to use NVIDIA LLM API tool calling with Spring AI:

    spring.ai.openai.api-key=${NVIDIA_API_KEY}
    spring.ai.openai.base-url=https://integrate.api.nvidia.com
    spring.ai.openai.chat.model=meta/llama-3.1-70b-instruct
    spring.ai.openai.chat.max-tokens=2048

    public class WeatherService implements Function<WeatherService.Request, WeatherService.Response> {

        public record Request(String location, String unit) {}
        public record Response(double temp, String unit) {}

        @Override
        public Response apply(Request request) {
            double temperature = request.location().contains("Amsterdam") ? 20 : 25;
            return new Response(temperature, request.unit);
        }
    }

    ToolCallback weatherCallback = FunctionToolCallback.builder("getCurrentWeather", new WeatherService())
        .description("Get the weather in location")
        .inputType(WeatherService.Request.class)
        .build();

    var response = chatClient.prompt()
        .user("What is the weather in Amsterdam and Paris?")
        .tools(weatherCallback)
        .call()
        .content();

In this example, when the model needs weather information, it will automatically call the `WeatherService`, which can then fetch real-time weather data. The expected response looks like this: "The weather in Amsterdam is currently 20 degrees Celsius, and the weather in Paris is currently 25 degrees Celsius."

Read more about Tool Calling.

## Sample Controller

Create a new Spring Boot project and add the `spring-ai-starter-model-openai` to your pom (or gradle) dependencies.

Add a `application.properties` file, under the `src/main/resources` directory, to enable and configure the OpenAi chat model:

    spring.ai.openai.api-key=${NVIDIA_API_KEY}
    spring.ai.openai.base-url=https://integrate.api.nvidia.com
    spring.ai.openai.chat.model=meta/llama-3.1-70b-instruct

    # The NVIDIA LLM API doesn't support embeddings, so we need to disable it.
    spring.ai.model.embedding=none

    # The NVIDIA LLM API requires this parameter to be set explicitly or server internal error will be thrown.
    spring.ai.openai.chat.max-tokens=2048

Here is an example of a simple `@Controller` class that uses the chat model for text generations.

    @RestController
    public class ChatController {

        private final OpenAiChatModel chatModel;

        @Autowired
        public ChatController(OpenAiChatModel chatModel) {
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

MiniMax Ollama

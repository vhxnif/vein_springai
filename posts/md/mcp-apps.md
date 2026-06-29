The way humans typically interact with AI is via a chat-style interface such as ChatGPT or Claude Desktop. In fact, the ability to converse with an AI in natural language is perhaps one of the most amazing things about this technology. It lets humans talk to computers in human terms, rather than requiring that the human work within the confines of an interface made up of buttons, lists, and text fields.

Even though those traditional UIs aren’t as flexible and as fluid as a chat interface, they are sometimes the best and most natural way to communicate with an application. Clicking a location on a map, for example, is much more precise and natural than trying to describe where a specific location is in natural language. (That is, unless you just happen to know the latitude and longitude.)

What if you could have the best of both worlds? What if you could chat with an AI, but then interact with a more traditional UI when it makes sense to do so? That’s precisely what [MCP Apps](https://modelcontextprotocol.io/extensions/apps/overview) brings to the conversation: The ability to embed rich UI elements in a chat interface. The result is a hybrid experience where chat and application blend together, allowing users to not just ask questions, but actively interact with tools and workflows without ever leaving the chat.

Thanks to some contributions from the Spring AI community (shout out to Vadzim Shurmialiou and Alexandros Pappas for their pull-requests), it’s now easy to create rich UIs as part of an MCP server with Spring AI 2.0.0-M3. In this article, that’s exactly what we’ll do.

## MCP Apps in a Nutshell

At its core, an MCP App has two primary elements:

- A tool served by the MCP server that has metadata that references the HTML resource.
- A resource served by the MCP server that is HTML (with JavaScript and CSS) that makes up the UI.

The UI itself is a special kind of MCP client that can communicate with the MCP server, as well as its host assistant, using JSON-RPC. To make server-interaction easier, there’s an ext-apps.ts module that the UI can use to invoke tools, handle context changes, push messages to the host, and many other things.

To demonstrate how to build MCP Apps with Spring AI, let’s create a simple, but fun dice-rolling example.

## Initializing the Project

The first step in creating an MCP server that includes an MCP App is to create an MCP server. With Spring AI, that starts with using the Spring Boot Initializr (whether with your IDE or through <https://start.spring.io>) to initialize a new Spring Boot project that includes the [Spring MVC and Model Context Protocol Server dependencies](https://start.spring.io/#!type=gradle-project&language=groovy&platformVersion=4.0.3&packaging=jar&configurationFileFormat=properties&jvmVersion=25&groupId=com.example&artifactId=demo&name=demo&description=Demo%20project%20for%20Spring%20Boot&packageName=com.example.demo&dependencies=web,spring-ai-mcp-server).

------------------------------------------------------------------------

**⚠️ IMPORTANT**

Once the project has been initialized, you’ll want to make sure that the Spring AI version is 2.0.0-M3 or higher. It’s with this version that MCP annotations were merged into Spring AI itself and that the ability to specify metadata on tools and resources—important for working with MCP Apps—was added.

For a Gradle-built project, you should see this block in build.gradle:

    ext {
      set('springAiVersion', "2.0.0-M3")
    }

If you’re using Maven, then look for a `<properties>` block that looks like this:

    <properties>
      <!-- other properties such as the Java version go here -->
      <spring-ai.version>2.0.0-M3</spring-ai.version>
    </properties>

------------------------------------------------------------------------

With the freshly initialized project, you’re ready to define the app’s user interface.

## Define the User Interface

The user interface of an MCP App is a typical HTML file, plus any accompanying JavaScript and/or CSS. To demonstrate MCP Apps, let’s create a UI for rolling a pair of dice. The following HTML defines such a UI (src/main/resources/app/dice-app.html):

    <!DOCTYPE html>
    <html>
    <head>
        <title>Dice Roller</title>
        <style>
            body { font-family: sans-serif; text-align: center; margin-top: 50px; }
            .dice { font-size: 80px; }
            button { font-size: 18px; padding: 8px 16px; }

            @media (prefers-color-scheme: dark) {
                body {
                    background-color: #1d1e22; /* A dark color */
                    color: white; /* A light color for text */
                }}
        </style>
    </head>
    <body>

    <div class="dice">
        <span id="die1">⚀</span>
        <span id="die2">⚀</span>
    </div>

    <br>
    <button id="roll-dice-btn">Roll Dice</button>

    <script type="module">
        import { App } from "https://unpkg.com/@modelcontextprotocol/ext-apps@0.4.2/app-with-deps";
        const app = new App({ name: "roll-the-dice", version: "1.0.0" });

        app.connect().then(() => {
            rollDice().then(() => {});
        });

        const updateContext = async (diceRoll) => {
            let message = `The dice roll results are ${diceRoll.die1} and ${diceRoll.die2}.`;
            app.updateModelContext({
                content: [{ type: "text", text: message }],
            }).then(() => {});
        };

        // Dice UI functions
        const diceFaces = ["⚀","⚁","⚂","⚃","⚄","⚅"];

        const rollDiceBtn = document.getElementById("roll-dice-btn");
        rollDiceBtn.addEventListener("click", async () => {
            await rollDice();
        });

        const randomIndex = () => {
            return Math.floor(Math.random() * 6);
        };

        const rollDice = async () => {
            const die1 = document.getElementById("die1");
            const die2 = document.getElementById("die2");

            let rolls = 0;
            let final1, final2;

            const animation = setInterval(() => {
                final1 = randomIndex();
                final2 = randomIndex();

                die1.textContent = diceFaces[final1];
                die2.textContent = diceFaces[final2];

                rolls++;
                if (rolls > 15) {
                    // Convert to 1–6 instead of 0–5
                    let diceRoll = {
                        die1: final1 + 1,
                        die2: final2 + 1
                    };

                    updateContext(diceRoll).then(() => {});

                    clearInterval(animation);
                }
            }, 30);
        }
    </script>

    </body>
    </html>

That’s quite a lot of HTML! Most of it defines the visual elements of the UI as well as some JavaScript-driven animation for effect. But there are a few pieces of the HTML of particular interest to the subject of creating MCP Apps, all of which is contained within the first several lines of the `<script>` block.

The first order of business is to import the `ext-apps.ts` module and to create an `App` instance from it. The `ext-apps.ts` module is imported via an external URL at <https://unpkg.com> (more on this a little later). The `App` instance will be used to interact with the AI assistant that is hosting the MCP App. The assistant host could be something like Claude Desktop, MCP Jam, or Goose.

The next thing to do is to connect with the assistant host. Assuming that it is able to successfully connect, it calls the `rollDice()` function (lower in the `<script>` block) to perform the initial roll of the dice.

Finally, the `updateContext()` function is defined that uses the `App` object’s `updateModelContext()` function to send a message to the assistant to update its context with the outcome of the roll of the dice. This injects a message regarding the results of the dice roll into the chat history ensuring that future interactions in the chat are aware of the current state of the dice (as if the result of the dice roll were part of the chat itself).

The following sequence diagram helps visualize how all of this comes together:

![MCP App sequence diagram](https://static.spring.io/blog/habuma/20260317/mcpapp-sequence.png)

It's worth noting that there are other ways that the HTML/JavaScript view can interact with the MCP server. In addition to `updateModelContext()`, two other useful functions are `sendMessage()` and `callServerTool()`. The `sendMessage()` function lets you inject a message into the chat as if the user had typed it themselves. And `callServerTool()` makes it possible to invoke a tool on the MCP server from the UI.

The rest of the code in the `<script>` block implements the random selection of the dice roll and the animation of the dice in the UI. But near the end of the `rollDice()` function, the `updateContext()` function is called to send the result to the assistant's context.

Now that the MCP App’s UI is defined, let’s implement the MCP server.

## Create the MCP Server

Developing an MCP server with Spring AI involves creating a bean that has one or more methods annotated with `@McpTool` and `@McpResource` annotations. For an MCP App, you’ll need two methods: An `@McpResource`-annotated method to serve the HTML UI and an `@McpTool`-annotated method to associate with the MCP App.

To begin, let’s define the `@McpResource`-annotated method:

    @Service
    public class DiceApp {

        @Value("classpath:/app/dice-app.html")
        private Resource diceAppResource;

        @McpResource(name = "Dice App Resource",
            uri = "ui://dice/dice-app.html",
            mimeType = "text/html;profile=mcp-app",
            metaProvider = CspMetaProvider.class)
        public String getDiceAppResource() throws IOException {
          return diceAppResource.getContentAsString(Charset.defaultCharset());
        }

        public static final class CspMetaProvider implements MetaProvider {
          @Override
          public Map<String, Object> getMeta() {
            return Map.of("ui",
                Map.of("csp",
                    Map.of("resourceDomains",
                        List.of("https://unpkg.com"))));
          }
        }

    }

The `DiceApp` class is annotated with `@Service` so that it will be discovered during classpath scanning and created as a bean in the Spring application context. It has a `diceAppResource` instance variable that is injected (via the `@Value` annotation) with the path to the HTML file where it resides in the classpath. The contents of that `Resource` object is served as an MCP resource through the MCP server at the "ui://dice/dice-app.html" URI.

As you’ll recall, the HTML UI imports the `ext-apps.ts` module from <https://unpkg.com>. Normally, MCP Apps are not allowed to access resources outside of their sandbox. Therefore, it is necessary to set the content security policy (CSP) of this resource so that it can load `ext-apps.ts`. The `metaProvider` attribute of `@McpResource` references the `CspMetaProvider` inner class. `CspMetaProvider` implements `MetaProvider` to set the `ui.csp.resourceDomains` metadata entry to allow the resource to access content at <https://unpkg.com>.

Now that the MCP server has a resource, all that’s left is to add the tool method. The following `rollTheDice()` method should do the trick:

    @McpTool(
      title = "Roll the Dice",
      name = "roll-the-dice",
      description = "Rolls the dice",
      metaProvider = DiceMetaProvider.class)
    public String rollTheDice() {
      return "Opening dice roller app.";
    }

    public static final class DiceMetaProvider implements MetaProvider {
      @Override
      public Map<String, Object> getMeta() {
        return Map.of("ui",
            Map.of(
                "resourceUri", "ui://dice/dice-app.html"));
      }
    }

The `rollTheDice()` method doesn’t do much. It simply returns a `String` to tell the assistant host that the dice roller app has been opened. But so that it can serve the HTML as an MCP App, it has a `metaProvider` attribute that references `DiceMetaProvider`. Similar to how `CspMetaProvider` works, this implementation of `MetaProvider` sets the `ui.resourceUri` metadata entry to reference the previously defined resource at the "ui://dice/dice-app.html" URI.

Finally, let’s set a few configuration properties to customize how the MCP server behaves. In application.properties, add the following two entries:

    spring.ai.mcp.server.protocol=streamable
    server.port=3001

These properties specify the MCP server transport and server port. By default, Spring AI’s MCP server support defaults to using the SSE transport. But the SSE transport is deprecated and the Streamable HTTP transport is the preferred transport. As for the server port, you could leave it to default to port 8080 and it would still work. But port 3001 is commonly used for MCP servers.

And that’s all there is to creating an MCP App! Let’s fire it up and see it in action.

## Running the MCP App

You can start the MCP server like any Spring Boot application, either through the facilities of your IDE or using the build tool:

    ./gradlew bootRun

Once the MCP server has started up, you can configure your favorite MCP client to use it. When you add the MCP server configuration, be sure to select the Streamable HTTP transport and set the URL to "<http://localhost:3001/mcp>".

Two client options that work well are MCP Jam and Claude Desktop. At this time, however, Goose doesn’t support the ability to update the model context via the `App` object’s `updateModelContext()` function, so the MCP App will not fully work with Goose.

Claude Desktop does not support the Streamable HTTP transport. So if you choose to use Claude Desktop, you’ll need to configure the "mcp-remote" MCP server to proxy communication to the dice rolling MCP server:

    "mcpServers": {
      "dice-tools": {
        "command": "npx",
        "args": [
          "-y",
          "mcp-remote",
          "http://localhost:3001/mcp"
        ]
      }
    }

Once you have your MCP client configured to reference the MCP server, ask it to roll dice in the chat by typing "Roll the dice". After granting it permission to use the "roll-the-dice" tool, you should see the MCP App’s UI displayed in the chat with the initial result of rolling the dice. Just to confirm that the model context was updated with the dice values, ask "What was the result of rolling the dice?". It should give an answer reflective of the dice displayed in the UI.

The following screenshot of Claude Desktop shows how this might look.

![Running the MCP App in Claude Desktop](https://static.spring.io/blog/habuma/20260317/dice-roll-mcp-app.png)

Then to shake things up (literally), click the "Roll Dice" button. Then ask about the dice roll results again to see that the model context was updated with the newest values.

## Conclusion

Developing an MCP App with Spring AI means developing an MCP server that includes an `@McpResource`-annotated method to serve an HTML user-interface and an `@McpTool`-annotated method that triggers the application when invoked in a client.

Spring AI supports MCP Apps by letting you specify the metadata necessary on tools and resources to expose the app’s UI.

In this article, we created a relatively simple dice-rolling application, but an MCP App can do anything that you can do in HTML (along with JavaScript and CSS as necessary). The sky is the limit, breaking LLM interaction out of the textual chat-response mold and enabling rich and responsive UIs directly in the chat.

How will you create more interactive AI interactions with MCP Apps?

## Resources

- **MCP Apps GitHub Repository**: [Dice Roller MCP App](https://github.com/spring-projects/spring-ai-examples/tree/main/model-context-protocol/mcp-apps-server)
- **MCP Apps**: [MCP Apps Documentation](https://modelcontextprotocol.io/extensions/apps/overview)

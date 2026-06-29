As AI agents connect to more services—Slack, GitHub, Jira, MCP servers—tool libraries grow rapidly. A typical multi-server setup can easily have 50+ tools consuming **55,000+ tokens** before any conversation starts. Worse, tool selection accuracy degrades when models face 30+ similarly-named tools.

![](https://raw.githubusercontent.com/spring-io/spring-io-static/refs/heads/main/blog/tzolov/20251208/spring-ai-tool-search-tool-overview.png)

The **[Tool Search Tool](https://www.anthropic.com/engineering/advanced-tool-use)** pattern, pioneered by Anthropic, addresses this: instead of loading all tool definitions upfront, the model discovers tools on-demand. It receives only a search tool initially, queries for capabilities when needed, and gets relevant tool definitions expanded into context. This achieves **significant token savings** while maintaining access to hundreds of tools.

**The key insight:** While Anthropic introduced this pattern for Claude, we can implement the same approach for **any LLM** using Spring AI's **[Recursive Advisors](https://docs.spring.io/spring-ai/reference/api/advisors-recursive.html)**. Spring AI provides a portable abstraction that makes dynamic tool discovery work across OpenAI, Anthropic, Gemini, Ollama, Azure OpenAI, and any other LLM provider supported by Spring AI.

**Our preliminary benchmarks show Spring AI's Tool Search Tool implementation achieves 34-64% token reduction** across OpenAI, Anthropic, and Gemini models while maintaining full access to hundreds of tools.

> **Update (Spring AI 2.0.0 GA):** The Tool Search Tool has been promoted from the [Spring AI Community](https://github.com/spring-ai-community/spring-ai-tool-search-tool) into the core [Spring AI](https://github.com/spring-projects/spring-ai) project. The API has been updated to align with Spring AI 2.0.0 conventions — see the [Getting Started](#getting-started) section for the new Maven coordinates and usage.

## How Tool Calling Works

First, let's understand how Spring AI's [tool calling](https://docs.spring.io/spring-ai/reference/api/tools.html) works when using the [ToolCallingAdvisor](https://docs.spring.io/spring-ai/reference/api/advisors-recursive.html#_toolcalladvisor) - a special recursive advisor that:

![](https://raw.githubusercontent.com/spring-io/spring-io-static/refs/heads/main/blog/tzolov/20251208/spring-ai-tool-calling-flow.png)

1.  **Intercepts the ChatClient request** before it reaches the LLM
2.  **Includes tool definitions** in the prompt sent to the model - for all registered tools!
3.  **Detects tool call requests** in the model's response
4.  **Executes the requested tools** using the `ToolCallingManager`
5.  **Loops back** with tool results until the model provides a final answer

The tool execution happens in a **recursive loop** - the advisor keeps calling the LLM until no more tool calls are requested.

## The Problem

The standard tool calling flow (such as `ToolCallingAdvisor`) sends **all tool definitions** to the LLM upfront. This creates three major issues with large tool collections:

- **Context bloat** - Massive token consumption before any conversation begins
- **Tool confusion** - Models struggle to choose correctly when facing 30+ similar tools
- **Higher costs** - Paying for unused tool definitions in every request

## The Tool Search Tool Solution

By extending Spring AI's `ToolCallingAdvisor`, we've created a `ToolSearchToolCallingAdvisor` that implements dynamic tool discovery. It intercepts the tool calling loop to selectively inject tools based on what the model discovers it needs:

![](https://raw.githubusercontent.com/spring-io/spring-io-static/refs/heads/main/blog/tzolov/20251208/spring-ai-tool-search-tool-calling-flow.png)

The flow works as follows:

1.  **Indexing**: At conversation start, all registered tools are indexed in the `ToolIndex` (but NOT sent to the LLM)
2.  **Initial Request**: Only the **Tool Search Tool (TST)** definition is sent to the LLM - saving context
3.  **Discovery Call**: When the LLM needs capabilities, it calls the TST with a search query
4.  **Search & Expand**: The `ToolIndex` finds matching tools (e.g., "Tool XYZ") and their definitions are added to the next request
5.  **Tool Invocation**: The LLM now sees both TST and the discovered tool definitions, and can call the actual tool
6.  **Tool Execution**: The discovered tool is executed and results returned to the LLM
7.  **Response**: The LLM generates the final answer using the tool results

In code, this looks like this:

    var toolSearchAdvisor = ToolSearchToolCallingAdvisor.builder()
        .toolIndex(new LuceneToolIndex())
        .maxResults(5)
        .build();

    ChatClient chatClient = chatClientBuilder
        .defaultTools(new MyTools())  // 100s of tools registered but NOT sent to LLM initially
        .defaultAdvisors(toolSearchAdvisor) // Activate Tool Search Tool
        .build();

### Pluggable Search Strategies

The `ToolIndex` interface abstracts the search implementation, supporting multiple strategies:

<table>
<thead>
<tr>
<th>Strategy</th>
<th>Implementation</th>
<th>Best For</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>Semantic</strong></td>
<td><code>VectorToolIndex</code></td>
<td>Natural language queries, fuzzy matching</td>
</tr>
<tr>
<td><strong>Keyword</strong></td>
<td><code>LuceneToolIndex</code></td>
<td>Exact term matching, known tool names</td>
</tr>
<tr>
<td><strong>Regex</strong></td>
<td><code>RegexToolIndex</code></td>
<td>Tool name patterns (<code>get_*_data</code>)</td>
</tr>
</tbody>
</table>

## Getting Started

The Tool Search Tool is now part of the core [Spring AI](https://github.com/spring-projects/spring-ai) project. The easiest way to get started is the Spring Boot starter, which auto-configures everything from a single property.

*The community [v1.0.x](https://github.com/spring-ai-community/spring-ai-tool-search-tool/tree/1.0.x) release remains available for Spring AI 1.1.x / Spring Boot 3 compatibility.*

### Spring Boot Auto-configuration (Recommended)

Add the Spring Boot starter, which bundles the advisor, the `ToolIndex` API, and Apache Lucene:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-tool-search-advisor</artifactId>
    </dependency>

Then enable dynamic tool discovery with a single property:

    spring.ai.chat.client.tool-search-advisor.enabled=true

That's it. The auto-configuration replaces the default `ToolCallingAdvisor` with `ToolSearchToolCallingAdvisor` and registers a `RegexToolIndex` by default. No code changes are needed — your existing `ChatClient` usages will automatically benefit from dynamic tool discovery.

The `tool-index-type` property selects the search strategy: `regex` (default, no extra dependencies), `lucene` (bundled in the starter), or `vector` (requires a `VectorStore` bean). A custom `ToolIndex` bean always takes precedence over the auto-configured one.

For the full list of configuration properties see the [Spring Boot Auto Configuration](https://docs.spring.io/spring-ai/reference/api/tools.html#_spring_boot_auto_configuration) reference documentation.

### Manual Configuration

If you prefer explicit wiring, add the two individual modules and construct the advisor programmatically:

    <!-- Tool Search advisor -->
    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-tool-search-advisor</artifactId>
    </dependency>

    <!-- Tool Index API + implementations (Lucene, Vector, Regex) -->
    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-tool-search-tool</artifactId>
    </dependency>

**Example Usage**

    @SpringBootApplication
    public class Application {

        @Bean
        CommandLineRunner demo(ChatClient.Builder builder) {
            return args -> {
                var advisor = ToolSearchToolCallingAdvisor.builder()
                    .toolIndex(new LuceneToolIndex())
                    .build();

                ChatClient chatClient = builder
                    .defaultTools(new MyTools())
                    .defaultAdvisors(advisor)
                    .build();

                var answer = chatClient.prompt("""
                    Help me plan what to wear today in Amsterdam.
                    Please suggest clothing shops that are open right now.
                    """)
                    .advisors(a -> a.param(ChatMemory.CONVERSATION_ID, "my-session-id"))
                    .call().content();
                
                System.out.println(answer);
            };
        }

        static class MyTools {

            @Tool(description = "Get the weather for a given location at a given time")
            public String weather(String location, 
                @ToolParam(description = "YYYY-MM-DDTHH:mm") String atTime) {...}

            @Tool(description = "Get clothing shop names for a given location at a given time")
            public List<String> clothing(String location,
                    @ToolParam(description = "YYYY-MM-DDTHH:mm") String openAtTime) {...}

            @Tool(description = "Current date and time for a given location")
            public String currentTime(String location) {...}
            
            // ... potentially hundreds more tools
        }
    }

> **Note:** The `ToolSearchToolCallingAdvisor` requires a conversation ID in the advisor params context via `ChatMemory.CONVERSATION_ID`. This scopes the tool index per session, enabling multi-tenant and multi-turn conversation support. When using the auto-configuration, the session ID key is configurable via `spring.ai.chat.client.tool-search-advisor.session-id-key-name`.

For the example above, the flow would be:

1.  **User Request**: *"Help me plan what to wear today in Amsterdam. Please suggest clothing shops that are open right now."*
2.  **Initialization**: Index all tools: `weather`, `clothing`, `currentTime` (+ potentially 100s more)
3.  **First LLM Call** - LLM sees only `toolSearchTool`
    - LLM calls `toolSearchTool(query="current time date")` → `["currentTime"]`
4.  **Second LLM Call** - LLM sees `toolSearchTool` + `currentTime`
    - LLM calls `currentTime("Amsterdam")` → `"2025-12-08T11:30"`
    - LLM calls `toolSearchTool(query="weather location")` → `["weather"]`
5.  **Third LLM Call** - LLM sees `toolSearchTool` + `currentTime` + `weather`
    - LLM calls `weather("Amsterdam")` → `"Sunny, 15°C"`
    - LLM calls `toolSearchTool(query="clothing shops")` → `["clothing"]`
6.  **Fourth LLM Call** - LLM sees `toolSearchTool` + `currentTime` + `weather` + `clothing`
    - LLM calls `clothing("Amsterdam", "2025-12-08T11:30")` → `["H&M", "Zara", "Uniqlo"]`
7.  **Final Response**: *"Based on the sunny 15°C weather in Amsterdam, I recommend light layers. Here are clothing shops open now: H&M, Zara, ..."*

## Performance Measurements

> ⚠️ **Disclaimer:** These are preliminary, manual measurements taken after a few runs. They are not averaged across multiple iterations and should be considered illustrative rather than representative.

To quantify the token savings, we ran preliminary benchmarks using the [demo application](https://github.com/spring-ai-community/spring-ai-tool-search-tool/tree/1.0.x/examples/tool-search-tool-demo) with the following setup:

- **Task**: *"Help me plan what to wear today in Amsterdam. Please suggest clothing shops that are open right now."*

- **28 total tools**: 3 relevant tools (`weather`, `clothing`, `currentTime`) + 25 unrelated "dummy" tools, deliberately **not relevant** to the weather/clothing task, demonstrating how the tool search efficiently discovers only the needed tools among many unrelated options.

- **Search strategies**: Lucene (keyword-based) and VectorStore (semantic)

- **Models tested**: Gemini (`gemini-3-pro-preview`), OpenAI (`gpt-5-mini-2025-08-07`), Anthropic (`claude-sonnet-4-5-20250929`)

The measurements are collected using a custom [TokenCounterAdvisor](https://github.com/spring-ai-community/spring-ai-tool-search-tool/blob/1.0.x/examples/tool-search-tool-demo/src/main/java/org/springaicommunity/tool/search/TokenCounterAdvisor.java) that tracks and aggregates the token usage.

#### Results with Lucene Search

<table>
<thead>
<tr>
<th>Model</th>
<th>Approach</th>
<th>Total Tokens</th>
<th>Prompt Tokens</th>
<th>Completion Tokens</th>
<th>Requests</th>
<th><strong>Savings</strong></th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>Gemini</strong></td>
<td>With TST</td>
<td>2,165</td>
<td>1,412</td>
<td>231</td>
<td>4</td>
<td><strong>60%</strong></td>
</tr>
<tr>
<td></td>
<td>Without TST</td>
<td>5,375</td>
<td>4,800</td>
<td>176</td>
<td>3</td>
<td>—</td>
</tr>
<tr>
<td><strong>OpenAI</strong></td>
<td>With TST</td>
<td>4,706</td>
<td>2,770</td>
<td>1,936</td>
<td>5</td>
<td><strong>34%</strong></td>
</tr>
<tr>
<td></td>
<td>Without TST</td>
<td>7,175</td>
<td>5,765</td>
<td>1,410</td>
<td>3</td>
<td>—</td>
</tr>
<tr>
<td><strong>Anthropic</strong></td>
<td>With TST</td>
<td>6,273</td>
<td>5,638</td>
<td>635</td>
<td>5</td>
<td><strong>64%</strong></td>
</tr>
<tr>
<td></td>
<td>Without TST</td>
<td>17,342</td>
<td>16,752</td>
<td>590</td>
<td>4</td>
<td>—</td>
</tr>
</tbody>
</table>

#### Results with VectorStore Search

<table>
<thead>
<tr>
<th>Model</th>
<th>Approach</th>
<th>Total Tokens</th>
<th>Prompt Tokens</th>
<th>Completion Tokens</th>
<th>Requests</th>
<th><strong>Savings</strong></th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>Gemini</strong></td>
<td>With TST</td>
<td>2,214</td>
<td>1,502</td>
<td>234</td>
<td>4</td>
<td><strong>57%</strong></td>
</tr>
<tr>
<td></td>
<td>Without TST</td>
<td>5,122</td>
<td>4,767</td>
<td>73</td>
<td>3</td>
<td>—</td>
</tr>
<tr>
<td><strong>OpenAI</strong></td>
<td>With TST</td>
<td>3,697</td>
<td>2,109</td>
<td>1,588</td>
<td>4</td>
<td><strong>47%</strong></td>
</tr>
<tr>
<td></td>
<td>Without TST</td>
<td>6,959</td>
<td>5,771</td>
<td>1,188</td>
<td>3</td>
<td>—</td>
</tr>
<tr>
<td><strong>Anthropic</strong></td>
<td>With TST</td>
<td>6,319</td>
<td>5,642</td>
<td>677</td>
<td>5</td>
<td><strong>63%</strong></td>
</tr>
<tr>
<td></td>
<td>Without TST</td>
<td>17,291</td>
<td>16,744</td>
<td>547</td>
<td>4</td>
<td>—</td>
</tr>
</tbody>
</table>

#### Key Observations

- **Significant token savings across all models**: The Tool Search Tool pattern achieved **34-64% reduction** in total token consumption depending on the model and search strategy.
- **Prompt tokens are the key driver**: The savings come primarily from reduced prompt tokens - with TST, only discovered tool definitions are included rather than all 28 tools upfront.
- **Trade-off: More requests, fewer tokens**: TST requires 4-5 requests vs 3-4 without, but the total token cost is significantly lower.
- **Both search strategies perform similarly**: Lucene and VectorStore produced comparable results, with VectorStore showing slightly better efficiency for OpenAI in this test.
- **All models successfully completed the task**: All three models (Gemini, OpenAI, Anthropic) figured out that they needed to call `currentTime` before invoking the other tools, demonstrating correct reasoning about tool dependencies.
- **Different tool discovery strategies**: Models exhibited varying approaches—some managed to request all necessary tools upfront, while others discovered them one by one. However, all models leveraged parallel tool calling when possible to optimize execution.
- **Older models may struggle**: The older model versions may have difficulty with the tool search pattern, potentially missing required tools or making suboptimal discovery decisions. Consider adding a custom `systemMessageSuffix` to provide additional guidance to the model, experiment with different `ToolIndex` configurations or pair this approach with the [LLM as Judge pattern](https://spring.io/blog/2025/11/10/spring-ai-llm-as-judge-blog-post) to ensure reliable and consistent behavior across different models.

## When to Use

<table>
<thead>
<tr>
<th>Tool Search Tool Approach</th>
<th>Traditional Approach</th>
</tr>
</thead>
<tbody>
<tr>
<td>20+ tools in your system</td>
<td>Small tool library (&lt;20 tools)</td>
</tr>
<tr>
<td>Tool definitions consuming &gt;5K tokens</td>
<td>All tools frequently used in every session</td>
</tr>
<tr>
<td>Building MCP-powered systems with multiple servers</td>
<td>Very compact tool definitions</td>
</tr>
<tr>
<td>Experiencing tool selection accuracy issues</td>
<td></td>
</tr>
</tbody>
</table>

## Next Steps

As part of Spring AI 2.0.0, the Tool Search Tool is now a first-class feature of the core Spring AI project. You can find the source in the [spring-projects/spring-ai](https://github.com/spring-projects/spring-ai) repository.

Also, you can consider combining the Tool Search Tool with [LLM-as-a-Judge patterns](https://spring.io/blog/2025/11/10/spring-ai-llm-as-judge-blog-post) to ensure discovered tools actually fulfill the user's task. A judge model could evaluate whether the dynamically selected tools produced satisfactory results and improve the tool discovery if needed.

## Conclusion

The Tool Search Tool pattern is a step toward scalable AI agents. By combining Anthropic's innovative approach with Spring AI's **portable abstraction**, we can build systems that efficiently manage thousands of tools while maintaining high accuracy **across any LLM provider**.

**The power of Spring AI's recursive advisor architecture** is that it allows us to implement sophisticated tool discovery workflows that work universally - whether you're using OpenAI's GPT models, Anthropic's Claude, local Ollama models, or any other LLM supported by Spring AI. You get the same dynamic tool discovery benefits without being locked into a specific provider's native implementation.

## References

- **Anthropic Tool Search Tool Pattern**: [Advanced Tool Use](https://www.anthropic.com/engineering/advanced-tool-use)
- **Spring AI Tool Search Tool**: [spring-projects/spring-ai](https://github.com/spring-projects/spring-ai)
- **Spring AI Tools Documentation**: [Tools API Reference](https://docs.spring.io/spring-ai/reference/api/tools.html)
- **Spring AI Recursive Advisors**: [Advisors API Reference](https://docs.spring.io/spring-ai/reference/api/advisors-recursive.html)
- **Spring AI Recursive Advisors Blog**: [Spring AI Recursive Advisors](https://spring.io/blog/2025/11/04/spring-ai-recursive-advisors)

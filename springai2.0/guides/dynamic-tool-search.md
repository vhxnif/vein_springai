Search

# Dynamic Tool Discovery with Tool Search Tool

As AI agents connect to more services—Slack, GitHub, Jira, MCP servers—tool libraries grow rapidly. A typical multi-server setup can easily have 50+ tools consuming significant tokens before any conversation starts. Worse, tool selection accuracy degrades when models face 30+ similarly-named tools.

The **Tool Search Tool** pattern, pioneered by Anthropic, addresses this: instead of loading all tool definitions upfront, the model discovers tools on-demand. It receives only a search tool initially, queries for capabilities when needed, and gets relevant tool definitions expanded into context.

Spring AI’s implementation achieves **34-64% token reduction** across OpenAI, Anthropic, and Gemini models while maintaining full access to hundreds of tools.

## Introduction

The Tool Search Tool extends Spring AI’s Recursive Advisors to implement dynamic tool discovery that works across **any LLM provider** supported by Spring AI.

**Key benefits:**

- **Token savings** - Only discovered tool definitions are sent to the LLM

- **Improved accuracy** - Models select tools more reliably from smaller, relevant sets

- **Scalability** - Manage hundreds of tools without context bloat

- **Portability** - Works with OpenAI, Anthropic, Gemini, Ollama and more

## Blog Post

📖 **Full Tutorial:** Smart Tool Selection: Achieving 34-64% Token Savings with Spring AI’s Dynamic Tool Discovery

The blog post covers the complete implementation details, performance benchmarks, and advanced use cases.

## Quick Start

### Dependencies

Use the Spring Boot starter for the simplest setup (includes Lucene and auto-configuration):

With the starter, enable the advisor in `application.properties` — no Java configuration needed:

    spring.ai.chat.client.tool-search-advisor.enabled=true

See Tool Search Tool auto-configuration for the full list of configuration properties and ToolIndex selection options.

Alternatively, add only the library for manual `@Bean` configuration:

### Basic Usage

    @SpringBootApplication
    public class Application {

        @Bean
        CommandLineRunner demo(ChatClient.Builder builder, ToolIndex toolIndex) {
            return args -> {
                var advisor = ToolSearchToolCallingAdvisor.builder()
                    .toolIndex(toolIndex)
                    .build();

                ChatClient chatClient = builder
                    .defaultTools(new MyTools())  // 100s of tools registered but NOT sent to LLM initially
                    .defaultAdvisors(advisor)     // Activate Tool Search Tool
                    .build();

                var answer = chatClient.prompt("""
                    Help me plan what to wear today in Amsterdam.
                    Please suggest clothing shops that are open right now.
                    """).call().content();

                System.out.println(answer);
            };
        }

        static class MyTools {
            @Tool(description = "Get the weather for a given location at a given time")
            public String weather(String location,
                @ToolParam(description = "YYYY-MM-DDTHH:mm") String atTime) {
                // implementation
            }

            @Tool(description = "Get clothing shop names for a given location at a given time")
            public List<String> clothing(String location,
                    @ToolParam(description = "YYYY-MM-DDTHH:mm") String openAtTime) {
                // implementation
            }

            @Tool(description = "Current date and time for a given location")
            public String currentTime(String location) {
                // implementation
            }

            // ... potentially hundreds more tools
        }
    }

## How It Works

The `ToolSearchToolCallingAdvisor` extends Spring AI’s `ToolCallingAdvisor` to implement dynamic tool discovery:

1.  **Indexing**: At conversation start, all registered tools are indexed in the `ToolIndex` (but NOT sent to the LLM)

2.  **Initial Request**: Only the **Tool Search Tool** definition is sent to the LLM

3.  **Discovery Call**: When the LLM needs capabilities, it calls the search tool with a query

4.  **Search & Expand**: The `ToolIndex` finds matching tools and their definitions are added to the next request

5.  **Tool Invocation**: The LLM now sees both the search tool and discovered tool definitions

6.  **Tool Execution**: Discovered tools are executed and results returned

7.  **Response**: The LLM generates the final answer

## Search Strategies

The `ToolIndex` interface supports multiple search implementations:

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 20%" />
<col style="width: 40%" />
<col style="width: 40%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Strategy</th>
<th class="tableblock halign-left valign-top">Implementation</th>
<th class="tableblock halign-left valign-top">Best For</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><strong>Semantic</strong></p></td>
<td class="tableblock halign-left valign-top"><p><code>VectorToolIndex</code></p></td>
<td class="tableblock halign-left valign-top"><p>Natural language queries, fuzzy matching</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><strong>Keyword</strong></p></td>
<td class="tableblock halign-left valign-top"><p><code>LuceneToolIndex</code></p></td>
<td class="tableblock halign-left valign-top"><p>Exact term matching, known tool names</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><strong>Regex</strong></p></td>
<td class="tableblock halign-left valign-top"><p><code>RegexToolIndex</code></p></td>
<td class="tableblock halign-left valign-top"><p>Tool name patterns (<code>get_*_data</code>)</p></td>
</tr>
</tbody>
</table>

See Tool Search Tool for all available implementations and configuration options.

## Performance

Preliminary benchmarks with 28 tools show significant token savings:

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Model</th>
<th class="tableblock halign-left valign-top">With Tool Search</th>
<th class="tableblock halign-left valign-top">Without</th>
<th class="tableblock halign-left valign-top">Savings</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Gemini</p></td>
<td class="tableblock halign-left valign-top"><p>2,165 tokens</p></td>
<td class="tableblock halign-left valign-top"><p>5,375 tokens</p></td>
<td class="tableblock halign-left valign-top"><p><strong>60%</strong></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>OpenAI</p></td>
<td class="tableblock halign-left valign-top"><p>4,706 tokens</p></td>
<td class="tableblock halign-left valign-top"><p>7,175 tokens</p></td>
<td class="tableblock halign-left valign-top"><p><strong>34%</strong></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Anthropic</p></td>
<td class="tableblock halign-left valign-top"><p>6,273 tokens</p></td>
<td class="tableblock halign-left valign-top"><p>17,342 tokens</p></td>
<td class="tableblock halign-left valign-top"><p><strong>64%</strong></p></td>
</tr>
</tbody>
</table>

## When to Use

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Tool Search Tool Approach</th>
<th class="tableblock halign-left valign-top">Traditional Approach</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>20+ tools in your system</p></td>
<td class="tableblock halign-left valign-top"><p>Small tool library (&lt;20 tools)</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Tool definitions consuming &gt;5K tokens</p></td>
<td class="tableblock halign-left valign-top"><p>All tools frequently used in every session</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Building MCP-powered systems with multiple servers</p></td>
<td class="tableblock halign-left valign-top"><p>Very compact tool definitions</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Experiencing tool selection accuracy issues</p></td>
<td class="tableblock halign-left valign-top"></td>
</tr>
</tbody>
</table>

## Related Documentation

- Tool Calling

- Recursive Advisors

- ChatClient

## References

- Anthropic Advanced Tool Use - Original pattern description

- Spring AI Recursive Advisors Blog - Foundation for tool search implementation

Getting Started with MCP LLM-as-a-Judge Evaluation

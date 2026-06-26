In our [previous blog post about Anthropic prompt caching](https://spring.io/blog/2025/10/27/spring-ai-anthropic-prompt-caching-blog), we explored how prompt caching dramatically reduces API costs and latency by reusing previously processed prompt content. We introduced Spring AI's five strategic caching patterns for Anthropic Claude models and showed how they automatically handle cache breakpoint placement while respecting the 4-breakpoint limit.

AWS Bedrock brings prompt caching to a broader ecosystem—supporting both Claude models (accessed via Bedrock) and Amazon's own Nova family. If you're considering Bedrock or already using it, you'll find the same Spring AI caching strategies apply with a few key differences.

In this blog post, we explain what's different about prompt caching in AWS Bedrock compared to Anthropic's direct API and how Spring AI maintains consistent patterns across both providers.

## What AWS Bedrock Adds

AWS Bedrock extends prompt caching beyond Claude to include Amazon Nova models:

**Claude models** (via Bedrock):

- Claude 3 Opus 4.1, Opus 4, Sonnet 4.5, Sonnet 4, Haiku 4.5
- Claude 3.7 Sonnet, 3.5 Haiku
- Full caching support including tool definitions

**Amazon Nova models**:

- Nova Micro, Lite, Pro, Premier
- System and conversation caching support only

For complete model details, see [AWS Bedrock supported models](https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-caching.html#prompt-caching-models).

## Key Differences from Anthropic Direct API

While the core caching concepts remain the same (as covered in our [previous blog](https://spring.io/blog/2025/10/27/spring-ai-anthropic-prompt-caching-blog)), AWS Bedrock has several differences worth understanding.

### Fixed 5-Minute Cache TTL

AWS Bedrock uses a fixed 5-minute TTL with no configuration options, while Anthropic's direct API offers optional 1-hour caching.

    // Anthropic direct API: optional TTL configuration
    AnthropicCacheOptions.builder()
        .strategy(AnthropicCacheStrategy.SYSTEM_ONLY)
        .messageTypeTtl(MessageType.SYSTEM, AnthropicCacheTtl.ONE_HOUR)
        .build()

    // AWS Bedrock: always 5 minutes
    BedrockCacheOptions.builder()
        .strategy(BedrockCacheStrategy.SYSTEM_ONLY)
        .build()

For high-frequency workloads (requests every few seconds or minutes), the 5-minute TTL keeps the cache warm. For applications with requests spaced 5-30 minutes apart, cache entries may expire between requests.

### Tool Caching Not Supported on Nova

Amazon Nova models do not support tool caching. Attempting to use `TOOLS_ONLY` or `SYSTEM_AND_TOOLS` strategies with Nova throws an exception.

    // Works with Claude models
    BedrockChatOptions.builder()
        .model("anthropic.claude-sonnet-4-5-20250929-v1:0")
        .cacheOptions(BedrockCacheOptions.builder()
            .strategy(BedrockCacheStrategy.SYSTEM_AND_TOOLS)
            .build())
            .toolCallbacks(tools)
        .build()

    // Throws exception with Nova models
    BedrockChatOptions.builder()
        .model("us.amazon.nova-pro-v1:0")
        .cacheOptions(BedrockCacheOptions.builder()
            .strategy(BedrockCacheStrategy.TOOLS_ONLY)
            .build())
            .toolCallbacks(tools)
        .build()

    // Use SYSTEM_ONLY for Nova
    BedrockChatOptions.builder()
        .model("us.amazon.nova-pro-v1:0")
        .cacheOptions(BedrockCacheOptions.builder()
            .strategy(BedrockCacheStrategy.SYSTEM_ONLY)
            .build())
            .build()

### Model-Specific Token Thresholds

<table>
<thead>
<tr>
<th>Model</th>
<th>Minimum Tokens per Checkpoint</th>
</tr>
</thead>
<tbody>
<tr>
<td>Claude 3.7 Sonnet, 3.5 Sonnet v2, Opus 4, Sonnet 4, Sonnet 4.5</td>
<td>1,024</td>
</tr>
<tr>
<td>Claude 3.5 Haiku</td>
<td>2,048</td>
</tr>
<tr>
<td>Claude Haiku 4.5</td>
<td>4,096</td>
</tr>
<tr>
<td>Amazon Nova (all variants)</td>
<td>1,000</td>
</tr>
</tbody>
</table>

See [Bedrock token limits documentation](https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-caching.html#prompt-caching-models) for details.

### Cache Metrics Naming

<table>
<thead>
<tr>
<th>Metric</th>
<th>Anthropic Direct</th>
<th>AWS Bedrock</th>
</tr>
</thead>
<tbody>
<tr>
<td>Creating a cache entry</td>
<td><code>cacheCreationInputTokens</code></td>
<td><code>cacheWriteInputTokens</code></td>
</tr>
<tr>
<td>Reading from cache</td>
<td><code>cacheReadInputTokens</code></td>
<td><code>cacheReadInputTokens</code></td>
</tr>
</tbody>
</table>

## Same Spring AI Patterns Across Providers

Spring AI uses identical caching strategies across both providers:

    BedrockCacheStrategy.SYSTEM_ONLY           ←→ AnthropicCacheStrategy.SYSTEM_ONLY
    BedrockCacheStrategy.TOOLS_ONLY            ←→ AnthropicCacheStrategy.TOOLS_ONLY
    BedrockCacheStrategy.SYSTEM_AND_TOOLS      ←→ AnthropicCacheStrategy.SYSTEM_AND_TOOLS
    BedrockCacheStrategy.CONVERSATION_HISTORY  ←→ AnthropicCacheStrategy.CONVERSATION_HISTORY

Let's take a look at how similar the code is:

    // Anthropic direct API
    ChatResponse response = anthropicChatModel.call(
                    new Prompt(
                            List.of(new SystemMessage(systemPrompt), new UserMessage(userQuery)),
                            AnthropicChatOptions.builder()
                                    .model(AnthropicApi.ChatModel.CLAUDE_4_5_SONNET)
                                    .cacheOptions(AnthropicCacheOptions.builder()
                                            .strategy(AnthropicCacheStrategy.SYSTEM_ONLY)
                                            .build())
                                    .maxTokens(500)
                                    .build()
                    )
            );

    // AWS Bedrock (nearly identical)
    ChatResponse response = bedrockChatModel.call(
            new Prompt(
                    List.of(new SystemMessage(systemPrompt), new UserMessage(userQuery)),
                    BedrockChatOptions.builder()
                            .model("anthropic.claude-sonnet-4-5-20250929-v1:0")
                            .cacheOptions(BedrockCacheOptions.builder()
                                    .strategy(BedrockCacheStrategy.SYSTEM_ONLY)
                                    .build())
                            .maxTokens(500)
                            .build()
            )
    );

The only differences: the chat model instance, options class, and model identifier format.

## Provider Characteristics at a Glance

<table>
<thead>
<tr>
<th>Feature</th>
<th>AWS Bedrock</th>
<th>Anthropic Direct</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>Cache TTL</strong></td>
<td>5 minutes (fixed)</td>
<td>5 minutes (default), 1 hour (optional)</td>
</tr>
<tr>
<td><strong>Models</strong></td>
<td>Claude + Nova</td>
<td>Claude only</td>
</tr>
<tr>
<td><strong>Tool Caching</strong></td>
<td>Claude only</td>
<td>All Claude models</td>
</tr>
<tr>
<td><strong>Token Metrics</strong></td>
<td><code>cacheWriteInputTokens</code>, <code>cacheReadInputTokens</code></td>
<td><code>cacheCreationInputTokens</code>, <code>cacheReadInputTokens</code></td>
</tr>
<tr>
<td><strong>Pricing</strong></td>
<td>Varies by region/model</td>
<td>Published per-model</td>
</tr>
<tr>
<td><strong>Cost Pattern</strong></td>
<td>~25% write premium, ~90% read savings</td>
<td>25% write premium, 90% read savings</td>
</tr>
</tbody>
</table>

## Example: Document Analysis with Caching

Here's a practical example showing cache effectiveness:

    @Service
    public class ContractAnalyzer {

        private final BedrockProxyChatModel chatModel;
        private final DocumentExtractor documentExtractor;

        public AnalysisReport analyzeContract(String contractId) {
            String contractText = documentExtractor.extract(contractId);

            String systemPrompt = """
                    You are an expert legal analyst specializing in commercial contracts.
                    Analyze the following contract and provide precise insights about
                    terms, obligations, risks, and opportunities:
                    
                    CONTRACT:
                    %s
                    """.formatted(contractText);

            String[] questions = {
                    "What are the key legal clauses and penalties?",
                    "Summarize the payment terms and financial obligations.",
                    "What intellectual property rights are defined?",
                    "Identify potential compliance risks.",
                    "What are the performance milestones?"
            };

            AnalysisReport report = new AnalysisReport();

            BedrockChatOptions options = BedrockChatOptions.builder()
                    .model("anthropic.claude-sonnet-4-5-20250929-v1:0")
                    .cacheOptions(BedrockCacheOptions.builder()
                            .strategy(BedrockCacheStrategy.SYSTEM_ONLY)
                            .build())
                    .maxTokens(1000)
                    .build();

            for (int i = 0; i < questions.length; i++) {
                ChatResponse response = chatModel.call(
                        new Prompt(
                                List.of(new SystemMessage(systemPrompt), new UserMessage(questions[i])),
                                options
                        )
                );

                report.addSection(questions[i], response.getResult().getOutput().getText());
                logCacheMetrics(response, i);
            }

            return report;
        }

        private void logCacheMetrics(ChatResponse response, int questionNum) {
            Integer cacheWrite = (Integer) response.getMetadata()
                    .getMetadata().get("cacheWriteInputTokens");
            Integer cacheRead = (Integer) response.getMetadata()
                    .getMetadata().get("cacheReadInputTokens");

            if (questionNum == 0 && cacheWrite != null) {
                logger.info("Cache created: {} tokens", cacheWrite);
            } else if (cacheRead != null && cacheRead > 0) {
                logger.info("Cache hit: {} tokens", cacheRead);
            }
        }
    }

AWS Bedrock provides cache metrics through the response metadata:

First request: `cacheWriteInputTokens` &gt; 0, `cacheReadInputTokens` = 0

Subsequent requests (within TTL): `cacheWriteInputTokens` = 0, `cacheReadInputTokens` &gt; 0

With a 3,500-token system prompt, this yields approximately 65% cost reduction on cached content (first question pays ~1.25x, subsequent questions pay ~0.10x).

## Using Different Models on Bedrock

    @Service
    public class MultiModelService {

        // Nova: System prompt caching
        public String analyzeWithNova(String document, String query) {
            return chatClient.prompt()
                    .system("You are an expert analyst. Context: " + document)
                    .user(query)
                    .options(BedrockChatOptions.builder()
                            .model("us.amazon.nova-pro-v1:0")
                            .cacheOptions(BedrockCacheOptions.builder()
                                    .strategy(BedrockCacheStrategy.SYSTEM_ONLY)
                                    .build())
                            .maxTokens(500)
                            .build())
                    .call()
                    .content();
        }

        // Claude: System + tool caching
        public String analyzeWithTools(String document, String query,
                List<ToolCallback> tools) {
            return chatClient.prompt()
                    .system("You are an expert analyst. Context: " + document)
                    .user(query)
                    .options(BedrockChatOptions.builder()
                            .model("anthropic.claude-sonnet-4-5-20250929-v1:0")
                            .cacheOptions(BedrockCacheOptions.builder()
                                    .strategy(BedrockCacheStrategy.SYSTEM_AND_TOOLS)
                                    .build())
                            .toolCallbacks(tools)
                            .maxTokens(500)
                            .build())
                    .call()
                    .content();
        }
    }

## Getting Started

Add the Spring AI Bedrock Converse starter:

**Note:** AWS Bedrock Prompt caching support is available in Spring AI `1.1.0` and later. Try it with the latest `1.1.0-SNAPSHOT` version.

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-bedrock-converse</artifactId>
    </dependency>

Configure AWS credentials:

    spring.ai.bedrock.aws.region=us-east-1
    spring.ai.bedrock.aws.access-key=${AWS_ACCESS_KEY_ID}
    spring.ai.bedrock.aws.secret-key=${AWS_SECRET_ACCESS_KEY}

You can then start using prompt caching via AWS Bedrock as shown in the examples above.

## Strategy Selection Reference

<table>
<thead>
<tr>
<th>Strategy</th>
<th>Use When</th>
<th>Claude</th>
<th>Nova</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>SYSTEM_ONLY</code></td>
<td>Large stable system prompt</td>
<td>Yes</td>
<td>Yes</td>
</tr>
<tr>
<td><code>TOOLS_ONLY</code></td>
<td>Large stable tools, dynamic system</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td><code>SYSTEM_AND_TOOLS</code></td>
<td>Both large and stable</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td><code>CONVERSATION_HISTORY</code></td>
<td>Multi-turn conversations</td>
<td>Yes</td>
<td>Yes</td>
</tr>
<tr>
<td><code>NONE</code></td>
<td>Disable caching explicitly</td>
<td>Yes</td>
<td>Yes</td>
</tr>
</tbody>
</table>

For detailed strategy explanations, cache hierarchy, and cascade invalidation patterns, see our [Anthropic prompt caching blog post](https://spring.io/blog/2025/10/27/spring-ai-anthropic-prompt-caching-blog). These concepts still hold true in the case of AWS Bedrock.

## Conclusion

AWS Bedrock extends prompt caching to Amazon Nova models while maintaining full support for Claude models. The key differences from Anthropic's direct API are a fixed 5-minute TTL, Nova's lack of tool caching support, and region-specific pricing.

Spring AI provides the same strategic caching patterns across both providers. Whether you choose Claude through Anthropic, Claude through Bedrock, or Amazon Nova models, the five caching strategies work consistently with minimal code changes.

The decision between providers depends on model availability (Nova is only on Bedrock), cache TTL requirements, and tool caching needs (Nova doesn't support it).

For more on prompt caching support in Spring AI for AWS Bercok see [Spring AI Bedrock documentation](https://docs.spring.io/spring-ai/reference/1.1-SNAPSHOT/api/chat/bedrock-converse.html#_prompt_caching) and [AWS Bedrock Prompt Caching documentation](https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-caching.html).

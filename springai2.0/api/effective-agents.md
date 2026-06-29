Search

# Building Effective Agents

In a recent research publication, Building Effective Agents, Anthropic shared valuable insights about building effective Large Language Model (LLM) agents. What makes this research particularly interesting is its emphasis on simplicity and composability over complex frameworks. Let’s explore how these principles translate into practical implementations using Spring AI.

While the pattern descriptions and diagrams are sourced from Anthropic’s original publication, we’ll focus on how to implement these patterns using Spring AI’s features for model portability and structured output. We recommend reading the original paper first.

The agentic-patterns directory in the spring-ai-examples repository contains all the code for the examples that follow.

## Agentic Systems

The research publication makes an important architectural distinction between two types of agentic systems:

1.  **Workflows**: Systems where LLMs and tools are orchestrated through predefined code paths (e.g., prescriptive systems)

2.  **Agents**: Systems where LLMs dynamically direct their own processes and tool usage

The key insight is that while fully autonomous agents might seem appealing, workflows often provide better predictability and consistency for well-defined tasks. This aligns perfectly with enterprise requirements where reliability and maintainability are crucial.

Let’s examine how Spring AI implements these concepts through five fundamental patterns, each serving specific use cases:

### 1. Chain Workflow

The Chain Workflow pattern exemplifies the principle of breaking down complex tasks into simpler, more manageable steps.

**When to Use:** - Tasks with clear sequential steps - When you want to trade latency for higher accuracy - When each step builds on the previous step’s output

Here’s a practical example from Spring AI’s implementation:

    public class ChainWorkflow {
        private final ChatClient chatClient;
        private final String[] systemPrompts;

        public String chain(String userInput) {
            String response = userInput;
            for (String prompt : systemPrompts) {
                String input = String.format("{%s}\n {%s}", prompt, response);
                response = chatClient.prompt(input).call().content();
            }
            return response;
        }
    }

This implementation demonstrates several key principles:

- Each step has a focused responsibility

- Output from one step becomes input for the next

- The chain is easily extensible and maintainable

### 2. Parallelization Workflow

LLMs can work simultaneously on tasks and have their outputs aggregated programmatically.

**When to Use:** - Processing large volumes of similar but independent items - Tasks requiring multiple independent perspectives - When processing time is critical and tasks are parallelizable

    List<String> parallelResponse = new ParallelizationWorkflow(chatClient)
        .parallel(
            "Analyze how market changes will impact this stakeholder group.",
            List.of(
                "Customers: ...",
                "Employees: ...",
                "Investors: ...",
                "Suppliers: ..."
            ),
            4
        );

### 3. Routing Workflow

The Routing pattern implements intelligent task distribution, enabling specialized handling for different types of input.

**When to Use:** - Complex tasks with distinct categories of input - When different inputs require specialized processing - When classification can be handled accurately

    @Autowired
    private ChatClient chatClient;

    RoutingWorkflow workflow = new RoutingWorkflow(chatClient);

    Map<String, String> routes = Map.of(
        "billing", "You are a billing specialist. Help resolve billing issues...",
        "technical", "You are a technical support engineer. Help solve technical problems...",
        "general", "You are a customer service representative. Help with general inquiries..."
    );

    String input = "My account was charged twice last week";
    String response = workflow.route(input, routes);

### 4. Orchestrator-Workers

**When to Use:** - Complex tasks where subtasks can’t be predicted upfront - Tasks requiring different approaches or perspectives - Situations needing adaptive problem-solving

    public class OrchestratorWorkersWorkflow {
        public WorkerResponse process(String taskDescription) {
            // 1. Orchestrator analyzes task and determines subtasks
            OrchestratorResponse orchestratorResponse = // ...

            // 2. Workers process subtasks in parallel
            List<String> workerResponses = // ...

            // 3. Results are combined into final response
            return new WorkerResponse(/*...*/);
        }
    }

Usage Example:

    ChatClient chatClient = // ... initialize chat client
    OrchestratorWorkersWorkflow workflow = new OrchestratorWorkersWorkflow(chatClient);

    WorkerResponse response = workflow.process(
        "Generate both technical and user-friendly documentation for a REST API endpoint"
    );

    System.out.println("Analysis: " + response.analysis());
    System.out.println("Worker Outputs: " + response.workerResponses());

### 5. Evaluator-Optimizer

**When to Use:** - Clear evaluation criteria exist - Iterative refinement provides measurable value - Tasks benefit from multiple rounds of critique

    public class EvaluatorOptimizerWorkflow {
        public RefinedResponse loop(String task) {
            Generation generation = generate(task, context);
            EvaluationResponse evaluation = evaluate(generation.response(), task);
            return new RefinedResponse(finalSolution, chainOfThought);
        }
    }

Usage Example:

    ChatClient chatClient = // ... initialize chat client
    EvaluatorOptimizerWorkflow workflow = new EvaluatorOptimizerWorkflow(chatClient);

    RefinedResponse response = workflow.loop(
        "Create a Java class implementing a thread-safe counter"
    );

    System.out.println("Final Solution: " + response.solution());
    System.out.println("Evolution: " + response.chainOfThought());

## Spring AI’s Implementation Advantages

Spring AI’s implementation of these patterns offers several benefits that align with Anthropic’s recommendations:

### Model Portability

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-openai</artifactId>
    </dependency>

### Structured Output

    EvaluationResponse response = chatClient.prompt(prompt)
        .call()
        .entity(EvaluationResponse.class);

### Consistent API

- Uniform interface across different LLM providers

- Built-in error handling and retries

- Flexible prompt management

## Best Practices and Recommendations

- **Start Simple**

- Begin with basic workflows before adding complexity

- Use the simplest pattern that meets your requirements

- Add sophistication only when needed

- **Design for Reliability**

- Implement clear error handling

- Use type-safe responses where possible

- Build in validation at each step

- **Consider Trade-offs**

- Balance latency vs. accuracy

- Evaluate when to use parallel processing

- Choose between fixed workflows and dynamic agents

## Future Work

These guides will be updated to explore how to build more advanced Agents that combine these foundational patterns with sophisticated features:

**Pattern Composition** - Combining multiple patterns to create more powerful workflows - Building hybrid systems that leverage the strengths of each pattern - Creating flexible architectures that can adapt to changing requirements

**Advanced Agent Memory Management** - Implementing persistent memory across conversations - Managing context windows efficiently - Developing strategies for long-term knowledge retention

**Tools and Model-Context Protocol (MCP) Integration** - Leveraging external tools through standardized interfaces - Implementing MCP for enhanced model interactions - Building extensible agent architectures

## Conclusion

The combination of Anthropic’s research insights and Spring AI’s practical implementations provides a powerful framework for building effective LLM-based systems.

By following these patterns and principles, developers can create robust, maintainable, and effective AI applications that deliver real value while avoiding unnecessary complexity.

The key is to remember that sometimes the simplest solution is the most effective. Start with basic patterns, understand your use case thoroughly, and only add complexity when it demonstrably improves your system’s performance or capabilities.

Prompt Engineering Patterns Upgrade Notes

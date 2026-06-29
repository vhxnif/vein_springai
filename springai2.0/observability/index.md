Search

# Observability

Spring AI builds upon the observability features in the Spring ecosystem to provide insights into AI-related operations. It provides metrics and tracing capabilities for its core components: `ChatClient` (including `Advisor`), `ChatModel`, `EmbeddingModel`, `ImageModel`, and `VectorStore`.

Refer to the Spring Boot Metrics and Spring Boot Tracing documentation to enable metrics and tracing support in your application.

## Chat Client

The `spring.ai.chat.client` observations are recorded when a ChatClient `call()` or `stream()` operations are invoked. They measure the time spent performing the invocation and propagate the related tracing information.

<table class="tableblock frame-all grid-all stripes-even stretch">
<caption>Table 1. Low Cardinality Keys</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Name</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.operation.name</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>Always <code>framework</code>.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.system</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>Always <code>spring_ai</code>.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>spring.ai.chat.client.stream</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>Is the chat model response a stream - <code>true or false</code></p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>spring.ai.kind</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The kind of framework API in Spring AI: <code>chat_client</code>.</p>
</div>
</div></td>
</tr>
</tbody>
</table>

<table class="tableblock frame-all grid-all stripes-even stretch">
<caption>Table 2. High Cardinality Keys</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>Name</p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>Description</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>spring.ai.chat.client.advisors</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>List of configured chat client advisors.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>spring.ai.chat.client.conversation.id</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>Identifier of the conversation when using the chat memory.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>spring.ai.chat.client.tool.names</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>Names of the tools passed to the chat client.</p>
</div>
</div></td>
</tr>
</tbody>
</table>

### Prompt and Completion Data

The `ChatClient` prompt and completion data is typically big and possibly containing sensitive information. For those reasons, it is not exported by default.

Spring AI supports logging the prompt and completion data to help with debugging and troubleshooting.

<table class="tableblock frame-all grid-all stripes-even stretch" style="width:100%;">
<colgroup>
<col style="width: 60%" />
<col style="width: 30%" />
<col style="width: 10%" />
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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.client.observations.log-prompt</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to log the chat client prompt content.</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.client.observations.log-completion</code></p></td>
<td class="tableblock halign-left valign-top"><p>Whether to log the chat client completion content.</p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
</tbody>
</table>

### Chat Client Advisors

The `spring.ai.advisor` observations are recorded when an advisor is executed. They measure the time spent in the advisor (including the time spent on the inner advisors) and propagate the related tracing information.

<table class="tableblock frame-all grid-all stripes-even stretch">
<caption>Table 3. Low Cardinality Keys</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Name</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.operation.name</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>Always <code>framework</code>.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.system</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>Always <code>spring_ai</code>.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>spring.ai.advisor.name</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>Name of the advisor.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>spring.ai.kind</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The kind of framework API in Spring AI: <code>advisor</code>.</p>
</div>
</div></td>
</tr>
</tbody>
</table>

<table class="tableblock frame-all grid-all stripes-even stretch">
<caption>Table 4. High Cardinality Keys</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Name</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>spring.ai.advisor.order</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>Advisor order in the advisor chain.</p>
</div>
</div></td>
</tr>
</tbody>
</table>

## Chat Model

The `gen_ai.client.operation` observations are recorded when calling the ChatModel `call` or `stream` methods. They measure the time spent on method completion and propagate the related tracing information.

<table class="tableblock frame-all grid-all stripes-even stretch">
<caption>Table 5. Low Cardinality Keys</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Name</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.operation.name</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The name of the operation being performed.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.system</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The model provider as identified by the client instrumentation.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.request.model</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The name of the model a request is being made to.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.response.model</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The name of the model that generated the response.</p>
</div>
</div></td>
</tr>
</tbody>
</table>

<table class="tableblock frame-all grid-all stripes-even stretch">
<caption>Table 6. High Cardinality Keys</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Name</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.request.frequency_penalty</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The frequency penalty setting for the model request.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.request.max_tokens</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The maximum number of tokens the model generates for a request.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.request.presence_penalty</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The presence penalty setting for the model request.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.request.stop_sequences</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>List of sequences that the model will use to stop generating further tokens.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.request.stream</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>Whether the request was made in streaming mode. Only present when <code>true</code>.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.request.temperature</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The temperature setting for the model request.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.request.top_k</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The top_k sampling setting for the model request.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.request.top_p</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The top_p sampling setting for the model request.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.response.finish_reasons</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>Reasons the model stopped generating tokens, corresponding to each generation received.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.response.id</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The unique identifier for the AI response.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.usage.cache_creation.input_tokens</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The number of input tokens written to a provider-managed cache.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.usage.cache_read.input_tokens</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The number of input tokens served from a provider-managed cache.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.usage.input_tokens</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The number of tokens used in the model input (prompt).</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.usage.output_tokens</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The number of tokens used in the model output (completion).</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.usage.total_tokens</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The total number of tokens used in the model exchange.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>spring.ai.model.request.tool.names</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>List of tool definitions provided to the model in the request.</p>
</div>
</div></td>
</tr>
</tbody>
</table>

### Chat Prompt and Completion Data

The chat prompt and completion data is typically big and possibly containing sensitive information. For those reasons, it is not exported by default.

Spring AI supports logging chat prompt and completion data, useful for troubleshooting scenarios. When tracing is available, the logs will include trace information for better correlation.

<table class="tableblock frame-all grid-all stripes-even stretch" style="width:100%;">
<colgroup>
<col style="width: 60%" />
<col style="width: 30%" />
<col style="width: 10%" />
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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.observations.log-prompt</code></p></td>
<td class="tableblock halign-left valign-top"><p>Log the prompt content. <code>true</code> or <code>false</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.observations.log-completion</code></p></td>
<td class="tableblock halign-left valign-top"><p>Log the completion content. <code>true</code> or <code>false</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring.ai.chat.observations.include-error-logging</code></p></td>
<td class="tableblock halign-left valign-top"><p>Include error logging in observations. <code>true</code> or <code>false</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
</tbody>
</table>

## Tool Calling

The `spring.ai.tool` observations are recorded when performing tool calling in the context of a chat model interaction. They measure the time spent on tool call completion and propagate the related tracing information.

<table class="tableblock frame-all grid-all stripes-even stretch">
<caption>Table 7. Low Cardinality Keys</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Name</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.operation.name</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The name of the operation being performed. It’s always <code>execute_tool</code>.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.system</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The provider responsible for the operation. It’s always <code>spring_ai</code>.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>spring.ai.kind</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The kind of operation performed by Spring AI. It’s always <code>tool_call</code>.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>spring.ai.tool.definition.name</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The name of the tool.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>spring.ai.tool.type</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The type of the tool. By default, it’s <code>function</code>.</p>
</div>
</div></td>
</tr>
</tbody>
</table>

<table class="tableblock frame-all grid-all stripes-even stretch">
<caption>Table 8. High Cardinality Keys</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>Name</p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>Description</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>spring.ai.tool.definition.description</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>Description of the tool.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>spring.ai.tool.definition.schema</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>Schema of the parameters used to call the tool.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>spring.ai.tool.call.id</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The ID of the tool call, as identified by the chat model.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>spring.ai.tool.call.arguments</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The input arguments to the tool call. (Only when enabled)</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>spring.ai.tool.call.result</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The result of the tool call execution. (Only when enabled)</p>
</div>
</div></td>
</tr>
</tbody>
</table>

### Tool Call Arguments and Result Data

The input arguments and result from the tool call are not exported by default, as they can be potentially sensitive.

Spring AI supports exporting tool call arguments and result data as span attributes.

<table class="tableblock frame-all grid-all stripes-even stretch" style="width:100%;">
<colgroup>
<col style="width: 60%" />
<col style="width: 30%" />
<col style="width: 10%" />
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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.tools.observations.include-content</code></p></td>
<td class="tableblock halign-left valign-top"><p>Include the tool call content in observations. <code>true</code> or <code>false</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
</tbody>
</table>

## EmbeddingModel

The `gen_ai.client.operation` observations are recorded on embedding model method calls. They measure the time spent on method completion and propagate the related tracing information.

<table class="tableblock frame-all grid-all stripes-even stretch">
<caption>Table 9. Low Cardinality Keys</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Name</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.operation.name</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The name of the operation being performed.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.system</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The model provider as identified by the client instrumentation.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.request.model</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The name of the model a request is being made to.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.response.model</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The name of the model that generated the response.</p>
</div>
</div></td>
</tr>
</tbody>
</table>

<table class="tableblock frame-all grid-all stripes-even stretch">
<caption>Table 10. High Cardinality Keys</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Name</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.request.embedding.dimensions</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The number of dimensions the resulting output embeddings have.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.usage.input_tokens</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The number of tokens used in the model input.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.usage.total_tokens</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The total number of tokens used in the model exchange.</p>
</div>
</div></td>
</tr>
</tbody>
</table>

## Image Model

The `gen_ai.client.operation` observations are recorded on image model method calls. They measure the time spent on method completion and propagate the related tracing information.

<table class="tableblock frame-all grid-all stripes-even stretch">
<caption>Table 11. Low Cardinality Keys</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Name</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.operation.name</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The name of the operation being performed.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.system</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The model provider as identified by the client instrumentation.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.request.model</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The name of the model a request is being made to.</p>
</div>
</div></td>
</tr>
</tbody>
</table>

<table class="tableblock frame-all grid-all stripes-even stretch">
<caption>Table 12. High Cardinality Keys</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Name</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.request.image.response_format</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The format in which the generated image is returned.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.request.image.size</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The size of the image to generate (e.g. <code>1024x1024</code>).</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>gen_ai.request.image.style</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The style of the image to generate.</p>
</div>
</div></td>
</tr>
</tbody>
</table>

### Image Prompt Data

The image prompt data is typically big and possibly containing sensitive information. For those reasons, it is not exported by default.

Spring AI supports logging image prompt data, useful for troubleshooting scenarios. When tracing is available, the logs will include trace information for better correlation.

<table class="tableblock frame-all grid-all stripes-even stretch" style="width:100%;">
<colgroup>
<col style="width: 60%" />
<col style="width: 30%" />
<col style="width: 10%" />
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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.image.observations.log-prompt</code></p></td>
<td class="tableblock halign-left valign-top"><p>Log the image prompt content. <code>true</code> or <code>false</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
</tbody>
</table>

## Vector Stores

All vector store implementations in Spring AI are instrumented to provide metrics and distributed tracing data through Micrometer.

The `db.vector.client.operation` observations are recorded when interacting with the Vector Store. They measure the time spent on the `query`, `add` and `remove` operations and propagate the related tracing information.

<table class="tableblock frame-all grid-all stripes-even stretch">
<caption>Table 13. Low Cardinality Keys</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Name</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>db.operation.name</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The name of the operation or command being executed. One of <code>add</code>, <code>delete</code>, or <code>query</code>.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>db.system</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The database management system (DBMS) product as identified by the client instrumentation. One of <code>pg_vector</code>, <code>azure</code>, <code>cassandra</code>, <code>chroma</code>, <code>elasticsearch</code>, <code>milvus</code>, <code>neo4j</code>, <code>opensearch</code>, <code>qdrant</code>, <code>redis</code>, <code>typesense</code>, <code>weaviate</code>, <code>pinecone</code>, <code>oracle</code>, <code>mongodb</code>, <code>gemfire</code>, <code>simple</code>.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>spring.ai.kind</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The kind of framework API in Spring AI: <code>vector_store</code>.</p>
</div>
</div></td>
</tr>
</tbody>
</table>

<table class="tableblock frame-all grid-all stripes-even stretch">
<caption>Table 14. High Cardinality Keys</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Name</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>db.collection.name</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The name of a collection (table, container) within the database.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>db.namespace</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The name of the database, fully qualified within the server address and port.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>db.search.similarity_metric</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The metric used in similarity search.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>db.vector.dimension_count</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The dimension of the vector.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>db.vector.field_name</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The name field as of the vector (e.g. a field name).</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>db.vector.query.content</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The content of the search query being executed.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>db.vector.query.filter</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The metadata filters used in the search query.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>db.vector.query.response.documents</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>Returned documents from a similarity search query. Optional.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>db.vector.query.similarity_threshold</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>Similarity threshold that accepts all search scores. A threshold value of 0.0 means any similarity is accepted or disable the similarity threshold filtering. A threshold value of 1.0 means an exact match is required.</p>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><div>
<div>
<p><code>db.vector.query.top_k</code></p>
</div>
</div></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>The top-k most similar vectors returned by a query.</p>
</div>
</div></td>
</tr>
</tbody>
</table>

### Response Data

The vector search response data is typically big and possibly containing sensitive information. For those reasons, it is not exported by default.

Spring AI supports logging vector search response data, useful for troubleshooting scenarios. When tracing is available, the logs will include trace information for better correlation.

<table class="tableblock frame-all grid-all stripes-even stretch" style="width:100%;">
<colgroup>
<col style="width: 60%" />
<col style="width: 30%" />
<col style="width: 10%" />
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
<td class="tableblock halign-left valign-top"><p><code>spring.ai.vectorstore.observations.log-query-response</code></p></td>
<td class="tableblock halign-left valign-top"><p>Log the vector store query response content. <code>true</code> or <code>false</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>false</code></p></td>
</tr>
</tbody>
</table>

## More Metrics Reference

This section documents the metrics emitted by Spring AI components as they appear in Prometheus.

### Metric Naming Conventions

Spring AI uses Micrometer. Base metric names use dots (e.g., `gen_ai.client.operation`), which Prometheus exports with underscores and standard suffixes:

- **Timers** → `<base>_seconds_count`, `<base>_seconds_sum`, `<base>_seconds_max`, and (when supported) `<base>_active_count`

- **Counters** → `<base>_total` (monotonic)

#### References

- OpenTelemetry — Semantic Conventions for Generative AI (overview)

- Micrometer — Naming Meters

### Chat Client Metrics

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 12%" />
<col style="width: 37%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Metric Name</th>
<th class="tableblock halign-left valign-top">Type</th>
<th class="tableblock halign-left valign-top">Unit</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>gen_ai_chat_client_operation_seconds_sum</code></p></td>
<td class="tableblock halign-left valign-top"><p>Timer</p></td>
<td class="tableblock halign-left valign-top"><p>seconds</p></td>
<td class="tableblock halign-left valign-top"><p>Total time spent in ChatClient operations (call/stream)</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>gen_ai_chat_client_operation_seconds_count</code></p></td>
<td class="tableblock halign-left valign-top"><p>Counter</p></td>
<td class="tableblock halign-left valign-top"><p>count</p></td>
<td class="tableblock halign-left valign-top"><p>Number of completed ChatClient operations</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>gen_ai_chat_client_operation_seconds_max</code></p></td>
<td class="tableblock halign-left valign-top"><p>Gauge</p></td>
<td class="tableblock halign-left valign-top"><p>seconds</p></td>
<td class="tableblock halign-left valign-top"><p>Maximum observed duration of ChatClient operations</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>gen_ai_chat_client_operation_active_count</code></p></td>
<td class="tableblock halign-left valign-top"><p>Gauge</p></td>
<td class="tableblock halign-left valign-top"><p>count</p></td>
<td class="tableblock halign-left valign-top"><p>Number of ChatClient operations currently in flight</p></td>
</tr>
</tbody>
</table>

**Active vs Completed**:

active\_count shows in-flight calls; the `_seconds` series reflect only completed calls.

### Chat Model Metrics (Model provider execution)

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 12%" />
<col style="width: 37%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Metric Name</th>
<th class="tableblock halign-left valign-top">Type</th>
<th class="tableblock halign-left valign-top">Unit</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>gen_ai_client_operation_seconds_sum</code></p></td>
<td class="tableblock halign-left valign-top"><p>Timer</p></td>
<td class="tableblock halign-left valign-top"><p>seconds</p></td>
<td class="tableblock halign-left valign-top"><p>Total time executing chat model operations</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>gen_ai_client_operation_seconds_count</code></p></td>
<td class="tableblock halign-left valign-top"><p>Counter</p></td>
<td class="tableblock halign-left valign-top"><p>count</p></td>
<td class="tableblock halign-left valign-top"><p>Number of completed chat model operations</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>gen_ai_client_operation_seconds_max</code></p></td>
<td class="tableblock halign-left valign-top"><p>Gauge</p></td>
<td class="tableblock halign-left valign-top"><p>seconds</p></td>
<td class="tableblock halign-left valign-top"><p>Maximum observed duration for chat model operations</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>gen_ai_client_operation_active_count</code></p></td>
<td class="tableblock halign-left valign-top"><p>Gauge</p></td>
<td class="tableblock halign-left valign-top"><p>count</p></td>
<td class="tableblock halign-left valign-top"><p>Number of chat model operations currently in flight</p></td>
</tr>
</tbody>
</table>

#### Token Usage

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 12%" />
<col style="width: 37%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Metric Name</th>
<th class="tableblock halign-left valign-top">Type</th>
<th class="tableblock halign-left valign-top">Unit</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>gen_ai_client_token_usage_total</code></p></td>
<td class="tableblock halign-left valign-top"><p>Counter</p></td>
<td class="tableblock halign-left valign-top"><p>tokens</p></td>
<td class="tableblock halign-left valign-top"><p>Total tokens consumed, labeled by token type</p></td>
</tr>
</tbody>
</table>

#### Labels

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 40%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Label</th>
<th class="tableblock halign-left valign-top">Meaning</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>gen_ai_token_type=input</code></p></td>
<td class="tableblock halign-left valign-top"><p>Prompt tokens sent to the model</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>gen_ai_token_type=output</code></p></td>
<td class="tableblock halign-left valign-top"><p>Completion tokens returned by the model</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>gen_ai_token_type=total</code></p></td>
<td class="tableblock halign-left valign-top"><p>Input + output</p></td>
</tr>
</tbody>
</table>

### Vector Store Metrics

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 12%" />
<col style="width: 37%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Metric Name</th>
<th class="tableblock halign-left valign-top">Type</th>
<th class="tableblock halign-left valign-top">Unit</th>
<th class="tableblock halign-left valign-top">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>db_vector_client_operation_seconds_sum</code></p></td>
<td class="tableblock halign-left valign-top"><p>Timer</p></td>
<td class="tableblock halign-left valign-top"><p>seconds</p></td>
<td class="tableblock halign-left valign-top"><p>Total time spent in vector store operations (add/delete/query)</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>db_vector_client_operation_seconds_count</code></p></td>
<td class="tableblock halign-left valign-top"><p>Counter</p></td>
<td class="tableblock halign-left valign-top"><p>count</p></td>
<td class="tableblock halign-left valign-top"><p>Number of completed vector store operations</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>db_vector_client_operation_seconds_max</code></p></td>
<td class="tableblock halign-left valign-top"><p>Gauge</p></td>
<td class="tableblock halign-left valign-top"><p>seconds</p></td>
<td class="tableblock halign-left valign-top"><p>Maximum observed duration for vector store operations</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>db_vector_client_operation_active_count</code></p></td>
<td class="tableblock halign-left valign-top"><p>Gauge</p></td>
<td class="tableblock halign-left valign-top"><p>count</p></td>
<td class="tableblock halign-left valign-top"><p>Number of vector store operations currently in flight</p></td>
</tr>
</tbody>
</table>

#### Labels

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 40%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Label</th>
<th class="tableblock halign-left valign-top">Meaning</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p><code>db_operation_name</code></p></td>
<td class="tableblock halign-left valign-top"><p>Operation type (<code>add</code>, <code>delete</code>, <code>query</code>)</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>db_system</code></p></td>
<td class="tableblock halign-left valign-top"><p>Vector DB/provider (<code>redis</code>, <code>chroma</code>, <code>pgvector</code>, …)</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p><code>spring_ai_kind</code></p></td>
<td class="tableblock halign-left valign-top"><p><code>vector_store</code></p></td>
</tr>
</tbody>
</table>

### Understanding Active vs Completed

- **Active (`*_active_count`)** — instantaneous gauge of in-progress operations (concurrency/load).

- **Completed (`*_seconds_sum|count|max`)** — statistics for operations that have finished:

- `_seconds_sum / _seconds_count` → average latency

- `_seconds_max` → high-water mark since last scrape (subject to registry behavior)

S3 Vector Store Development-time Services

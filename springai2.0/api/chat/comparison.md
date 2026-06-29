Search

# Chat Models Comparison

This table compares various Chat Models supported by Spring AI, detailing their capabilities:

- Multimodality: The types of input the model can process (e.g., text, image, audio, video).

- Tools/Function Calling: Whether the model supports function calling or tool use.

- Streaming: If the model offers streaming responses.

- Retry: Support for retry mechanisms.

- Observability: Features for monitoring and debugging.

- Built-in JSON: Native support for JSON output.

- Local deployment: Whether the model can be run locally.

- OpenAI API Compatibility: If the model is compatible with OpenAI’s API.

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 45%" />
<col style="width: 22%" />
<col style="width: 4%" />
<col style="width: 4%" />
<col style="width: 4%" />
<col style="width: 4%" />
<col style="width: 4%" />
<col style="width: 4%" />
<col style="width: 4%" />
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Provider</th>
<th class="tableblock halign-left valign-top">Multimodality</th>
<th class="tableblock halign-center valign-top">Tools/Functions</th>
<th class="tableblock halign-center valign-top">Streaming</th>
<th class="tableblock halign-center valign-top">Retry</th>
<th class="tableblock halign-center valign-top">Observability</th>
<th class="tableblock halign-center valign-top">Built-in JSON</th>
<th class="tableblock halign-center valign-top">Local</th>
<th class="tableblock halign-center valign-top">OpenAI API Compatible</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Anthropic Claude</p></td>
<td class="tableblock halign-left valign-top"><p>text, pdf, image</p></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>DeepSeek (OpenAI-proxy)</p></td>
<td class="tableblock halign-left valign-top"><p>text</p></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Google GenAI</p></td>
<td class="tableblock halign-left valign-top"><p>text, pdf, image, audio, video</p></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Groq (OpenAI-proxy)</p></td>
<td class="tableblock halign-left valign-top"><p>text, image</p></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Mistral AI</p></td>
<td class="tableblock halign-left valign-top"><p>text, image, audio</p></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>MiniMax (Anthropic-proxy)</p></td>
<td class="tableblock halign-left valign-top"><p>text, image</p></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>NVIDIA (OpenAI-proxy)</p></td>
<td class="tableblock halign-left valign-top"><p>text, image</p></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Ollama</p></td>
<td class="tableblock halign-left valign-top"><p>text, image</p></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>OpenAI</p></td>
<td class="tableblock halign-left valign-top"><div>
<div>
<p>In: text, image, audio Out: text, audio</p>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Perplexity (OpenAI-proxy)</p></td>
<td class="tableblock halign-left valign-top"><p>text</p></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Amazon Bedrock Converse</p></td>
<td class="tableblock halign-left valign-top"><p>text, image, video, docs (pdf, html, md, docx …​)</p></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
<td class="tableblock halign-center valign-top"><div>
<div>
<div>
&#10;</div>
</div>
</div></td>
</tr>
</tbody>
</table>

Chat Models Amazon Bedrock Converse

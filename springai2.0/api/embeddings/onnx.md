Search

# Transformers (ONNX) Embeddings

The `TransformersEmbeddingModel` is an `EmbeddingModel` implementation that locally computes sentence embeddings using a selected sentence transformer.

You can use any HuggingFace Embedding model.

It uses pre-trained transformer models, serialized into the Open Neural Network Exchange (ONNX) format.

The Deep Java Library and the Microsoft ONNX Java Runtime libraries are applied to run the ONNX models and compute the embeddings in Java.

## Prerequisites

To run things in Java, we need to **serialize the Tokenizer and the Transformer Model** into `ONNX` format.

Serialize with optimum-cli - One, quick, way to achieve this, is to use the optimum-cli command line tool. The following snippet prepares a python virtual environment, installs the required packages and serializes (e.g. exports) the specified model using `optimum-cli` :

    python3 -m venv venv
    source ./venv/bin/activate
    (venv) pip install --upgrade pip
    (venv) pip install optimum onnx onnxruntime sentence-transformers
    (venv) optimum-cli export onnx --model sentence-transformers/all-MiniLM-L6-v2 onnx-output-folder

The snippet exports the sentence-transformers/all-MiniLM-L6-v2 transformer into the `onnx-output-folder` folder. The latter includes the `tokenizer.json` and `model.onnx` files used by the embedding model.

In place of the all-MiniLM-L6-v2 you can pick any huggingface transformer identifier or provide direct file path.

## Auto-configuration

Spring AI provides Spring Boot auto-configuration for the ONNX Transformer Embedding Model. To enable it add the following dependency to your project’s Maven `pom.xml` file:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-transformers</artifactId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-model-transformers'
    }

To configure it, use the `spring.ai.embedding.transformer.*` properties.

For example, add this to your *application.properties* file to configure the client with the intfloat/e5-small-v2 text embedding model:

    spring.ai.embedding.transformer.onnx.model-uri=https://huggingface.co/intfloat/e5-small-v2/resolve/main/model.onnx
    spring.ai.embedding.transformer.tokenizer.uri=https://huggingface.co/intfloat/e5-small-v2/raw/main/tokenizer.json

The complete list of supported properties are:

### Embedding Properties

<table class="tableblock frame-all grid-all stripes-even stretch">
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
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
<td class="tableblock halign-left valign-top"><p>spring.ai.embedding.transformer.enabled (Removed and no longer valid)</p></td>
<td class="tableblock halign-left valign-top"><p>Enable the Transformer Embedding model.</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.model.embedding</p></td>
<td class="tableblock halign-left valign-top"><p>Enable the Transformer Embedding model.</p></td>
<td class="tableblock halign-left valign-top"><p>transformers</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.embedding.transformer.tokenizer.uri</p></td>
<td class="tableblock halign-left valign-top"><p>URI of a pre-trained HuggingFaceTokenizer created by the ONNX engine (e.g. tokenizer.json).</p></td>
<td class="tableblock halign-left valign-top"><p>onnx/all-MiniLM-L6-v2/tokenizer.json</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.embedding.transformer.tokenizer.options</p></td>
<td class="tableblock halign-left valign-top"><p>HuggingFaceTokenizer options such as ‘addSpecialTokens’, ‘modelMaxLength’, ‘truncation’, ‘padding’, ‘maxLength’, ‘stride’, ‘padToMultipleOf’. Leave empty to fallback to the defaults.</p></td>
<td class="tableblock halign-left valign-top"><p>empty</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.embedding.transformer.cache.enabled</p></td>
<td class="tableblock halign-left valign-top"><p>Enable remote Resource caching.</p></td>
<td class="tableblock halign-left valign-top"><p>true</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.embedding.transformer.cache.directory</p></td>
<td class="tableblock halign-left valign-top"><p>Directory path to cache remote resources, such as the ONNX models</p></td>
<td class="tableblock halign-left valign-top"><p>${java.io.tmpdir}/spring-ai-onnx-model</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.embedding.transformer.onnx.model-uri</p></td>
<td class="tableblock halign-left valign-top"><p>Existing, pre-trained ONNX model.</p></td>
<td class="tableblock halign-left valign-top"><p>onnx/all-MiniLM-L6-v2/model.onnx</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.embedding.transformer.onnx.model-output-name</p></td>
<td class="tableblock halign-left valign-top"><p>The ONNX model’s output node name, which we’ll use for embedding calculation.</p></td>
<td class="tableblock halign-left valign-top"><p>last_hidden_state</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.embedding.transformer.onnx.gpu-device-id</p></td>
<td class="tableblock halign-left valign-top"><p>The GPU device ID to execute on. Only applicable if &gt;= 0. Ignored otherwise.(Requires additional onnxruntime_gpu dependency)</p></td>
<td class="tableblock halign-left valign-top"><p>-1</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>spring.ai.embedding.transformer.metadata-mode</p></td>
<td class="tableblock halign-left valign-top"><p>Specifies what parts of the Documents content and metadata will be used for computing the embeddings.</p></td>
<td class="tableblock halign-left valign-top"><p>NONE</p></td>
</tr>
</tbody>
</table>

### Errors and special cases

## Manual Configuration

If you are not using Spring Boot, you can manually configure the Onnx Transformers Embedding Model. For this add the `spring-ai-transformers` dependency to your project’s Maven `pom.xml` file:

    <dependency>
      <groupId>org.springframework.ai</groupId>
      <artifactId>spring-ai-transformers</artifactId>
    </dependency>

then create a new `TransformersEmbeddingModel` instance and use the `setTokenizerResource(tokenizerJsonUri)` and `setModelResource(modelOnnxUri)` methods to set the URIs of the exported `tokenizer.json` and `model.onnx` files. (`classpath:`, `file:` or `https:` URI schemas are supported).

If the model is not explicitly set, `TransformersEmbeddingModel` defaults to sentence-transformers/all-MiniLM-L6-v2:

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Dimensions</p></td>
<td class="tableblock halign-left valign-top"><p>384</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Avg. performance</p></td>
<td class="tableblock halign-left valign-top"><p>58.80</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Speed</p></td>
<td class="tableblock halign-left valign-top"><p>14200 sentences/sec</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>Size</p></td>
<td class="tableblock halign-left valign-top"><p>80MB</p></td>
</tr>
</tbody>
</table>

The following snippet illustrates how to use the `TransformersEmbeddingModel` manually:

    TransformersEmbeddingModel embeddingModel = new TransformersEmbeddingModel();

    // (optional) defaults to classpath:/onnx/all-MiniLM-L6-v2/tokenizer.json
    embeddingModel.setTokenizerResource("classpath:/onnx/all-MiniLM-L6-v2/tokenizer.json");

    // (optional) defaults to classpath:/onnx/all-MiniLM-L6-v2/model.onnx
    embeddingModel.setModelResource("classpath:/onnx/all-MiniLM-L6-v2/model.onnx");

    // (optional) defaults to ${java.io.tmpdir}/spring-ai-onnx-model
    // Only the http/https resources are cached by default.
    embeddingModel.setResourceCacheDirectory("/tmp/onnx-zoo");

    // (optional) Set the tokenizer padding if you see an errors like:
    // "ai.onnxruntime.OrtException: Supplied array is ragged, ..."
    embeddingModel.setTokenizerOptions(Map.of("padding", "true"));

    embeddingModel.afterPropertiesSet();

    List<List<Double>> embeddings = this.embeddingModel.embed(List.of("Hello world", "World is big"));

The first `embed()` call downloads the large ONNX model and caches it on the local file system. Therefore, the first call might take longer than usual. Use the `#setResourceCacheDirectory(<path>)` method to set the local folder where the ONNX models as stored. The default cache folder is `${java.io.tmpdir}/spring-ai-onnx-model`.

It is more convenient (and preferred) to create the TransformersEmbeddingModel as a `Bean`. Then you don’t have to call the `afterPropertiesSet()` manually.

    @Bean
    public EmbeddingModel embeddingModel() {
       return new TransformersEmbeddingModel();
    }

Ollama OpenAI

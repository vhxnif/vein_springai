Search

# Amazon Bedrock

Amazon Bedrock is a managed service that provides foundation models from various AI providers, available through a unified API.

Spring AI supports the Embedding AI models available through Amazon Bedrock by implementing the Spring `EmbeddingModel` interface.

Additionally, Spring AI provides Spring Auto-Configurations and Boot Starters for all clients, making it easy to bootstrap and configure for the Bedrock models.

## Getting Started

There are a few steps to get started

- Add the Spring Boot starter for Bedrock to your project.

- Obtain AWS credentials: If you don’t have an AWS account and AWS CLI configured yet, this video guide can help you configure it: AWS CLI & SDK Setup in Less Than 4 Minutes!. You should be able to obtain your access and security keys.

- Enable the Models to use: Go to Amazon Bedrock and from the Model Access menu on the left, configure access to the models you are going to use.

### Project Dependencies

Then add the Spring Boot Starter dependency to your project’s Maven `pom.xml` build file:

    <dependency>
     <artifactId>spring-ai-starter-model-bedrock</artifactId>
     <groupId>org.springframework.ai</groupId>
    </dependency>

or to your Gradle `build.gradle` build file.

    dependencies {
        implementation 'org.springframework.ai:spring-ai-starter-model-bedrock'
    }

### Connect to AWS Bedrock

Use the `BedrockAwsConnectionProperties` to configure AWS credentials and region:

    spring.ai.bedrock.aws.region=us-east-1

    spring.ai.bedrock.aws.access-key=YOUR_ACCESS_KEY
    spring.ai.bedrock.aws.secret-key=YOUR_SECRET_KEY

    spring.ai.bedrock.aws.profile.name=YOUR_PROFILE_NAME
    spring.ai.bedrock.aws.profile.credentials-path=YOUR_CREDENTIALS_PATH
    spring.ai.bedrock.aws.profile.configuration-path=YOUR_CONFIGURATION_PATH

    spring.ai.bedrock.aws.timeout=10m

The `region` property is compulsory.

AWS credentials are resolved in the following order:

1.  Spring-AI Bedrock `spring.ai.bedrock.aws.access-key` and `spring.ai.bedrock.aws.secret-key` properties.

2.  Spring-AI Bedrock `spring.ai.bedrock.aws.profile.name`, If `spring.ai.bedrock.aws.profile.credentials-path` and `spring.ai.bedrock.aws.profile.configuration-path` are not specified, Spring AI use the standard AWS shared files: `~/.aws/credentials` for credentials and `~/.aws/config` for configuration.

3.  Java System Properties - `aws.accessKeyId` and `aws.secretAccessKey`.

4.  Environment Variables - `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.

5.  Web Identity Token credentials from system properties or environment variables.

6.  Credential profiles file at the default location (`~/.aws/credentials`) shared by all AWS SDKs and the AWS CLI.

7.  Credentials delivered through the Amazon EC2 container service if the `AWS_CONTAINER_CREDENTIALS_RELATIVE_URI` environment variable is set and the security manager has permission to access the variable.

8.  Instance profile credentials delivered through the Amazon EC2 metadata service or set the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables.

AWS region is resolved in the following order:

1.  Spring-AI Bedrock `spring.ai.bedrock.aws.region` property.

2.  Java System Properties - `aws.region`.

3.  Environment Variables - `AWS_REGION`.

4.  Credential profiles file at the default location (`~/.aws/credentials`) shared by all AWS SDKs and the AWS CLI.

5.  Instance profile region delivered through the Amazon EC2 metadata service.

In addition to the standard Spring-AI Bedrock credentials and region properties configuration, Spring-AI provides support for custom `AwsCredentialsProvider` and `AwsRegionProvider` beans.

### Enable selected Bedrock model

Here are the supported \`&lt;model-name&gt;\`s:

<table class="tableblock frame-all grid-all stretch">
<colgroup>
<col style="width: 100%" />
</colgroup>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p>Model</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>bedrock-cohere</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p>bedrock-titan (no batch support yet)</p></td>
</tr>
</tbody>
</table>

For example, to enable the Bedrock Cohere embedding model, you need to set `spring.ai.model.embedding=bedrock-cohere`.

Next, you can use the `spring.ai.bedrock.<model>.embedding.*` properties to configure each model as provided.

For more information, refer to the documentation below for each supported model.

- Spring AI Bedrock Cohere Embeddings: `spring.ai.model.embedding=bedrock-cohere`

- Spring AI Bedrock Titan Embeddings: `spring.ai.model.embedding=bedrock-titan`

Embedding Models Cohere

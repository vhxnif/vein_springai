Search

# Spring AI API

## Introduction

The Spring AI API covers a wide range of functionalities. Each major feature is detailed in its own dedicated section. To provide an overview, the following key functionalities are available:

### AI Model API

Portable `Model API` across AI providers for `Chat`, `Text to Image`, `Audio Transcription`, `Text to Speech`, and `Embedding` models. Both `synchronous` and `stream` API options are supported. Dropping down to access model specific features is also supported.

With support for AI Models from OpenAI, Microsoft, Amazon, Google, Amazon Bedrock and more.

### Vector Store API

Portable `Vector Store API` across multiple providers, including a novel `SQL-like metadata filter API` that is also portable. Support for many vector databases is available.

### Tool Calling API

Spring AI makes it easy to have the AI model invoke your services as `@Tool`-annotated methods or POJO `java.util.Function` objects.

Check the Spring AI Tool Calling documentation.

### ChatClient API

The ChatClient API offers a fluent API for communicating with an AI Model, idiomatic to Spring developers and similar to `WebClient` or `RestClient`.

### Advisors API

The Advisors API encapsulates recurring Generative AI patterns, transforms data sent to and from Language Models (LLMs), and provides portability across various models and use cases (e.g., memory, tool-calling, RAG).

### MCP (Model Context Protocol)

MCP (Model Context Protocol) - Seamless integration for building AI applications that consume MCP servers or expose Spring-based services to the AI ecosystem.

### Auto Configuration

Spring Boot Auto Configuration and Starters for AI Models and Vector Stores.

### ETL Data Engineering

ETL framework for Data Engineering. This provides the basis of loading data into a vector database, helping implement the Retrieval Augmented Generation pattern that enables you to bring your data to the AI model to incorporate into its response.

## Feedback and Contributions

The project’s GitHub discussions is a great place to send feedback.

Multimodality Chat Models

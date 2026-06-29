Search

# Getting Started with Model Context Protocol (MCP)

The Model Context Protocol (MCP) standardizes how AI applications interact with external tools and resources.

Spring joined the MCP ecosystem early as a key contributor, helping to develop and maintain the official MCP Java SDK that serves as the foundation for Java-based MCP implementations. Building on this contribution, Spring AI provides MCP support through Boot Starters and annotations, making it easy to build both MCP servers and clients.

## Introduction Video

**Introduction to Model Context Protocol (MCP) - YouTube**

Start here for an introductory overview of the Model Context Protocol, explaining core concepts and architecture.

## Complete Tutorial and Source Code

**📖 Blog Tutorial:** Connect Your AI to Everything

**💻 Complete Source Code:** MCP Weather Example Repository

The tutorial covers the essentials of MCP development with Spring AI, including advanced features, and deployment patterns. All code examples below are taken from this tutorial.

## Quick Start

The fastest way to get started is with Spring AI’s annotation-based approach. The following examples are from the blog tutorial:

### Simple MCP Server

    @Service
    public class WeatherService {

        @McpTool(description = "Get current temperature for a location")
        public String getTemperature(
                @McpToolParam(description = "City name", required = true) String city) {
            return String.format("Current temperature in %s: 22°C", city);
        }
    }

Add the dependency and configure:

    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-mcp-server-webmvc</artifactId>
    </dependency>

    spring.ai.mcp.server.protocol=STREAMABLE

### Simple MCP Client

    @Bean
    public CommandLineRunner demo(ChatClient chatClient, ToolCallbackProvider mcpTools) {
        return args -> {
            String response = chatClient
                .prompt("What's the weather like in Paris?")
                .tools(mcpTools)
                .call()
                .content();
            System.out.println(response);
        };
    }

Add the dependency and configure:

    <dependency>
      <groupId>org.springframework.ai</groupId>
      <artifactId>spring-ai-starter-mcp-client</artifactId>
    </dependency>

    spring:
      ai:
        mcp:
          client:
            streamable-http:
              connections:
                weather-server:
                  url: http://localhost:8080

## Learning Resources

### Implementation Video

**Spring AI Model Context Protocol (MCP) Integration - YouTube**

A video walkthrough of Spring AI’s MCP integration, covering both server and client implementations.

## Additional Examples Repository

Beyond the tutorial examples, the Spring AI Examples repository contains numerous MCP implementations.

### Recommended Starting Points

**Annotation-based examples**

- Complete Annotations Example - All annotation features (Client & Server)

- Sampling with Annotations - Advanced bidirectional AI (Client & Server)

- MCP Weather Tutorial - Full tutorial source code (Client & Server)

### By Use Case

**Weather Services:**

- WebFlux Weather Server

- OAuth2 Secured Weather Server

**Data Integration:**

- SQLite AI Chatbot

- Filesystem Access Server

**Web Integration:**

- Brave Search Chatbot

**Client Examples:**

- Basic MCP Client

- Annotations Client

## Community Resources

- Awesome Spring AI - Community examples and resources

- Official MCP Specification

- Official MCP Java SDK - Java SDK developed by the Spring team

- MCP Java SDK Documentation

## Reference Documentation

- MCP Overview and Architecture

- MCP Annotations Guide

- Server Boot Starters

- Client Boot Starters

Testcontainers Dynamic Tool Discovery

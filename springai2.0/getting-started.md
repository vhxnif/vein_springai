Search

# Getting Started

This section offers jumping off points for how to get started using Spring AI.

You should follow the steps in each of the following sections according to your needs.

## Spring Initializr

Head on over to start.spring.io and select the AI Models and Vector Stores that you want to use in your new applications.

## Artifact Repositories

### Releases - Use Maven Central

Spring AI artifacts are available in Maven Central. No additional repository configuration is required. Just make sure you have Maven Central enabled in your build file.

### Snapshots - Add Snapshot Repositories

To use the latest development versions (e.g. `2.0.0-SNAPSHOT`), you need to add the following snapshot repositories in your build file.

Add the following repository definitions to your Maven or Gradle build file:

**NOTE:** When using Maven with Spring AI snapshots, pay attention to your Maven mirror configuration. If you have configured a mirror in your `settings.xml` like this:

    <mirror>
        <id>my-mirror</id>
        <mirrorOf>*</mirrorOf>
        <url>https://my-company-repository.com/maven</url>
    </mirror>

The wildcard `*` will redirect all repository requests to your mirror, preventing access to Spring snapshot repositories. To fix this, modify the `mirrorOf` configuration to exclude Spring repositories:

    <mirror>
        <id>my-mirror</id>
        <mirrorOf>*,!spring-snapshots,!central-portal-snapshots</mirrorOf>
        <url>https://my-company-repository.com/maven</url>
    </mirror>

This configuration allows Maven to access Spring snapshot repositories directly while still using your mirror for other dependencies.

## Dependency Management

The Spring AI Bill of Materials (BOM) declares the recommended versions of all the dependencies used by a given release of Spring AI. This is a BOM-only version and it just contains dependency management and no plugin declarations or direct references to Spring or Spring Boot. You can use the Spring Boot parent POM, or use the BOM from Spring Boot (`spring-boot-dependencies`) to manage Spring Boot versions.

Add the BOM to your project:

## Add dependencies for specific components

Each of the following sections in the documentation shows which dependencies you need to add to your project build system.

- Chat Models

- Embeddings Models

- Image Generation Models

- Transcription Models

- Text-To-Speech (TTS) Models

- Vector Databases

## Spring AI samples

Please refer to this page for more resources and samples related to Spring AI.

AI Concepts Chat Client API

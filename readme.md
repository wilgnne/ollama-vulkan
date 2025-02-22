# Dockerized Ollama with Vulkan Backend Support

[![Docker](https://github.com/wilgnne/ollama-vulkan/actions/workflows/docker-publish.yml/badge.svg?branch=main)](https://github.com/wilgnne/ollama-vulkan/actions/workflows/docker-publish.yml)

This project provides a Docker image and a sample `docker-compose.yml` configuration for running Ollama with Vulkan as the backend for executing LLM models. The setup ensures the necessary paths and dependencies are correctly configured to leverage Vulkan for optimized model execution.

## Motivation

Leveraging Vulkan for LLM model execution allows for improved performance on compatible hardware, providing a more efficient and scalable way to run machine learning workloads. This setup is designed to facilitate easy deployment and testing of Ollama with Vulkan support in a containerized environment.

## Features

- Pre-configured Docker image for Ollama with Vulkan support.
- Sample `docker-compose.yml` for quick deployment.
- Hardware acceleration via Vulkan for enhanced performance.
- Integration with Open WebUI for an accessible user interface.

## Getting Started

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- A Vulkan-compatible GPU and drivers installed on the host machine.

### Installation & Usage

#### Clone the Repository

```sh
git clone https://github.com/your-repo/ollama-vulkan-docker.git
cd ollama-vulkan-docker
```

#### Use Prebuilt Docker Image

A prebuilt Docker image is available at:

```sh
docker pull ghcr.io/wilgnne/ollama-vulkan
```

#### Build and Run with Docker Compose

```sh
docker-compose up -d --build
```

This command will build the Ollama Vulkan image and start the services, exposing the Ollama API on port `11434` and the WebUI on `8080`.

#### Accessing the Services

- Ollama API: `http://localhost:11434`
- Open WebUI: `http://localhost:8080`

### Configuration Options

#### Environment Variables

| Variable            | Default Value  | Description |
|---------------------|---------------|-------------|
| `OLLAMA_HOST`      | `0.0.0.0`      | Ollama API bind address |
| `WEBUI_AUTH`       | `False`        | Disable authentication for WebUI |
| `WEBUI_URL`        | `http://localhost:8080` | WebUI service URL |

#### GPU Access Considerations

- Ensure your user is part of the `video` group to allow Vulkan access.
- Modify the `group_add` entry in `docker-compose.yml` to match your system’s render group ID.
- If experiencing GPU detection issues, try running the container with `privileged: true` enabled.

### Stopping the Services

To stop and remove all running containers:

```sh
docker-compose down
```

## Contributing

Special thanks to the following contributors:

- [whyvl](https://github.com/whyvl) for the contribution to the Ollama Vulkan backend.
- [Dts0](https://github.com/Dts0) for the build patches.

Contributions are welcome! Feel free to submit pull requests or open issues to enhance the functionality or fix any bugs.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

FROM ubuntu:24.04 AS base

WORKDIR /root
ENV DEBIAN_FRONTEND=noninteractive
ENV CGO_ENABLED=1
ENV LDFLAGS=-s

# Install dependencies
RUN apt update \
    && apt install -y git cmake wget libcap-dev golang-go

# Install vulkan-sdk
RUN wget -qO- https://packages.lunarg.com/lunarg-signing-key-pub.asc | tee /etc/apt/trusted.gpg.d/lunarg.asc \
    && wget -qO /etc/apt/sources.list.d/lunarg-vulkan-noble.list http://packages.lunarg.com/vulkan/lunarg-vulkan-noble.list \
    && apt update \
    && apt install -y vulkan-sdk

# Download ollama-vulkan
RUN git config --global user.email "ollama.vulkan@email.com" \
    && git config --global user.name "ollama-vulkan" \
    && git clone -b vulkan https://github.com/whyvl/ollama-vulkan.git \
    && cd ollama-vulkan \
    && git remote add ollama_vanilla https://github.com/ollama/ollama.git \
    && git fetch ollama_vanilla --tags \
    && git checkout tags/v0.5.11 -b ollama_vanilla_stable \
    && git checkout vulkan \
    && git merge ollama_vanilla_stable --allow-unrelated-histories --no-edit

# Apply patches
COPY patches /tmp/patches
RUN bash -c 'for patch in /tmp/patches/*.patch; do \
    cd /root/ollama-vulkan && patch -p1 -N -i "$patch" || true; \
    done'

# Build ollama-vulkan
RUN cd /root/ollama-vulkan \
    && cmake --preset CPU \
    && cmake --build --parallel --preset CPU \
    && cmake --install build --component CPU --strip \
    && cmake --preset Vulkan \
    && cmake --build --parallel --preset Vulkan \
    && cmake --install build --component Vulkan --strip \
    && . scripts/env.sh \
    && mkdir -p dist/bin \
    && go build \
    -ldflags "-w -s -X github.com/ollama/ollama/version.Version=0.1.44-29-g35ae589-dirty -X github.com/ollama/ollama/server.mode=release" \
    -trimpath \
    -buildmode=pie \
    -o dist/bin/ollama .

# Build final image
FROM ubuntu:24.04

ENV OLLAMA_HOST=0.0.0.0
ENV CAP_PERFMON=1

RUN apt-get update && \
    apt-get install -y libcap2 libxext6 libvulkan1 libvulkan-dev vulkan-tools

COPY --from=base /root/ollama-vulkan/dist/lib/ollama/ /lib/ollama/
COPY --from=base /root/ollama-vulkan/dist/lib/ollama/vulkan/ /lib/ollama/vulkan/
COPY --from=base /root/ollama-vulkan/dist/bin/ /bin/

EXPOSE 11434
CMD ["ollama", "serve"]

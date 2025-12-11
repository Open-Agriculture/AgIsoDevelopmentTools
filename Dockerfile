FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y \
        llvm-18-dev \
        clang-18 \
        libclang-18-dev \
        clang-tidy \
        cmake make g++ git

# Clone and build plugin
COPY builder/clone_and_build.sh /builder.sh
RUN chmod +x /builder.sh && /builder.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

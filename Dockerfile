FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y \
        clang clang-tidy clang-tools \
        cmake make g++ git

# Clone AgIsoDevelopmentTools and build the plugin
COPY builder/clone_and_build.sh /builder.sh
RUN chmod +x /builder.sh && /builder.sh

# Entry point
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

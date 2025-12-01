FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y \
        llvm-18-dev \
        clang-18 \
        libclang-18-dev \
        cmake make g++ git

# clang symlinkek (clang-tidy is)
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-18 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-18 100 && \
    update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-18 100

# Clone and build plugin
COPY builder/clone_and_build.sh /builder.sh
RUN chmod +x /builder.sh && /builder.sh

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

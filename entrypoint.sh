#!/bin/bash
set -e

SRC_DIR="${INPUT_PATH:-.}"

echo "Running clang-tidy with std-prefix plugin..."
clang-tidy \
    -load=/usr/local/lib/libclangTidyStdPrefixPlugin.so \
    $(find "$SRC_DIR" -name "*.cpp" -o -name "*.h")

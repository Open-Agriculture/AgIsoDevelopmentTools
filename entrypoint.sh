#!/bin/bash
set -e

SRC_DIR="${INPUT_PATH:-.}"

echo "Running clang-tidy with std-prefix plugin..."
clang-tidy \
    -load=/usr/local/lib/clangTidyStdPrefixPlugin.so \
    $(find "$SRC_DIR" -name "*.cpp" -o -name "*.h")

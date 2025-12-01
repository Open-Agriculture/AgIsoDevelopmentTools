#!/bin/bash
set -e

echo "Cloning AgIsoDevelopmentTools..."
git clone https://github.com/Open-Agriculture/AgIsoDevelopmentTools.git /src

echo "Building clang-tidy-std-prefix plugin..."
cd /src/clang-tidy-std-prefix

cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --target clangTidyStdPrefix

# Move the .so to system location
cp build/*.so /usr/local/lib/

echo "Plugin installed to /usr/local/lib"

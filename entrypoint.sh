#!/bin/bash
echo "Running clang-tidy with std-prefix plugin..."

cd /github/workspace

CHANGED_FILES=$(git diff --name-only HEAD~1 HEAD | grep -E "\.(c|cc|cpp|h|hpp)$" || true)

if [ -z "$CHANGED_FILES" ]; then
    echo "No changed source files. Nothing to analyze."
    exit 0
fi

echo "Files to check:"
echo "$CHANGED_FILES"

# 2) Run clang-tidy on each changed file
EXIT_CODE=0

for FILE in $CHANGED_FILES; do
    echo "---------------------------------------------------------"
    echo "Checking: $FILE"
    echo "---------------------------------------------------------"

    clang-tidy-18 \
        -load=/usr/local/lib/libclangTidyStdPrefixPlugin.so \
        -checks=-*,std-prefix-fixed-int \
        "$FILE" -- -std=c++17 || EXIT_CODE=$?
done

exit $EXIT_CODE

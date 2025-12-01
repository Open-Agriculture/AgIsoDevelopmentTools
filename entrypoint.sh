#!/bin/bash
set -e

echo "Running clang-tidy with std-prefix plugin..."
cd /github/workspace

if [ "$GITHUB_EVENT_NAME" = "pull_request" ]; then
    echo "Pull request detected."
    BASE_SHA="$GITHUB_BASE_SHA"
    HEAD_SHA="$GITHUB_HEAD_SHA"
    CHANGED_FILES=$(git diff --name-only "$BASE_SHA" "$HEAD_SHA" | grep -E "\.(c|cc|cpp|h|hpp)$" || true)
else
    echo "Push or other event detected."
    CHANGED_FILES=$(git diff --name-only HEAD^ HEAD | grep -E "\.(c|cc|cpp|h|hpp)$" || true)
fi

if [ -z "$CHANGED_FILES" ]; then
    echo "No changed source files. Nothing to analyze."
    exit 0
fi

echo "Files to check:"
echo "$CHANGED_FILES"

EXIT_CODE=0

for FILE in $CHANGED_FILES; do
    echo "---------------------------------------------------------"
    echo "Checking: $FILE"
    echo "---------------------------------------------------------"

    clang-tidy \
        -load=/usr/local/lib/libclangTidyStdPrefixPlugin.so \
        -checks=-*,std-prefix-fixed-int \
        "$FILE" -- -std=c++17 || EXIT_CODE=$?
done

exit $EXIT_CODE

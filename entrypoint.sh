#!/bin/bash
set -e

git config --global --add safe.directory /github/workspace

echo "Running clang-tidy with std-prefix plugin..."
cd /github/workspace

if [ "$GITHUB_EVENT_NAME" = "pull_request" ]; then
    echo "Pull request detected."

    BASE_SHA=$(jq -r '.pull_request.base.sha' "$GITHUB_EVENT_PATH")
    HEAD_SHA=$(jq -r '.pull_request.head.sha' "$GITHUB_EVENT_PATH")

    echo "Base SHA: $BASE_SHA"
    echo "Head SHA: $HEAD_SHA"

    # ---- CRITICAL FIX ----
    echo "Fetching missing commits..."
    git fetch --depth=1 origin "$BASE_SHA"
    git fetch --depth=1 origin "$HEAD_SHA"
    # -----------------------

    CHANGED_FILES=$(git diff --name-only "$BASE_SHA" "$HEAD_SHA" | grep -E "\.(c|cc|cpp|h|hpp)$" || true)

else
    echo "Push or other event detected."

    if git rev-parse HEAD^ >/dev/null 2>&1; then
        CHANGED_FILES=$(git diff --name-only HEAD^ HEAD | grep -E "\.(c|cc|cpp|h|hpp)$" || true)
    else
        echo "No parent commit. Probably initial push — nothing to analyze."
        exit 0
    fi
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

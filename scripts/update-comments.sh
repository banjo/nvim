#!/bin/bash
# update_descriptions.sh

cd "$(git rev-parse --show-toplevel)" || {
  echo "Not a git repo?"
  exit 1
}

echo "Working directory: $(pwd)"

# Find files containing lines with desc =
FILES=$(rg -l "desc =")

PROMPT="I want you to update all desciptions of keymaps that are not clear enough.
- It should be title case
- Remove brackets like [ and ]
- Short and concise
- Make sure to keep the original meaning
- Make it make sense with the keymap
- Remove unnecessary words
- If the description is already good, leave it as is
- If the context is already defined in which-key, do not include it, for example with Aider"

aider --message "$PROMPT" --yes $FILES

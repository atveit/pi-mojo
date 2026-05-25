#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Get the directory of this script to locate the repository root
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$DIR/.."

# Check if a prompt was provided as an argument
if [ -z "$1" ]; then
    echo "❌ Error: Please provide a research prompt."
    echo "Usage: bin/deepresearch.sh \"your custom prompt here\""
    exit 1
fi

# Run the Mojo deep research agent with the custom prompt
mojo -I "$REPO_ROOT/src" -I "$REPO_ROOT/scenarios/scenario_11_deep_researcher" "$REPO_ROOT/scenarios/scenario_11_deep_researcher/scenario_deep_researcher.mojo" --prompt "$1"

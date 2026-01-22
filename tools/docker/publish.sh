#!/bin/bash
set -euo pipefail

SOLUTION_NAME="TirsvadCLI.SitemapGenerator"
declare -a PROJECT_NAMES=("Domain" "Core" "Infrastructure")

exit_code=0

# Ensure we're in workspace containing the solution/repo
cd /workspace || exit 1

find . -type d -name bin -exec rm -rf {} +
find . -type d -name obj -exec rm -rf {} +
find . -type d -name g -exec rm -rf {} +

# Copy solution README.md into each main project directory for NuGet packaging
cp /workspace/README.md /workspace/src/${SOLUTION_NAME}.Domain/README.md
cp /workspace/README.md /workspace/src/${SOLUTION_NAME}.Core/README.md
cp /workspace/README.md /workspace/src/${SOLUTION_NAME}.Infrastructure/README.md

for proj in "${PROJECT_NAMES[@]}";
do
  echo "Packing project: ${SOLUTION_NAME}.${proj}"
  #dotnet restore src/${SOLUTION_NAME}.${proj}/${SOLUTION_NAME}.${proj}.csproj || exit_code=$?
  dotnet pack src/${SOLUTION_NAME}.${proj}/${SOLUTION_NAME}.${proj}.csproj -c Release -o /nuget --include-symbols --include-source || exit_code=$?
done

exit $exit_code

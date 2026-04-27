#!/bin/bash
set -e

# Usage: ./update-helm-values.sh <env> <service_name> <image_repository> <tag>

ENV=$1
SERVICE=$2
REPO=$3
TAG=$4

if [[ -z "$ENV" || -z "$SERVICE" || -z "$REPO" || -z "$TAG" ]]; then
  echo "Usage: $0 <dev|prod> <service_name> <image_repository> <tag>"
  exit 1
fi

VALUES_FILE="charts/${SERVICE}/values-${ENV}.yaml"

if [[ ! -f "$VALUES_FILE" ]]; then
  echo "Error: $VALUES_FILE does not exist."
  exit 1
fi

echo "Updating $VALUES_FILE with $REPO:$TAG..."

# Use yq to update the values while preserving formatting and comments
yq -i ".image.repository = \"${REPO}\" | .image.tag = \"${TAG}\"" "$VALUES_FILE"

# Git commit and push
git config --global user.name "GitHub Actions Bot"
git config --global user.email "actions@github.com"

git add "$VALUES_FILE"

if git diff-index --quiet HEAD; then
  echo "No changes to commit. Image tag is already $TAG."
  exit 0
fi

if [[ "$ENV" == "dev" ]]; then
  git commit -m "chore(dev): update ${SERVICE} image tag to ${TAG}"
else
  git commit -m "chore(prod): release ${SERVICE} ${TAG}"
fi

git push origin main

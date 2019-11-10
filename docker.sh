#!/bin/bash

# Build and tag docker image to fullfil Google Cloud requirements.

set -e

source gcp/settings.sh

docker build -t vertx-server:1.0 .

docker tag vertx-server:1.0 "gcr.io/$PROJECT_NAME/vertx-server:1.0"

docker push "gcr.io/$PROJECT_NAME/vertx-server:1.0"
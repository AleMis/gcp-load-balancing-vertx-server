#!/bin/bash

set -e

source settings.sh

#Create health check for our Manage Instance Group

gcloud compute health-checks create http $HEALTH_CHECK  \
  --project=$PROJECT_NAME \
  --port=8080 \
  --request-path=/ \
  --proxy-header=NONE  \
  --check-interval=5 \
  --timeout=5 \
  --unhealthy-threshold=2 \
  --healthy-threshold=2
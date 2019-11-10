#!/bin/bash

set -e

source settings.sh

# Create backend service
gcloud compute backend-services create $BACKEND_SERVICE \
      --protocol HTTP \
      --port-name http \
      --health-checks $HEALTH_CHECK \
      --global \
      --connection-draining-timeout 120

# Add backend service to MIG
gcloud compute backend-services add-backend $BACKEND_SERVICE \
    --instance-group $MIG_NAME \
    --instance-group-region $REGION \
    --global \
    --max-rate-per-instance 5


gcloud compute url-maps create $URL_MAP \
    --default-service $BACKEND_SERVICE

gcloud compute target-http-proxies create $HTTP_PROXY \
    --url-map $URL_MAP

gcloud compute forwarding-rules create $FORWARDING_RULE \
        --target-http-proxy $HTTP_PROXY \
        --global \
        --ports 8080

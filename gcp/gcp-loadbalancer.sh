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

# Add backend service to MIG. Replicas are created based on RPS per each instance
gcloud compute backend-services add-backend $BACKEND_SERVICE \
    --instance-group $MIG_NAME \
    --instance-group-region $REGION \
    --global \
    --balancing-mode RATE \
    --max-rate-per-instance 5

# Create a default URL map that directs all incoming requests to all your instances
gcloud compute url-maps create $URL_MAP \
    --default-service $BACKEND_SERVICE

# Create a target HTTP proxy to rout requests to your URL map
gcloud compute target-http-proxies create $HTTP_PROXY \
    --url-map $URL_MAP

# Create a global forwarding rule to handle and route incoming requests.
# A forwarding rule sends traffic to a specific target HTTP proxy
# depending on the IP address,
gcloud compute forwarding-rules create $FORWARDING_RULE \
        --target-http-proxy $HTTP_PROXY \
        --global \
        --ports 8080

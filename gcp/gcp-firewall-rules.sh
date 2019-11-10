#!/bin/bash

set -e

source settings.sh

# Create firewall rule for external traffic to our load balancer

gcloud compute --project $PROJECT_NAME firewall-rules create $EXTERNAL_LB_FIREWALL \
    --network default \
    --priority 1000 \
    --direction ingress \
    --action allow \
    --target-tags $NETWORK_TAG \
    --source-ranges 0.0.0.0/0 \
    --rules tcp:8080

# Create firewall rule for healthchecks from load balancer to our MIG

gcloud compute firewall-rules create $INTERNAL_LB_FIREWALL \
    --network default \
    --priority 1000 \
    --direction ingress \
    --action allow \
    --target-tags $NETWORK_TAG \
    --source-ranges 130.211.0.0/22,35.191.0.0/16 \
    --rules tcp:8080


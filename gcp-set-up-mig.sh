#!/bin/bash

set -e

source gcp/settings.sh

# Step 0. Configuration
gcloud config set compute/zone $ZONE
gcloud config set compute/region $REGION

cd gcp

# Step 1. Create instance template
bash gcp-instance-template.sh

# Step 2. Create firewall rules
bash gcp-firewall-rules.sh

# Step 3. Create healthcheck
bash gcp-healthcheck.sh

# Step 4. Create Managed Instance Group
bash gcp-mig.sh

# Step 5. Create HTTP Load Balancer with backend service and forwarding rule
bash gcp-loadbalancer.sh
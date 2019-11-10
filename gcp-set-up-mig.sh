#!/bin/bash

# Step 0. Configuration
gcloud config set compute/zone $ZONE
gcloud config set compute/region $REGION

# Step 1. Create instance template
bash gcp/gcp-instance-tempalate.sh

# Step 2. Create firewall rules
bash gcp/gcp-firewall-rules.sh

# Step 3. Create healthcheck
bash gcp/gcp-healthcheck.sh

# Step 4. Create Managed Instance Group
bash gcp/gcp-mig.sh

# Step 5. Create HTTP Load Balancer with backend service and forwarding rule
bash gcp/gcp-loadbalancer.sh
#!/bin/bash

set -e

source settings.sh

#Create instance template for MIG

gcloud beta compute --project $PROJECT_NAME instance-groups managed create $MIG_NAME \
  --base-instance-name $BASE_INSTANCE_NAME \
  --template $INSTANCE_TEMPLATE \
  --size=1 \
  --region $REGION \
  --instance-redistribution-type PROACTIVE \
  --health-check $HEALTH_CHECK \
  --initial-delay=180

gcloud beta compute --project $PROJECT_NAME instance-groups managed set-autoscaling $MIG_NAME \
  --region $REGION \
  --cool-down-period 60 \
  --max-num-replicas 10 \
  --min-num-replicas 2 \
  --target-load-balancing-utilization 0.70

gcloud beta compute --project $PROJECT_NAME instance-groups managed set-named-ports $MIG_NAME \
  --named-ports http:8080 \
  --region $REGION
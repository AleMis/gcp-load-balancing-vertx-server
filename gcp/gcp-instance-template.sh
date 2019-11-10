#!/bin/bash

set -e

source settings.sh

#Create instance template for MIG

gcloud compute --project $PROJECT_NAME instance-templates create-with-container $INSTANCE_TEMPLATE \
  --container-image $CONTAINER_IMAGE \
  --machine-type n1-standard-1 \
  --tags=$NETWORK_TAG,http-server \
  --image cos-beta-67-10575-13-0 \
  --image-project cos-cloud
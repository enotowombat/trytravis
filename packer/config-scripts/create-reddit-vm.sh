#!/bin/bash
set -e
gcloud compute instances create reddit-app-new \
--image-family=reddit-full \
--machine-type=g1-small \
--tags "puma-server","http-server","https-server" \
--restart-on-failure \
--zone=europe-west1-b 
gcloud compute instances start projects/infra-188820/zones/europe-west1-b/instances/reddit-app-new


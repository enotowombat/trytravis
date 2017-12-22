#!/bin/bash
set -e
gcloud compute instances create reddit-app-new \
--image-family=reddit-full \
--machine-type=g1-small \
--tags "puma-server","http-server","https-server" \
--restart-on-failure \
--zone=europe-west1-b 
gcloud compute instances start reddit-app-new


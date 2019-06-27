#!/bin/bash
gcloud compute instances create reddit-app  --boot-disk-size=10GB   --image-family ubuntu-1604-lts   --image-project=ubuntu-os-cloud   --machine-type=g1-small   --tags puma-server   --restart-on-failure --metadata-from-file startup-script=startup-script.sh
gcloud compute firewall-rules create default-puma-server --action allow --target-tags puma-server --direction ingress --source-ranges 0.0.0.0/0 --rules tcp:9292


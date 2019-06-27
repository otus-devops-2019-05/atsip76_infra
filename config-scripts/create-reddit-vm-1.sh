#!/bin/bash
#
gcloud compute instances create reddit-app  --boot-disk-size=10GB --machine-type=g1-small --image-family reddit-base --image-project=atsip76  --tags puma-server   --restart-on-failure --metadata-from-file startup-script=startup-script2.sh
#
gcloud compute firewall-rules create default-puma-server --action allow --target-tags puma-server --direction ingress --source-ranges 0.0.0.0/0 --rules tcp:9292


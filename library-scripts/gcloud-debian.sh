#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
pip install -U crcmod

export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" > /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - 
apt-get update
apt-get install -y --no-install-recommends \
    google-cloud-sdk \
    google-cloud-sdk-app-engine-python \
    google-cloud-sdk-app-engine-java \
    google-cloud-sdk-app-engine-go \
    google-cloud-sdk-datalab \
    google-cloud-sdk-datastore-emulator \
    google-cloud-sdk-pubsub-emulator \
    google-cloud-sdk-bigtable-emulator \
    google-cloud-sdk-cbt \
    kubectl
gcloud config set core/disable_usage_reporting true && \
gcloud config set component_manager/disable_update_check true && \
gcloud config set metrics/environment github_docker_image
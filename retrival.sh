#!/bin/bash

# Define the metadata URL for the current instance
metadata_url="http://169.254.169.254/latest/meta-data/"

aws_metadata_paths=("ami-id" "instance-id" "instance-type" "placement/availability-zone")
azure_metadata_paths=("compute/location" "compute/name" "compute/vmSize" "network/interface/0/macAddress")
gcp_metadata_paths=("instance/zone" "instance/name" "instance/machine-type" "network-interfaces/0/mac")

# Determine which cloud provider the instance is running on
cloud_provider=""

if curl -s -I "$metadata_url" | grep "Server: AmazonEC2" > /dev/null; then
    cloud_provider="aws"
elif curl -s -I "$metadata_url" | grep "Server: Microsoft-HTTPAPI" > /dev/null; then
    cloud_provider="azure"
elif curl -s -I "$metadata_url" | grep "Server: Google Frontend" > /dev/null; then
    cloud_provider="gcp"
else
    echo "Unable to determine cloud provider"
    exit 1
fi

# Retrieve metadata based on the cloud provider
if [ "$cloud_provider" = "aws" ]; then
    metadata_paths=("${aws_metadata_paths[@]}")
elif [ "$cloud_provider" = "azure" ]; then
    metadata_paths=("${azure_metadata_paths[@]}")
elif [ "$cloud_provider" = "gcp" ]; then
    metadata_paths=("${gcp_metadata_paths[@]}")
else
    metadata_paths=()
fi

declare -A metadata

for path in "${metadata_paths[@]}"; do
    if value=$(curl -s "$metadata_url$path"); then
        metadata["$path"]="$value"
    else
        metadata["$path"]="null"
        echo "Unable to retrieve metadata for $path"
    fi
done

# Output the metadata as JSON
echo "$(declare -p metadata | sed -e "s/declare -A/declare -g -A/")"

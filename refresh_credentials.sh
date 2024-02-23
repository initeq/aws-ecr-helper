#!/bin/bash
set -eux

DOCKER_REGISTRY_SERVER=https://${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com
DOCKER_USER=AWS
DOCKER_PASSWORD=`aws ecr get-login --region ${AWS_REGION} --registry-ids ${AWS_ACCOUNT} | cut -d' ' -f6`
echo "DOCKER_REGISTRY_SERVER=$DOCKER_REGISTRY_SERVER"
echo "DOCKER_USER=$DOCKER_USER"

IFS=' ' read -r -a TARGET_NAMESPACES_ARR <<< "$TARGET_NAMESPACES"

for i in "${TARGET_NAMESPACES_ARR[@]}"
do
    :
    echo "$(date): Updating secret for namespace - $i"
    kubectl delete secret --namespace $i aws-registry || true
    kubectl create secret --namespace $i docker-registry aws-registry \
    --docker-server=$DOCKER_REGISTRY_SERVER \
    --docker-username=$DOCKER_USER \
    --docker-password=$DOCKER_PASSWORD \
    --docker-email=no@email.local
done

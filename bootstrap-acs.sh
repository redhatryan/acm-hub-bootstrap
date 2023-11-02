#!/bin/bash

LANG=C
SLEEP_SECONDS=30

echo ""
echo "Installing ACS GitOps Cluster."

kustomize build github.com/redhatryan/acs-hub-bootstrap/bootstrap/overlays | oc apply -f -

echo "Pause $SLEEP_SECONDS seconds for the creation of the GitOps Cluster..."
sleep $SLEEP_SECONDS
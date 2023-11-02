#!/bin/bash

LANG=C
SLEEP_SECONDS=30

echo ""

echo "Bootstrap secret"

kustomize build bootstrap/secrets/base | oc apply -f -
kustomize build github.com/redhatryan/cluster-config/bootstrap/secrets/base | oc apply -f

echo "Installing ACS GitOps Cluster."

kustomize build github.com/redhatryan/acs-hub-bootstrap/bootstrap/overlays | oc apply -f -

echo "Pause $SLEEP_SECONDS seconds for the creation of the GitOps Cluster..."
sleep $SLEEP_SECONDS

echo "Labeling cluster with 'acs: acs.hub'"
oc label managedcluster acs-hub acs=acs.hub --overwrite=true
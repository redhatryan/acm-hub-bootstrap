#!/bin/bash

LANG=C
SLEEP_SECONDS=30

echo ""

echo "Installing policies to bootstrap ACS"

#kustomize build bootstrap/secrets/acs/base | oc apply -f -
kustomize build bootstrap/policies/overlays/acs --enable-alpha-plugins | oc apply -f -

echo "Labeling cluster with 'gitops: local.home'"
oc label managedcluster local-cluster acs=acs.hub --overwrite=true
#First, export the api cert External-loadbalancer-serving-certkey from OpenShift Kube APIServer so you can run the import command for ACM

#Then update DNS so the spoke Klusterlet can talk to the hub API
echo "Update DNS for Klusterlet to talk to hub API"

kustomize build github.com/redhatryan/cluster-config/components/dns | oc apply -f -


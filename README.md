### Introduction

This repository is used to bootstrap the RHACM Hub cluster as well as hold the ACM configuration
I use in my homelab environment. It is modeled after the hard work of Gerald Nunn (https://github.com/gnunn-gitops) and is referenced by the [cluster-config](https://github.com/redhatryan/cluster-config) repo for the `local.acm` cluster's ACM applications (Hub, Policies and Observerability).

From the perspective of bootstrapping the Hub there are a couple of different ways to go. You could
manually install OpenShift GitOps and have it bootstrap everything on the Hub including RHACM, but the below workflow was created for consistency as my homelab scales.

### Bootstrap Process

The bootstrap process, encapsulated in the `bootstrap.sh` script, is as follows:

1. Install the RHACM operator and wait for it to complete
2. Install the MultiClusterHub custom resource and wait for it to be in the Running phase
3. Deploy all of the RHACM policies including the policy that deploys the OpenShift
GitOps operator with the bootstrap application
4. Label the Hub cluster, `local-cluster`, with the label `gitops=local.acm`. This trigger the
GitOps policy we deployed in step #3 to install OpenShift GitOps on the Hub cluster and
deploy the bootstrap application pointing to the repo and path needed for this cluster, i.e.
`local.acm`

At this point the GitOps operator deploys everything the Hub cluster requires including storage, operators, etc
as well as other ACM components. In particular, the components that the script deployed (Hub + Policies) have
Argo applications that will take over managing these.

With the script bootstrapping the Hub because a one command affair. Once the command completes successfully, you can walk away for 20-30 minutes while everything gets sorted out.

### Side-note on LVM Operator

If you are running a SNO cluster like I am and using the LVM Operator make sure that whatever device you are using for storage with it is free. For example, if you are doing a reinstall of the hub (or other cluster), after the cluster is provisioned but before you provision Day 2 ops ssh to the cluster and run `lsblk` to make sure the device is empty with no partitions.

NOTE: There must be no activity on the disk while the next steps are performed. Disable LVM via GitOps if currently enabled, and then proceed with the below.

To do this, run `dd if=/dev/zero of=/dev/sda bs=512 count=34` and `dd if=/dev/zero of=/dev/sda bs=512 count=34 seek=$((`blockdev --getsz /dev/sda` - 34))` from the node (chroot /host). If LVM still doesn't detect disks, manually create the `system.devices` file at `/etc/lvm/devices` by adding the drive `lvmdevices --adddev /dev/sda`. Delete LVMCluster and the vg-manager and topolvm-node pods.

Ref: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_logical_volumes/limiting-lvm-device-visibility-and-usage_configuring-and-managing-logical-volumes

https://man7.org/linux/man-pages/man8/lvmdevices.8.html
gcloud container clusters create bharath-regional-cluster \
--num-nodes 3 \
--region asia-southeast1 \
--disk-size=15GB \
--disk-type=pd-standard \
--enable-autoscaling --min-nodes 1 --max-nodes 10 \
--network bharaths-vpc \
--enable-autorepair




bharathkumarraju@R77-NB193 ~ % gcloud container clusters create bharath-regional-cluster \
--num-nodes 3 \
--region asia-southeast1 \
--disk-size=15GB \
--disk-type=pd-standard \
--enable-autoscaling --min-nodes 1 --max-nodes 10 \
--network bharaths-vpc
WARNING: Currently VPC-native is not the default mode during cluster creation. In the future, this will become the default mode and can be disabled using `--no-enable-ip-alias` flag. Use `--[no-]enable-ip-alias` flag to suppress this warning.
WARNING: Newly created clusters and node-pools will have node auto-upgrade enabled by default. This can be disabled using the `--no-enable-autoupgrade` flag.
WARNING: Starting with version 1.18, clusters will have shielded GKE nodes by default.
WARNING: Your Pod address range (`--cluster-ipv4-cidr`) can accommodate at most 1008 node(s).
This will enable the autorepair feature for nodes. Please see https://cloud.google.com/kubernetes-engine/docs/node-auto-repair for more information on node autorepairs.
ERROR: (gcloud.container.clusters.create) ResponseError: code=403, message=Insufficient regional quota to satisfy request: resource "IN_USE_ADDRESSES": request requires '9.0' and is short '1.0'. project has a quota of '8.0' with '8.0' available. View and manage quotas at https://console.cloud.google.com/iam-admin/quotas?usage=USED&project=srianjaneyam.
bharathkumarraju@R77-NB193 ~ %




bharathkumarraju@R77-NB193 ~ % gcloud container clusters create bharath-regional-cluster \
--num-nodes 3 \
--zone asia-southeast1-c \
--disk-size=15GB \
--disk-type=pd-standard \
--enable-autoscaling --min-nodes 1 --max-nodes 10 \
--network bharaths-vpc
WARNING: Currently VPC-native is not the default mode during cluster creation. In the future, this will become the default mode and can be disabled using `--no-enable-ip-alias` flag. Use `--[no-]enable-ip-alias` flag to suppress this warning.
WARNING: Newly created clusters and node-pools will have node auto-upgrade enabled by default. This can be disabled using the `--no-enable-autoupgrade` flag.
WARNING: Starting with version 1.18, clusters will have shielded GKE nodes by default.
WARNING: Your Pod address range (`--cluster-ipv4-cidr`) can accommodate at most 1008 node(s).
This will enable the autorepair feature for nodes. Please see https://cloud.google.com/kubernetes-engine/docs/node-auto-repair for more information on node autorepairs.
Creating cluster bharath-regional-cluster in asia-southeast1-c... Cluster is being health-checked (master is healthy)...done.
Created [https://container.googleapis.com/v1/projects/srianjaneyam/zones/asia-southeast1-c/clusters/bharath-regional-cluster].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/asia-southeast1-c/bharath-regional-cluster?project=srianjaneyam
kubeconfig entry generated for bharath-regional-cluster.
NAME                      LOCATION           MASTER_VERSION  MASTER_IP       MACHINE_TYPE   NODE_VERSION   NUM_NODES  STATUS
bharath-regional-cluster  asia-southeast1-c  1.15.12-gke.2   35.198.229.253  n1-standard-1  1.15.12-gke.2  3          RUNNING
bharathkumarraju@R77-NB193 ~ %



gcloud container clusters create bharath-zonal-cluster --zone asia-southeast1-b \
--preemptible \
--machine-type n1-standard-1 \
--no-enable-cloud-monitoring \
--no-enable-cloud-logging \
--network bharaths-vpc



bharathkumarraju@R77-NB193 ~ % gcloud container clusters update bharath-zonal-cluster --zone asia-southeast1-b --logging-service="logging.googleapis.com"
ERROR: (gcloud.container.clusters.update) ResponseError: code=400, message=Legacy monitoring is not supported in clusters running Kubernetes 1.15 or above.
bharathkumarraju@R77-NB193 ~ %



bharathkumarraju@R77-NB193 ~ % gcloud container clusters create hanumans-zonal-cluster --zone asia-southeast1-b \
--preemptible \
--machine-type n1-standard-1 \
--network bharaths-vpc
WARNING: Currently VPC-native is not the default mode during cluster creation. In the future, this will become the default mode and can be disabled using `--no-enable-ip-alias` flag. Use `--[no-]enable-ip-alias` flag to suppress this warning.
WARNING: Newly created clusters and node-pools will have node auto-upgrade enabled by default. This can be disabled using the `--no-enable-autoupgrade` flag.
WARNING: Starting with version 1.18, clusters will have shielded GKE nodes by default.
WARNING: Your Pod address range (`--cluster-ipv4-cidr`) can accommodate at most 1008 node(s).
This will enable the autorepair feature for nodes. Please see https://cloud.google.com/kubernetes-engine/docs/node-auto-repair for more information on node autorepairs.
Creating cluster hanumans-zonal-cluster in asia-southeast1-b... Cluster is being deployed...⠏
Creating cluster hanumans-zonal-cluster in asia-southeast1-b... Cluster is being deployed...⠹
Creating cluster hanumans-zonal-cluster in asia-southeast1-b... Cluster is being deployed...⠼
bharathkumarraju@R77-NB193 ~ %


bharathkumarraju@R77-NB193 ~ % gcloud container node-pools list --cluster hanumans-zonal-cluster --zone asia-southeast1-b
NAME          MACHINE_TYPE   DISK_SIZE_GB  NODE_VERSION
default-pool  n1-standard-1  100           1.15.12-gke.2
bharathkumarraju@R77-NB193 ~ %



bharathkumarraju@R77-NB193 ~ % gcloud container node-pools list --cluster hanumans-zonal-cluster --zone asia-southeast1-b
NAME          MACHINE_TYPE   DISK_SIZE_GB  NODE_VERSION
default-pool  n1-standard-1  100           1.15.12-gke.2
bharathkumarraju@R77-NB193 ~ %


gcloud container node-pools create bharath-pool --num-nodes=2 \
--cluster hanumans-zonal-cluster \
--zone asia-southeast1-b


gcloud container clusters get-credentials hanumans-zonal-cluster--zone asia-southeast1-b --project srianjaneyam



bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % gcloud container node-pools list --cluster hanumans-zonal-cluster --zone asia-southeast1-b
NAME          MACHINE_TYPE   DISK_SIZE_GB  NODE_VERSION
default-pool  n1-standard-1  100           1.15.12-gke.2
hanuman-pool  n1-standard-1  100           1.15.12-gke.2
bharath-pool  n1-standard-1  100           1.15.12-gke.2
bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % gcloud container node-pools delete bharath-pool --cluster hanumans-zonal-cluster --zone asia-southeast1-b
The following node pool will be deleted.
[bharath-pool] in cluster [hanumans-zonal-cluster] in
[asia-southeast1-b]

Do you want to continue (Y/n)?  Y
Deleting node pool bharath-pool...⠼
bharathkumarraju@R77-NB193 ntuc-coe-ds-uat %

bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % kubectl config current-context
gke_srianjaneyam_asia-southeast1-b_hanumans-zonal-cluster
bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % kubectl cluster-info
Kubernetes master is running at https://35.247.156.135
GLBCDefaultBackend is running at https://35.247.156.135/api/v1/namespaces/kube-system/services/default-http-backend:http/proxy
Heapster is running at https://35.247.156.135/api/v1/namespaces/kube-system/services/heapster/proxy
KubeDNS is running at https://35.247.156.135/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
Metrics-server is running at https://35.247.156.135/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
bharathkumarraju@R77-NB193 ntuc-coe-ds-uat %



bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % gcloud container clusters update hanumans-zonal-cluster --zone asia-southeast1-b \
> --node-locations asia-southeast1-b,asia-southeast1-c,asia-southeast1-a
Updating hanumans-zonal-cluster...done.
ERROR: (gcloud.container.clusters.update) Operation [<Operation
 clusterConditions: [<StatusCondition
 message: 'Insufficient regional quota to satisfy request: resource "IN_USE_ADDRESSES": request requires \'10.0\' and is short \'7.0\'. project has a quota of \'8.0\' with \'3.0\' available. View and manage quotas at https://console.cloud.google.com/iam-admin/quotas?usage=USED&project=srianjaneyam.'>]
 detail: 'Insufficient regional quota to satisfy request: resource "IN_USE_ADDRESSES": request requires \'10.0\' and is short \'7.0\'. project has a quota of \'8.0\' with \'3.0\' available. View and manage quotas at https://console.cloud.google.com/iam-admin/quotas?usage=USED&project=srianjaneyam.'
 endTime: '2020-08-06T23:17:34.368867168Z'
 name: 'operation-1596755851225-88cba749'
 nodepoolConditions: []
 operationType: OperationTypeValueValuesEnum(UPDATE_CLUSTER, 6)
 selfLink: 'https://container.googleapis.com/v1/projects/202016682554/zones/asia-southeast1-b/operations/operation-1596755851225-88cba749'
 startTime: '2020-08-06T23:17:31.225935016Z'
 status: StatusValueValuesEnum(DONE, 3)
 statusMessage: 'Insufficient regional quota to satisfy request: resource "IN_USE_ADDRESSES": request requires \'10.0\' and is short \'7.0\'. project has a quota of \'8.0\' with \'3.0\' available. View and manage quotas at https://console.cloud.google.com/iam-admin/quotas?usage=USED&project=srianjaneyam.'
 targetLink: 'https://container.googleapis.com/v1/projects/202016682554/zones/asia-southeast1-b/clusters/hanumans-zonal-cluster'
 zone: 'asia-southeast1-b'>] finished with error: Insufficient regional quota to satisfy request: resource "IN_USE_ADDRESSES": request requires '10.0' and is short '7.0'. project has a quota of '8.0' with '3.0' available. View and manage quotas at https://console.cloud.google.com/iam-admin/quotas?usage=USED&project=srianjaneyam.
bharathkumarraju@R77-NB193 ntuc-coe-ds-uat %'



bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % gcloud container clusters delete hanumans-zonal-cluster --zone asia-southeast1-b
The following clusters will be deleted.
 - [hanumans-zonal-cluster] in [asia-southeast1-b]

Do you want to continue (Y/n)?  Y

Deleting cluster hanumans-zonal-cluster...⠶
bharathkumarraju@R77-NB193 ntuc-coe-ds-uat %


bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % gcloud container clusters create autoscaling-cluster --network bharaths-vpc --zone us-central1-a
WARNING: Currently VPC-native is not the default mode during cluster creation. In the future, this will become the default mode and can be disabled using `--no-enable-ip-alias` flag. Use `--[no-]enable-ip-alias` flag to suppress this warning.
WARNING: Newly created clusters and node-pools will have node auto-upgrade enabled by default. This can be disabled using the `--no-enable-autoupgrade` flag.
WARNING: Starting with version 1.18, clusters will have shielded GKE nodes by default.
WARNING: Your Pod address range (`--cluster-ipv4-cidr`) can accommodate at most 1008 node(s).
This will enable the autorepair feature for nodes. Please see https://cloud.google.com/kubernetes-engine/docs/node-auto-repair for more information on node autorepairs.
Creating cluster autoscaling-cluster in us-central1-a... Cluster is being configured...⠏
Creating cluster autoscaling-cluster in us-central1-a... Cluster is being health-checked...⠶
Creating cluster autoscaling-cluster in us-central1-a... Cluster is being health-checked (master is healthy)...done.
Created [https://container.googleapis.com/v1/projects/srianjaneyam/zones/us-central1-a/clusters/autoscaling-cluster].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/us-central1-a/autoscaling-cluster?project=srianjaneyam
kubeconfig entry generated for autoscaling-cluster.
NAME                 LOCATION       MASTER_VERSION  MASTER_IP      MACHINE_TYPE   NODE_VERSION   NUM_NODES  STATUS
autoscaling-cluster  us-central1-a  1.15.12-gke.2   34.66.167.201  n1-standard-1  1.15.12-gke.2  3          RUNNING

bharathkumarraju@R77-NB193 ntuc-coe-ds-uat %


bharathkumarraju@R77-NB193 ntuc-coe-ds-uat %  gcloud beta container clusters get-credentials autoscaling-cluster --zone us-central1-a --project srianjaneyam
Fetching cluster endpoint and auth data.
kubeconfig entry generated for autoscaling-cluster.
bharathkumarraju@R77-NB193 ntuc-coe-ds-uat %








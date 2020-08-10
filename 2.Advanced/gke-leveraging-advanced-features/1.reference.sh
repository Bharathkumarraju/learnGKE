
gcloud container clusters get-credentials bharath-dev-cluster --zone us-central1-a --project srianjaneyam


bharath@cloudshell:~ (srianjaneyam)$ kubectl get nodes
NAME                                                  STATUS   ROLES    AGE     VERSION
gke-bharath-dev-clust-preemptive-pool-0c91251d-wx1c   Ready    <none>   8m26s   v1.16.11-gke.5
gke-bharath-dev-cluster-default-pool-71dd9ee9-4sb7    Ready    <none>   8m15s   v1.16.11-gke.5
gke-bharath-dev-cluster-default-pool-71dd9ee9-f7js    Ready    <none>   8m13s   v1.16.11-gke.5
gke-bharath-dev-cluster-default-pool-71dd9ee9-sfnt    Ready    <none>   8m15s   v1.16.11-gke.5
bharath@cloudshell:~ (srianjaneyam)$


bharath@cloudshell:~ (srianjaneyam)$ kubectl describe node gke-bharath-dev-clust-preemptive-pool-0c91251d-wx1c
Name:               gke-bharath-dev-clust-preemptive-pool-0c91251d-wx1c
Roles:              <none>
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/instance-type=e2-medium
                    beta.kubernetes.io/os=linux
                    cloud.google.com/gke-nodepool=preemptive-pool
                    cloud.google.com/gke-os-distribution=cos
                    cloud.google.com/gke-preemptible=true
                    failure-domain.beta.kubernetes.io/region=us-central1
                    failure-domain.beta.kubernetes.io/zone=us-central1-a
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=gke-bharath-dev-clust-preemptive-pool-0c91251d-wx1c
                    kubernetes.io/os=linux
                    preemptive=true
Annotations:        container.googleapis.com/instance_id: 8121863264345605981
                    node.alpha.kubernetes.io/ttl: 0
                    node.gke.io/last-applied-node-labels:
                      cloud.google.com/gke-nodepool=preemptive-pool,cloud.google.com/gke-os-distribution=cos,cloud.google.com/gke-preemptible=true,preemptive=tr...
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Mon, 10 Aug 2020 15:41:53 +0800
Taints:             <none>
Unschedulable:      false
Lease:
  HolderIdentity:  gke-bharath-dev-clust-preemptive-pool-0c91251d-wx1c
  AcquireTime:     <unset>
  RenewTime:       Mon, 10 Aug 2020 15:52:34 +0800
Conditions:
  Type                          Status  LastHeartbeatTime                 LastTransitionTime                Reason                          Message
  ----                          ------  -----------------                 ------------------                ------                          -------
  CorruptDockerOverlay2         False   Mon, 10 Aug 2020 15:51:58 +0800   Mon, 10 Aug 2020 15:41:56 +0800   NoCorruptDockerOverlay2         docker overlay2 is functioning properly
  FrequentUnregisterNetDevice   False   Mon, 10 Aug 2020 15:51:58 +0800   Mon, 10 Aug 2020 15:41:56 +0800   NoFrequentUnregisterNetDevice   node is functioning properly
  FrequentKubeletRestart        False   Mon, 10 Aug 2020 15:51:58 +0800   Mon, 10 Aug 2020 15:41:56 +0800   NoFrequentKubeletRestart        kubelet is functioning properly
  FrequentDockerRestart         False   Mon, 10 Aug 2020 15:51:58 +0800   Mon, 10 Aug 2020 15:41:56 +0800   NoFrequentDockerRestart         docker is functioning properly
  FrequentContainerdRestart     False   Mon, 10 Aug 2020 15:51:58 +0800   Mon, 10 Aug 2020 15:41:56 +0800   NoFrequentContainerdRestart     containerd is functioning properly


present-ratings-job

bharath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$ kubectl apply -f present-ratings-job.yaml
job.batch/present-ratings-job created
bharath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$ kubectl get pods
NAME                        READY   STATUS      RESTARTS   AGE
present-ratings-job-p8h9g   0/1     Completed   0          68s
bharath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$ kubectl get job
NAME                  COMPLETIONS   DURATION   AGE
present-ratings-job   1/1           33s        72s
bharath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$ kubectl describe job present-ratings-job
Name:           present-ratings-job
Namespace:      default
Selector:       controller-uid=5d0ca96f-f00f-47d1-aeeb-9a3151d5a378
Labels:         controller-uid=5d0ca96f-f00f-47d1-aeeb-9a3151d5a378
                job-name=present-ratings-job
                preemptive=true
Annotations:    Parallelism:  1
Completions:    1
Start Time:     Mon, 10 Aug 2020 16:38:46 +0800
Completed At:   Mon, 10 Aug 2020 16:39:19 +0800
Duration:       33s
Pods Statuses:  0 Running / 1 Succeeded / 0 Failed
Pod Template:
  Labels:  controller-uid=5d0ca96f-f00f-47d1-aeeb-9a3151d5a378
           job-name=present-ratings-job
           preemptive=true
  Containers:
   customer-ratings:
    Image:        gcr.io/srianjaneyam/customer-ratings:v1
    Port:         <none>
    Host Port:    <none>
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Events:
  Type    Reason            Age   From            Message
  ----    ------            ----  ----            -------
  Normal  SuccessfulCreate  83s   job-controller  Created pod: present-ratings-job-p8h9g
bharath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$



bharath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$ gcloud beta container node-pools list --cluster bharath-dev-cluster
NAME             MACHINE_TYPE  DISK_SIZE_GB  NODE_VERSION
default-pool     e2-medium     100           1.16.11-gke.5
preemptive-pool  e2-medium     100           1.16.11-gke.5
bharath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$


bharath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$ kubectl taint nodes gke-bharath-dev-clust-preemptive-pool-0c91251d-wx1c preemptive="true":NoSchedule
node/gke-bharath-dev-clust-preemptive-pool-0c91251d-wx1c tainted
bharath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$




bharath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$ kubectl describe node gke-bharath-dev-clust-preemptive-pool-0c91251d-wx1c
Name:               gke-bharath-dev-clust-preemptive-pool-0c91251d-wx1c
Roles:              <none>
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/instance-type=e2-medium
                    beta.kubernetes.io/os=linux
                    cloud.google.com/gke-nodepool=preemptive-pool
                    cloud.google.com/gke-os-distribution=cos
                    cloud.google.com/gke-preemptible=true
                    failure-domain.beta.kubernetes.io/region=us-central1
                    failure-domain.beta.kubernetes.io/zone=us-central1-a
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=gke-bharath-dev-clust-preemptive-pool-0c91251d-wx1c
                    kubernetes.io/os=linux
                    preemptive=true
Annotations:        container.googleapis.com/instance_id: 665317778086737187
                    node.alpha.kubernetes.io/ttl: 0
                    node.gke.io/last-applied-node-labels:
                      cloud.google.com/gke-nodepool=preemptive-pool,cloud.google.com/gke-os-distribution=cos,cloud.google.com/gke-preemptible=true,preemptive=tr...
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Mon, 10 Aug 2020 15:41:53 +0800
Taints:             preemptive=true:NoSchedule
Unschedulable:      false
Lease:
  HolderIdentity:  gke-bharath-dev-clust-preemptive-pool-0c91251d-wx1c
  AcquireTime:     <unset>
  RenewTime:       Mon, 10 Aug 2020 17:00:38 +0800
Conditions:

bharath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$ kubectl apply -f weekly-ratings-cronjob.yaml
cronjob.batch/weekly-ratings-cronjob created
bharath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$


bharath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$ kubectl get pods
NAME                                      READY   STATUS      RESTARTS   AGE
present-ratings-job-p8h9g                 0/1     Completed   0          32m
weekly-ratings-cronjob-1597050600-pvbwv   0/1     Completed   0          44s
bharath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$

harath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$ kubectl get cronjob
NAME                     SCHEDULE       SUSPEND   ACTIVE   LAST SCHEDULE   AGE
weekly-ratings-cronjob   18 */1 * * *   False     0        2m25s           8m43s
bharath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$

bharath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$ kubectl taint nodes gke-bharath-dev-clust-preemptive-pool-0c91251d-wx1c preemptive-
node/gke-bharath-dev-clust-preemptive-pool-0c91251d-wx1c untainted
bharath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$



bharath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$ gcloud beta container node-pools list --cluster bharath-dev-cluster
NAME             MACHINE_TYPE  DISK_SIZE_GB  NODE_VERSION
default-pool     e2-medium     100           1.16.11-gke.5
preemptive-pool  e2-medium     100           1.16.11-gke.5
bharath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$ gcloud beta container node-pools delete preemptive-pool --cluster bharath-dev-cluster
The following node pool will be deleted.
[preemptive-pool] in cluster [bharath-dev-cluster] in [us-central1-a]

Do you want to continue (Y/n)?  Y

Deleting node pool preemptive-pool...⠶
bharath@cloudshell:~/bharath_practise/gke-dev (srianjaneyam)$





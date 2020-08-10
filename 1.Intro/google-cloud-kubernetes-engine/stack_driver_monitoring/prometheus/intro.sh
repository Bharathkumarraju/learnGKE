curl -sSO "https://storage.googleapis.com/stackdriver-prometheus-documentation/rbac-setup.yml"


kubectl apply -f rbac-setup.yaml --as=admin --as-group=system:masters


bharathkumarraju@R77-NB193 stack_driver_monitoring % gcloud beta container clusters get-credentials bharaths-cluster  --zone us-central1-c
Fetching cluster endpoint and auth data.
kubeconfig entry generated for bharaths-cluster.
bharathkumarraju@R77-NB193 stack_driver_monitoring % cd prometheus

bharathkumarraju@R77-NB193 prometheus % kubectl apply -f rbac-setup.yml --as=admin --as-group=system:masters
namespace/stackdriver created
clusterrole.rbac.authorization.k8s.io/prometheus created
serviceaccount/prometheus created
clusterrolebinding.rbac.authorization.k8s.io/prometheus-stackdriver created
bharathkumarraju@R77-NB193 prometheus %


bharathkumarraju@R77-NB193 prometheus % curl -sSO "https://storage.googleapis.com/stackdriver-prometheus-documentation/prometheus-service.yml"
bharathkumarraju@R77-NB193 prometheus %

bharathkumarraju@R77-NB193 prometheus % kubectl apply -f prometheus-service.yml
namespace/stackdriver unchanged
service/prometheus unchanged
deployment.apps/prometheus created
configmap/prometheus unchanged
bharathkumarraju@R77-NB193 prometheus %


bharathkumarraju@R77-NB193 prometheus % kubectl get deployment,service -n stackdriver
NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/prometheus   0/1     1            0           3m7s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
service/prometheus   ClusterIP   10.0.8.26    <none>        9090/TCP   4m24s
bharathkumarraju@R77-NB193 prometheus %



bharathkumarraju@R77-NB193 prometheus % kubectl get namespace
NAME                  STATUS   AGE
bharaths-website-ns   Active   4h22m
default               Active   4h25m
kube-node-lease       Active   4h25m
kube-public           Active   4h25m
kube-system           Active   4h25m
stackdriver           Active   15m


bharathkumarraju@R77-NB193 prometheus % kubectl delete namespace stackdriver
namespace "stackdriver" deleted


bharathkumarraju@R77-NB193 prometheus % kubectl delete all --all -n  bharaths-website-ns
pod "bharaths-website-5f59567c9d-h7djr" deleted
pod "bharaths-website-5f59567c9d-m9x8d" deleted
pod "bharaths-website-5f59567c9d-ss9vw" deleted
service "bharaths-website-service" deleted
deployment.apps "bharaths-website" deleted
replicaset.apps "bharaths-website-5f59567c9d" deleted
horizontalpodautoscaler.autoscaling "bharaths-website-hpa-dvnq" deleted
bharathkumarraju@R77-NB193 prometheus %



bharathkumarraju@R77-NB193 prometheus % echo "Y" | gcloud beta container clusters delete bharaths-cluster  --zone us-central1-c
The following clusters will be deleted.
 - [bharaths-cluster] in [us-central1-c]

Do you want to continue (Y/n)?
Deleting cluster bharaths-cluster...
.............................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................done.
Deleted [https://container.googleapis.com/v1beta1/projects/srianjaneyam/zones/us-central1-c/clusters/bharaths-cluster].
bharathkumarraju@R77-NB193 prometheus %

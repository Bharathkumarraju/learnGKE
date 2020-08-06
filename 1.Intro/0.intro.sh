gcloud container clusters get-credentials hello-cluster --zone asia-southeast1-a --project srianjaneyam

bharathkumarraju@R77-NB193 external % gcloud container clusters get-credentials hello-cluster --zone asia-southeast1-a --project srianjaneyam
Fetching cluster endpoint and auth data.
kubeconfig entry generated for hello-cluster.
bharathkumarraju@R77-NB193 external %


bharathkumarraju@R77-NB193 external % kubectl get nodes -o wide
NAME                                           STATUS   ROLES    AGE   VERSION          INTERNAL-IP   EXTERNAL-IP      OS-IMAGE                             KERNEL-VERSION   CONTAINER-RUNTIME
gke-hello-cluster-default-pool-94315dd0-11dn   Ready    <none>   67m   v1.15.12-gke.2   10.148.0.4    34.87.65.211     Container-Optimized OS from Google   4.19.112+        docker://19.3.1
gke-hello-cluster-default-pool-94315dd0-2bgw   Ready    <none>   67m   v1.15.12-gke.2   10.148.0.5    35.198.224.126   Container-Optimized OS from Google   4.19.112+        docker://19.3.1
gke-hello-cluster-default-pool-94315dd0-tdjj   Ready    <none>   67m   v1.15.12-gke.2   10.148.0.2    35.198.251.197   Container-Optimized OS from Google   4.19.112+        docker://19.3.1
gke-hello-cluster-default-pool-94315dd0-tsbl   Ready    <none>   67m   v1.15.12-gke.2   10.148.0.3    35.240.173.191   Container-Optimized OS from Google   4.19.112+        docker://19.3.1
bharathkumarraju@R77-NB193 external %


bharathkumarraju@R77-NB193 external % kubectl get all -n default
NAME                           READY   STATUS    RESTARTS   AGE
pod/nginx-1-76949974bb-c86x9   1/1     Running   0          31m


NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.0.0.1     <none>        443/TCP   68m


NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-1   1/1     1            1           31m

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-1-76949974bb   1         1         1       31m


NAME                                                   REFERENCE            TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
horizontalpodautoscaler.autoscaling/nginx-1-hpa-56ff   Deployment/nginx-1   0%/80%    1         5         1          31m


bharathkumarraju@R77-NB193 external %
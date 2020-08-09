
gcloud container clusters create autoscaling-cluster --network bharaths-vpc --zone us-central1-a

bharathkumarraju@R77-NB193 wordpress-persistent-disks % gcloud container clusters list
NAME                 LOCATION       MASTER_VERSION  MASTER_IP     MACHINE_TYPE   NODE_VERSION   NUM_NODES  STATUS
autoscaling-cluster  us-central1-a  1.15.12-gke.2   34.69.45.175  n1-standard-1  1.15.12-gke.2  3          RUNNING


bharathkumarraju@R77-NB193 wordpress-persistent-disks % gcloud container clusters get-credentials autoscaling-cluster --zone us-central1-a
Fetching cluster endpoint and auth data.
kubeconfig entry generated for autoscaling-cluster.
bharathkumarraju@R77-NB193 wordpress-persistent-disks %


bharathkumarraju@R77-NB193 wordpress-persistent-disks % kubectl apply -f mysql-volumeclaim.yaml
persistentvolumeclaim/mysql-volumeclaim created
bharathkumarraju@R77-NB193 wordpress-persistent-disks % kubectl apply -f wordpress-volumeclaim.yaml
persistentvolumeclaim/wordpress-volumeclaim created


bharathkumarraju@R77-NB193 wordpress-persistent-disks % kubectl get pvc
NAME                    STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
mysql-volumeclaim       Bound    pvc-1c9c7355-69ed-4387-9427-51bfb187437b   50Gi       RWO            standard       25s
wordpress-volumeclaim   Bound    pvc-fa7b0d96-9600-418e-aa6e-2b31fd80194d   50Gi       RWO            standard       15s
bharathkumarraju@R77-NB193 wordpress-persistent-disks %


bharathkumarraju@R77-NB193 wordpress-persistent-disks % kubectl create secret generic mysql --from-literal=password=123four
secret/mysql created
bharathkumarraju@R77-NB193 wordpress-persistent-disks %

bharathkumarraju@R77-NB193 wordpress-persistent-disks % kubectl apply -f mysql.yaml
deployment.apps/mysql created
bharathkumarraju@R77-NB193 wordpress-persistent-disks %

bharathkumarraju@R77-NB193 wordpress-persistent-disks % kubectl get pods
NAME                     READY   STATUS              RESTARTS   AGE
mysql-556878987d-nw46f   0/1     ContainerCreating   0          21s
bharathkumarraju@R77-NB193 wordpress-persistent-disks % kubectl get pods
NAME                     READY   STATUS              RESTARTS   AGE
mysql-556878987d-nw46f   0/1     ContainerCreating   0          26s
bharathkumarraju@R77-NB193 wordpress-persistent-disks % kubectl get pod -l app=mysql
NAME                     READY   STATUS    RESTARTS   AGE
mysql-556878987d-nw46f   1/1     Running   0          37s
bharathkumarraju@R77-NB193 wordpress-persistent-disks %

bharathkumarraju@R77-NB193 wordpress-persistent-disks % kubectl apply -f mysql-service.yaml
service/mysql created
bharathkumarraju@R77-NB193 wordpress-persistent-disks % kubectl get svc -l app=mysql
NAME    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
mysql   ClusterIP   10.35.244.211   <none>        3306/TCP   4m20s
bharathkumarraju@R77-NB193 wordpress-persistent-disks %


bharathkumarraju@R77-NB193 wordpress-persistent-disks % kubectl apply -f wordpress.yaml
deployment.apps/wordpress created
bharathkumarraju@R77-NB193 wordpress-persistent-disks % kubectl apply -f wordpress-service.yaml
service/wordpress created
bharathkumarraju@R77-NB193 wordpress-persistent-disks %


bharathkumarraju@R77-NB193 wordpress-persistent-disks % kubectl get pod -l app=wordpress
NAME                       READY   STATUS    RESTARTS   AGE
wordpress-c7cbfc75-k48mv   1/1     Running   0          103s
bharathkumarraju@R77-NB193 wordpress-persistent-disks %


bharathkumarraju@R77-NB193 wordpress-persistent-disks % kubectl get svc -l app=wordpress
NAME        TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)        AGE
wordpress   LoadBalancer   10.35.249.239   34.67.251.19   80:31603/TCP   102s
bharathkumarraju@R77-NB193 wordpress-persistent-disks %


bharathkumarraju@R77-NB193 infra-gcp-ne-central-data-cloud % gcloud compute forwarding-rules list
NAME                              REGION       IP_ADDRESS    IP_PROTOCOL  TARGET
a2234c50fc7574bc6817b4af68ee5d58  us-central1  34.67.251.19  TCP          us-central1/targetPools/a2234c50fc7574bc6817b4af68ee5d58
bharathkumarraju@R77-NB193 infra-gcp-ne-central-data-cloud %






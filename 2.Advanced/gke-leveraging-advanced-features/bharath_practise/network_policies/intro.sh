gcloud beta container clusters create  bharath-cluster  --zone us-central1-a --enable-network-policy --network bharaths-vpc

bharath@cloudshell:~ (srianjaneyam)$ gcloud beta container clusters list
NAME             LOCATION       MASTER_VERSION  MASTER_IP      MACHINE_TYPE   NODE_VERSION   NUM_NODES  STATUS
bharath-cluster  us-central1-a  1.15.12-gke.2   35.223.83.144  n1-standard-1  1.15.12-gke.2  3          RUNNING
bharath@cloudshell:~ (srianjaneyam)$


bharath@cloudshell:~ (srianjaneyam)$ kubectl run bk-website --labels app=bk-website \
>   --image=gcr.io/srianjaneyam/bk-website:v1 \
>   --port 80 \
>   --expose
service/bk-website created
pod/bk-website created

bharath@cloudshell:~ (srianjaneyam)$ kubectl get all
NAME             READY   STATUS    RESTARTS   AGE
pod/bk-website   1/1     Running   0          10s

NAME                 TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
service/bk-website   ClusterIP   10.7.246.15   <none>        80/TCP    9s
service/kubernetes   ClusterIP   10.7.240.1    <none>        443/TCP   76m
bharath@cloudshell:~ (srianjaneyam)$





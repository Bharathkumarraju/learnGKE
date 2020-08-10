bharath@cloudshell:~/bharath_practise$ cd version-1
bharath@cloudshell:~/bharath_practise/version-1$ ls -rtlh
total 16K
-rwxr-xr-x 1 bharath bharath 6.9K Nov 26  2018 index.html
-rwxr-xr-x 1 bharath bharath  116 Nov 26  2018 Dockerfile
-rwxr-xr-x 1 bharath bharath 1.1K Nov 26  2018 default.conf


bharath@cloudshell:~/bharath_practise/version-1$ docker build -t gcr.io/srianjaneyam/bk-website:v1 .
Sending build context to Docker daemon  11.78kB
Step 1/3 : FROM nginx:alpine
alpine: Pulling from library/nginx
cbdbe7a5bc2a: Pull complete
85434292d1cb: Pull complete
75fcb1e58684: Pull complete
2a8fe5451faf: Pull complete
42ceeab04dd4: Pull complete
Digest: sha256:966f134cf5ddeb12a56ede0f40fff754c0c0a749182295125f01a83957391d84
Status: Downloaded newer image for nginx:alpine
 ---> ecd67fe340f9
Step 2/3 : COPY default.conf /etc/nginx/conf.d/default.conf
 ---> ac605afde184
Step 3/3 : COPY index.html /usr/share/nginx/html/index.html
 ---> c60f4d76bfc9
Successfully built c60f4d76bfc9
Successfully tagged gcr.io/srianjaneyam/bk-website:v1


bharath@cloudshell:~/bharath_practise/version-1$ docker push gcr.io/srianjaneyam/bk-website:v1
The push refers to repository [gcr.io/srianjaneyam/bk-website]
f899125b2ffa: Pushed
464ddf9bb8c6: Pushed
689cc6c05bc7: Layer already exists
b7d86c86e432: Layer already exists
08fb2e2ff084: Layer already exists
5f1add6e505b: Layer already exists
3e207b409db3: Layer already exists
v1: digest: sha256:5b9fd624fda51420853f4834a1bb999d71a16e93f59036f20639299ff82f9499 size: 1775
bharath@cloudshell:~/bharath_practise/version-1$


bharath@cloudshell:~/bharath_practise/version-1$ cd ../version-1-offer/

bharath@cloudshell:~/bharath_practise/version-1-offer$ docker build -t gcr.io/srianjaneyam/bk-website:v1-offer .
Sending build context to Docker daemon  11.78kB
Step 1/3 : FROM nginx:alpine
 ---> ecd67fe340f9
Step 2/3 : COPY default.conf /etc/nginx/conf.d/default.conf
 ---> Using cache
 ---> ac605afde184
Step 3/3 : COPY index.html /usr/share/nginx/html/index.html
 ---> 2058e1781f03
Successfully built 2058e1781f03
Successfully tagged gcr.io/srianjaneyam/bk-website:v1-offer

bharath@cloudshell:~/bharath_practise/version-1-offer$ docker push gcr.io/srianjaneyam/bk-website:v1-offer
The push refers to repository [gcr.io/srianjaneyam/bk-website]
2b718cbccc4f: Pushed
464ddf9bb8c6: Layer already exists
689cc6c05bc7: Layer already exists
b7d86c86e432: Layer already exists
08fb2e2ff084: Layer already exists
5f1add6e505b: Layer already exists
3e207b409db3: Layer already exists
v1-offer: digest: sha256:994e8401dfcc1177b47b126fffdf0e7987b89e7d3a1c6574efcde906d8190983 size: 1775
bharath@cloudshell:~/bharath_practise/version-1-offer$

bharath@cloudshell:~/bharath_practise/gke-dev$ kubectl get  deploy bk-website
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
bk-website   3/3     3            3           29s

bharath@cloudshell:~/bharath_practise/gke-dev$ kubectl get pod -l app=bk-website
NAME                          READY   STATUS    RESTARTS   AGE
bk-website-85f4797576-65m5z   1/1     Running   0          60s
bk-website-85f4797576-nkb9t   1/1     Running   0          60s
bk-website-85f4797576-pr2zl   1/1     Running   0          60s
bharath@cloudshell:~/bharath_practise/gke-dev$

bharath@cloudshell:~/bharath_practise/gke-dev$ kubectl rollout status deployment bk-website
deployment "bk-website" successfully rolled out

bharath@cloudshell:~/bharath_practise/gke-dev$ kubectl rollout undo deployment bk-website --to-revision=1
deployment.apps/bk-website rolled back

bharath@cloudshell:~/bharath_practise/gke-dev$ kubectl rollout status deployment bk-website
deployment "bk-website" successfully rolled out
bharath@cloudshell:~/bharath_practise/gke-dev$



bharath@cloudshell:~/bharath_practise/gke-dev$ gcloud container clusters get-credentials bharath-dev-cluster --zone us-central1-a --project srianjaneyam
Fetching cluster endpoint and auth data.
kubeconfig entry generated for bharath-dev-cluster.
bharath@cloudshell:~/bharath_practise/gke-dev$ kubectl apply -f spikey-stateful-deployment.yaml
statefulset.apps/bk-website created
bharath@cloudshell:~/bharath_practise/gke-dev$ kubectl get all
NAME                                          READY   STATUS              RESTARTS   AGE
pod/bk-website-0                              0/1     ContainerCreating   0          9s
pod/bk-website-85f4797576-6cnxk               1/1     Running             0          8m25s
pod/bk-website-85f4797576-c5sqv               1/1     Running             0          8m23s
pod/bk-website-85f4797576-mtgl5               1/1     Running             0          8m21s
pod/weekly-ratings-cronjob-1597050600-pvbwv   0/1     Completed           0          33m
pod/weekly-ratings-cronjob-1597050720-gd5k6   0/1     Completed           0          32m
pod/weekly-ratings-cronjob-1597051080-882cf   0/1     Completed           0          26m

NAME                         TYPE           CLUSTER-IP   EXTERNAL-IP     PORT(S)        AGE
service/bk-website-service   LoadBalancer   10.0.4.237   35.192.96.182   80:30708/TCP   14m
service/kubernetes           ClusterIP      10.0.0.1     <none>          443/TCP        123m

NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/bk-website   3/3     3            3           16m

NAME                                    DESIRED   CURRENT   READY   AGE
replicaset.apps/bk-website-85f4797576   3         3         3       16m
replicaset.apps/bk-website-dffd69987    0         0         0       12m

NAME                          READY   AGE
statefulset.apps/bk-website   0/3     11s

NAME                                          COMPLETIONS   DURATION   AGE
job.batch/present-ratings-job                 1/1           33s        66m
job.batch/weekly-ratings-cronjob-1597050600   1/1           32s        33m
job.batch/weekly-ratings-cronjob-1597050720   1/1           3s         32m
job.batch/weekly-ratings-cronjob-1597051080   1/1           4s         26m

NAME                                   SCHEDULE       SUSPEND   ACTIVE   LAST SCHEDULE   AGE
cronjob.batch/weekly-ratings-cronjob   18 */1 * * *   False     0        26m             39m
bharath@cloudshell:~/bharath_practise/gke-dev$


bharath@cloudshell:~/bharath_practise/gke-dev$ kubectl get pods -l app=bk-website
NAME                          READY   STATUS    RESTARTS   AGE
bk-website-0                  1/1     Running   0          3m12s
bk-website-1                  1/1     Running   0          2m55s
bk-website-2                  1/1     Running   0          2m40s
bk-website-85f4797576-6cnxk   1/1     Running   0          11m
bk-website-85f4797576-c5sqv   1/1     Running   0          11m
bk-website-85f4797576-mtgl5   1/1     Running   0          11m
bharath@cloudshell:~/bharath_practise/gke-dev$ kubectl delete pod bk-website-0
pod "bk-website-0" deleted

bharath@cloudshell:~/bharath_practise/gke-dev$
bharath@cloudshell:~/bharath_practise/gke-dev$ kubectl get pods -l app=bk-website
NAME                          READY   STATUS              RESTARTS   AGE
bk-website-0                  0/1     ContainerCreating   0          4s
bk-website-1                  1/1     Running             0          3m25s
bk-website-2                  1/1     Running             0          3m10s
bk-website-85f4797576-6cnxk   1/1     Running             0          11m
bk-website-85f4797576-c5sqv   1/1     Running             0          11m
bk-website-85f4797576-mtgl5   1/1     Running             0          11m
bharath@cloudshell:~/bharath_practise/gke-dev$


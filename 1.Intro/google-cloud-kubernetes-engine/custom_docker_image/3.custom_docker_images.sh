test

bharathkumarraju@R77-NB193 custom_docker_image % export PROJECT_ID="$(gcloud config get-value project -q)"
bharathkumarraju@R77-NB193 custom_docker_image % docker build -t gcr.io/${PROJECT_ID}/bharaths-website:v1 .
Sending build context to Docker daemon  11.78kB
Step 1/3 : FROM nginx:alpine
alpine: Pulling from library/nginx
cbdbe7a5bc2a: Already exists
85434292d1cb: Pull complete
75fcb1e58684: Pull complete
2a8fe5451faf: Pull complete
42ceeab04dd4: Pull complete
Digest: sha256:ee8c35a6944eb3cc415cd4cbeddef13927895d4ffa50b976886e3abe48b3f35a
Status: Downloaded newer image for nginx:alpine
 ---> ecd67fe340f9
Step 2/3 : COPY default.conf /etc/nginx/conf.d/default.conf
 ---> 9685538677ac
Step 3/3 : COPY index.html /usr/share/nginx/html/index.html
 ---> 3b80352bdd1c
Successfully built 3b80352bdd1c
Successfully tagged gcr.io/srianjaneyam/bharaths-website:v1
bharathkumarraju@R77-NB193 custom_docker_image %



bharathkumarraju@R77-NB193 custom_docker_image % gcloud auth configure-docker
Adding credentials for all GCR repositories.
WARNING: A long list of credential helpers may cause delays running 'docker build'. We recommend passing the registry name to configure only the registry you are using.
After update, the following will be written to your Docker config file
 located at [/Users/bharathkumarraju/.docker/config.json]:
 {
  "credHelpers": {
    "gcr.io": "gcloud",
    "us.gcr.io": "gcloud",
    "eu.gcr.io": "gcloud",
    "asia.gcr.io": "gcloud",
    "staging-k8s.gcr.io": "gcloud",
    "marketplace.gcr.io": "gcloud"
  }
}

Do you want to continue (Y/n)?  Y

Docker configuration file updated.
bharathkumarraju@R77-NB193 custom_docker_image %

bharathkumarraju@R77-NB193 custom_docker_image % docker push gcr.io/${PROJECT_ID}/bharaths-website:v1
The push refers to repository [gcr.io/srianjaneyam/bharaths-website]
1da12eb01a97: Pushed
837cd0006926: Pushed
689cc6c05bc7: Layer already exists
b7d86c86e432: Layer already exists
08fb2e2ff084: Layer already exists
5f1add6e505b: Layer already exists
3e207b409db3: Layer already exists
v1: digest: sha256:90a5b71348c9cab8116927859047a9f131491fbb8f6660b0ca5c1d6fa1c97e0d size: 1775
bharathkumarraju@R77-NB193 custom_docker_image %


bharathkumarraju@R77-NB193 custom_docker_image % kubectl run bk-website --image gcr.io/srianjaneyam/bharaths-website:v1
kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
deployment.apps/bk-website created
bharathkumarraju@R77-NB193 custom_docker_image %

bharathkumarraju@R77-NB193 custom_docker_image % kubectl scale deployment bk-website --replicas 3
deployment.extensions/bk-website scaled
bharathkumarraju@R77-NB193 custom_docker_image %

bharathkumarraju@R77-NB193 custom_docker_image % kubectl get deployments
'NAME         READY   UP-TO-DATE   AVAILABLE   AGE
bk-website   3/3     3            3           2m20s
bharathkumarraju@R77-NB193 custom_docker_image' %


bharathkumarraju@R77-NB193 custom_docker_image % kubectl expose deployment bk-website --type LoadBalancer --port 80 --target-port 80
service/bk-website exposed
bharathkumarraju@R77-NB193 custom_docker_image %

bharathkumarraju@R77-NB193 custom_docker_image % kubectl get svc bk-website
NAME         TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
bk-website   LoadBalancer   10.35.253.62   <pending>     80:30311/TCP   33s
bharathkumarraju@R77-NB193 custom_docker_image %


bharathkumarraju@R77-NB193 custom_docker_image % kubectl get svc bk-website
NAME         TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)        AGE
bk-website   LoadBalancer   10.35.253.62   35.192.99.229   80:30311/TCP   63s
bharathkumarraju@R77-NB193 custom_docker_image %

bharathkumarraju@R77-NB193 custom_docker_image % kubectl delete svc bk-website
service "bk-website" deleted
bharathkumarraju@R77-NB193 custom_docker_image % kubectl delete deployment bk-website
deployment.extensions "bk-website" deleted
bharathkumarraju@R77-NB193 custom_docker_image %







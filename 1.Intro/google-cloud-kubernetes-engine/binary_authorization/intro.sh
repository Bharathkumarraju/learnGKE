enable container.googleapis.com
enable binaryauthorization.googleapis.com

bharathkumarraju@R77-NB193 wordpress-persistent-disks % gcloud services enable container.googleapis.com
bharathkumarraju@R77-NB193 wordpress-persistent-disks % gcloud services enable binaryauthorization.googleapis.com
Operation "operations/acf.62bbd9b7-baec-476a-804a-69ec2a814d36" finished successfully.
bharathkumarraju@R77-NB193 wordpress-persistent-disks %


bharathkumarraju@R77-NB193 wordpress-persistent-disks % gcloud container clusters delete autoscaling-cluster --zone us-central1-a
The following clusters will be deleted.
 - [autoscaling-cluster] in [us-central1-a]

Do you want to continue (Y/n)?  Y
Deleting cluster autoscaling-cluster...done.
Deleted [https://container.googleapis.com/v1/projects/srianjaneyam/zones/us-central1-a/clusters/autoscaling-cluster].
bharathkumarraju@R77-NB193 wordpress-persistent-disks %


bharathkumarraju@R77-NB193 wordpress-persistent-disks % gcloud container clusters get-credentials binary-auth-cluster --zone us-central1-a
Fetching cluster endpoint and auth data.
kubeconfig entry generated for binary-auth-cluster.
bharathkumarraju@R77-NB193 wordpress-persistent-disks % gcloud auth configure-docker
WARNING: Your config file at [/Users/bharathkumarraju/.docker/config.json] contains these credential helper entries:

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
Adding credentials for all GCR repositories.
WARNING: A long list of credential helpers may cause delays running 'docker build'. We recommend passing the registry name to configure only the registry you are using.
gcloud credential helpers already registered correctly.
bharathkumarraju@R77-NB193 wordpress-persistent-disks %



cat >> EOF > Dockerfile
FROM alpine
CMD tail -f /dev/null
EOF

export PROJECT_ID="$(gcloud config get-value project -q)"

bharathkumarraju@R77-NB193 binary_authorization % CONTAINER_PATH=us.gcr.io/$PROJECT_ID/hello-world
bharathkumarraju@R77-NB193 binary_authorization % echo $PROJECT_ID
srianjaneyam

bharathkumarraju@R77-NB193 binary_authorization % echo $CONTAINER_PATH
us.gcr.io/srianjaneyam/hello-world
bharathkumarraju@R77-NB193 binary_authorization % docker build -t $CONTAINER_PATH .
Sending build context to Docker daemon  4.608kB
Step 1/2 : FROM alpine
latest: Pulling from library/alpine
df20fa9351a1: Already exists
Digest: sha256:185518070891758909c9f839cf4ca393ee977ac378609f700f60a771a2dfe321
Status: Downloaded newer image for alpine:latest
 ---> a24bb4013296
Step 2/2 : CMD tail -f /dev/null
 ---> Running in 4b458cb58718
Removing intermediate container 4b458cb58718
 ---> 42bd9f1f04b7
Successfully built 42bd9f1f04b7
Successfully tagged us.gcr.io/srianjaneyam/hello-world:latest
bharathkumarraju@R77-NB193 binary_authorization %

bharathkumarraju@R77-NB193 binary_authorization % docker push $CONTAINER_PATH
The push refers to repository [us.gcr.io/srianjaneyam/hello-world]
50644c29ef5a: Layer already exists
latest: digest: sha256:35a70bdb7394af1b8c317cdcbb4c9b5560dbb165b53848fee7f77ab59f3e0724 size: 528
bharathkumarraju@R77-NB193 binary_authorization %

bharathkumarraju@R77-NB193 binary_authorization % kubectl run hello-bharath --image $CONTAINER_PATH
kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
deployment.apps/hello-bharath created
bharathkumarraju@R77-NB193 binary_authorization %


Enable binary_authorization:
===================================================>
bharathkumarraju@R77-NB193 binary_authorization % gcloud beta container clusters update binary-auth-cluster --zone us-central1-a --enable-binauthz
Updating binary-auth-cluster...⠛
Updating binary-auth-cluster...done.
Updated [https://container.googleapis.com/v1beta1/projects/srianjaneyam/zones/us-central1-a/clusters/binary-auth-cluster].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/us-central1-a/binary-auth-cluster?project=srianjaneyam


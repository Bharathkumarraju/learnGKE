

>>>>> Module 1 Demo 1 - 2

# create a cluster and add a preemeptive vm in one node pool with label as preemptive=true
# and giving storage read/write permission as well
# create two bucket with name customer reviews and customer ratings
# upoad only one file from local directory/customer-reviews to bucket/customer-reviews

gcloud config set project spikey-gke

gcloud config set compute/zone us-central1-a

sudo gcloud components update

kubectl get nodes

kubectl describe node gke-spikey-dev-cluste-preemptive-pool-c72cb76e-hzpb

# go to editor and write image file in gke-dev directory
# upload that file in gcr

docker build -t gcr.io/spikey-gke/customer-ratings:v1 .

gcloud auth configure-docker

docker push gcr.io/spikey-gke/customer-ratings:v1

# write yaml file of job
# run the job

kubectl apply -f present-ratings-job.yaml

kubectl get pods 

kubectl get job

kubectl describe job present-ratings-job

# Go in instance groups monitoring to observe that job ran on one instance group only
# Now taint the preemptive node pool

gcloud container node-pools list --cluster spikey-dev-cluster

kubectl get nodes

kubectl taint nodes gke-spikey-dev-cluste-preemptive-pool-c72cb76e-hzpb \
 preemptive="true":NoSchedule

kubectl describe node gke-spikey-dev-cluste-preemptive-pool-c72cb76e-hzpb

# Upload remaining reviews to bucket
# Schedule the time properly

kubectl apply -f weekly-ratings-cronjob.yaml

kubectl get pods 

kubectl get cronjob

kubectl describe job weekly-ratings-cronjob

kubectl get nodes

kubectl taint nodes gke-spikey-dev-cluste-preemptive-pool-c72cb76e-hzpb preemptive-

kubectl get nodes

kubectl describe nodes gke-spikey-dev-cluste-preemptive-pool-c72cb76e-hzpb

gcloud container node-pools list --cluster spikey-dev-cluster

gcloud container node-pools delete preemptive-pool --cluster spikey-dev-cluster



>>>>> Module 1 Demo 3
### STATELESS - STATEFUL - ROLLING UPDATE

gcloud config set project spikey-gke

gcloud config set compute/zone us-central1-a

sudo gcloud components update


# Uploading website to gcr 

docker build -t gcr.io/spikey-gke/spikey-website:v1 .

gcloud auth configure-docker

docker push gcr.io/spikey-gke/spikey-website:v1 

docker build -t gcr.io/spikey-gke/spikey-website:v1-offer .

docker push gcr.io/spikey-gke/spikey-website:v1-offer 


# Deploying spikeysales first version 

kubectl apply -f spikey-stateless-deployment.yaml 

kubectl describe deployment spikey-website

kubectl get pods -l app=spikey-website

kubectl describe pod spikey-website

kubectl get deployments spikey-website -o yaml

kubectl expose deployment spikey-website --type LoadBalancer --port 80 --target-port 80


# Deploying spikeysales secong version 
# Go to deployment console action -> rolling update and then change the image file to 
# gcr.io/spikey-gke/spikeysales-website:v1-offer
# observe the revision

kubectl rollout status deployment spikey-website

#kubectl rollout history deployment spikey-website

kubectl describe deployment spikey-website

kubectl get pods -l app=spikey-website

kubectl describe pod spikey-website

kubectl get deployments spikey-website -o yaml

kubectl rollout undo deployment spikey-website --to-revision=1


# Deploying stateful deployment using RollingUpdate using imagefile
# gcr.io/spikey-gke/spikeysales-website:v1-offer
# Delete pods from both the deloyment and observe the difference 


kubectl apply -f spikey-stateful-deployment.yaml 

kubectl describe deployment spikey-website

kubectl get pods -l app=spikey-website

kubectl describe pod spikey-website

kubectl get deployments spikey-website -o yaml

# Delete Deployment having ReplicaSet pods

>>>>> Module 1 Demo 4

gcloud container clusters get-credentials spikey-dev-cluster \
--zone us-central1-a --project spikey-gke

gcloud pubsub topics create echo
gcloud pubsub subscriptions create echo-read --topic=echo

kubectl apply -f message-alert-pubsub.yaml

kubectl get pods -l app=message-alert

kubectl logs -l app=message-alert

# Specify a Service Account Name .
# In the Role dropdown, select “Pub/Sub → Subscriber”.
# Check Furnish a new private key and choose key type as JSON.

kubectl create secret generic message-alert-key \
--from-file=key.json=../../spikey-gke-fb086be90faf.json


kubectl apply -f message-alert-pubsub.yaml

kubectl get pods -l app=message-alert

gcloud pubsub topics publish echo \
--message="Flash Sale on Spikeysales! 50% off on all Face Shop products.!"

kubectl logs -l app=message-alert







>>>>>>> Module 2 Demo 1
# Network Policy

export PS1="\[\e[34m\]\w\[\e[m\]>\n-->"

gcloud config set project spikey-gke

gcloud config set compute/zone us-central1-a

sudo gcloud components update

gcloud container clusters create spikey-cluster \
 --enable-network-policy

kubectl run spikey-website --labels app=spikey-website \
  --image=gcr.io/spikey-gke/spikey-website:v1 \
  --port 80 \
  --expose

kubectl apply -f spikey-allow-from-dev.yaml 

kubectl run -l app=dev --image=alpine \
 --restart=Never --rm -i -t test-pod

wget -qO- --timeout=2 http://spikey-website:80

exit

kubectl run -l app=test --image=alpine \
 --restart=Never --rm -i -t test-pod

wget -qO- --timeout=2 http://spikey-website:80

exit

kubectl apply -f dev-allow-from-spikey.yaml 

kubectl run nginx --labels app=nginx \
  --image=nginx --port 9000 \
  --expose

kubectl run -l app=dev --image=alpine \
 --restart=Never --rm -i -t test-pod

wget -qO- --timeout=2 http://spikey-website:80

wget -qO- --timeout=2 http://nginx:9000

wget -qO- --timeout=2 http://www.example.com

exit

gcloud container clusters delete spikey-cluster \
 --zone us-central1-a


>>>>> Moule 2 Demo 2
# Understanding private clusters and internal load balancing


# Creating private cluster and source instace 

export PS1="\[\e[34m\]\w\[\e[m\]>\n-->"

gcloud config set compute/zone us-central1-a

gcloud beta container clusters create spikey-website-cluster \
 --private-cluster \
 --master-ipv4-cidr 172.16.0.16/28 \
 --enable-ip-alias \
 --create-subnetwork "" 

gcloud compute instances create content-team-instance \
 --zone us-central1-a 

# You cant access private cluster from source instance

gcloud compute ssh content-team-instance --zone us-central1-a

gcloud container clusters get-credentials spikey-website-cluster \
 --zone us-central1-a

# Giving access of private cluster to source instance

gcloud compute networks subnets list --network default

gcloud compute networks subnets describe gke-spikey-website-cluster-subnet-dee353c1\
  --region us-central1

gcloud compute instances stop content-team-instance

gcloud compute instances set-service-account content-team-instance \
 --zone=us-central1-a \
 --scopes 'https://www.googleapis.com/auth/cloud-platform'

gcloud compute instances describe content-team-instance \
 --zone us-central1-a | grep natIP

gcloud container clusters update spikey-website-cluster \
 --enable-master-authorized-networks \
 --master-authorized-networks 35.193.223.122/32


# Now you can access private cluster from content-team-instance

gcloud compute ssh content-team-instance --zone us-central1-a

gcloud container clusters get-credentials spikey-website-cluster \
 --zone us-central1-a

sudo apt-get install kubectl

kubectl get nodes --output yaml | grep -A4 addresses

kubectl get nodes --output wide





>>> Module 2 Demo 3
#Cluster Ip, Internal lb, native lb

export PS1="\[\e[34m\]\w\[\e[m\]>\n-->"

gcloud config set compute/zone us-central1-a

gcloud container get-server-config

gcloud container clusters create spikey-website-cluster \
    --enable-ip-alias \
    --create-subnetwork="" \
    --network=default \
    --zone=us-central1-a \
    --cluster-version=1.10.7-gke.6


# Show the cluster IP Service usses

# Create a deployment in private cluster 
# Create a Cluster IP load balancer 
# (show thats its not accessible in browser buts its accesible within cluster and not in another vm in same network)

kubectl apply -f spikey-internal-lb-service.yaml

# Another VM will be qa-team-instance


>>> Module 2 Demo 4

https://github.com/kubernetes/kubernetes/tree/master/test/images/serve-hostname

# (Show that now can acces a cluster from another VM within that network)
# Now create a new VM in another region and 
# show that its not accesible though its in same network

export PS1="\[\e[34m\]\w\[\e[m\]>\n-->"

gcloud container clusters get-credentials spikey-website-cluster \
 --zone us-central1-a \
 --project spikey-gke


kubectl apply -f spikey-neg-deployment.yaml

kubectl apply -f spikey-neg-service.yaml

kubectl apply -f spikey-neg-ingress.yaml

kubectl describe ingress spikey-website-ingress

kubectl get ingress spikey-website-ingress

gcloud beta compute backend-services list

gcloud compute backend-services get-health \
 k8s1-959d85dc-default-spikey-website-svc-80-b6345648 \
 --global

kubectl scale deployment spikey-website --replicas 2

kubectl get deployment spikey-website

for i in `seq 1 100`; do \
  curl --connect-timeout 1 -s 35.227.212.249 && echo; \
done  | sort | uniq -c





>>>>> Module 2 Demo 4

# Understanding pod policies

export PS1="\[\e[34m\]\w\[\e[m\]>\n-->"

gcloud container clusters get-credentials spikey-website-cluster \
 --zone us-central1-a \
 --project spikey-gke

kubectl create namespace spikey-pod

kubectl create serviceaccount intern -n spikey-pod

kubectl create rolebinding intern-editor \
 --clusterrole=edit \
 --serviceaccount=spikey-pod:intern \
 -n spikey-pod


kubectl create -f spikey-psp.yaml -n spikey-pod 

kubectl get podsecuritypolicies

gcloud beta container clusters update spikey-website-cluster \
 --enable-pod-security-policy \
 --zone=us-central1-a 

kubectl auth can-i use podsecuritypolicy/spikey-psp \
 --as=system:serviceaccount:spikey-pod:intern \
 -n spikey-pod 

kubectl apply -f create-pod.yaml \
 --as=system:serviceaccount:spikey-pod:intern \
 -n spikey-pod 

# kubectl create -f create-priviledged-pod.yaml \
#  --as=system:serviceaccount:spikey-pod:intern \
#  -n spikey-pod 

gcloud info | grep Account

kubectl create clusterrolebinding spikey-website-cluster-admin-binding \
 --clusterrole=cluster-admin \
 --user=spikeysales@loonycorn.com

kubectl create role psp:unprivileged \
    -n spikey-pod \
    --verb=use \
    --resource=podsecuritypolicy \
    --resource-name=spikey-psp 

kubectl create rolebinding intern:psp:unprivileged \
    -n spikey-pod \
    --role=psp:unprivileged \
    --serviceaccount=spikey-pod:intern

kubectl auth can-i use podsecuritypolicy/spikey-psp \
 --as=system:serviceaccount:spikey-pod:intern \
 -n spikey-pod 


kubectl apply -f create-pod.yaml \
 --as=system:serviceaccount:spikey-pod:intern \
 -n spikey-pod 

kubectl apply -f create-privileged-pod.yaml \
 --as=system:serviceaccount:spikey-pod:intern \
 -n spikey-pod 


kubectl delete pod spikey \
 --as=system:serviceaccount:spikey-pod:intern \
 -n spikey-pod 

kubectl run spikey --image=gcr.io/spikey-gke/spikey-website:v1 \
 --as=system:serviceaccount:spikey-pod:intern \
 -n spikey-pod 

kubectl get pods \
 --as=system:serviceaccount:spikey-pod:intern \
 -n spikey-pod 

kubectl get events  \
 --as=system:serviceaccount:spikey-pod:intern \
 -n spikey-pod | head -n 2


kubectl create rolebinding default:psp:unprivileged \
    --role=psp:unprivileged \
    --serviceaccount=spikey-pod:default \
    -n spikey-pod 

kubectl  get pods --watch \
 --as=system:serviceaccount:spikey-pod:intern \
 -n spikey-pod

gcloud beta container clusters update spikey-website-cluster \
 --no-enable-pod-security-policy \
 --zone=us-central1-a 


Module 2 Demo 6

# IP rotation

export PS1="\[\e[34m\]\w\[\e[m\]>\n-->"

gcloud config set compute/zone us-central1-a

gcloud container clusters update spikey-website-cluster \
 --start-ip-rotation 

gcloud container operations list | grep "AUTO_UPGRADE_NODES.*RUNNING"

gcloud container operations wait operation-1541241685595-21eaaea5 \
 --zone us-central1-a

gcloud container clusters get-credentials spikey-website-cluster 

gcloud container clusters update spikey-website-cluster \
 --complete-ip-rotation



gcloud container clusters get-credentials spikey-website-cluster --project spikey-developers --zone us-central1-a

>>> Module 3 Demo 1

export PS1="\[\e[34m\]\w\[\e[m\]>\n-->"

gcloud config set project spikey-gke

gcloud config set compute/zone us-central1-f


# Clonning GCP repository 

git clone \
 https://github.com/GoogleCloudPlatform/continuous-deployment-on-kubernetes.git 

cd continuous-deployment-on-kubernetes

# Creating cluster

gcloud container clusters create jenkins-cd \
 --num-nodes 2 \
 --machine-type n1-standard-2 \
 --scopes "https://www.googleapis.com/auth/projecthosting,cloud-platform"

#Insatll Helm

wget https://storage.googleapis.com/kubernetes-helm/helm-v2.9.1-linux-amd64.tar.gz

tar zxfv helm-v2.9.1-linux-amd64.tar.gz

cp linux-amd64/helm .

kubectl create clusterrolebinding cluster-admin-binding \
 --clusterrole=cluster-admin \
 --user=$(gcloud config get-value account)

kubectl create serviceaccount tiller \
 --namespace kube-system

kubectl create clusterrolebinding tiller-admin-binding \
 --clusterrole=cluster-admin \
 --serviceaccount=kube-system:tiller

./helm init --service-account=tiller

./helm update

./helm version

# Installing Jenkins

./helm install -n cd stable/jenkins \
 -f jenkins/values.yaml  \
 --version 0.16.6 --wait

kubectl get pods

export POD_NAME=$(kubectl get pods -l "component=cd-jenkins-master" -o jsonpath="{.items[0].metadata.name}")

kubectl port-forward $POD_NAME 8080:8080 >> /dev/null &

kubectl get svc

# Connecting to jenkins

printf $(kubectl get secret cd-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo

# Preview on port 8080

# Deploying sample-app

cd sample-app

kubectl create ns production

kubectl apply -f k8s/production -n production

kubectl apply -f k8s/canary -n production

kubectl apply -f k8s/services -n production

kubectl scale deployment gceme-frontend-production \
 -n production --replicas 4

kubectl get pods -n production -l app=gceme -l role=frontend

kubectl get pods -n production -l app=gceme -l role=backend

kubectl get service gceme-frontend -n production

export FRONTEND_SERVICE_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" \
 --namespace=production services gceme-frontend)

curl http://$FRONTEND_SERVICE_IP/version

#Creating pipeline

gcloud alpha source repos create default

git init

git config credential.helper gcloud.sh

git remote add origin https://source.developers.google.com/p/spikey-gke/r/default

git config --global user.email "spikeysales@loonycorn.com"

git config --global user.name "spikey-dev"

# Edit Jenkinsfile and correct project_id

git add .

git commit -m "Initial commit"

git push origin master

#Checking deployment

curl \
http://localhost:8001/api/v1/proxy/namespaces/production/services/gceme-frontend:80/version

# Canary deployment

git checkout -b canary

git add html.go main.go

git commit -m "Version 2.0.0"

git push origin canary

export FRONTEND_SERVICE_IP=$(kubectl get -o \
jsonpath="{.status.loadBalancer.ingress[0].ip}" \
 --namespace=production services gceme-frontend)

while true; do curl http://$FRONTEND_SERVICE_IP/version; sleep 1; done

#Deploying to production

git checkout master

git merge canary

git push origin master


export FRONTEND_SERVICE_IP=$(kubectl get -o \
jsonpath="{.status.loadBalancer.ingress[0].ip}" \
 --namespace=production services gceme-frontend)

while true; do curl http://$FRONTEND_SERVICE_IP/version; sleep 1; done


kubectl get service gceme-frontend -n production






bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % kubectl run nging --image=nginx --replicas=2
kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
deployment.apps/nging created
bharathkumarraju@R77-NB193 ntuc-coe-ds-uat %


bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % kubectl get pods -o wide
NAME                     READY   STATUS    RESTARTS   AGE   IP          NODE                                                  NOMINATED NODE   READINESS GATES
nging-78fc7c5bbf-6m2sj   1/1     Running   0          75s   10.60.3.4   gke-hanumans-zonal-clust-hanuman-pool-4e6e70a7-brdp   <none>           <none>
nging-78fc7c5bbf-pwhlb   1/1     Running   0          75s   10.60.4.3   gke-hanumans-zonal-clust-hanuman-pool-4e6e70a7-qqhj   <none>           <none>
bharathkumarraju@R77-NB193 ntuc-coe-ds-uat %


bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % kubectl expose deployment nging --port=80 --target-port=80 --type=LoadBalancer
service/nging exposed
bharathkumarraju@R77-NB193 ntuc-coe-ds-uat %

bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % kubectl get service/nging
NAME    TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)        AGE
nging   LoadBalancer   10.63.247.92   35.187.250.51   80:31253/TCP   79s
bharathkumarraju@R77-NB193 ntuc-coe-ds-uat %

bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % kubectl run php-apache --image=k8s.gcr.io/hpa-example --requests=cpu=200m --expose --port=80
kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
service/php-apache created
deployment.apps/php-apache created


bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10
horizontalpodautoscaler.autoscaling/php-apache autoscaled
bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % kubectl get hpa
NAME         REFERENCE               TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
php-apache   Deployment/php-apache   <unknown>/50%   1         10        0          10s
bharathkumarraju@R77-NB193 ntuc-coe-ds-uat %


bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % kubectl get hpa
NAME         REFERENCE               TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
php-apache   Deployment/php-apache   0%/50%    1         10        1          72s
bharathkumarraju@R77-NB193 ntuc-coe-ds-uat %


bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % kubectl run -i --tty load-generator --image=busybox /bin/sh
kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
If you don't see a command prompt, try pressing enter.
/ #


bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % kubectl run -i --tty load-generator --image=busybox /bin/sh
kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
If you don't see a command prompt, try pressing enter.
/ # while true; do wget -q -O- http://php-apache.default.svc.cluster.local; done
OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!O


bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % kubectl get hpa
NAME         REFERENCE               TARGETS    MINPODS   MAXPODS   REPLICAS   AGE
php-apache   Deployment/php-apache   465%/50%   1         10        1          4m34s


bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % kubectl get hpa
NAME         REFERENCE               TARGETS    MINPODS   MAXPODS   REPLICAS   AGE
php-apache   Deployment/php-apache   465%/50%   1         10        1          4m36s


bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % kubectl get hpa
NAME         REFERENCE               TARGETS    MINPODS   MAXPODS   REPLICAS   AGE
php-apache   Deployment/php-apache   266%/50%   1         10        10         5m27s
bharathkumarraju@R77-NB193 ntuc-coe-ds-uat %

After stopping busybox which runs while loop like below autoscale pods will get scale down to 1.
while true; do wget -q -O- http://php-apache.default.svc.cluster.local; done

bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % kubectl get hpa
NAME         REFERENCE               TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
php-apache   Deployment/php-apache   15%/50%   1         10        10         7m20s
bharathkumarraju@R77-NB193 ntuc-coe-ds-uat %

bharathkumarraju@R77-NB193 ntuc-coe-ds-uat % kubectl get hpa
NAME         REFERENCE               TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
php-apache   Deployment/php-apache   0%/50%    1         10        10         9m37s
bharathkumarraju@R77-NB193 ntuc-coe-ds-uat %






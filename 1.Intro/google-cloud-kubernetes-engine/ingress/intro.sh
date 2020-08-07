ingress:

When you have multiple services that you want to expose to the expose to the external world use ingress
Ingress is a collection of rules how external clients can access your kubernetes cluster.


bharathkumarraju@R77-NB193 custom_docker_image % kubectl run  bk-website --image gcr.io/srianjaneyam/bharaths-website:v1 --replicas 3 --port=80
kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
deployment.apps/bk-website created

bharathkumarraju@R77-NB193 custom_docker_image % kubectl expose deployment bk-website --type NodePort --target-port 80
service/bk-website exposed
bharathkumarraju@R77-NB193 custom_docker_image %


bharathkumarraju@R77-NB193 custom_docker_image % kubectl apply -f ../ingress/ingress.yml
ingress.networking.k8s.io/bharaths-website-ingress created
bharathkumarraju@R77-NB193 custom_docker_image %

bharathkumarraju@R77-NB193 custom_docker_image % kubectl get ingress
NAME                       HOSTS   ADDRESS         PORTS   AGE
bharaths-website-ingress   *       34.102.227.53   80      42s
bharathkumarraju@R77-NB193 custom_docker_image %




bharathkumarraju@R77-NB193 custom_docker_image % kubectl describe ingress bharaths-website-ingress
Name:             bharaths-website-ingress
Namespace:        default
Address:          34.102.227.53
Default backend:  bk-website:80 (10.32.0.10:80,10.32.1.11:80,10.32.2.7:80)
Rules:
  Host  Path  Backends
  ----  ----  --------
  *     *     bk-website:80 (10.32.0.10:80,10.32.1.11:80,10.32.2.7:80)
Annotations:
  ingress.kubernetes.io/forwarding-rule:             k8s-fw-default-bharaths-website-ingress--98fd932993a8ab95
  ingress.kubernetes.io/target-proxy:                k8s-tp-default-bharaths-website-ingress--98fd932993a8ab95
  ingress.kubernetes.io/url-map:                     k8s-um-default-bharaths-website-ingress--98fd932993a8ab95
  kubectl.kubernetes.io/last-applied-configuration:  {"apiVersion":"networking.k8s.io/v1beta1","kind":"Ingress","metadata":{"annotations":{},"name":"bharaths-website-ingress","namespace":"default"},"spec":{"backend":{"serviceName":"bk-website","servicePort":80}}}

  ingress.kubernetes.io/backends:  {"k8s-be-32034--98fd932993a8ab95":"Unknown"}
Events:
  Type    Reason  Age   From                     Message
  ----    ------  ----  ----                     -------
  Normal  ADD     109s  loadbalancer-controller  default/bharaths-website-ingress
  Normal  CREATE  69s   loadbalancer-controller  ip: 34.102.227.53
bharathkumarraju@R77-NB193 custom_docker_image %



bharathkumarraju@R77-NB193 custom_docker_image % kubectl describe ingress bharaths-website-ingress
Name:             bharaths-website-ingress
Namespace:        default
Address:          34.102.227.53
Default backend:  bk-website:80 (10.32.0.10:80,10.32.1.11:80,10.32.2.7:80)
Rules:
  Host  Path  Backends
  ----  ----  --------
  *     *     bk-website:80 (10.32.0.10:80,10.32.1.11:80,10.32.2.7:80)
Annotations:
  kubectl.kubernetes.io/last-applied-configuration:  {"apiVersion":"networking.k8s.io/v1beta1","kind":"Ingress","metadata":{"annotations":{},"name":"bharaths-website-ingress","namespace":"default"},"spec":{"backend":{"serviceName":"bk-website","servicePort":80}}}

  ingress.kubernetes.io/backends:         {"k8s-be-32034--98fd932993a8ab95":"HEALTHY"}
  ingress.kubernetes.io/forwarding-rule:  k8s-fw-default-bharaths-website-ingress--98fd932993a8ab95
  ingress.kubernetes.io/target-proxy:     k8s-tp-default-bharaths-website-ingress--98fd932993a8ab95
  ingress.kubernetes.io/url-map:          k8s-um-default-bharaths-website-ingress--98fd932993a8ab95
Events:
  Type    Reason  Age   From                     Message
  ----    ------  ----  ----                     -------
  Normal  ADD     19m   loadbalancer-controller  default/bharaths-website-ingress
  Normal  CREATE  19m   loadbalancer-controller  ip: 34.102.227.53
bharathkumarraju@R77-NB193 custom_docker_image %

bharathkumarraju@R77-NB193 custom_docker_image % kubectl delete -f ../ingress/ingress.yml
ingress.networking.k8s.io "bharaths-website-ingress" deleted

bharathkumarraju@R77-NB193 custom_docker_image %
bharathkumarraju@R77-NB193 custom_docker_image % kubectl delete svc bk-website
service "bk-website" deleted
bharathkumarraju@R77-NB193 custom_docker_image % kubectl delete deployment bk-website
deployment.extensions "bk-website" deleted
bharathkumarraju@R77-NB193 custom_docker_image %




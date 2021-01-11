[![CircleCI](https://circleci.com/gh/sebmrgn/checkout-project.svg?style=svg)](https://app.circleci.com/pipelines/github/sebmrgn/checkout-project)
## Simple website CI/CD pipeline with K8S and CircleCI

A simple project to create a managed Kubernetes cluster on AWS EKS and host a simple webapp. 
In this project we:
- provision an EKS cluster in an AWS using Terraform
- create a CircleCI deployment for our simple-website using orbs
- deploy the simple-website behind a NLB and expose it to public access
- install Prometheus and Grafana for monitoring
- utilise Cloudwatch for logging

### Diagram

![diagram](https://github.com/sebmrgn/checkout-project/blob/master/diagram.png?raw=true)


### Infrastructure

- deploy a VPC with private (for EKS cluster) and public subnets (for NLB)
- deploy the EKS cluster via Terraform as mentioned in the guide [here](https://github.com/sebmrgn/checkout-project/blob/master/terraform/README.md)
- deploy Prometheus and Grafana using the script
```bash
chmod +x terraform/scripts/prometheus-grafana.sh
./prometheus-grafana.sh
```

- to access Prometheus(* port forwarding, since no internal network for this project)
```bash
chmod +x terraform/scripts/prometheus-grafana.sh
./prometheus-grafana.sh

export POD_NAME=$(kubectl get pods --namespace monitoring -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace monitoring port-forward $POD_NAME 9090
```

- Grafana is provisioning an ELB in the public subnet, so the dashboard can be accessed externally
- to find the endpoint and password
```bash
➜ git:(master) ✗ kubectl get svc grafana -n monitoring
NAME      TYPE           CLUSTER-IP     EXTERNAL-IP                                                               PORT(S)        AGE
grafana   LoadBalancer   172.20.89.85   a2bca697608b34c0ebfe73a976121aa8-1553215385.eu-west-1.elb.amazonaws.com   80:30090/TCP   10m

kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

### CircleCI

- Sign in to CircleCI with your GitHub auth
- Add the "checkout-project" project
- Go to Project Settings - Environment variables and set the values for the following:
    - AWS_ACCESS_KEY_ID
    - AWS_SECRET_ACCESS_KEY
    - AWS_ECR_URL
    - AWS_DEFAULT_REGION
- CircleCi will automatically look for a config file ".circleci/config.yml" in your project
- deployments are triggered automatically when changes have been pushed to the master branch
- the pipeline has 2 stages
    - build-and-push-image 
    - deploy-application

![circle](https://github.com/sebmrgn/checkout-project/blob/master/circleci.png?raw=true)

### Simple-website

- to verify the deployment has run successfully
```bash
➜ git:(master) ✗ kubectl get svc simple-website
NAME             TYPE           CLUSTER-IP    EXTERNAL-IP                                                                     PORT(S)        AGE
simple-website   LoadBalancer   172.20.2.84   adc524b3786134fdaa5afa7a69534535-d83a932b7311ca1b.elb.eu-west-1.amazonaws.com   80:31262/TCP   4m27s
```

- to confirm the application is available publicly, paste the EXTERNAL-IP in browser

### Scaling

- to scale up the simple-website, just update the number of pod replicas running
```bash
➜ git:(master) ✗ kubectl scale --replicas=2 deployment.apps/simple-website
deployment.apps/simple-website scaled

➜ git:(master) ✗ kubectl get pods --watch
NAME                              READY   STATUS    RESTARTS   AGE
simple-website-85fdd44cb9-2rh68   1/1     Running   0          59s
simple-website-85fdd44cb9-t7kd7   1/1     Running   0          5m31s
```
- second service is automatically added to the NLB target group










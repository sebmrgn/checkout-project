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


### CircleCI

- Sign in to CircleCI with your GitHub auth
- Add the simple-website project
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

### Simple-website

- to verify the deployment has run successfully
```bash
➜  terraform git:(master) ✗ kubectl get svc simple-website
NAME             TYPE           CLUSTER-IP    EXTERNAL-IP                                                                     PORT(S)        AGE
simple-website   LoadBalancer   172.20.2.84   adc524b3786134fdaa5afa7a69534535-d83a932b7311ca1b.elb.eu-west-1.amazonaws.com   80:31262/TCP   73m
```

- to confirm the application is available publicly, paste the EXTERNAL-IP in browser













#!/bin/bash

echo "This will install Prometheus and Graphana via HELM"

## Add Prometheus and Grafana to HELM repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

## create a new NS and install Prometheus
kubectl create namespace monitoring

helm install prometheus prometheus-community/prometheus \
    --namespace monitoring \
    --set alertmanager.persistentVolume.storageClass="gp2" \
    --set server.persistentVolume.storageClass="gp2"

## Get a password from SSM Param Store

ADMIN_PASS=`aws ssm get-parameters --name "grafana" --query "Parameters[*].[Value]" --output text | cat`

## install Grafana
helm install grafana grafana/grafana \
    --namespace monitoring \
    --set persistence.storageClassName="gp2" \
    --set persistence.enabled=true \
    --set adminPassword=${ADMIN_PASS} \
    --values /Users/seb/personal_projects/Checkout_project/terraform/scripts/grafana.yaml \
    --set service.type=LoadBalancer

#!/bin/bash

echo "This will install Prometheus and Graphana via HELM"

## Add Prometheus and Grafana to HELM repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

## create a new NS and install Prometheus
kubectl create namespace prometheus
helm install prometheus prometheus-community/prometheus \
    --namespace prometheus \
    --set alertmanager.persistentVolume.storageClass="gp2" \
    --set server.persistentVolume.storageClass="gp2"


## create a new NS and install Grafana
kubectl create namespace grafana
helm install grafana grafana/grafana \
    --namespace grafana \
    --set persistence.storageClassName="gp2" \
    --set persistence.enabled=true \
    --set adminPassword='EKS!sAWSome' \
    --values /Users/seb/personal_projects/Checkout_project/terraform/scripts/grafana.yaml \
    --set service.type=LoadBalancer

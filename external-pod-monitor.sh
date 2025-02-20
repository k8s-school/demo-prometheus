#!/bin/bash

# Check metrics from example-app

set -euxo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

NS=example-app

# Deploy app
kubectl apply -f "$DIR"/manifests/
kubectl rollout status deployment example-app -n "$NS" --timeout=300s
kubectl get podmonitor -n "$NS"

# Deploy pod to check metrics are available
kubectl delete pod -l run=curl -n "$NS" --force --grace-period=0 || true
kubectl run -n "$NS" --image=curlimages/curl:8.12.1 curl -- sleep infinity
kubectl wait --for=condition=Ready pod -l run=curl -n "$NS" --timeout=300s
kubectl exec -n "$NS" -it curl -- curl -Lk "http://example-app.$NS:8080/metrics"

# TODO: Check metrics are available in Prometheus
PROM_URL="prometheus-stack-kube-prom-prometheus.monitoring"
kubectl exec -n "$NS" -it curl -- curl -G http://$PROM_URL:9090/api/v1/targets/metadata \
    --data-urlencode 'match_target={namespace="example-app"}' \
    --data-urlencode 'limit=2' | grep "$NS"
#!/bin/bash

# Check metrics from example-app

set -euxo pipefail

NS=example-app

kubectl rollout status deployment example-app -n "$NS" --timeout=300s
kubectl delete pod -l run=curl -n "$NS" --force --grace-period=0 || true
kubectl run -n "$NS" --image=curlimages/curl:8.12.1 curl -- sleep infinity
kubectl wait --for=condition=Ready pod -l run=curl -n "$NS" --timeout=300s
kubectl exec -n "$NS" -it curl -- curl -Lk "http://example-app.$NS:8080/metrics"

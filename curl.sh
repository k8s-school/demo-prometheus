#!/bin/bash

# Check metrics from example-app

set -euxo pipefail

kubectl run  --image=curlimages/curl:8.12.1 curl -- sleep infinity
kubectl exec -it curl -- curl -Lk http://example-app.example-app:8080/metrics

# Pre-requisite 

An up and running k8s cluster

NOTE: Successfully tested on kind-v0.6.1 (2020-01-10) and helm-v3.0.1

# Ex1: Install prometheus-operator

```shell
./install.sh

# Prometheus access:
kubectl port-forward -n monitoring prometheus-prometheus-stack-kube-prom-prometheus-0 9090

# Grafana access:
# login as admin with password prom-operator
kubectl port-forward $(kubectl get  pods --selector=app.kubernetes.io/name=grafana -n  monitoring --output=jsonpath="{.items..metadata.name}") -n monitoring  3000 &

# Alertmanager UI access
kubectl port-forward -n monitoring svc/alertmanager-operated 9093:9093 

```


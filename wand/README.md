# Wand helm chart

This chart is to install the relevent components required for Wand

## Installation
### One-liner
Add Wand repo:
```
helm repo add wand https://wand-cloud.github.io/charts/
```

Install the chart:
```
export CUSTOMER_ID=<Customer ID provided by Wand>
export CLUSTER_ID=<Cluster ID>
export TOKEN=<Authentication token provided by Wand>

helm upgrade -i wand wand/wand -n wand --create-namespace \
--set customerID=$CUSTOMER_ID \
--set clusterID=$CLUSTER_ID \
--set auth.token=$TOKEN
```

## Secret management

If you prefer to implement your own secret management to provide the authentication token the chart can consume an existing Kubernetes secret.
To do so create a custom values.yaml file with the following:

```
auth:
  createSecret: false

prometheus:
  server:
    extraSecretMounts:
      - name: auth-file # This name is required as "auth-file"
        mountPath: /etc/config/auth
        secretName: <Existing secret name>
```

Then install by running the following:
```
export CUSTOMER_ID=<Customer ID provided by Wand>
export CLUSTER_ID=<Cluster ID>

helm upgrade -i wand wand/wand -n wand --create-namespace \
--set customerID=$CUSTOMER_ID \
--set clusterID=$CLUSTER_ID \
-f <custom values file>
```
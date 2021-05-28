# Terraform Google GKE node pool update 

Sample terraform code that creates a GCP project and start a GKE cluster with a node pool.

The configuration allows for node pool updates without the downtime while deleting the node pool because the replacement node pool is created prior to deleting the existing one.
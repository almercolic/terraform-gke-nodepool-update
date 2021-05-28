locals {
  oauth_scopes = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]
}

resource "google_service_account" "default" {
  project      = google_project.project.project_id
  account_id   = "default-sa"
  display_name = "GKE Service Account"
}

resource "google_container_cluster" "cluster" {
  project = google_project.project.project_id
  name    = "cluster"

  location = "europe-west3"

  network    = google_compute_network.vpc_network.id
  subnetwork = google_compute_subnetwork.subnetwork.id

  # A cluster can't be created w/o node pool. This node pool is removed immediately
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "random_integer" "random" {
  max = 999
  min = 100
  keepers = {
    name : var.nodepool_name,
    project : google_project.project.project_id,
    cluster : google_container_cluster.cluster.name,
    machine_type : var.nodepool_machine_type,
    location : var.nodepool_location,
    service_account : google_service_account.default.email,
    oauth_scopes : join(",", sort(local.oauth_scopes)),
  }
}

resource "google_container_node_pool" "nodepool" {
  project    = google_project.project.project_id
  name       = "${var.nodepool_name}-${random_integer.random.result}"
  location   = var.nodepool_location
  cluster    = google_container_cluster.cluster.name
  node_count = var.nodepool_node_count

  node_config {
    preemptible     = true
    machine_type    = var.nodepool_machine_type
    service_account = google_service_account.default.email
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "google_compute_network" "vpc_network" {
  project                 = google_project.project.project_id
  name                    = "gke-nodepool-update-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  project       = google_project.project.project_id
  name          = "gke-nodepool-update-subnet"
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.vpc_network.id
  region        = "europe-west3"
}
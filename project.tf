resource "random_integer" "project_id_suffix" {
  max = 999
  min = 100
}
resource "google_project" "project" {
  name                = "GKE nodepool example"
  project_id          = "gke-nodepool-example-${random_integer.project_id_suffix.result}"
  org_id              = data.google_organization.my_org.org_id
  auto_create_network = false
  billing_account     = data.google_billing_account.billing_acc.id
}

data "google_organization" "my_org" {
  domain = var.organization
}

data "google_billing_account" "billing_acc" {
  billing_account = var.billing_account
}

locals {
  services = [
    "logging.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com"
  ]
}

resource "google_project_service" "services" {
  for_each           = toset(local.services)
  service            = each.value
  project            = google_project.project.project_id
  disable_on_destroy = false
}


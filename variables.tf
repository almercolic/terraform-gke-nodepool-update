variable "organization" {
}
variable "billing_account" {
}

variable "nodepool_name" {
  default = "nodepool"
}
variable "nodepool_location" {
  default = "europe-west3"
}
variable "nodepool_node_count" {
  default = 1
}
variable "nodepool_machine_type" {
  default = "e2-small"
}
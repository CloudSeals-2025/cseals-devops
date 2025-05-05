# modules/billing_export/variables.tf

variable "project_id" {}
variable "region" {}
variable "billing_account_id" {}
variable "dataset_id" {
  default = "billing_export"
}
variable "table_id" {
  default = "gcp_billing_export"
}

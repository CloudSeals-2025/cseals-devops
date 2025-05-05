# root/variables.tf

variable "project_id" {}
variable "region" {
  default = "us-central1"
}
variable "billing_account_id" {}
variable "budget_amount" {
  default = 100
}
variable "alert_email" {}
variable "source_zip_path" {
  default = "./functions/delete-idle-disks.zip"
}
variable "function_archive_name" {
  default = "delete-idle-disks.zip"
}

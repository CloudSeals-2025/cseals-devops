# modules/cloud_function/variables.tf

variable "bucket_name" {
  default = "gcp-cost-optimizer-fn"
}
variable "function_archive_name" {
  default = "delete-idle-disks.zip"
}
variable "source_zip_path" {
  default = "./functions/delete-idle-disks.zip"
}
variable "function_name" {
  default = "deleteIdleDisks"
}
variable "entry_point" {
  default = "main"
}
variable "runtime" {
  default = "python310"
}
variable "memory_mb" {
  default = 128
}
variable "timeout" {
  default = 60
}
variable "project_id" {}
variable "region" {}

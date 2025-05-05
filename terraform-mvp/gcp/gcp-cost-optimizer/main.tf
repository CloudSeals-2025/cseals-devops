# root/main.tf

provider "google" {
  credentials = file("/Users/avsvishal/Desktop/DevOps/gcp.json")
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "function_bucket" {
  name     = "gcp-optimizer"
  location = "US"

  uniform_bucket_level_access = true
}

resource "google_project_service" "required_apis" {
  for_each = toset([
    "cloudbilling.googleapis.com",
    "billingbudgets.googleapis.com",
    "cloudresourcemanager.googleapis.com",
  ])
  project = var.project_id
  service = each.key
}

module "billing_export" {
  source             = "./modules/billing_export"
  project_id         = var.project_id
  region             = var.region
  billing_account_id = var.billing_account_id
}

module "budget_alerts" {
  source             = "./modules/budget_alerts"
  billing_account_id = var.billing_account_id
  budget_amount      = var.budget_amount
}

module "recommender" {
  source     = "./modules/recommender"
  project_id = var.project_id
}

module "monitoring" {
  source         = "./modules/monitoring"
  project_id     = var.project_id
  budget_amount  = var.budget_amount
  alert_email    = var.alert_email
}

module "cloud_function" {
  source               = "./modules/cloud_function"
  project_id           = var.project_id
  region               = var.region
  source_zip_path      = var.source_zip_path
  function_archive_name = var.function_archive_name
}

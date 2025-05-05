# modules/cloud_function/main.tf

resource "google_storage_bucket" "function_bucket" {
  name     = var.bucket_name
  location = var.region
}

resource "google_storage_bucket_object" "function_source" {
  name   = var.function_archive_name
  bucket = google_storage_bucket.function_bucket.name
  source = var.source_zip_path
}

resource "google_cloudfunctions_function" "delete_idle_disks" {
  name                  = var.function_name
  runtime               = var.runtime
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.function_source.name
  trigger_http          = true
  entry_point           = var.entry_point
  available_memory_mb   = var.memory_mb
  timeout               = var.timeout

  environment_variables = {
    PROJECT_ID = var.project_id
  }
}

resource "google_project_iam_member" "fn_recommender_access" {
  project = var.project_id
  role    = "roles/recommender.viewer"
  member  = "serviceAccount:${google_cloudfunctions_function.delete_idle_disks.service_account_email}"
}

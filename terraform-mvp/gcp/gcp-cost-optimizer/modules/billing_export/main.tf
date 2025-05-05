# modules/billing_export/main.tf

resource "google_bigquery_dataset" "billing_dataset" {
  dataset_id = var.dataset_id
  location   = var.region
}

resource "google_bigquery_table" "billing_table" {
  dataset_id = google_bigquery_dataset.billing_dataset.dataset_id
  table_id   = var.table_id
  schema     = "[]"  # Placeholder; GCP billing export sets schema
}

resource "google_billing_account_iam_member" "billing_export_writer" {
  billing_account_id = var.billing_account_id
  role               = "roles/bigquery.dataEditor"
  member             = "serviceAccount:billing-export@system.gserviceaccount.com"
}

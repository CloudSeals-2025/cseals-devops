# modules/monitoring/main.tf

resource "google_project_service" "monitoring_api" {
  for_each = toset([
    "monitoring.googleapis.com",
    "cloudbilling.googleapis.com"
  ])
  project            = var.project_id
  service            = each.key
  disable_on_destroy = true
}

resource "google_monitoring_notification_channel" "email" {
  display_name = "Billing Alert Email"
  type         = "email"

  labels = {
    email_address = var.alert_email
  }
}

resource "google_monitoring_alert_policy" "high_cost_policy" {
  display_name = "High Cost Alert"
  combiner     = "OR"

  conditions {
    display_name = "Billing Cost Spike"

    condition_threshold {
      filter          = "metric.type=\"billing.googleapis.com/billing_account/amount\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = var.budget_amount

      aggregations {
        alignment_period   = "3600s"
        per_series_aligner = "ALIGN_SUM"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.name]
}

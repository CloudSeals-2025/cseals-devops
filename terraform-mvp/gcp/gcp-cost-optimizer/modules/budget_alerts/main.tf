# modules/budget_alerts/main.tf

resource "google_pubsub_topic" "budget_alerts" {
  name = var.topic_name
}

resource "google_pubsub_subscription" "budget_subscriber" {
  name  = var.subscription_name
  topic = google_pubsub_topic.budget_alerts.name
}

resource "google_billing_budget" "budget" {
  billing_account = var.billing_account_id
  display_name    = var.budget_display_name

  amount {
    specified_amount {
      currency_code = "USD"
      units         = var.budget_amount
    }
  }

  dynamic "threshold_rules" {
    for_each = var.threshold_percents
    content {
      threshold_percent = threshold_rules.value
    }
  }

  all_updates_rule {
    pubsub_topic   = google_pubsub_topic.budget_alerts.id
    schema_version = "1.0"
  }
}

# modules/budget_alerts/variables.tf

variable "billing_account_id" {}
variable "budget_amount" {
  default = 100
}
variable "budget_display_name" {
  default = "Monthly Budget Alert"
}
variable "threshold_percents" {
  default = [0.5, 0.9, 1.0]
}
variable "topic_name" {
  default = "budget-alert-topic"
}
variable "subscription_name" {
  default = "budget-subscription"
}

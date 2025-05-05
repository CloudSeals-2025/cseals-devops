# modules/recommender/main.tf

resource "google_project_service" "recommender_apis" {
  for_each = toset([
    "recommender.googleapis.com",
    "cloudasset.googleapis.com"
  ])
  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}

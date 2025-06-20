resource "google_project_service" "main" {
  service            = "admin.googleapis.com"
  disable_on_destroy = false
}

resource "google_service_account" "main" {
  account_id   = "${var.google_project_id}-dex"
  display_name = "${var.google_project_id}-dex"
  description  = "This service account is used by Dex to fetch Google groups."
}

resource "google_service_account_key" "main" {
  service_account_id = google_service_account.main.name
  key_algorithm      = "KEY_ALG_RSA_2048"
}

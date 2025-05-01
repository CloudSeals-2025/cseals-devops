# Provider Configuration for Google Cloud
provider "google" {
  credentials = file("/Users/avsvishal/Desktop/cseals-devops/gcp_demo/terraform_demo/terraform-sa-key.json")  # Path to your service account JSON
  project     = "organic-justice-458415-i0"  # Your GCP project ID
  region      = "us-central1"  # Specify the region you are working in
}

resource "google_compute_instance" "instance" {
  # Sanitize the timestamp to remove invalid characters
  name = "instance-${replace(replace(lower(timestamp()), "T", "-"), ":", "-")}"

  boot_disk {
    auto_delete = true
    device_name = "instance-${replace(replace(lower(timestamp()), "T", "-"), ":", "-")}"

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20250415"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = true
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src           = "vm_add-tf"
    goog-ops-agent-policy = "v2-x86-template-1-4-0"
  }

  machine_type = "e2-micro"

  metadata = {
    enable-osconfig = "TRUE"
    startup-script  = "#!/bin/bash\nsudo apt update\nsudo apt install -y apache2\nsudo systemctl start apache2\nsudo bash -c 'echo Hello from Terraform! > /var/www/html/index.html'"
  }

  network_interface {
    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/organic-justice-458415-i0/regions/us-central1/subnetworks/default"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "1093984229502-compute@developer.gserviceaccount.com"
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["http-server", "https-server"]
  zone = "us-central1-a"
}

module "ops_agent_policy" {
  source        = "github.com/terraform-google-modules/terraform-google-cloud-operations/modules/ops-agent-policy"
  project       = "organic-justice-458415-i0"
  zone          = "us-central1-a"
  assignment_id = "goog-ops-agent-v2-x86-template-1-4-0-us-central1-a"
  
  agents_rule = {
    package_state = "installed"
    version       = "latest"
  }
  
  instance_filter = {
    all                 = false
    inclusion_labels = [{
      labels = {
        goog-ops-agent-policy = "v2-x86-template-1-4-0"
      }
    }]
  }
}

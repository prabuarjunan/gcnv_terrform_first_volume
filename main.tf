# Configure the Google Cloud provider
provider "google" {
  project = var.project_id
  region  = var.region
}

# 1. A VPC network is required for NetApp Volumes.
# This creates a new, dedicated network for your volume.
resource "google_compute_network" "vpc_network" {
  name                    = "netapp-vpc-network"
  auto_create_subnetworks = false
}

# 2. Create a Storage Pool.
# A storage pool is a container for one or more volumes.
resource "google_netapp_storage_pool" "storage_pool" {
  name          = var.storage_pool_name
  location      = var.region
  service_level = "PREMIUM" # Can be STANDARD, PREMIUM, or EXTREME
  capacity_gib  = 1024      # Minimum size is 1024 GiB (1 TiB)
  network       = google_compute_network.vpc_network.id
}

# 3. Create the NetApp Volume.
resource "google_netapp_volume" "volume" {
  name              = var.volume_name
  location          = var.region
  storage_pool      = google_netapp_storage_pool.storage_pool.name
  capacity_gib      = 100             # Minimum size is 100 GiB
  share_name        = var.volume_name # This is the export path for mounting
  protocols         = ["NFSV3"]       # Can be NFSV3, NFSV4_1, or SMB
  deletion_policy   = "DEFAULT"       # Use "DELETE" to automatically delete the volume when the resource is destroyed

  # Ensure the storage pool is created before the volume
  depends_on = [google_netapp_storage_pool.storage_pool]
}

# Output the full mount path for the volume
output "volume_mount_point" {
  description = "The full export path for the NetApp volume to be used for mounting."
  value       = google_netapp_volume.volume.mount_options[0].export_full
}

variable "project_id" {
  description = "The ID of the Google Cloud project where resources will be created."
  type        = string
}

variable "region" {
  description = "The Google Cloud region to deploy resources in (e.g., 'us-central1')."
  type        = string
  default     = "us-central1"
}

variable "storage_pool_name" {
  description = "The name for the NetApp storage pool."
  type        = string
  default     = "my-netapp-pool"
}

variable "volume_name" {
  description = "The name for the NetApp volume. This will also be used as the share name."
  type        = string
  default     = "my-first-volume"
}

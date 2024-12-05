############################
###        PROJECT      ###
############################

variable "project" {
  default = "angular-expanse-432014-q0"
}
variable "region" {
  default = "asia-east1"
}

variable "zone" {
  default = "asia-east1-b"
}

############################
###        NETWORK      ###
############################

variable "gcp_host_project" {
  default = "wingwill-sharevpc-host-1"
}
variable "shared_vpc_name" {
  default = "ww-sharevpc-gke"
}
variable "shared_vpc_subnetwork" {
  default = "ww-sharevpc-gke-private-subnet-1"
}
variable "subnetwork_pod_range_name" {
  default = "ww-sharevpc-gke-private-pod-subnet-1"
}

variable "subnetwork_svc_range_name" {
  default = "ww-sharevpc-gke-private-svc-subnet-1"
}
variable "subnetwork_gce_subnet" {
  default = "ww-sharevpc-web-prod-subnet-1"
}
variable "master_ipv4_cidr_block" {
  default = "10.230.83.0/28"
}

variable "subnetwork_gce_vpc" {
  default = "ww-sharevpc-web"
}

variable "subnetwork_gce_vpc_subnet" {
  default = "ww-sharevpc-web-prod-subnet-1"
}

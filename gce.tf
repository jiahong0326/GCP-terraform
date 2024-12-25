provider "google" {
  project = var.project # 替換為你的 GCP 專案 ID
  region  = var.region         # 替換為你要使用的區域
  zone    = var.zone       # 替換為你要使用的可用區
  credentials = key.json(/github.com/jiahong0326/GCP-terraform/blob/main/key.json)
}


resource "google_compute_instance" "shared_vpc_vm" {
  name         = "test-leo"        # VM 實例的名稱
  machine_type = "e2-micro"        # 機器類型
  zone         = var.zone          # 指定 VM 部署的區域，由變數 `var.zone` 提供
  project      = var.project

  metadata = {
    enable-osconfig = "true"       # 啟用 Google OS Config，用於管理操作系統更新和配置
    enable-oslogin  = "false"      # 禁用 OS Login 功能，直接使用 SSH 密鑰管理
    ssh-keys        = <<EOT
test:ssh-rsa AAAAB3...YourPublicKey...restofkey== username@hostname
EOT
  }

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20240910" # 指定映像
      size  = 20                   # 設置啟動磁碟的大小為 20 GB
      type  = "pd-balanced"        # 使用 PD Balanced 類型的磁碟
    }
  }

  network_interface {
    stack_type  = "IPV4_ONLY"      # 設置網路堆疊類型為僅支持 IPv4
    network    = "projects/${var.gcp_host_project}/global/networks/${var.subnetwork_gce_vpc}"  # VPC 網路
    subnetwork = "projects/${var.gcp_host_project}/regions/${var.region}/subnetworks/${var.subnetwork_gce_subnet}"  # 子網
  }

  service_account {
    email  = "846966349875-compute@developer.gserviceaccount.com"  # 指定服務帳戶
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
    enable_integrity_monitoring = true  # 啟用完整性監控
    enable_secure_boot          = false # 禁用安全啟動
    enable_vtpm                 = true  # 啟用虛擬 TPM
  }

  allow_stopping_for_update = true       # 允許更新時停止 VM
  metadata_startup_script   = "sudo timedatectl set-timezone Asia/Taipei"  # 啟動腳本
}

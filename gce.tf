resource "google_compute_instance" "shared_vpc_vm" {
  name         = "test-leo"        # VM 實例的名稱
  machine_type = "e2-micro"              # 機器類型
  zone         = var.zone                 # 指定 VM 部署的區域，由變數 `var.zone` 提供
  project = var.project

  metadata = {
    enable-osconfig = "true"              # 啟用 Google OS Config，用於管理操作系統更新和配置

  boot_disk = {
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20240910"   # 使用 Red Hat Enterprise Linux (RHEL) 8 的映像
      size  = 20                                                     # 設置啟動磁碟的大小為 20 GB
      type  = "pd-balanced"                                          # 使用 PD Balanced 類型的磁碟，具有良好的性能和成本效益
    }
  }

  network_interface {
    stack_type  = "IPV4_ONLY"                                      # 設置網路堆疊類型為僅支持 IPv4
    network    = "projects/${var.gcp_host_project}/global/networks/${var.subnetwork_gce_vpc}"  # 參與對等的 VPC 網路，由變數 `var.gcp_host_project` 和 `var.subnetwork_gce_vpc` 提供
    subnetwork = "projects/${var.gcp_host_project}/regions/${var.region}/subnetworks/${var.subnetwork_gce_subnet}"  # 參與的子網，由變數 `var.region` 和 `var.subnetwork_gce_vpc_ap` 提供
  }

  service_account {
    email  = "846966349875-compute@developer.gserviceaccount.com"  # 使用指定的服務帳戶來運行 VM 實例
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",      # 訪問 Google Cloud Storage 的只讀權限
      "https://www.googleapis.com/auth/logging.write",             # 寫入 Google Cloud Logging 日誌的權限
      "https://www.googleapis.com/auth/monitoring.write",          # 寫入 Google Cloud Monitoring 監控數據的權限
      "https://www.googleapis.com/auth/service.management.readonly",  # 讀取 Google Cloud Service Management 的權限
      "https://www.googleapis.com/auth/servicecontrol",            # 使用 Google Service Control 的權限
      "https://www.googleapis.com/auth/trace.append"               # 記錄 Google Cloud Trace 跟蹤數據的權限
    ]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true   # 啟用完整性監控，防止未經授權的系統變更
    enable_secure_boot          = false  # 啟用安全啟動，僅允許簽名的操作系統啟動，防止加載未授權的代碼
    enable_vtpm                 = true   # 啟用虛擬 TPM（Trusted Platform Module），增強硬體安全性
  }

  allow_stopping_for_update = true       # 允許在更新 VM 配置時自動停止 VM
  metadata_startup_script = "sudo timedatectl set-timezone Asia/Taipei"  # 可以放置一個啟動腳本（目前註釋掉），這會在 VM 啟動時執行
}

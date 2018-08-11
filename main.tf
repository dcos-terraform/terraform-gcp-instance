provider "google" {}

resource "google_compute_instance" "instances" {
  count          = "${var.num_instances}"
  name           = "${var.cluster_name}-instance"
  machine_type   = "${var.machine_type}"
  can_ip_forward = false
  zone           = "${element(var.zone_list, count.index)}"

  boot_disk {
    initialize_params {
      image = "${var.image}"
      size  = "${var.disk_size}"
      type  = "${var.disk_type}"
    }

    auto_delete = true
  }

  network_interface {
    subnetwork = "${var.instance_subnetwork_name}"

    access_config = {
      // Ephemeral IP
    }
  }

  tags = ["${var.tags}", "${format(var.hostname_format, (count.index + 1), var.cluster_name)}"]

  metadata = {
    user-data = "${var.user_data}"
    sshKeys   = "${var.ssh_user}:${file(var.public_ssh_key)}"
  }
}

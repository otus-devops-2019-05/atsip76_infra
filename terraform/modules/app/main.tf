#создание ресурса приложения
resource "google_compute_instance" "app" {
  name         = "${var.name}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    private_key = "${file("~/.ssh/appuser")}"
  }

  #подгружаем unit файл пумы в инстанс
  provisioner "file" {
    source      = "${path.module}/puma.service"
    destination = "/tmp/puma.service"
  }

  #подгружаем файл деплоя unit пумы в инстанс
  provisioner "file" {
    source      = "../modules/app/deploy.sh"
    destination = "/tmp/deploy.sh"
  }

  #выполняем команды удаленно (помещаем переменную DATABASE_URL в файл юнита и выполняем деплой http сервиса )
  provisioner "remote-exec" {
    inline = [
      "echo Environment='DATABASE_URL=${var.db_external_ip}:27017' >> '/tmp/puma.service'",
      "bash /tmp/deploy.sh",
    ]
  }
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app"]
}

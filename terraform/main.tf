provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_project_metadata" "ssh_keys" {
  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}

resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "google_compute_instance" "app2" {
  name         = "reddit-app2"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с тегом …
  target_tags = ["reddit-app"]
}


resource "google_compute_instance_group" "webservers" {
  name        = "reddit-apps"
  description = "reddit-apps group"

  instances = [
    "${google_compute_instance.app.self_link}",
    "${google_compute_instance.app2.self_link}"
  ]

  named_port {
    name = "http"
    port = "9292"
  }

  zone = "${var.zone}"
}

resource "google_compute_http_health_check" "app_check" {
  name               = "app-check"
  request_path       = "/"
  check_interval_sec = 10
  timeout_sec        = 5
  port               = 9292
}

resource "google_compute_global_forwarding_rule" "app_rule" {
  name       = "app-rule"
  target     = "${google_compute_target_http_proxy.app_proxy.self_link}"
  port_range = "80"
}

resource "google_compute_backend_service" "website" {
  name        = "app-backend"
  description = "app-website"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  backend {
    group = "${google_compute_instance_group.webservers.self_link}"
  }

  health_checks = ["${google_compute_http_health_check.app_check.self_link}"]

}

resource "google_compute_url_map" "app_map" {
  name        = "url-map"
  description = "urlmap"

  default_service = "${google_compute_backend_service.website.self_link}"
}

resource "google_compute_target_http_proxy" "app_proxy" {
  name        = "app-proxy"
  description = "proxy"
  url_map     = "${google_compute_url_map.app_map.self_link}"
}

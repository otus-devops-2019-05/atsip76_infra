resource "google_compute_instance_group" "app-cluster" {
  name        = "app-cluster"
  description = "app test instance group"

  instances = [
    "${google_compute_instance.app.*.self_link}",
  ]

  named_port {
    name = "http"
    port = "9292"
  }

  zone = "${var.zone}"
}

resource "google_compute_target_tcp_proxy" "app-target-tcp-proxy" {
  name            = "app-lb-proxy"
  backend_service = "${google_compute_backend_service.app-lb.self_link}"
}

resource "google_compute_global_address" "app-load-balancer-ip" {
  name = "app-load-balancer-ip"
}

resource "google_compute_global_forwarding_rule" "app-lb-fwd" {
  name       = "app-lb-fwd"
  port_range = "443"

  ip_address = "${google_compute_global_address.app-load-balancer-ip.address}"
  target     = "${google_compute_target_tcp_proxy.app-target-tcp-proxy.self_link}"
}

resource "google_compute_backend_service" "app-lb" {
  name             = "app-lb"
  description      = "backend-lb"
  protocol         = "TCP"
  timeout_sec      = 10
  session_affinity = "NONE"
  health_checks    = ["${google_compute_health_check.app-healthcheck.self_link}"]

  backend {
    group = "${google_compute_instance_group.app-cluster.self_link}"
  }
}

resource "google_compute_health_check" "app-healthcheck" {
  name               = "app-healthcheck"
  check_interval_sec = 5
  timeout_sec        = 5

  tcp_health_check {
    port = "9292"
  }
}

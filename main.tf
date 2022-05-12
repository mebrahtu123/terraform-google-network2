resource "google_compute_network" "vpc_network01" {
  name                    = "vpc-network01"
  auto_create_subnetworks = false
  mtu                     = 1460
}
resource "google_compute_network" "vpc_network02" {
  name                    = "vpc-network02"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "subnet01" {
  name          = "subnet01"
  ip_cidr_range = "192.168.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network01.self_link
}

resource "google_compute_subnetwork" "subnet02" {
  name          = "subnet02"
  ip_cidr_range = "192.168.2.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network02.self_link
}

###network Peering##

resource "google_compute_network_peering" "peering01" {
  name         = "peering01"
  network      = google_compute_network.vpc_network01.self_link
  peer_network =  google_compute_network.vpc_network02.self_link
}

resource "google_compute_network_peering" "peering2" {
  name         = "peering2"
  network      = google_compute_network.vpc_network02.self_link
  peer_network = google_compute_network.vpc_network01.self_link
}
##create a vm##

resource "google_compute_instance" "vm01" {
  name         = "vm01"
  machine_type = var.machine_type
  zone         = var.zone
   

  allow_stopping_for_update = true
 
  lifecycle {
    ignore_changes = [
        labels,tags,
      
    ]
  }
 
  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

 
  network_interface {
   network = google_compute_network.vpc_network01.self_link
   subnetwork = google_compute_subnetwork.subnet01.self_link

  }

  metadata = {
    foo = ""
  }

  metadata_startup_script = "echo hi > /test.txt"

  
}

###second VM ###

resource "google_compute_instance" "vm02" {
  name         = "vm02"
  machine_type = var.machine_type
  zone         = var.zone
 
  allow_stopping_for_update = true
 
  lifecycle {
    ignore_changes = [
        labels,tags,
      
    ]
  }
 
  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

 
  network_interface {
   network = google_compute_network.vpc_network02.self_link
   subnetwork = google_compute_subnetwork.subnet02.self_link

  }

  metadata = {
    foo = ""
  }

  metadata_startup_script = "echo hi > /test.txt"

  
}


#Base for createing resources
resource "google_compute_network" "mynetwork" {
name = "mynetwork"
# RESOURCE properties go inside
auto_create_subnetworks = "true"
}

#Also the resources tamplate helps for firewall rules
resource "google_compute_firewall" "mynetwork-allow-http-ssh-rdp-icmp" {
name = "mynetwork-allow-http-ssh-rdp-icmp"
network = google_compute_network.mynetwork.self_link

allow {
    protocol = "tcp"
    ports = ["22", "80", "3389"]
}
allow {
    protocl = "icmp"
}
source_ranges = ["0.0.0.0/0"]
}

#Create vm instances using the modules we previously coded
module "mynet-us-vm" {
  source = "./instance"
  instance_name = "mynet-us-vm"
  instance_zone = "Zone"
  instance_network = google_compute_network.mynetwork.self_link
}

module "mynet-eu-vm" {
    source = "./instance"
    instance_name = "mynet-eu-vm"
    instance_zone = "europe-west1-d"
    instance_network = google_compute_network.mynetwork.self_link
}

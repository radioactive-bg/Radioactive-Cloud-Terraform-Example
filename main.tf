terraform {
  required_providers {
    cloudstack = {
      source = "orange-cloudfoundry/cloudstack"
      version = "0.5.1"
    }
  }
}

provider "cloudstack" {
  # Configuration options
  api_url    = var.cloudstack_api_url
  api_key    = var.cloudstack_api_key
  secret_key = var.cloudstack_secret_key
}

resource "cloudstack_network" "NewEthernet" {
  name             = "NewEthernet"
  cidr             = "10.4.12.0/24"
  network_offering = "DefaultIsolatedNetworkOfferingWithSourceNatService"
  zone             = "SOF-1"
  source_nat_ip    = "true"
}

resource "cloudstack_instance" "web" {
  name             = ""
  service_offering = "t3.medium"
  network_id       = "a4ced0c4-8cce-4919-9b33-ec2a24811588"
  template         = "54c34c71-0bf9-40d7-a092-0abe4331ffc6"
  zone             = "cc680757-4e70-4609-8c2f-c8ccae36dff6"
  start_vm         = "true"
  keypair          = "myKey"
  expunge          = "true"

}

resource "cloudstack_firewall" "MyNewFirewallRulles" {
  ip_address_id = "9ca072e9-acbb-455d-87ec-336a539b3b22"

  rule {
    cidr_list = ["0.0.0.0/0"]
    protocol  = "tcp"
    ports     = ["0-65535"]
  }
  depends_on = [
      cloudstack_instance.web, 
    ]
}

resource "cloudstack_egress_firewall" "EgressFirewall" {
  network_id = "a4ced0c4-8cce-4919-9b33-ec2a24811588"

  rule {
    cidr_list = ["10.4.12.0/24"]
    protocol  = "tcp"
    ports     = ["0-65535"]
  }
}

resource "cloudstack_port_forward" "MyNewPortForward" {
  ip_address_id = "9ca072e9-acbb-455d-87ec-336a539b3b22"

  forward {
    protocol           = "tcp"
    private_port       = 80
    public_port        = 8080
    virtual_machine_id = cloudstack_instance.web.id
  }
  forward {
    protocol           = "tcp"
    private_port       = 22
    public_port        = 22
    virtual_machine_id = cloudstack_instance.web.id
  }
  depends_on = [
      cloudstack_instance.web, 
    ]
}


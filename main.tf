terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {
  user_name   = var.user_name
  tenant_id   = var.tenant_id
  password    = var.password
  auth_url    = var.auth_url
  region      = var.region
}

resource "openstack_blockstorage_volume_v2" "vol-01" {
  name = var.volume_name_01
  size = 110
  snapshot_id = var.snapshot_id
}

#resource "openstack_blockstorage_volume_v2" "vol-02" {
#  name = var.volume_name_02
#  size = 1
#}

resource "openstack_compute_keypair_v2" "yet-keypair" {
  name       = var.keypair_name
  public_key = var.keypair
}

resource "openstack_compute_instance_v2" "myinstance" {
  name            = var.instance_name
  image_id        = var.image_id
  flavor_id       = var.flavor_id
  key_pair        = openstack_compute_keypair_v2.yet-keypair.id
  security_groups = ["default"]

  network {
    name = var.network
  }
}

resource "openstack_compute_volume_attach_v2" "attached" {
  instance_id = openstack_compute_instance_v2.myinstance.id
  volume_id   = openstack_blockstorage_volume_v2.vol-01.id
}

#resource "openstack_compute_volume_attach_v2" "attached-01" {
#  instance_id = var.openstack_compute_instance_v2.myinstance.id
#  volume_id   = var.openstack_blockstorage_volume_v2.vol-02.id
#}

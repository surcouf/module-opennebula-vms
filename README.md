# Terraform OpenNebula VMs module

![Terraform Version](https://img.shields.io/badge/Terraform-1.3.0-green.svg) [![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](https://github.com/Terraform-VMWare-Modules/terraform-vsphere-vm/releases) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

For Virtual Machine Provisioning with Linux customization. Based on Terraform v0.13 and up, this module includes most of the advanced features available in resource `opennebula_virtual_machine`.

## Deploys (Single/Multiple) Virtual Machines to your OpenNebula environment

This Terraform module deploys single or multiple virtual machines of type Linux with the following features:

- Ability to specify Linux VM contextualization.
- Ability to add multiple network cards for the VM
- Ability to configure advanced features for a VM.
- Ability to deploy either a datastore or a datastore cluster.
  - Add extra data disk (up to 15) to the VM.
- Ability to define depend on using variable vm_depends_on

> Note: For the module to work, it needs several required variables corresponding to existing resources in vSphere. Please refer to the variable section for the list of required variables.

## Getting started

The following example contains the bare minimum options to be configured for Linux VM deployment.

You can also download the entire module and use your predefined variables to map your entire vSphere environment and use it within this module.

First, create a `main.tf` file.

Next, copy the code below and fill in the required variables.

```hcl
# Configure the OpenNebula Provider
provider "opennebula" {
  user           = "fill"
  password       = "fill"
  server_url     = "fill"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}

# Deploy 2 linux VMs
module "example-server-linuxvm" {
  source    = "https://forge.dgfip.finances.rie.gouv.fr/dgfip/design/terraform/terraform-opennebula-vms"
  version   = "1.0.0"
  template  = "VM Template Name (Should Already exist)"
  instances = 2
  names     = "example-server-linux"
  networks  = {
    "admin" = {
      network_id  = "admin"
      interface   = "eth0"
      ipv4addr    = "192.168.1.2/24"
    } 
    "appli" = {
      network_id  = "appli"
      interface   = "eth1"
      ipv4addr    = "172.16.1.2/24"
    }
    # To use DHCP create Empty list ["",""]; You can also use a CIDR annotation;
  }
  gateway   = "10.13.113.1"
}
```

Finally, run 

```bash
terraform run
```
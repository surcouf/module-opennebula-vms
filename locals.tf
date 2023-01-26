// Build flatten list of all networks defined in each instance
locals {
  networks = distinct(flatten([
    for instance in var.instances: [
      for network in instance.networks: network.network_name
    ]
    if instance.networks != null
  ]))

  // Build flatten list of all templates defined with each instance
  templates = distinct( flatten( [[var.template], [
      for instance in var.instances: instance.template
      if instance.template != null
    ]]
  ))

  images = distinct( flatten([
    for instance in var.instances: [
      for disk in instance.disks: disk.image
      if disk.image != null
    ]
    if instance.disks != null
  ]))
}
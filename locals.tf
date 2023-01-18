// Build flatten list of all networks defined in each instance
locals {
  networks = distinct(flatten([
    for instance in var.instances: [
        for name, network_interface in instance.network_interfaces: network_interface.network_name
    ]
  ]))

// Build flatten list of all templates defined with each instance
  templates = distinct(flatten([
    for name, instance in var.instances: instance.template
  ]))
}
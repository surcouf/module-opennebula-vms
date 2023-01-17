// Build flatten list of all networks defined in each instance
locals {
  networks = distinct(flatten([
    for instance in var.instances: [
        for network_interface in instance.network_interfaces: {
            name = network_interface.network_name 
        }
    ]
  ]))
} 
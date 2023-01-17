data "opennebula_group" "group" {
    name        = var.group
}

data "opennebula_template" "templates" {
    for_each    = var.instances
    name        = each.value.template
}

data "opennebula_template" "template" {
    count       = var.template != null ? 1 : 0
    name        = var.template
}

// Get id of networks defined with each instance
data "opennebula_virtual_network" "networks" {
    for_each = { for network in local.networks: network.name => network }
    name = each.value.name
}

// Cloning a Linux VM from a given template
resource "opennebula_virtual_machine" "vm" {
    for_each    = var.instances
    name        = each.key

    template_id = each.value.template != null ? data.opennebula_template.templates[each.key].id : data.opennebula_template.template[0].id 

    group       = data.opennebula_group.group.name
    permissions = each.value.permissions != null ? each.value.permissions : var.permissions

    memory      = each.value.memory != null ? each.value.memory : var.memory

    os {
        arch = "x86_64"
        boot = "nic0,disk0"
    } 

    context = {
        HOSTNAME="$NAME"
        NETWORK="YES"
    }  

    dynamic "nic" {
        for_each = each.value.network_interfaces
        content {
            physical_device = nic.key
            model           = "virtio"
            network_id      = data.opennebula_virtual_network.networks[nic.value.network_name].id
        }
    }

    // Disks defined in the original template
    dynamic "disk" {
        for_each = data.opennebula_template.templates[each.key].disk
        iterator = template_disk
        content {
            size            = each.value.disk_size != null ? each.value.disk_size[template_disk.key] : data.opennebula_template.templates[each.key].disk[template_disk.key].size
        }
    }
}
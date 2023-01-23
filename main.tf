data "opennebula_group" "group" {
    name        = var.group
}

data "opennebula_template" "templates" {
    for_each    = toset(local.templates)
    name        = each.key
}

data "opennebula_template" "template" {
    count       = var.template != null ? 1 : 0
    name        = var.template
}

// Get id of networks defined with each instance
data "opennebula_virtual_network" "networks" {
    for_each    = toset(local.networks)
    name        = each.key
}

data "opennebula_image" "images" {
    for_each    = toset(local.images)
    name        = each.key
}

// Cloning a Linux VM from a given template
resource "opennebula_virtual_machine" "vm" {
    for_each    = var.instances
    name        = each.key

    template_id = each.value.template != null ? data.opennebula_template.templates[each.value.template].id : data.opennebula_template.template[0].id

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

    keep_nic_order = true
    dynamic "nic" {
        for_each = each.value.networks
        content {
            physical_device = nic.value.physical_device
            model           = "virtio"
            network_id      = data.opennebula_virtual_network.networks[nic.value.network_name].id
            ip              = nic.value.ipv4addr
        }
    }

    // Disks defined in the original template
    dynamic "disk" {
        for_each = each.value.disks != null ? each.value.disks : []
        content {
            image_id        = disk.value.image != null ? data.opennebula_image.images[disk.value.image].id : null
            size            = disk.value.size
            target          = disk.value.target
            volatile_type   = disk.value.volatile_type
            volatile_format = disk.value.volatile_format
        }
    }
}
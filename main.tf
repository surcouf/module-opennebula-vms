data "opennebula_group" "group" {
    name        = var.group
}

data "opennebula_template" "template" {
    name        = var.template
}

data "opennebula_virtual_network" "network" {
    for_each = var.networks
    name = each.value.network_id
}

// Cloning a Linux VM from a given template
resource "opennebula_virtual_machine" "vm" {
    count       = var.instances
    depends_on  = [ var.vm_depends_on ]
    name        = var.staticvmname != null ? var.staticvmname : format("${var.vmname}${var.vmnameformat}", count.index + 1)

    template_id = data.opennebula_template.template.id
  
    group       = data.opennebula_group.pito.name
    permissions = var.permissions

    memory      = var.memory

    os {
        arch = "x86_64"
        boot = "nic0,disk0"
    } 

    context = {
        HOSTNAME="$NAME"
        NETWORK="YES"
    }  

    dynamic "nic" {
        for_each = var.networks
        content {
            nic {
                physical_device = each.value.interface
                model           = "virtio"
                network_id      = data.opennebula_virtual_network.network[each.key].id
            }
        }
    }
}
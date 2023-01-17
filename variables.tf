variable "instances" {
    description = "Number of instances you want to deploy from the template"  
    type        = map(object({
        memory           = optional(number)
        permissions      = optional(number)
        template         = optional(string)
        disk_size        = optional(list(any))
        network_interfaces = map(object({
            network_name = string
            ipv4addr     = string
        }))

    }))
}

# OpenNebula Group
variable "group" {
    description = "Define OpenNebula group."
    type        = string
    default     = "pito"
}

variable "permissions" {
    description = "Permissions (Usage/Manage/Admin) for each VMs."
    default     = 660
}

variable "vm_depends_on" {
  description = "Add any external depend on module here like vm_depends_on = [module.fw_core01.firewall]."
  type        = any
  default     = null
}

variable "template" {
  description = "Name of the OpenNebula virtual machine template"
  type        = string
  default     = null
}

variable "memory" {
    description = "VM RAM size (megabytes)"
    default     = 4096
}

variable "disk_size" {
  description = "List of disk sizes to override template disk size."
  type        = list(any)
  default     = null
}
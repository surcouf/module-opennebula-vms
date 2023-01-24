# OpenNebula VM instances
variable "instances" {
    description = "Number of instances you want to deploy from the template"  
    type        = map(object({
        memory              = optional(number)
        permissions         = optional(number)
        template            = optional(string)
        disks               = optional(list(object({
              volatile_type   = optional(string)
              volatile_format = optional(string)
              image    = optional(string)
              target   = optional(string)
              size     = optional(number)
            })))
        networks  = map(object({
            network_name    = string
            ipv4addr        = optional(string)
            security_groups = optional(list(any))
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
    type        = number
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

variable "disks" {
  description = "List of additional disks."
  type        = map(object({
    size  = number
  }))
  default     = null
}
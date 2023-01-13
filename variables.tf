variable "instances" {
    description = "Number of instances you want to deploy from the template"  
    default     = 1
}

variable "vmname" {
  description = "The name of the virtual machine used to deploy the vms. This name can scale out based on number of instances and vmnameformat - example can be found under exampel folder"
  default     = "terraformvm"
}

variable "vmnameformat" {
  description = "vmname format. default is set to 2 decimal with leading 0. example: %03d for 3 decimal with leading zero or %02dprod for additional suffix"
  default     = "%02d"
}

variable "staticvmname" {
  description = "Static name of the virtual machine. When this option is used VM can not scale out using instance variable. You can use for_each outside the module to deploy multiple static vms with different names"
  default     = null
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

variable "template" {
    description = "Name of the OpenNebula virtual machine template"
}

variable "memory" {
    description = "VM RAM size (megabytes)"
    default     = 4096
}

variable "networks" {
    description = "List of networks"
    type        = map(object({
        network_id  = string
        interface   = string
        ipv4addr    = string
    }))
    default     = {}
}
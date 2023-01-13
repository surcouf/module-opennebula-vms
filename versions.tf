terraform {
    required_version = ">= 0.13.4"
    required_providers {
        opennebula = {
            source = "OpenNebula/opennebula"
            version = "~> 1.1.0"
        }
    }
}
variable "location" {
    description = "Azure region"
    type = string
    
    validation {
        condition = contains(["eastus"], var.location)
        error_message = "Region must be one of: eastus."
    }
}
variable "location" {
    description = "Azure region"
    type = string
    
    validation {
        condition = contains(["eastus"], var.location)
        error_message = "Region must be one of: eastus."
    }
}

variable "location2" {
    description = "Azure region of second hub"
    type = string
    
    validation {
        condition = contains(["westus"], var.location2)
        error_message = "Region must be one of: westus."
    }
}
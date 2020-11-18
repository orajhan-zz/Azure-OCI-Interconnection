variable "prefix" {
  default = "Azure-OCI"
}

# Select Oracle Cloud FastConnect as ExpressRT provider in Azure
variable "fastconenct" {
  default = "Oracle Cloud FastConnect"
}

#OCI location, currently I am using Tokyo
variable "fastconenct-location" {
  type = map
    default = {
        Tokyo = "Tokyo"
        Sydney = "Sydney" #Not available yet
    }
}

#Azure location
variable "location" {
    type = map
    default = {
        Tokyo = "Japan East"
        Sydney = "Australia East" #Not available yet
    }
}

#Azure VM shape
variable "shape" {
  default = "Standard_B1ls"
}
#VM login username
variable "admin_username" {
  default = "ubuntu"
}
#VM password
#The supplied password must be between 6-72 characters long and must satisfy at least 3 of password complexity requirements from the following:
#Contains an uppercase character
#Contains a lowercase character
#Contains a numeric digit
#Contains a special character
variable "admin_password" {
  default = "Oracle123456#"
}
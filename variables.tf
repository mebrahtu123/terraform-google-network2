variable "region" {
    default = "us-west2"
   description = "us-west2"
}

variable "zone" {
    default = "us-west2-a"
}

variable "routing" {
    default = "regional"
  
}

variable "each" {
  default = ["us-west2-a","us-west2-b","us-west2-c"]
}

####new variables###

variable "name" {
    default = "tree1"
    description = "This variable will be used for vm name"
}

variable "machine_type" {
  default = "e2-medium"
  description = "This is for machine type"
}

variable "myvms" {
    default = ["prd","qa","dev"]
  
}


variable "images" {
  type = map

  default = {
    dev  = "us-west2-a"
    prd = "us-west2-b"
    qa =  "us-west2-c"
  }
}

variable "project_name" {
    default = "roboshop"
}
variable "environment" {
  default =  "dev"
}
variable "common_tags" {
  default =  {
     Project = "roboshop"
     Environment = "dev"
     Terraform = true
     Component ="ingress-alb"
  }
}
variable "zone_name" {
  default = "lithesh.shop"
}

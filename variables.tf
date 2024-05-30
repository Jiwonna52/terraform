# 지역 변수
variable "region" {
  description = "The AWS region to create resources in."
  type = string
}

# AZ
variable "az1" {
  description = "The First AZ"
  type = string
}
variable "az2" {
  description = "The Second AZ"
  type = string
}

# vpc cidr
variable "cidr_block" {
  description = "The Cidr block about main VPC."
  type = string
}

# Public Subnet cidr
variable "subnet-pub01-cidr" {
  description = "The Cidr block about public subnet 01."
  type = string
}

variable "subnet-pub02-cidr" {
  description = "The Cidr block about public subnet 02."
  type = string
}

#Private Subnet cidr for WEB
variable "subnet-pri03-cidr" {
  description = "The Cidr block about private subnet 03 for web."
  type = string
}

variable "subnet-pri04-cidr" {
  description = "The Cidr block about private subnet 04 for web."
  type = string
}

#Private Subnet cidr for APP
variable "subnet-pri05-cidr" {
  description = "The Cidr block about private subnet 05 for app."
  type = string
}

variable "subnet-pri06-cidr" {
  description = "The Cidr block about private subnet 06 for app."
  type = string
}

#Private Subnet cidr for DB
variable "subnet-pri07-cidr" {
  description = "The Cidr block about private subnet 07 for db."
  type = string
}

variable "subnet-pri08-cidr" {
  description = "The Cidr block about private subnet 08 for db."
  type = string
}
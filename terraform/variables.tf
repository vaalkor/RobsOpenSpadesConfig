variable region {
  type        = string
  default     = "eu-west-2"
  description = "AWS region"
}

variable key_name {
  type        = string
  default     = ""
  description = "Key pair name to assign to the instance"
}

variable credentials_file {
  type        = string
  default     = "E:/aws/keys/credentials"
  description = "Credentials file."
}

variable "enforce_domain_name" {
  default     = "enforce.dev"
  type        = string
  description = "Domain name of your Chainguard Enforce environment"
  sensitive   = false
  nullable    = false
}

variable "enforce_group_id" {
  type        = string
  description = "DEPRECATED: Please use 'enforce_group_ids'. Enforce IAM group ID to bind your AWS account to"
  default     = "b503e31b0dd075dbbcbc9b33f3476291d8e9b9a1"
  sensitive   = false

  validation {
    condition     = var.enforce_group_id != "" ? length(regexall("^[a-f0-9]{40}(\\/[a-f0-9]{16})*$", var.enforce_group_id)) == 1 : true
    error_message = "The value 'enforce_group_id' must be a valid group id."
  }
}

variable "enforce_group_ids" {
  type        = list(string)
  description = "Enforce IAM group IDs to bind your AWS account to. If both 'enforce_group_id' and 'enforce_group_ids' are specified, 'enforce_group_id' is ignored."
  sensitive   = false
  default     = ["20c1263ac49f8cf9ad39e91006fa2beb8096e7f4", "b503e31b0dd075dbbcbc9b33f3476291d8e9b9a1"]

  validation {
    condition     = can([for g in var.enforce_group_ids : regex("^[a-f0-9]{40}(\\/[a-f0-9]{16})*$", g)])
    error_message = "IDs in enforce_group_ids must be a valid group id."
  }
}

# resource "null_resource" "enforce_group_id_is_specified" {
#   lifecycle {
#     precondition {
#       condition     = length(var.enforce_group_ids) > 0 || var.enforce_group_id != ""
#       error_message = "one of variable [enforce_group_id, enforce_group_ids] must be specified."
#     }
#   }
# }

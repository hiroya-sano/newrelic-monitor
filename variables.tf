variable "newrelic_account_id" {
  description = "New Relic Account Id"
  type        = string
}

variable "newrelic_api_key" {
  description = "New Relic API Key"
  type        = string
}

variable "private_locations" {
  description = "List of synthetics private locations"
  type = list(string)
}

variable "monitors" {
  description = "List of ping monitors"
  type = list(object({
    name        = string
    url         = string
    private_locations    = list(string)
  }))
}

variable "policies" {
  description = "List of alert policies"
  type = list(string)
}

variable "conditions" {
  description = "List of alert conditions per policy"
  type = list(object({
    policy_name = string
    app_name    = string
    violation_time_limit_seconds = number
    critical_threshold = number
    warning_threshold   = number
  }))
}
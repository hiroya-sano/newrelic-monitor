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

variable "conditions_cpurata_namespace" {
  description = "List of alert conditions per policy"
  type = list(object({
    app_name    = string
    threshold_duration = number
    alert_frequency = number
    critical_threshold = number
    warning_threshold   = optional(number)
  }))
}
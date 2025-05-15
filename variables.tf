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

variable "synthetics" {
  description = "List of ping monitors"
  type = list(object({
    name        = string
    url         = string
    private_locations    = list(string)
  }))
}

variable "conditions_cpurate_namespace" {
  description = "List of alert conditions for cpurate by namespace"
  type = list(object({
    namespace_name    = string
    threshold_duration = number
    alert_frequency = number
    critical_threshold = number
    warning_threshold   = optional(number)
  }))
}

variable "conditions_cpurate_pod" {
  description = "List of alert conditions for cpurate by pod"
  type = list(object({
    namespace_name    = string
    threshold_duration = number
    alert_frequency = number
    critical_threshold = number
    warning_threshold   = optional(number)
  }))
}

variable "conditions_memoryrate_namespace" {
  description = "List of alert conditions for memoryrate by namespace"
  type = list(object({
    namespace_name    = string
    threshold_duration = number
    alert_frequency = number
    critical_threshold = number
    warning_threshold   = optional(number)
  }))
}

variable "conditions_memoryrate_pod" {
  description = "List of alert conditions for memoryrate by pod"
  type = list(object({
    namespace_name    = string
    threshold_duration = number
    alert_frequency = number
    critical_threshold = number
    warning_threshold   = optional(number)
  }))
}

variable "conditions_status_pod" {
  description = "List of alert conditions for memoryrate by pod"
  type = list(object({
    namespace_name    = string
    threshold_duration = number
    alert_frequency = number
    critical_threshold = number
  }))
}

variable "conditions_status_container" {
  description = "List of alert conditions for memoryrate by pod"
  type = list(object({
    namespace_name    = string
    threshold_duration = number
    alert_frequency = number
    critical_threshold = number
  }))
}

variable "conditions_url" {
  description = "List of alert conditions for memoryrate by pod"
  type = list(object({
    url    = string
    threshold_duration = number
    alert_frequency = number
    critical_threshold = number
  }))
}
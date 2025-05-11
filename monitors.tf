resource "newrelic_synthetics_monitor" "ping" {
  for_each = { for monitor in var.monitors : monitor.name => monitor }

  status           = "ENABLED"
  type             = "SIMPLE"
  name             = each.value.name
  uri              = each.value.url
  period           = "EVERY_MINUTE"
  locations_public = each.value.location

  treat_redirect_as_failure = true
  validation_string         = "success"
  bypass_head_request       = true
  verify_ssl                = true
}

data "newrelic_synthetics_private_location" "private_locations" {
  for_each = toset(var.private_locations)
  name     = each.value
}

resource "newrelic_synthetics_monitor" "ping" {
  for_each = { for monitor in var.monitors : monitor.name => monitor }

  status           = "ENABLED"
  type             = "SIMPLE"
  name             = each.value.name
  uri              = each.value.url
  period           = "EVERY_MINUTE"
  locations_private =   [
    for loc in each.value.private_locations :
    data.newrelic_synthetics_private_location.private_locations[loc].id
  ]


  treat_redirect_as_failure = true
  validation_string         = "success"
  bypass_head_request       = true
  verify_ssl                = true
}

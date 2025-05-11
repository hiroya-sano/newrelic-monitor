resource "newrelic_alert_policy" "policies" {
  for_each = toset(var.policies)

  name = each.value
}

resource "newrelic_nrql_alert_condition" "conditions" {
  for_each = {
    for condition in var.conditions :
    "${condition.policy_name}-${condition.app_name}" => condition
  }

  policy_id = newrelic_alert_policy.policies[each.value.policy_name].id
  name      = "${each.value.app_name} Alert Condition"
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = each.value.violation_time_limit_seconds

  nrql {
    query      = "SELECT count(*) FROM Transaction WHERE appName = '${each.value.app_name}'"
  }

  dynamic "warning" {
    for_each = each.value.warning_threshold > 0 ? [each.value] : []
    content {
      operator              = "above"
      threshold             = each.value.warning_threshold
      threshold_duration    = 300
      threshold_occurrences = "ALL"
    }
  }
}

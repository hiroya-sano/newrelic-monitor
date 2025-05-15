resource "newrelic_alert_policy" "cpurata_namespace" {
  name = "CPU Usage Policy by Namespace"
}

resource "newrelic_nrql_alert_condition" "cpurata_namespace" {
  for_each = {
    for condition in var.conditions_cpurata_namespace :
    "${condition.namespace_name}" => condition
  }

  policy_id = newrelic_alert_policy.cpurata_namespace.id
  name      = "CPU Usage Rate (%) by Namespace_${each.value.namespace_name}"
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = each.value.alert_frequency - each.value.threshold_duration

  nrql {
    query      = "FROM K8sContainerSample SELECT average(cpuCoresUtilization) WHERE namespaceName = '${each.value.namespace_name}'"
  }

  critical {
    operator              = "above"
    threshold             = each.value.critical_threshold
    threshold_duration    = each.value.threshold_duration
    threshold_occurrences = "ALL"
  }

  dynamic "warning" {
    for_each = try(each.value.warning_threshold, null) != null ? [1] : []
    content {
      operator              = "above"
      threshold             = each.value.warning_threshold
      threshold_duration    = each.value.threshold_duration
      threshold_occurrences = "ALL"
    }
  }
}

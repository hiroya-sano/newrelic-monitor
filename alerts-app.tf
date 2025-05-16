resource "newrelic_alert_policy" "cpurate_namespace" {
  name = "CPU Usage Policy by Namespace"
}

resource "newrelic_nrql_alert_condition" "cpurate_namespace" {
  for_each = {
    for condition in var.conditions_cpurate_namespace :
    "${condition.namespace_name}" => condition
  }

  policy_id = newrelic_alert_policy.cpurate_namespace.id
  name      = "CPU Usage Rate (%) by Namespace_${each.value.namespace_name}"
  enabled = local.alert_enabled
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = each.value.alert_frequency - each.value.threshold_duration

  nrql {
    query      = "FROM K8sContainerSample SELECT average(cpuCoresUtilization) FACET namespaceName WHERE namespaceName = '${each.value.namespace_name}'"
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


resource "newrelic_alert_policy" "cpurate_pod" {
  name = "CPU Usage Policy by Pod"
}

resource "newrelic_nrql_alert_condition" "cpurate_pod" {
  for_each = {
    for condition in var.conditions_cpurate_pod :
    "${condition.namespace_name}" => condition
  }

  policy_id = newrelic_alert_policy.cpurate_pod.id
  name      = "CPU Usage Rate (%) by Pod_${each.value.namespace_name}"
  enabled = local.alert_enabled
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = each.value.alert_frequency - each.value.threshold_duration

  nrql {
    query      = "FROM K8sContainerSample SELECT average(cpuCoresUtilization) FACET podName WHERE namespaceName = '${each.value.namespace_name}'"
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


resource "newrelic_alert_policy" "memoryrate_namespace" {
  name = "Memory Usage Policy by Namespace"
}

resource "newrelic_nrql_alert_condition" "memoryrate_namespace" {
  for_each = {
    for condition in var.conditions_memoryrate_namespace :
    "${condition.namespace_name}" => condition
  }

  policy_id = newrelic_alert_policy.memoryrate_namespace.id
  name      = "Memory Usage Rate (%) by Namespace_${each.value.namespace_name}"
  enabled = local.alert_enabled
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = each.value.alert_frequency - each.value.threshold_duration

  nrql {
    query      = "FROM K8sContainerSample SELECT average(memoryUtilization) FACET namespaceName WHERE namespaceName = '${each.value.namespace_name}'"
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


resource "newrelic_alert_policy" "memoryrate_pod" {
  name = "Memory Usage Policy by Pod"
}

resource "newrelic_nrql_alert_condition" "memoryrate_pod" {
  for_each = {
    for condition in var.conditions_memoryrate_pod :
    "${condition.namespace_name}" => condition
  }

  policy_id = newrelic_alert_policy.memoryrate_pod.id
  name      = "Memory Usage Rate (%) by Pod_${each.value.namespace_name}"
  enabled = local.alert_enabled
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = each.value.alert_frequency - each.value.threshold_duration

  nrql {
    query      = "FROM K8sContainerSample SELECT average(memoryUtilization) FACET podName WHERE namespaceName = '${each.value.namespace_name}'"
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


resource "newrelic_alert_policy" "status_pod" {
  name = "Pod Status"
}

resource "newrelic_nrql_alert_condition" "status_pod" {
  for_each = {
    for condition in var.conditions_status_pod :
    "${condition.namespace_name}" => condition
  }

  policy_id = newrelic_alert_policy.status_pod.id
  name      = "Not Running Status by Pod_${each.value.namespace_name}"
  enabled = local.alert_enabled
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = each.value.alert_frequency - each.value.threshold_duration

  nrql {
    query      = "FROM K8sPodSample SELECT uniqueCount(podName) FACET podName WHERE status NOT IN ('Running', 'Succeeded') AND namespaceName = '${each.value.namespace_name}'"
  }

  critical {
    operator              = "above"
    threshold             = each.value.critical_threshold
    threshold_duration    = each.value.threshold_duration
    threshold_occurrences = "ALL"
  }
}


resource "newrelic_alert_policy" "status_container" {
  name = "Container Status"
}

resource "newrelic_nrql_alert_condition" "status_container" {
  for_each = {
    for condition in var.conditions_status_container :
    "${condition.namespace_name}" => condition
  }

  policy_id = newrelic_alert_policy.status_container.id
  name      = "Not Running Status by Container_${each.value.namespace_name}"
  enabled = local.alert_enabled
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = each.value.alert_frequency - each.value.threshold_duration

  nrql {
    query      = "FROM K8sContainerSample SELECT uniqueCount(containerName) FACET podName,containerName WHERE (status NOT IN ('Running') AND jobName is NULL) OR (lastTerminatedExitCode != 0 AND jobName is NOT NULL) AND namespaceName = '${each.value.namespace_name}'"
  }

  critical {
    operator              = "above"
    threshold             = each.value.critical_threshold
    threshold_duration    = each.value.threshold_duration
    threshold_occurrences = "ALL"
  }
}


resource "newrelic_alert_policy" "url" {
  name = "URL Monitoring"
}

resource "newrelic_nrql_alert_condition" "url" {
  for_each = {
    for condition in var.conditions_url :
    "${condition.url}" => condition
  }

  policy_id = newrelic_alert_policy.url.id
  name      = "URL Monitor Apache (${split("/", replace(each.value.url, "^[^:]+://", ""))[2]})"
  enabled = local.alert_enabled
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = each.value.alert_frequency - each.value.threshold_duration

  nrql {
    query      = "FROM SyntheticRequest SELECT uniqueCount(URL) FACET URL WHERE URL = '${each.value.url}' AND responseCode != 200"
  }

  critical {
    operator              = "above"
    threshold             = each.value.critical_threshold
    threshold_duration    = each.value.threshold_duration
    threshold_occurrences = "ALL"
  }
}

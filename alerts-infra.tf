locals {
  infra_query_filter = "clusterName NOT LIKE 'g3stmt%' and clusterName NOT LIKE 'g3cshrwc-shared-dev' and clusterName NOT LIKE 'g3cshrwc-shared-prod'"
  infra_threshold = {
    critical = 90
    warning = 80
  }
  infra_alert_frequency = 600
  infra_threshold_duration = 300
  infra_violation_time_limit_seconds = local.infra_alert_frequency - local.infra_threshold_duration
}

resource "newrelic_alert_policy" "cpurate_infra" {
  name = "CPU Usage Policy by TKG Cluster"
}

resource "newrelic_nrql_alert_condition" "cpurate_infra" {
  policy_id = newrelic_alert_policy.cpurate_infra.id
  name      = "CPU Usage Rate (%) by TKG Cluster"
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = local.infra_violation_time_limit_seconds

  nrql {
    query      = "FROM K8sContainerSample SELECT average(cpuCoresUtilization) FACET clusterName WHERE ${local.infra_query_filter}"
  }

  critical {
    operator              = "above"
    threshold             = local.infra_threshold.critical
    threshold_duration    = local.infra_threshold_duration
    threshold_occurrences = "ALL"
  }

  warning {
    operator              = "above"
    threshold             = local.infra_threshold.warning
    threshold_duration    = local.infra_threshold_duration
    threshold_occurrences = "ALL"
  }
}


resource "newrelic_alert_policy" "memoryrate_infra" {
  name = "Memory Usage Policy by TKG Cluster"
}

resource "newrelic_nrql_alert_condition" "memoryrate_infra" {
  policy_id = newrelic_alert_policy.memoryrate_infra.id
  name      = "Memory Usage Rate (%) by TKG Cluster"
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = local.infra_violation_time_limit_seconds

  nrql {
    query      = "FROM K8sContainerSample SELECT average(memoryUtilization) FACET clusterName WHERE ${local.infra_query_filter}"
  }

  critical {
    operator              = "above"
    threshold             = local.infra_threshold.critical
    threshold_duration    = local.infra_threshold_duration
    threshold_occurrences = "ALL"
  }

  warning {
    operator              = "above"
    threshold             = local.infra_threshold.warning
    threshold_duration    = local.infra_threshold_duration
    threshold_occurrences = "ALL"
  }
}

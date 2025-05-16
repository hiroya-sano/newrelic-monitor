locals {
  infra_query_filter = {
    cpu_and_memory = "clusterName NOT LIKE 'g3stmt%' and clusterName NOT LIKE 'g3cshrwc-shared-dev' and clusterName NOT LIKE 'g3cshrwc-shared-prod'"
    disk = "clusterName NOT LIKE 'g3stmt%'"
    state = "clusterName NOT LIKE 'g3stmt%'"
  }
  infra_threshold = {
    cpu_and_memory = {
      critical = 90
      warning = 80
    }
    disk = {
      critical = 72.5
      warning = 65
    }
    state = {
      critical = 1
    }
  }
  infra_alert_frequency = {
    cpu_and_memory = 600
    disk = 600
    state = 480
  }
  infra_threshold_duration = {
    cpu_and_memory = 300
    disk = 300
    state = 180
  }
  infra_violation_time_limit_seconds = {
    cpu_and_memory = local.infra_alert_frequency.cpu_and_memory - local.infra_threshold_duration.cpu_and_memory
    disk = local.infra_alert_frequency.disk - local.infra_threshold_duration.disk
    state = local.infra_alert_frequency.state - local.infra_threshold_duration.state
  }
}

resource "newrelic_alert_policy" "cpurate_infra" {
  name = "CPU Usage Policy by TKG Cluster"
}

resource "newrelic_nrql_alert_condition" "cpurate_infra" {
  policy_id = newrelic_alert_policy.cpurate_infra.id
  name      = "CPU Usage Rate (%) by TKG Cluster"
  enabled = local.alert_enabled
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = local.infra_violation_time_limit_seconds.cpu_and_memory

  nrql {
    query      = "FROM K8sContainerSample SELECT average(cpuCoresUtilization) FACET clusterName WHERE ${local.infra_query_filter.cpu_and_memory}"
  }

  critical {
    operator              = "above"
    threshold             = local.infra_threshold.cpu_and_memory.critical
    threshold_duration    = local.infra_threshold_duration.cpu_and_memory
    threshold_occurrences = "ALL"
  }

  warning {
    operator              = "above"
    threshold             = local.infra_threshold.cpu_and_memory.warning
    threshold_duration    = local.infra_threshold_duration.cpu_and_memory
    threshold_occurrences = "ALL"
  }
}


resource "newrelic_alert_policy" "memoryrate_infra" {
  name = "Memory Usage Policy by TKG Cluster"
}

resource "newrelic_nrql_alert_condition" "memoryrate_infra" {
  policy_id = newrelic_alert_policy.memoryrate_infra.id
  name      = "Memory Usage Rate (%) by TKG Cluster"
  enabled = local.alert_enabled
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = local.infra_violation_time_limit_seconds.cpu_and_memory

  nrql {
    query      = "FROM K8sContainerSample SELECT average(memoryUtilization) FACET clusterName WHERE ${local.infra_query_filter.cpu_and_memory}"
  }

  critical {
    operator              = "above"
    threshold             = local.infra_threshold.cpu_and_memory.critical
    threshold_duration    = local.infra_threshold_duration.cpu_and_memory
    threshold_occurrences = "ALL"
  }

  warning {
    operator              = "above"
    threshold             = local.infra_threshold.cpu_and_memory.warning
    threshold_duration    = local.infra_threshold_duration.cpu_and_memory
    threshold_occurrences = "ALL"
  }
}


resource "newrelic_alert_policy" "diskrate_infra" {
  name = "Disk Usage Rate Policy by Node"
}

resource "newrelic_nrql_alert_condition" "diskrate_infra" {
  policy_id = newrelic_alert_policy.diskrate_infra.id
  name      = "Disk Usage Rate (%) by Node"
  enabled = local.alert_enabled
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = local.infra_violation_time_limit_seconds.disk

  nrql {
    query      = "FROM K8sNodeSample SELECT latest(fsCapacityUtilization) FACET nodeName WHERE ${local.infra_query_filter.disk}"
  }

  critical {
    operator              = "above"
    threshold             = local.infra_threshold.disk.critical
    threshold_duration    = local.infra_threshold_duration.disk
    threshold_occurrences = "ALL"
  }

  warning {
    operator              = "above"
    threshold             = local.infra_threshold.disk.warning
    threshold_duration    = local.infra_threshold_duration.disk
    threshold_occurrences = "ALL"
  }
}


resource "newrelic_alert_policy" "state_infra" {
  name = "Not Ready Status by Node"
}

resource "newrelic_nrql_alert_condition" "state_infra" {
  policy_id = newrelic_alert_policy.state_infra.id
  name      = "Not Ready Status by Node"
  enabled = local.alert_enabled
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = local.infra_violation_time_limit_seconds.state

  nrql {
    query      = "FROM K8sNodeSample SELECT uniqueCount(nodeName) FACET nodeName WHERE condition.Ready != 1 AND ${local.infra_query_filter.disk}"
  }

  critical {
    operator              = "above"
    threshold             = local.infra_threshold.disk.critical
    threshold_duration    = local.infra_threshold_duration.disk
    threshold_occurrences = "ALL"
  }

  warning {
    operator              = "above"
    threshold             = local.infra_threshold.disk.warning
    threshold_duration    = local.infra_threshold_duration.disk
    threshold_occurrences = "ALL"
  }
}

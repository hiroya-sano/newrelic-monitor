variable "harbor_env" {
  description = "for harbor url"
  type        = string
}

locals {
  harbor_query_filter = {
    cpu_and_memory = "clusterName LIKE 'g3cshrwc-shared-%' AND namespaceName LIKE 'app1986-harbor-%'"
    status = "namespace_name LIKE '%harbor%' or namespace_name LIKE '%jenkins%' or namespace_name LIKE '%vault%'"
    url = "URL = 'https://harbor-${var.harbor_env}.g3cshr.mazda.co.jp'"
    pvc = "clusterName LIKE 'g3cshrwc-shared-%' AND namespaceName LIKE 'app1986-harbor-%'"
  }
  harbor_threshold = {
    cpu_and_memory = {
      critical = 90
      warning = 80
    }
    status = {
      critical = 1
    }
    url = {
      critical = 1
    }
    pvc = {
      critical = 90
      warning = 80
    }
  }
  harbor_alert_frequency = {
    cpu_and_memory = 86400
    status = 600
    url = 600
    pvc = 86400
  }
  harbor_threshold_duration = {
    cpu_and_memory = 300
    status = 300
    url = 300
    pvc = 300
  }
  harbor_violation_time_limit_seconds = {
    cpu_and_memory = local.harbor_alert_frequency.cpu_and_memory - local.harbor_threshold_duration.cpu_and_memory
    status = local.harbor_alert_frequency.status - local.harbor_threshold_duration.status
    url = local.harbor_alert_frequency.url - local.harbor_threshold_duration.url
    pvc = local.harbor_alert_frequency.pvc - local.harbor_threshold_duration.pvc
  }
}

resource "newrelic_alert_policy" "cpurate_namespace_harbor" {
  name = "CPU Usage Policy by Harbor Namespace"
}

resource "newrelic_nrql_alert_condition" "cpurate_namespace_harbor" {
  policy_id = newrelic_alert_policy.cpurate_namespace_harbor.id
  name      = "CPU Usage Rate (%) by Harbor Namespace"
  enabled = local.alert_enabled
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = local.harbor_violation_time_limit_seconds.cpu_and_memory

  nrql {
    query      = "FROM K8sContainerSample SELECT average(cpuCoresUtilization) FACET namespaceName WHERE ${local.harbor_query_filter.cpu_and_memory}"
  }

  critical {
    operator              = "above"
    threshold             = local.harbor_threshold.cpu_and_memory.critical
    threshold_duration    = local.harbor_threshold_duration.cpu_and_memory
    threshold_occurrences = "ALL"
  }

  warning {
    operator              = "above"
    threshold             = local.harbor_threshold.cpu_and_memory.warning
    threshold_duration    = local.harbor_threshold_duration.cpu_and_memory
    threshold_occurrences = "ALL"
  }
}


resource "newrelic_alert_policy" "cpurate_pod_harbor" {
  name = "CPU Usage Policy by Harbor Pod"
}

resource "newrelic_nrql_alert_condition" "cpurate_pod_harbor" {
  policy_id = newrelic_alert_policy.cpurate_pod_harbor.id
  name      = "CPU Usage Rate (%) by Harbor Pod"
  enabled = local.alert_enabled
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = local.harbor_violation_time_limit_seconds.cpu_and_memory

  nrql {
    query      = "FROM K8sContainerSample SELECT average(cpuCoresUtilization) FACET podName WHERE ${local.harbor_query_filter.cpu_and_memory}"
  }

  critical {
    operator              = "above"
    threshold             = local.harbor_threshold.cpu_and_memory.critical
    threshold_duration    = local.harbor_threshold_duration.cpu_and_memory
    threshold_occurrences = "ALL"
  }

  warning {
    operator              = "above"
    threshold             = local.harbor_threshold.cpu_and_memory.warning
    threshold_duration    = local.harbor_threshold_duration.cpu_and_memory
    threshold_occurrences = "ALL"
  }
}


resource "newrelic_alert_policy" "memoryrate_namespace_harbor" {
  name = "Memory Usage Policy by Harbor Namespace"
}

resource "newrelic_nrql_alert_condition" "memoryrate_namespace_harbor" {
  policy_id = newrelic_alert_policy.memoryrate_namespace_harbor.id
  name      = "Memory Usage Rate (%) by Harbor Namespace"
  enabled = local.alert_enabled
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = local.harbor_violation_time_limit_seconds.cpu_and_memory

  nrql {
    query      = "FROM K8sContainerSample SELECT average(memoryUtilization) FACET namespaceName WHERE ${local.harbor_query_filter.cpu_and_memory}"
  }

  critical {
    operator              = "above"
    threshold             = local.harbor_threshold.cpu_and_memory.critical
    threshold_duration    = local.harbor_threshold_duration.cpu_and_memory
    threshold_occurrences = "ALL"
  }

  warning {
    operator              = "above"
    threshold             = local.harbor_threshold.cpu_and_memory.warning
    threshold_duration    = local.harbor_threshold_duration.cpu_and_memory
    threshold_occurrences = "ALL"
  }
}


resource "newrelic_alert_policy" "memoryrate_pod_harbor" {
  name = "Memory Usage Policy by Harbor Pod"
}

resource "newrelic_nrql_alert_condition" "memoryrate_pod_harbor" {
  policy_id = newrelic_alert_policy.memoryrate_pod_harbor.id
  name      = "Memory Usage Rate (%) by Harbor Pod"
  enabled = local.alert_enabled
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = local.harbor_violation_time_limit_seconds.cpu_and_memory

  nrql {
    query      = "FROM K8sContainerSample SELECT average(memoryUtilization) FACET podName WHERE ${local.harbor_query_filter.cpu_and_memory}"
  }

  critical {
    operator              = "above"
    threshold             = local.harbor_threshold.cpu_and_memory.critical
    threshold_duration    = local.harbor_threshold_duration.cpu_and_memory
    threshold_occurrences = "ALL"
  }

  warning {
    operator              = "above"
    threshold             = local.harbor_threshold.cpu_and_memory.warning
    threshold_duration    = local.harbor_threshold_duration.cpu_and_memory
    threshold_occurrences = "ALL"
  }
}


resource "newrelic_alert_policy" "status_pod_harbor" {
  name = "Pod Status by Shared Cluster Pod"
}

resource "newrelic_nrql_alert_condition" "status_pod_harbor" {
  policy_id = newrelic_alert_policy.status_pod_harbor.id
  name      = "Not Running Status by Shared Cluster Pod"
  enabled = local.alert_enabled
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = local.harbor_violation_time_limit_seconds.status

  nrql {
    query      = "FROM K8sPodSample SELECT uniqueCount(podName) FACET podName WHERE status NOT IN ('Running', 'Succeeded') AND ${local.harbor_query_filter.status}"
  }

  critical {
    operator              = "above"
    threshold             = local.harbor_threshold.status.critical
    threshold_duration    = local.harbor_threshold_duration.status
    threshold_occurrences = "ALL"
  }
}


resource "newrelic_alert_policy" "status_container_harbor" {
  name = "Container Status by Shared Cluster"
}

resource "newrelic_nrql_alert_condition" "status_container_harbor" {
  policy_id = newrelic_alert_policy.status_container_harbor.id
  name      = "Not Running Status by Shared Cluster Container"
  enabled = local.alert_enabled
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = local.harbor_violation_time_limit_seconds.status

  nrql {
    query      = "FROM K8sContainerSample SELECT uniqueCount(containerName) FACET podName,containerName WHERE (status NOT IN ('Running') AND jobName is NULL) OR (lastTerminatedExitCode != 0 AND jobName is NOT NULL) AND ${local.harbor_query_filter.status}"
  }

  critical {
    operator              = "above"
    threshold             = local.harbor_threshold.status.critical
    threshold_duration    = local.harbor_threshold_duration.status
    threshold_occurrences = "ALL"
  }
}


resource "newrelic_alert_policy" "url_harbor" {
  name = "URL Monitoring harbor-${var.harbor_env}"
}

resource "newrelic_nrql_alert_condition" "url_harbor" {
  policy_id = newrelic_alert_policy.url_harbor.id
  name      = "URL Monitor harbor-${var.harbor_env}"
  enabled = local.alert_enabled
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = local.harbor_violation_time_limit_seconds.url

  nrql {
    query      = "FROM SyntheticRequest SELECT uniqueCount(URL) FACET URL WHERE ${local.harbor_query_filter.url} AND responseCode != 200"
  }

  critical {
    operator              = "above"
    threshold             = local.harbor_threshold.url.critical
    threshold_duration    = local.harbor_threshold_duration.url
    threshold_occurrences = "ALL"
  }
}


resource "newrelic_alert_policy" "pvcrate_harbor" {
  name = "PVC by Harbor"
}

resource "newrelic_nrql_alert_condition" "pvcrate_harbor" {
  policy_id = newrelic_alert_policy.pvcrate_harbor.id
  name      = "PVC by Harbor Usage Rate (%)"
  enabled = local.alert_enabled
  aggregation_method = "event_flow"
  aggregation_window = "60"
  aggregation_delay = "60"
  violation_time_limit_seconds = local.harbor_violation_time_limit_seconds.pvc

  nrql {
    query      = "FROM K8sVolumeSample SELECT latest(fsUsedPercent) FACET clusterName WHERE ${local.harbor_query_filter.pvc}"
  }

  critical {
    operator              = "above"
    threshold             = local.harbor_threshold.pvc.critical
    threshold_duration    = local.harbor_threshold_duration.pvc
    threshold_occurrences = "ALL"
  }

  warning {
    operator              = "above"
    threshold             = local.harbor_threshold.pvc.warning
    threshold_duration    = local.harbor_threshold_duration.pvc
    threshold_occurrences = "ALL"
  }
}

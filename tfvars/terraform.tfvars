monitors = [
  {
    name      = "example-monitor-1"
    url       = "https://example1.com"
    private_locations  = ["test-sano"]
  },
  {
    name      = "example-monitor-2"
    url       = "https://example2.com"
    private_locations  = ["test-sano"]
  }
]

policies = [
  "cpurate-namespace",
  "cpurate-pod",
  "memoryrate-namespace",
  "memoryrate-pod",
  "pod-restart",
  "pod-status",
  "url"
]

conditions = [
  {
    policy_name = "cpurate-namespace"
    app_name    = "App-1"
    violation_time_limit_seconds = 1800
    critical_threshold   = 10
    warning_threshold = 8
  },
  {
    policy_name = "cpurate-pod"
    app_name    = "App-2"
    violation_time_limit_seconds = 1800
    critical_threshold   = 10
    warning_threshold = 8
  },
  {
    policy_name = "memoryrate-namespace"
    app_name    = "App-3"
    violation_time_limit_seconds = 1800
    critical_threshold   = 10
    warning_threshold = 8
  },
  {
    policy_name = "memoryrate-pod"
    app_name    = "App-4"
    violation_time_limit_seconds = 1800
    critical_threshold   = 10
    warning_threshold = 8
  },
  {
    policy_name = "pod-restart"
    app_name    = "App-5"
    violation_time_limit_seconds = 1800
    critical_threshold   = 10
    warning_threshold = 8
  },
  {
    policy_name = "pod-status"
    app_name    = "App-6"
    violation_time_limit_seconds = 1800
    critical_threshold   = 10
    warning_threshold = 8
  },
  {
    policy_name = "url"
    app_name    = "App-7"
    violation_time_limit_seconds = 1800
    critical_threshold   = 10
    warning_threshold = 8
  }
]

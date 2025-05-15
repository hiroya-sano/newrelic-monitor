private_locations = [
  "test-sano",
  "test-sano2"
]

monitors = [
  {
    name      = "example-monitor-1"
    url       = "https://example1.com"
    private_locations  = ["test-sano"]
  },
  {
    name      = "example-monitor-2"
    url       = "https://example2.com"
    private_locations  = ["test-sano2"]
  }
]

conditions_cpurata_namespace = [
  {
    namespace_name    = "App-1"
    threshold_duration = 300
    alert_frequency = 600
    critical_threshold   = 80
    warning_threshold = 90
  },
  {
    namespace_name    = "App-2"
    threshold_duration = 300
    alert_frequency = 600
    critical_threshold   = 70
    warning_threshold = 80
  },
  {
    namespace_name    = "App-3"
    threshold_duration = 300
    alert_frequency = 600
    critical_threshold   = 80
  }
]

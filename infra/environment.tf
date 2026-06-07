resource "conveyor_environment" "workshop" {
  # Environment names must match ^[a-z0-9]+$ (no hyphens)
  name                = "workshop"
  deletion_protection = false
  instance_lifecycle  = "spot"
  airflow_version     = 3
}

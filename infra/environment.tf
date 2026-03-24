resource "conveyor_environment" "hackandbeers" {
  name                = "hackandbeers"
  deletion_protection = false
  instance_lifecycle  = "spot"
  airflow_version     = 3
}

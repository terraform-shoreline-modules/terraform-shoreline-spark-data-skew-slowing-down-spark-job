terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "data_skew_slowing_down_spark_job" {
  source    = "./modules/data_skew_slowing_down_spark_job"

  providers = {
    shoreline = shoreline
  }
}
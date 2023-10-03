resource "shoreline_notebook" "data_skew_slowing_down_spark_job" {
  name       = "data_skew_slowing_down_spark_job"
  data       = file("${path.module}/data/data_skew_slowing_down_spark_job.json")
  depends_on = [shoreline_action.invoke_script_data_distribution,shoreline_action.invoke_update_spark_worker_instances]
}

resource "shoreline_file" "script_data_distribution" {
  name             = "script_data_distribution"
  input_file       = "${path.module}/data/script_data_distribution.sh"
  md5              = filemd5("${path.module}/data/script_data_distribution.sh")
  description      = "Imbalanced data distribution: If the data is not evenly distributed across the nodes in the cluster, some nodes may have to process more data than others, leading to data skew and slower processing times."
  destination_path = "/agent/scripts/script_data_distribution.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_spark_worker_instances" {
  name             = "update_spark_worker_instances"
  input_file       = "${path.module}/data/update_spark_worker_instances.sh"
  md5              = filemd5("${path.module}/data/update_spark_worker_instances.sh")
  description      = "Increase the number of executors or worker nodes in the Spark cluster to distribute the workload evenly."
  destination_path = "/agent/scripts/update_spark_worker_instances.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_script_data_distribution" {
  name        = "invoke_script_data_distribution"
  description = "Imbalanced data distribution: If the data is not evenly distributed across the nodes in the cluster, some nodes may have to process more data than others, leading to data skew and slower processing times."
  command     = "`chmod +x /agent/scripts/script_data_distribution.sh && /agent/scripts/script_data_distribution.sh`"
  params      = ["INSERT_INPUT_PATH","SPARK_JOB_JAR_FILE"]
  file_deps   = ["script_data_distribution"]
  enabled     = true
  depends_on  = [shoreline_file.script_data_distribution]
}

resource "shoreline_action" "invoke_update_spark_worker_instances" {
  name        = "invoke_update_spark_worker_instances"
  description = "Increase the number of executors or worker nodes in the Spark cluster to distribute the workload evenly."
  command     = "`chmod +x /agent/scripts/update_spark_worker_instances.sh && /agent/scripts/update_spark_worker_instances.sh`"
  params      = ["PATH_TO_SPARK_HOME","NUMBER_OF_WORKER_INSTANCES","SPARK_MASTER_PORT"]
  file_deps   = ["update_spark_worker_instances"]
  enabled     = true
  depends_on  = [shoreline_file.update_spark_worker_instances]
}


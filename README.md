
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Data Skew Slowing Down Spark Job.
---

Data skew slowing down a Spark job is a common incident that occurs when there is an uneven distribution of data across partitions. This can lead to some partitions handling a much larger amount of data than others, causing delays and slowing down the entire job. The result is a significant decrease in performance and a longer processing time for the Spark job.

### Parameters
```shell
export SPARK_JOB_LOG_FILE="PLACEHOLDER"

export SPARK_JOB_CONFIG_FILE="PLACEHOLDER"

export SPARK_JOB_JAR_FILE="PLACEHOLDER"

export INSERT_INPUT_PATH="PLACEHOLDER"

export SPARK_MASTER_PORT="PLACEHOLDER"

export PATH_TO_SPARK_HOME="PLACEHOLDER"

export NUMBER_OF_WORKER_INSTANCES="PLACEHOLDER"
```

## Debug

### Check Spark job logs for errors
```shell
grep -i error ${SPARK_JOB_LOG_FILE}
```

### Check Spark job logs for warnings
```shell
grep -i warning ${SPARK_JOB_LOG_FILE}
```

### Check Spark job logs for information
```shell
grep -i info ${SPARK_JOB_LOG_FILE}
```

### Check for data skew in Spark job logs
```shell
grep -i "data skew" ${SPARK_JOB_LOG_FILE}
```

### Check the Spark job configuration for any issues
```shell
cat ${SPARK_JOB_CONFIG_FILE}
```

### Check the Spark job DAG for any issues
```shell
spark-submit --class org.apache.spark.sql.execution.ui.SparkUI ${SPARK_JOB_JAR_FILE}
```

### Check the Spark job task execution time and distribution
```shell
spark-submit --class org.apache.spark.sql.execution.ui.SparkUI ${SPARK_JOB_JAR_FILE}
```

### Check the Spark job task failures
```shell
spark-submit --class org.apache.spark.sql.execution.ui.SparkUI ${SPARK_JOB_JAR_FILE}
```

### Check the Spark job task metrics
```shell
spark-submit --class org.apache.spark.sql.execution.ui.SparkUI ${SPARK_JOB_JAR_FILE}
```

### Imbalanced data distribution: If the data is not evenly distributed across the nodes in the cluster, some nodes may have to process more data than others, leading to data skew and slower processing times.
```shell


#!/bin/bash



# Define variables

APP_NAME=${SPARK_JOB_JAR_FILE}

INPUT_PATH=${INSERT_INPUT_PATH}



# Check data distribution

echo "Checking data distribution..."

hdfs dfs -ls $INPUT_PATH | awk '{print $5}' | sort -rn | awk '{total += $1} END {print "Total size: " total/1024/1024/1024 " GB"; print "Average size: " total/NR/1024/1024 " MB"; print "Max size: " $1/1024/1024 " MB"}'



# Check node distribution

echo "Checking node distribution..."

yarn application -status $APP_NAME | grep 'Total vCores' | awk '{print "Total vCores: " $3}'

yarn application -status $APP_NAME | grep 'Total MB' | awk '{print "Total memory: " $3/1024 " GB"}'

yarn application -status $APP_NAME | grep 'Node Resources' -A 10 | grep 'Memory' | awk '{print "Node memory: " $3/1024 " GB"}'

yarn application -status $APP_NAME | grep 'Node Resources' -A 10 | grep 'vCores' | awk '{print "Node vCores: " $3}'



# Check processing times

echo "Checking processing times..."

yarn application -list | grep $APP_NAME | awk '{print $1}' | xargs -I {} yarn application -appStates FINISHED -list {} | grep 'FINISHED' | awk '{print "Duration: " $2 " seconds"}'


```

## Repair

### Increase the number of executors or worker nodes in the Spark cluster to distribute the workload evenly.
```shell


#!/bin/bash



# Set the necessary environment variables

SPARK_HOME=${PATH_TO_SPARK_HOME}

SPARK_MASTER=${SPARK_MASTER_PORT}

SPARK_WORKER_INSTANCES=${NUMBER_OF_WORKER_INSTANCES}



# Stop the Spark cluster
sudo systemctl stop spark



# Update the Spark configuration with the new number of worker nodes

sed -i "s/spark.worker.instances=[0-9]*/spark.worker.instances=$SPARK_WORKER_INSTANCES/g" $SPARK_HOME/conf/spark-defaults.conf



# Start the Spark cluster with the updated configuration
sudo systemctl start spark
```
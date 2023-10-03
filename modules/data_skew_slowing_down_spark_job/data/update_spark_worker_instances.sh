

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
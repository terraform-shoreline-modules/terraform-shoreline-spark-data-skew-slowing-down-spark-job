

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
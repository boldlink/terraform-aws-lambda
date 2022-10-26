import logging
import boto3
import os
import jmespath


##Environment variables
DEPARTMENT = os.environ["department"]

ec2 = boto3.client("ec2")

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    response = ec2.describe_instances()
    Instances = jmespath.search("Reservations[].Instances[]", response)

    for instance in Instances:
        instance_id = instance.get("InstanceId", "")
        print(f"Stopping {instance_id} for {DEPARTMENT}")
        ec2.stop_instances(InstanceIds=[instance_id])

import boto3
import pandas as pd
import os
import tempfile

def lambda_handler(event, context):
    region = "us-east-1"
    bucket = "ai-cloud-optimizer"
    key = "unused_ec2/predicted_unused_us-east-1.csv"

    s3 = boto3.client('s3')
    ec2 = boto3.client('ec2', region_name=region)

    with tempfile.NamedTemporaryFile() as tmp:
        s3.download_file(bucket, key, tmp.name)
        df = pd.read_csv(tmp.name)

    to_stop = df[(df['recommendation'] == 'suggest_termination') & (df['confidence'] > 0.85)]
    if to_stop.empty:
        return {"message": "No instances to stop."}

    instance_ids = to_stop['instance_id'].tolist()

    ec2.stop_instances(InstanceIds=instance_ids)

    ec2.create_tags(
        Resources=instance_ids,
        Tags=[{"Key": "SuggestedByAI", "Value": "True"}]
    )

    return {
        "message": f"Stopped and tagged instances: {instance_ids}"
    }

import boto3
import json

# Define the AWS regions to be processed
REGIONS = ['us-west-2', 'us-east-1', 'eu-west-1', 'ap-south-1', 'eu-central-1']

def fetch_all_ec2_instances():
    all_instances_data = []
    
    # Loop over all regions to fetch EC2 instances data
    for region in REGIONS:
        ec2_client = boto3.client('ec2', region_name=region)
        
        # Fetch all running EC2 instances in the region
        response = ec2_client.describe_instances(Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])
        
        # Collect relevant data for each instance
        for reservation in response['Reservations']:
            for instance in reservation['Instances']:
                instance_data = {
                    'instance_id': instance['InstanceId'],
                    'instance_type': instance['InstanceType'],
                    'launch_time': instance['LaunchTime'].strftime('%Y-%m-%dT%H:%M:%S+00:00'),
                    'running_time_hours': (datetime.datetime.now() - instance['LaunchTime']).total_seconds() / 3600,
                    'avg_cpu': get_avg_cpu_usage(region, instance['InstanceId']),
                    'tag_name': get_instance_tag(instance)
                }
                all_instances_data.append(instance_data)

    return all_instances_data

def get_avg_cpu_usage(region, instance_id):
    # This function fetches the average CPU utilization for the last 7 days (can be adjusted)
    cw_client = boto3.client('cloudwatch', region_name=region)
    metrics = cw_client.get_metric_statistics(
        Namespace='AWS/EC2',
        MetricName='CPUUtilization',
        Dimensions=[{'Name': 'InstanceId', 'Value': instance_id}],
        StartTime=datetime.datetime.now() - datetime.timedelta(days=7),
        EndTime=datetime.datetime.now(),
        Period=3600,
        Statistics=['Average']
    )
    
    # Return the average CPU utilization
    return float(sum(dp['Average'] for dp in metrics['Datapoints']) / len(metrics['Datapoints'])) if metrics['Datapoints'] else 0.0

def get_instance_tag(instance):
    # This function gets the 'Name' tag of the EC2 instance, if it exists
    tags = instance.get('Tags', [])
    for tag in tags:
        if tag['Key'] == 'Name':
            return tag['Value']
    return 'unknown'

# Fetch all instances and prepare the input event for Lambda
all_instances_data = fetch_all_ec2_instances()
lambda_event = {
    'region': 'us-east-1',
    'instances': all_instances_data
}

# Convert to JSON for Lambda
print(json.dumps(lambda_event, indent=2))

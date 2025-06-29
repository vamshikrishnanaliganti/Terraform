import boto3

# Initialize EC2 client
ec2 = boto3.client('ec2', region_name='us-east-1')  # Change region as needed

# List all EC2 instances
response = ec2.describe_instances()

# Print instance IDs
for reservation in response['Reservations']:
    for instance in reservation['Instances']:
        print(f"Instance ID: {instance['InstanceId']}")

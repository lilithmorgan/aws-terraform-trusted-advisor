import boto3

def list_ec2_instances():
    ec2 = boto3.resource('ec2')
    for instance in ec2.instances.all():
        print(instance.id, instance.instance_type)

def get_cpu_utilization(instance_id):
    cloudwatch = boto3.client('cloudwatch')
    response = cloudwatch.get_metric_statistics(
        Namespace='AWS/EC2',
        MetricName='CPUUtilization',
        Dimensions=[{'Name': 'InstanceId', 'Value': instance_id}],
        StartTime='2023-10-01T00:00:00Z',
        EndTime='2023-10-02T00:00:00Z',
        Period=3600,
        Statistics=['Average']
    )
    print(response)


list_ec2_instances()
get_cpu_utilization('i-0abcd1234efgh5678')

def list_unused_volumes():
    ec2 = boto3.resource('ec2')
    for volume in ec2.volumes.all():
        if volume.state == 'available':
            print(volume.id)

def list_old_snapshots():
    ec2 = boto3.resource('ec2')
    for snapshot in ec2.snapshots.filter(OwnerIds=['self']):
        if snapshot.start_time < '2022-01-01T00:00:00Z':
            print(snapshot.id)

list_unused_volumes()
list_old_snapshots()

def check_autoscaling_configurations():
    autoscaling = boto3.client('autoscaling')
    response = autoscaling.describe_auto_scaling_groups()
    for group in response['AutoScalingGroups']:
        desired_capacity = group['DesiredCapacity']
        min_size = group['MinSize']
        max_size = group['MaxSize']
        print(f'Auto Scaling Group: {group["AutoScalingGroupName"]}, Desired: {desired_capacity}, Min: {min_size}, Max: {max_size}')

check_autoscaling_configurations()

def send_notification(message):
    sns = boto3.client('sns')
    sns.publish(
        TopicArn='Arn do TOPICO aqui',
        Message=message
    )

send_notification('Alerta de consumo de recursos')


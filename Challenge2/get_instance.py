import boto3
import json

def get_instances(keyname,keyvalue):
    result = {}
    ec2 = boto3.resource('ec2')
    data = ec2.instances.filter(Filters=[{'Name':'tag:keyname','Values': [keyvalue]}])
    for instance in data:
        for tag in instance.tags:
            if 'Name' in tag['Key']:
                name = tag['Value']
        ec2_info = {
             "Name": name,
             "Instance_Id": str(instance.id),
             "State": instance.state["Name"],
             "Private_IP": instance.private_ip_address,
             }
        data = json.dumps(ec2_info,indent=4,sort_keys=True)
        print(data)
		

# User can pass the key and value data to get the Instance details
get_instances(Lifecycle,Dev)
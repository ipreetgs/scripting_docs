import boto3
import os
def CreateKeyPair(KeyName,Region="us-east-1"):
    ec2_client = boto3.client("ec2", region_name=Region)
    key_pair = ec2_client.create_key_pair(KeyName=KeyName)

    private_key = key_pair["KeyMaterial"]
    pemfile= open(f"{keyname}.pem",'w')
    pemfile.write(private_key)
    pemfile.close()

def CreateInstance(ec2_name,KeyName,Region="us-east-1"):
    ec2_client = boto3.client("ec2", region_name=Region)
    instances = ec2_client.run_instances(
        ImageId="ami-0b0154d3d8011b0cd",
        MinCount=1,
        MaxCount=1,
        InstanceType="t2.micro",
        KeyName=KeyName
    )
def GetInstanceList():
    ec2_client = boto3.client("ec2", region_name="us-east-1")
    reservations = ec2_client.describe_instances(Filters=[
        {
            "Name": "instance-state-name",
            "Values": ["running"],
        }
    ]).get("Reservations")

    for reservation in reservations:
        for instance in reservation["Instances"]:
            instance_id = instance["InstanceId"]
            instance_type = instance["InstanceType"]
            public_ip = instance["PublicIpAddress"]
            private_ip = instance["PrivateIpAddress"]
            print(f"instance id is {instance_id}, {public_ip}, {private_ip}")
def TerminateInstance(instance_id):
    ec2_client = boto3.client("ec2", region_name="us-east-1")
    response = ec2_client.terminate_instances(InstanceIds=[instance_id])
    print(response)


print("""
\t 1. create new instance
\t 2. delete instances
""")
try:
    opt= int(input("chose any one:"))
    if opt ==1:
        print("""
        \t 1. create new key
        \t 2. use old key""")
        kopt =int(input("chose: "))
        regioni=input("enter region for ec2 instance e.g. us-east-1> ")
        if kopt ==1:
            keyname =input("enter key name> ")
            CreateKeyPair(keyname ,regioni)
            print("key creating done")
            InsName= input("type instance name> ")
            CreateInstance(InsName,keyname,regioni)
            GetInstanceList()


            
        elif kopt ==2:
            keyname= input("enter key name")
            InsName= input("type instance name> ")
            CreateInstance(InsName,keyname,regioni)
            GetInstanceList()
        
    elif opt ==2:
        GetInstanceList()
        iid= input("type insatnce id> ")
        TerminateInstance(iid)

    else:
        print("type valid option")
except Exception as e:
    print("input valid option 1 or 2",e)
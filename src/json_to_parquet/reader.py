import json
import pandas as pd
import os
import boto3


def lambda_handler(event, context):
    bucket_name = event["Records"][0]["s3"]["bucket"]["name"]
    object_name = event["Records"][0]["s3"]["object"]["key"]

    s3 = boto3.client('s3')
    json_data = get_text_from_file(s3, bucket_name, object_name)
    df = pd.DataFrame(json_data)
    pq_bytes = df.to_parquet()
    new_object_name = f'{os.path.splitext(object_name)[0]}.pq'
    s3.put_object(Bucket=bucket_name, Key=new_object_name, Body=pq_bytes)

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }


def get_text_from_file(client, bucket: str, key: str) -> str:
    """reads file from s3"""
    data = client.get_object(Bucket=bucket, Key=key)["Body"].read()
    json_data = json.loads(data)
    return json_data

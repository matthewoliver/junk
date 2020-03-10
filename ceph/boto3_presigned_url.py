import logging
import boto3
import sys
from botocore.exceptions import ClientError


def create_presigned_url(bucket_name, object_name, expiration=3600,
                         endpoint="http://localhost:8000"):
    """Generate a presigned URL to share an S3 object

    :param bucket_name: string
    :param object_name: string
    :param expiration: Time in seconds for the presigned URL to remain valid
    :return: Presigned URL as string. If error, returns None.
    """

    # Generate a presigned URL for the S3 object
    s3_client = boto3.client('s3', endpoint_url="http://localhost:8000")
    try:
        response = s3_client.generate_presigned_url('get_object',
                                                    Params={'Bucket': bucket_name,
                                                            'Key': object_name},
                                                    ExpiresIn=expiration)
    except ClientError as e:
        logging.error(e)
        return None

    # The response contains the presigned URL
    return response

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Useage: {} <bucket> <object> [[<expires>] <endpoint url>]".format(sys.argv[0]))
        sys.exit(1)
    bucket, obj = sys.argv[1:3]
    expires = 3600 if not len(sys.argv) >= 4 else int(sys.argv[3])
    endpoint = "http://localhost:8000"
    if len(sys.argv) >= 5:
        endpoint = sys.argv[4]

    print(create_presigned_url(bucket, obj, expires, endpoint))

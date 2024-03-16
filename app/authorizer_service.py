import json
import os
import requests

from jose import jwt
from jose.exceptions import JWTError


def lambda_handler(event, context):
    jwks_url = "https://cognito-idp.{region}.amazonaws.com/{user_pool_id}/.well-known/jwks.json".format(
        region=os.environ.get('aws_region'),
        user_pool_id=os.environ.get('user_pool_id')
    )
    jwks_response = requests.get(jwks_url)
    jwks = jwks_response.json()

    public_keys = {}
    for key in jwks['keys']:
        kid = key['kid']
        public_key = jwt.algorithms.RSAAlgorithm.from_jwk(json.dumps(key))
        public_keys[kid] = public_key

    token = event.get('headers', {}).get('Authorization')

    try:
        jwt.decode(token, public_keys, algorithms=['HS256'])

        return {
            'statusCode': 200,
            'body': json.dumps('Token verificado com sucesso')
        }
    except JWTError as e:
        print(f"Erro ao decodificar o token JWT: {str(e)}")
        return {
            'statusCode': 401,
            'body': json.dumps('Token nao autorizado')
        }


# def generate_policy(principal_id, effect, resource):
#     # Gerar uma política de autorização conforme necessário
#     policy = {
#         'principalId': principal_id,
#         'policyDocument': {
#             'Version': '2012-10-17',
#             'Statement': [{
#                 'Action': 'execute-api:Invoke',
#                 'Effect': effect,
#                 'Resource': resource
#             }]
#         }
#     }
#     return policy
#


#
# def get_user_pool_keys(user_pool_id):
#     client = boto3.client('cognito-idp')
#     response = client.describe_user_pool(UserPoolId=user_pool_id)
#     keys = response['UserPool']['Arn']
#     return keys

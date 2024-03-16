from src.authorizer_service import lambda_handler as inner_handler


def lambda_handler(event, context):
    return inner_handler(event, context)

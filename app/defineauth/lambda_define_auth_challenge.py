import json
from aws_lambda_powertools import Logger

logger = Logger()


def lambda_handler(event, context):
    logger.info('event received: ' + json.dumps(event))

    response = event.get('response')

    next_challenge = "CUSTOM_CHALLENGE"
    issue_tokens = False
    fail_authentication = False

    response.update = {
        "challengeName": next_challenge,
        "issueTokens": issue_tokens,
        "failAuthentication": fail_authentication
    }

    logger.info('event response: ' + json.dumps(event))
    return response

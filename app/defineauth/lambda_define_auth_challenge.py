import json
from aws_lambda_powertools import Logger

logger = Logger()


def lambda_handler(event, context):
    logger.info('event received: ' + json.dumps(event))

    response = event.get('response')

    next_challenge = "CUSTOM_CHALLENGE"
    issue_tokens = False
    fail_authentication = False

    session = event['request']['session']

    if (len(session) > 0 and session[-1]['challengeResult']):
        event['response']['issueTokens'] = True
        event['response']['failAuthentication'] = fail_authentication

        return event

    event['response']['challengeName'] = next_challenge
    event['response']['issueTokens'] = issue_tokens
    event['response']['failAuthentication'] = fail_authentication

    logger.info('event response: ' + json.dumps(event))
    return event

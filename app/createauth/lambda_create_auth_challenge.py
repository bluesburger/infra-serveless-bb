import json
from aws_lambda_powertools import Logger

logger = Logger()


def lambda_handler(event, context):
    logger.info('event received: ' + json.dumps(event))

    event['response']['privateChallengeParameters'] = dict()
    event['response']['privateChallengeParameters']['challenge'] = 'validatecpf'

    logger.info('event response: ' + json.dumps(event))
    return event

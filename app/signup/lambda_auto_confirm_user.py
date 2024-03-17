from aws_lambda_powertools import Logger

logger = Logger()


def lambda_handler(event, context):
    logger.info("event received" + event)

    event.get('response').update({
        'autoConfirmUser': True
    })

    return event

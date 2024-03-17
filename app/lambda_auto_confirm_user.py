import json


def lambda_handler(event, context):

    event.get('response').update({
        'autoConfirmUser': True
    })

    return event

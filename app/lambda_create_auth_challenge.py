def lambda_handler(event, context):
    event['response']['privateChallengeParameters'] = dict()
    event['response']['privateChallengeParameters']['challenge'] = 'validatecpf'

    return event

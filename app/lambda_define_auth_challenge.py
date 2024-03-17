import json


def lambda_handler(event, context):
    # Extrair os parâmetros necessários do evento
    response = event.get('response')
    request = event.get('request')

    # Lógica para definir o próximo desafio de autenticação
    next_challenge = "CUSTOM_CHALLENGE"  # Defina o próximo tipo de desafio
    issue_tokens = False  # Defina como True se todos os desafios foram concluídos
    fail_authentication = False  # Defina como True se deseja encerrar a autenticação

    response.update = {
        "challengeName": next_challenge,
        "issueTokens": issue_tokens,
        "failAuthentication": fail_authentication
    }

    return response

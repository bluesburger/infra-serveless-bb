import json
from aws_lambda_powertools import Logger

logger = Logger()


BAD_REQUEST = 400


def lambda_handler(event, context):
    logger.info("event received : " + json.dumps(event))

    if 'userName' not in event or 'request' not in event:
        return {
            'statusCode': BAD_REQUEST,
            'body': json.dumps('Parâmetros inválidos.')
        }

    request = event['request']

    if request['userAttributes'] and 'custom:cpf' in request['userAttributes']:
        cpf = request['userAttributes']['custom:cpf']

        if not validate_cpf(cpf):
            return {
                'statusCode': BAD_REQUEST,
                'body': json.dumps('CPF inválido.')
            }

        event['response']['answerCorrect'] = True
        logger.info("event response: " + json.dumps(event))
        return event

    event['response']['answerCorrect'] = False

    logger.info("event response: " + json.dumps(event))
    return event


def validate_cpf(cpf):
    # Remove caracteres especiais e espaços em branco do CPF
    cpf = ''.join(filter(str.isdigit, cpf))

    # Verifica se o CPF tem 11 dígitos
    if len(cpf) != 11:
        logger.warning("cpf nao possui 11 digitos: " + cpf)
        return False

    # Verifica se todos os dígitos do CPF são iguais, o que o tornaria inválido
    if len(set(cpf)) == 1:
        logger.warning("cpf invalido: " + cpf)
        return False

    # Calcula o primeiro dígito verificador
    soma = 0
    peso = 10
    for i in range(9):
        soma += int(cpf[i]) * peso
        peso -= 1

    digito1 = 11 - (soma % 11)
    if digito1 > 9:
        digito1 = 0

    # Calcula o segundo dígito verificador
    soma = 0
    peso = 11
    for i in range(10):
        soma += int(cpf[i]) * peso
        peso -= 1

    digito2 = 11 - (soma % 11)
    if digito2 > 9:
        digito2 = 0

    # Verifica se os dígitos verificadores calculados correspondem aos dígitos fornecidos
    if int(cpf[9]) == digito1 and int(cpf[10]) == digito2:
        logger.info("cpf validado com sucesso : " + cpf)
        return True
    else:
        logger.warning("cpf com digitos verificadores invalido: " + cpf)
        return False

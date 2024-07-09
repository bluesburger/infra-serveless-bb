# Provisionamento Amazon Cognito e Lambdas Triggers

Este repositório contém código Terraform para provisionar AWS Lambdas que funcionam como triggers personalizados para um pool de usuários no Amazon Cognito. As Lambdas são integradas ao fluxo de autenticação personalizado do Cognito.

## Pré-requisitos

Antes de começar, certifique-se de ter os seguintes requisitos configurados:

1. Conta AWS com permissões suficientes para provisionar recursos como Lambdas, Cognito, IAM, etc.
2. Terraform instalado localmente. Para instalar, consulte a [documentação oficial do Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).
3. Python 3.11 ou superior instalado para desenvolvimento das funções Lambda.

## Estrutura do Projeto

O projeto está estruturado da seguinte forma:


- `app`: Implementação da lógica dos requisitos.
  - `createauth`
    - `lambda_create_auth_challenge.py`: Lambda responsável por criar desafios de autenticação.
  - `defineauth`
    - `lambda_define_auth_challenge.py`: Lambda para definir desafios de autenticação personalizados.
  - `signupauth`
    - `lambda_auto_confirm_user.py`: Lambda para confirmar automaticamente o usuário após o registro.
  - `verifyauth`
    - `lambda_verify_auth_challenge.py`: Lambda para verificar desafios de autenticação.



- `infra`: Arquivos do Terraform para provisionar os recursos na AWS.
  - `main.tf`
  - `variables.tf`
  - `data.tf`
  - `cognito.tf`
  - `local.tf`
  - `lambda.tf`


## 3. Inicialize o Terraform
```sh
terraform init
```


### 4. Visualize o Plano de Execução

Visualize o plano de execução para verificar as alterações que o Terraform fará na sua infraestrutura:

```sh
terraform plan
```

### 5. Aplique a Configuração

Aplique a configuração para provisionar os recursos:


```sh
terraform apply
```
Digite yes quando solicitado para confirmar a execução.


# AWS Labs - Auditing Your Security with AWS Trusted Advisor

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=lilithmorgan_aws-terraform-trusted-advisor&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=lilithmorgan_aws-terraform-trusted-advisor)

Este projeto visa ajudar os iniciantes que estao fazendo o lab da AWS Auditing Your Security with AWS Trusted Advisor a entenderem como configurar usando Terraform. 

Dei uma explorada um pouco mais fiz as notificações serem enviadas por email utilizando Simple Notification Service (SNS) 

O projeto cria 1 instancia EC2 micro apenas para ser usado de exemplo e considera que voce tem um bucket s3 ativo para usar como tfstate

Para subir tudo voce precisara seguir alguns passos

Antes de qualquer coisa clone o projeto

`git clone git@github.com:lilithmorgan/aws-terraform-trusted-advisor.git`

`cd aws-terraform-trusted-advisor`

1 - Crie um bucket S3 e coloque o nome dele no arquivo main.tf no trecho mostrado abaixo, substitua `lilith-tfstate`` pelo nome do seu bucket

```
backend "s3" {
    bucket = "lilith-tfstate"              // Nome do bucket S3.
    key    = "aws-labs-FaC/lilith-tfstate" // Chave sob a qual o estado será armazenado.
    region = "us-east-1"                   // Região do bucket S3.
  }
```

No mesmo arquivo, no modulo trusted_advisor_notifications substitua o email de notificao pelo seu email

```
module "trusted_advisor_notifications" {
  source             = "./trusted_advisor_notifications"
  notification_email = "seuemail@seudominio.com.br"
}
```
2 - Crie o par de chaves SEM SENHA para a Key do EC2

`ssh-keygen -t rsa -f ./Keys/key`

3 - Inicie o terraform

`terraform init`

4 - Teste e aplique as configurações

```
terraform validate
terraform plan
terraform apply
```

Durante o Deploy você tera o output do ARN do Topico SNS, anote (copie e cole)

5 - Va para a pasta Scripts

`cd Scripts`

De permissao de execução no arquivo scan-aws.sh

`chmod +x scan-aws`

modifique o arquivo resource-analysis.py e substitua o arn do Topico SNS

```
def send_notification(message):
    sns = boto3.client('sns')
    sns.publish(
        TopicArn='Arn do TOPICO aqui',
        Message=message
    )
```

Pronto, agora você pode escanear periodicamente ou manualmente sua conta AWS com o comando

`./scan-aws.sh`

Alem de executar o código python em busca de problemas de processamento por exemplo, ele vai executar o trivy da aquasec em busca de falhas de segurança na sua conta aws.

Este é apenas um modelo com o objetivo de dar ideias do que é possível fazer com automações e Infra as Code, espero que gostem

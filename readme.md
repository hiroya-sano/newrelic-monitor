```bash
# setup_env-template.shをコピーしてsetup_env.shを作成する
# setup_env.shの変数に、Terraformコードを適用するNew RelicアカウントのUser Key（newrelic_api_key）とアカウントIDを設定する

source ./setup_env.sh
terraform init
terraform plan -var-file tfvars/terraform.tfvars
terraform apply -auto-approve -var-file tfvars/terraform.tfvars

terraform destroy -auto-approve -var-file tfvars/terraform.tfvars
```
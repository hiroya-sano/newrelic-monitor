```bash
# setup_env-template.shをコピーしてsetup_env.shを作成する
# setup_env.shの変数に、Terraformコードを適用するNew RelicアカウントのUser Key（newrelic_api_key）とアカウントIDを設定する

source ./setup_env.sh
ln -sf backend/local.config backend.tf
ln -sf backend/azure.config backend.tf # ULSの場合
terraform init -reconfigure

# 外形監視・アラートの作成
terraform plan -var-file tfvars/terraform.tfvars
terraform apply -auto-approve -var-file tfvars/terraform.tfvars

# 外形監視・アラートの削除
terraform destroy -auto-approve -var-file tfvars/terraform.tfvars
```
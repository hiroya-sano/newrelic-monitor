```bash
# setup_env-template.shをコピーしてsetup_env.shを作成する
# setup_env.shの変数に、Terraformコードを適用するNew RelicアカウントのUser Key（newrelic_api_key）とアカウントIDを設定する

source ./setup_env.sh
ln -sf backend/local.config backend.tf
ln -sf backend/azure.config backend.tf # ULSの場合
terraform init -reconfigure

# 外形監視・アラートの作成
terraform plan -var-file tfvars/common.tfvars -var-file tfvars/dev.tfvars
terraform apply -auto-approve -var-file tfvars/common.tfvars -var-file tfvars/dev.tfvars

# 外形監視・アラートの削除（開発環境向け）
terraform destroy -auto-approve -var-file tfvars/common.tfvars -var-file tfvars/dev.tfvars
```
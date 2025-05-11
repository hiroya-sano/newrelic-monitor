```bash
source ./setup_env.sh
terraform init
terraform plan -var-file tfvars/terraform.tfvars
terraform apply -auto-approve -var-file tfvars/terraform.tfvars

terraform destroy -auto-approve -var-file tfvars/terraform.tfvars
```
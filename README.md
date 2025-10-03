# **Terraform AWS Project 🚀**

This project provisions **AWS S3 buckets** and **EC2 instances** using Terraform in a **production-ready setup**:

* **Remote backend** with S3 \+ DynamoDB state locking

* **Reusable Terraform modules** (`s3`, `ec2`)

* **Workspaces** for dev, stage, prod

* **HashiCorp Vault** for secret management

* **GitHub-friendly repo** (no secrets checked in)

---

## **📂 Project Structure**

`terraform-aws-project/`  
`├── backend.tf          # Remote backend config (S3 + DynamoDB)`  
`├── main.tf             # Root module calling s3 & ec2`  
`├── providers.tf        # AWS & Vault providers`  
`├── variables.tf        # Input variables`  
`├── outputs.tf          # Root outputs`  
`├── modules/            # Reusable modules`  
`│   ├── ec2/`  
`│   │   ├── main.tf`  
`│   │   ├── variables.tf`  
`│   │   └── outputs.tf`  
`│   └── s3/`  
`│       ├── main.tf`  
`│       ├── variables.tf`  
`│       └── outputs.tf`  
`└── .gitignore          # Ignore secrets & tfstate files`

**Note**: The `envs/` folder is intentionally **not included**. You will create it locally with environment `.tfvars` files.

---

## **⚙️ Prerequisites**

* Terraform ≥ 1.5

* AWS CLI configured

* HashiCorp Vault running

* AWS IAM user/role with permissions:

  * `AmazonS3FullAccess`

  * `AmazonEC2FullAccess`

  * `AmazonDynamoDBFullAccess`

---

## **🚀 Setup & Deployment**

### **1️⃣ Clone the repository**

`git clone https://github.com/<your-username>/terraform-aws-project.git`  
`cd terraform-aws-project`

### **2️⃣ Create `envs/` folder with `.tfvars` files**

Create a folder:

`mkdir envs`

Inside it, add environment files:

**envs/dev.tfvars**

`aws_region    = "us-east-2"`  
`vault_addr    = "<vault-host>:8200"`  
`vault_token   = "VAULT_TOKEN"`  
`environment   = "dev"`  
`bucket_name   = "devaterraform-dev-bucket-12345"`  
`ami_id        = "ami-0cfde0ea8edd312d4"`  
`instance_type = "t3.micro"`

**envs/stage.tfvars**

`aws_region    = "us-east-2"`  
`vault_addr    = "<vault-host>:8200"`  
`vault_token   = "VAULT_TOKEN"`  
`environment   = "dev"`  
`bucket_name   = "devaterraform-dev-bucket-12345"`  
`ami_id        = "ami-0cfde0ea8edd312d4"`  
`instance_type = "t3.micro"`

**envs/prod.tfvars**

`aws_region    = "us-east-2"`  
`vault_addr    = "<vault-host>:8200"`  
`vault_token   = "VAULT_TOKEN"`  
`environment   = "dev"`  
`bucket_name   = "devaterraform-dev-bucket-12345"`  
`ami_id        = "ami-0cfde0ea8edd312d4"`  
`instance_type = "t3.micro"`

---

### **3️⃣ Initialize Terraform with remote backend**

`terraform init`

### **4️⃣ Create workspaces for environments**

`terraform workspace new dev`  
`terraform workspace new stage`  
`terraform workspace new prod`

### **5️⃣ Select a workspace**

`terraform workspace select dev`

### **6️⃣ Apply infrastructure**

`export VAULT_TOKEN="s.xxxxxx"   # from Vault`  
`terraform apply -var-file=envs/dev.tfvars`

### **7️⃣ Destroy infrastructure**

`terraform destroy -var-file=envs/dev.tfvars`

---

## **📤 Outputs**

When applied, Terraform will output:

* **S3 Bucket Name**

* **EC2 Instance ID**

* **EC2 Public IP**

---

## **🛠 Challenges & Solutions (Interview Highlights)**

| Challenge | Solution |
| ----- | ----- |
| GitHub rejected pushes due to Vault token in `.tfvars` | Cleaned repo, re-initialized Git, added `.gitignore`, excluded `.tfvars` |
| Terraform module errors (missing vars/outputs) | Fixed with proper `variables.tf` and `outputs.tf` in modules |
| Backend locking issues | Added DynamoDB table for state locking |
| Multiple environments | Used **workspaces** and per-environment `.tfvars` files |

---

## **📚 References**

* Terraform AWS Provider  
  [https://registry.terraform.io/providers/hashicorp/aws/latest/docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

* Terraform Workspaces  
  [https://developer.hashicorp.com/terraform/language/state/workspaces](https://developer.hashicorp.com/terraform/language/state/workspaces)  
* HashiCorp Vault  
  [https://developer.hashicorp.com/vault/docs](https://developer.hashicorp.com/vault/docs)

* Terraform Backends  
  [https://developer.hashicorp.com/terraform/language/settings/backends/s3](https://developer.hashicorp.com/terraform/language/settings/backends/s3)


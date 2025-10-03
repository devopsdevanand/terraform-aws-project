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

## **📂 Remote Backend State Layout**

Terraform uses an **S3 bucket \+ DynamoDB** for state management.  
 Workspaces (`dev`, `stage`, `prod`) create isolated state files inside the bucket:

`deva-terraform-remote-s3/`  
`├── env:/dev/global/s3-ec2/terraform.tfstate`  
`├── env:/stage/global/s3-ec2/terraform.tfstate`  
`└── env:/prod/global/s3-ec2/terraform.tfstate`

### **🔑 Why this is production-friendly**

* Each environment has a **separate state file** → no conflicts.

* State is stored **remotely in S3** → accessible to the whole team.

* **DynamoDB locking** prevents simultaneous changes.

* Encrypted (SSE) in S3 for security.

## **Create DynamoDB Table for Locking**

You can create it via **AWS CLI** or Terraform.

### **Option A: Using AWS CLI**

`aws dynamodb create-table \`

    `--table-name terraform-locks \`

    `--attribute-definitions AttributeName=LockID,AttributeType=S \`

    `--key-schema AttributeName=LockID,KeyType=HASH \`

    `--provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \`

    `--region us-east-1`

**Explanation:**

* `LockID` → Primary key for DynamoDB table.  
* Used by Terraform to acquire locks during `apply` to prevent concurrent changes.

---

### **Option B: Using Terraform**

Create a file called `dynamodb.tf`:

`resource "aws_dynamodb_table" "terraform_locks" {`

  `name         = "terraform-locks"`

  `billing_mode = "PAY_PER_REQUEST"`

  `hash_key     = "LockID"`

  `attribute {`

    `name = "LockID"`

    `type = "S"`

  `}`

  `tags = {`

    `Name = "Terraform Locks"`

  `}`

`}`

Then run:

`terraform init`

`terraform apply`

This will create the DynamoDB table automatically.

---

## **Step 2: Configure Backend with S3 \+ DynamoDB**

Create or update `backend.tf`:

`terraform {`

  `backend "s3" {`

    `bucket         = "<YOUR_S3_BUCKET_NAME>"`

    `key            = "terraform.tfstate"   # path inside the bucket`

    `region         = "us-east-1"`

    `dynamodb_table = "terraform-locks"    # DynamoDB table for state locking`

    `encrypt        = true                  # encrypt state at rest`

  `}`

`}`

**Replace** `<YOUR_S3_BUCKET_NAME>` with your existing S3 bucket name.

---

✅ **Important Notes**

* Always use **S3 \+ DynamoDB** in production for safe **remote state \+ locking**.

* Use **versioning** on the S3 bucket to avoid accidental state loss.

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


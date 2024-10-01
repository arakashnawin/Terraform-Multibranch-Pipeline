# Infrastructure as Code (IaC) Pipeline with Terraform, Checkov, and Jenkins

This project uses Jenkins, Terraform, Ansible, and Checkov to manage and verify infrastructure as code (IaC). The pipeline automates the deployment of AWS resources with Terraform and scans for potential misconfigurations using Checkov.

## Components

### 1. **Install_Checkov.yml (Ansible Playbook)**

The Ansible playbook installs the necessary dependencies, including Python, PIP, and Checkov, on a target server.

### 2. **Jenkinsfile**

Defines the pipeline stages for running Terraform commands and applying infrastructure changes.

### 3. **Jenkinsfile.Checkov**

A pipeline that runs Terraform commands, creates a plan, and performs security and compliance scans on the infrastructure plan using Checkov.

### 4. **Terraform Files**

- `gitops/demoinfra.tf`: Defines an AWS EC2 instance resource.
- `gitops/variables.tf`: Specifies the AMI ID as a variable for the EC2 instance.

---

## Ansible Playbook: `Install_Checkov.yml`

This playbook installs Python, PIP, and Checkov on the target server.

### Tasks:

1. **Update apt packages**: Ensures all apt packages are up-to-date.
2. **Add Python PPA**: Adds a repository for stable Python versions.
3. **Install required packages**: Installs necessary packages including Python 3.7, software-properties-common, and pip.
4. **Install Checkov**: Installs Checkov using pip.

### Usage:

```bash
ansible-playbook -i <inventory-file> Install_Checkov.yml -e server=<target-server>
```

---

## Jenkins Pipelines

### 1. **Jenkinsfile**

This pipeline runs Terraform commands to deploy the infrastructure and requires manual approval before applying changes to the main branch.

#### Stages:

- **Terraform Init**: Initializes Terraform in the `./gitops` directory.
- **Terraform Plan**: Generates an execution plan for Terraform.
- **Approval**: Waits for manual approval before applying changes to the main branch.
- **Terraform Apply**: Applies the Terraform plan and deploys the infrastructure.

### 2. **Jenkinsfile.Checkov**

This pipeline extends the functionality of `Jenkinsfile` by adding a Checkov security scan.

#### Stages:

- **Terraform Init**: Initializes Terraform in the `./gitops` directory.
- **Terraform Plan**: Generates a plan and exports it in JSON format.
- **Checkov Scan**: Scans the Terraform plan for security and compliance issues.
- **Approval**: Waits for manual approval before applying changes to the main branch.
- **Terraform Apply**: Applies the Terraform plan and deploys the infrastructure.

---

## Terraform Files

### 1. `gitops/demoinfra.tf`

Defines the AWS provider and provisions an EC2 instance in the `ap-south-1` region using the specified AMI ID.

```hcl
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "example" {
  ami           = var.amiid
  instance_type = "t2.micro"
}
```

### 2. `gitops/variables.tf`

Declares a variable `amiid` with a default value, which can be overridden when running Terraform.

```hcl
variable "amiid" {
  default = "ami-062df10d14676e201"
}
```

---

## Usage

### 1. **Ansible Playbook:**

- Run the `Install_Checkov.yml` playbook to install necessary dependencies on the target server.

### 2. **Jenkins Pipelines:**

- **Jenkinsfile**: Deploys infrastructure via Terraform.
- **Jenkinsfile.Checkov**: Runs a security scan with Checkov before deploying infrastructure.

### 3. **Terraform:**

- Initialize Terraform:

  ```bash
  terraform init
  ```

- Generate an execution plan:

  ```bash
  terraform plan
  ```

- Apply the plan:

  ```bash
  terraform apply -auto-approve
  ```

- **Checkov**: Scan the Terraform plan for security issues.

  ```bash
  checkov -f testplan.json
  ```

---

## Prerequisites

- **Jenkins**: Set up with credentials for AWS (`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`).
- **AWS CLI**: Ensure the necessary IAM permissions for provisioning AWS resources.
- **Ansible**: Installed on the control machine to execute the playbook.
- **Terraform**: Installed on the Jenkins server or build agent.

---

## License

This project is licensed under the MIT License.


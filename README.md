# Terraform 30 Days Challenge - Day 1

A hands-on introduction to Infrastructure as Code (IaC) using Terraform and Amazon Web Services (AWS). This repository demonstrates foundational Terraform concepts by provisioning a fully functional web server environment on AWS.

## 📋 Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Usage](#usage)
- [Architecture](#architecture)
- [Outputs](#outputs)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Overview

This project is part of a 30-day Terraform learning challenge. It covers the core concepts of Terraform by creating a real-world AWS infrastructure that includes:

- **Virtual Private Cloud (VPC)**: Leverages the default AWS VPC for simplicity
- **Subnets**: Creates a custom subnet within the default VPC
- **Security Groups**: Defines inbound/outbound rules for web access
- **EC2 Instance**: Launches a t2.micro instance running Apache HTTP Server

The infrastructure automatically configures and starts a web server on the EC2 instance, demonstrating infrastructure automation through user data scripts.

## Project Structure

```
.
├── main.tf                  # Primary Terraform configuration
├── Day3/
│   └── main.tf             # Day 3 continuation with additional resources
├── terraform.tfstate       # Terraform state file (do not commit to version control)
├── .terraform.lock.hcl     # Dependency lock file for reproducibility
├── .gitignore              # Git ignore rules for Terraform artifacts
└── README.md              # This file
```

## Prerequisites

Before you begin, ensure you have the following installed and configured:

### Software Requirements

- **Terraform**: Version >= 1.0.0
  - [Install Terraform](https://www.terraform.io/downloads.html)
  
- **AWS CLI**: For credential configuration
  - [Install AWS CLI](https://aws.amazon.com/cli/)

### AWS Requirements

- An active AWS account with appropriate permissions
- AWS credentials configured locally (Access Key ID and Secret Access Key)
- An EC2 key pair created in the `us-east-1` region named `terraform-key`
  - [Create a key pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)

### AWS IAM Permissions

Your AWS user or role should have permissions for:
- EC2 instance management
- VPC and subnet operations
- Security group management

## Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd "Terraform 30Days Challenge/Day 1"
```

### 2. Initialize Terraform

Initialize the Terraform working directory. This downloads the required provider plugins and prepares the environment.

```bash
terraform init
```

**Expected Output:**
```
Terraform has been successfully configured!
```

### 3. Create an EC2 Key Pair (if not already created)

```bash
aws ec2 create-key-pair \
  --key-name terraform-key \
  --region us-east-1 \
  --query 'KeyMaterial' \
  --output text > terraform-key.pem

chmod 400 terraform-key.pem
```

### 4. Configure AWS Credentials

Ensure your AWS credentials are configured:

```bash
aws configure
```

Or set environment variables:

```bash
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
export AWS_DEFAULT_REGION="us-east-1"
```

## Usage

### Validate Configuration

Before applying changes, validate the Terraform configuration:

```bash
terraform validate
```

### Plan Infrastructure

Review the resources that will be created:

```bash
terraform plan
```

This command shows all resources that will be provisioned without making any changes.

### Apply Configuration

Apply the Terraform configuration to create the infrastructure:

```bash
terraform apply
```

You'll be prompted to confirm the changes. Type `yes` to proceed.

**Expected Output:**
```
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

public_ip = "54.xxx.xxx.xxx"
```

### Access the Web Server

Once the infrastructure is deployed, access the web server using the public IP address from the outputs:

```bash
curl http://<public_ip>
# or open in a browser: http://<public_ip>
```

**Expected Output:**
```html
<h1>Hello from Wisdom!</h1>
```

### View Outputs

Display the outputs without re-applying:

```bash
terraform output
```

Or to get a specific output:

```bash
terraform output public_ip
```

### Destroy Infrastructure

When you're done, clean up all AWS resources to avoid unnecessary charges:

```bash
terraform destroy
```

Type `yes` to confirm the deletion.

## Architecture

### AWS Resources Created

1. **AWS Subnet** (`aws_subnet.default_subnet_custom`)
   - Created within the default VPC
   - Auto-assigns public IPs to instances
   - Uses a /25 subnet from the default VPC's CIDR block

2. **Security Group** (`aws_security_group.web_sg`)
   - Allows inbound HTTP (port 80) from anywhere
   - Allows inbound SSH (port 22) for management
   - Allows all outbound traffic

3. **EC2 Instance** (`aws_instance.web_server`)
   - Instance type: t2.micro (eligible for free tier)
   - AMI: Amazon Linux 2
   - Automatically installs and starts Apache HTTP Server via user data

### Data Sources Used

- `data.aws_vpc.default`: References the default VPC in your AWS account
- `data.aws_availability_zones.available`: Dynamically retrieves available AZs in the region

## Outputs

The configuration produces the following outputs:

### `public_ip`
The public IP address of the EC2 instance. Use this to access the web server.

```bash
terraform output public_ip
```

## Troubleshooting

### Issue: "Conflict with a conflicting resource"

**Cause**: Another security group or subnet with the same name might exist in your VPC.

**Solution**: Modify the resource names in `main.tf` or destroy existing resources:
```bash
terraform destroy
```

### Issue: "InvalidKeyPair.NotFound" Error

**Cause**: The `terraform-key` EC2 key pair doesn't exist in the specified region.

**Solution**: Create the key pair as described in the [Setup](#setup) section.

### Issue: Instance is running but web server is not responding

**Cause**: The user data script may still be executing.

**Solution**: Wait 1-2 minutes for the instance to finish initialization. Check EC2 console for detailed logs.

### Issue: "AccessDenied" when running Terraform commands

**Cause**: AWS credentials are misconfigured or lack required permissions.

**Solution**: 
- Verify credentials: `aws sts get-caller-identity`
- Check IAM permissions for EC2, VPC operations
- Reconfigure: `aws configure`

## Contributing

Contributions are welcome! To contribute to this project:

1. **Fork the Repository**
   ```bash
   git clone <your-fork-url>
   cd "Terraform 30Days Challenge/Day 1"
   ```

2. **Create a Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Your Changes**
   - Follow Terraform best practices
   - Use meaningful variable names and comments
   - Test thoroughly with `terraform plan` and `terraform apply` on a test environment

4. **Validate Your Changes**
   ```bash
   terraform fmt              # Format code
   terraform validate         # Validate syntax
   terraform plan             # Review changes
   ```

5. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "feat: add meaningful description of changes"
   ```

6. **Push to Your Branch**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Open a Pull Request**
   - Describe the changes and their purpose
   - Reference any related issues
   - Wait for review and feedback

### Code Style Guidelines

- Use consistent indentation (2 spaces for Terraform)
- Add descriptive comments for complex logic
- Use meaningful resource and variable names
- Follow the [Terraform Style Conventions](https://developer.hashicorp.com/terraform/language/style)

### Reporting Issues

Found a bug or have a suggestion? Open an issue with:
- Clear description of the problem
- Steps to reproduce (if applicable)
- Expected vs. actual behavior
- Your environment details (OS, Terraform version, AWS region)

## Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs/)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform AWS Best Practices](https://docs.aws.amazon.com/whitepapers/latest/terraform-on-aws/introduction.html)
- [30 Days of Terraform Challenge](https://www.terraform.io/tutorials)

## License

This project is licensed under the MIT License. See the LICENSE file for details.

---

**Note**: This repository is part of a learning challenge. Ensure you destroy infrastructure when not in use to minimize AWS costs, especially for production-like resources.

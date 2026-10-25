# Secure 2-VM Network (AWS Terraform alternative)

This project reproduces the assignment's security design in AWS because Azure subscription access was unavailable and the team lead approved AWS as an alternative. Record this platform substitution honestly in the walkthrough.

## Project Status

**Status:** Completed and tested.

- Provisioned the AWS network and two virtual machines using Terraform.
- Verified RDP access to the Windows jump host.
- Verified SSH access from Windows to the private Linux host.
- Confirmed that direct access to the private host from the laptop was blocked.
- Ran `terraform destroy` and verified that the project resources were terminated or deleted.

**Platform note:** This project implements the assignment's network security design in AWS because Azure subscription access was unavailable. The AWS substitution was approved by the team lead.

## Evidence

Screenshots documenting infrastructure provisioning, security group rules, connectivity tests, and cleanup are available in the [`screenshots/`](screenshots/) directory.

## Design

- One dedicated VPC: `10.20.0.0/16`
- Public subnet: `10.20.1.0/24`, internet gateway route
- Private subnet: `10.20.2.0/24`, no internet/NAT route
- Windows Server 2022 jump host has a public IPv4 address; inbound RDP (TCP 3389) is restricted to your current public IPv4 `/32`.
- Amazon Linux 2023 private host has no public IPv4 address; inbound SSH (TCP 22) is allowed only from the Windows security group.
- Encrypted gp3 root volumes and IMDSv2 required on both instances.

The private host can be reached over the VPC's local route from the Windows jump host. It has no direct public route or public IP. The private host's outbound security group is limited to VPC CIDR, and its subnet route table has no internet gateway or NAT route.

## Prerequisites

- AWS CLI and Terraform installed.
- AWS credentials/profile with permissions to create VPC, EC2, networking, security groups, and related resources.
- Existing EC2 key pair named `secure-2vm-lab-key`.
- Ensure the AWS account and region are the intended ones before applying.

## Deploy

In PowerShell from this folder:

```powershell
$env:AWS_PROFILE = "cloud-lab"
$env:AWS_PAGER = ""
aws sts get-caller-identity --profile cloud-lab
(Invoke-RestMethod -Uri "https://checkip.amazonaws.com").Trim()
Copy-Item .\terraform.tfvars.example .\terraform.tfvars
notepad .\terraform.tfvars
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply
```

Replace the placeholder in `terraform.tfvars` with your current public IPv4 followed by `/32`, e.g. `203.0.113.10/32`. Do not use the example address. If your public IP changes, update this value and apply again.

Review the plan carefully. It creates billable resources. Do not apply until the `admin_cidr` value is correct.

## Verify

Save screenshots of:
1. AWS caller identity/account and region (redact account identifiers if sharing publicly).
2. VPC, public/private subnets, route tables, and internet gateway.
3. Windows security group inbound rule showing TCP 3389 from your `/32` only.
4. Linux security group inbound rule showing TCP 22 sourced from the Windows security group, not `0.0.0.0/0`.
5. EC2 instance details showing Windows has a public IP and Linux has no public IP.
6. Successful RDP from your laptop to Windows.
7. Successful SSH from Windows to Linux using the Linux private IP.
8. Failed direct laptop-to-Linux connection (there is no public IP).
9. `terraform destroy` confirmation and AWS console showing the project resources are gone.

Never include private key contents, passwords, access keys, or other credentials in screenshots or GitHub.

## Connect

- RDP: use the Windows public IP and retrieve the Windows Administrator password in EC2 using the matching `.pem` key. Restrict inbound RDP to your `/32`.
- SSH: from the Windows host, connect to the Linux private IP. For a real deployment, prefer AWS Systems Manager Session Manager or a carefully managed SSH agent/forwarding approach rather than copying a private key to a jump host. If temporarily transferring a key for this lab, use a secure method, restrict access, remove it after testing, and never commit it to source control.

## Destroy and clean up

After capturing evidence and verifying the walkthrough:

```powershell
terraform destroy
```

Confirm the plan before typing `yes`. Verify in the AWS console that the VPC, subnets, route tables, internet gateway, security groups, and EC2 instances were deleted. The EC2 key pair was created separately and is not managed by this Terraform configuration; delete it only after the lab is finished and you no longer need it:

```powershell
aws ec2 delete-key-pair --key-name secure-2vm-lab-key --profile cloud-lab --region ap-south-1
```

Check EC2, VPC, Elastic IP, and billing/cost tools for any leftover resources. Keep evidence of successful teardown. Stop or destroy billable resources promptly after the demo.

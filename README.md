# Terraform managed Atlassian stack in AWS

Contents
--------
  - [Notes](#Notes)
  - [Features](#Features)
  - [Requirements](#Requirements)
  - [Defaults](#Defaults)
  - [Terraform Inputs](#Terraform-Inputs)
  - [Terraform Outputs](#Terraform-Outputs)

## Notes
This template is built to run Atlassian products behind a reverse proxy. Make sure you run all instances in a private network pointing to NAT Gateway/Instance for internet access.

## Features
The template instantiates single node for each of the applications, as well as an RDS DB. All applications use this RDS instance as a data store. 
You are free to tweak modules listed in *main.tf*, e.g remove or add any that might not be needed.

Each application instance runs in isolated Auto-Scaling group for scheduling and "self-healing" purposes. "Self-healing" is achieved by re-attaching Elastic network interface and Block store from failed to freshly spun up instance. Launch configuration, in addition to initial node setup, also has an embedded Ansible playbook for application installation, that is bootstrapped via cloud-init script. 

## Requirements
- Non-default VPC with at least 2 private subnets
- SSH key(s) uploaded to AWS
- Reverse proxy configured in a public subnet
- Set of registered domain names for each of the applications

## Defaults

- Default region: **eu-central-1** _(Frankfurt, Germany)_
- Default server type: **t2.medium** _(2x vCPU, 4.0GB memory)_
- Default OS: **Amazon Linux 2**
- Default DB node: **db.t2.micro** _(1x vCPU, 1.0GB memory)_
- Default DB engine: **PostgreSQL**

## Terraform Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_region | AWS region to use | string | eu-central-1 | yes |
| profile | AWS profile used for deployment | string | default | no |
| key_name | Name of the public key to install on EC2 instances | string | | yes |
| vpc_id | VPC ID to launch instances in | string |  | yes |
| private_app_subnets | Private subnet ID(s) for application deployments | list |  | yes |
| private_db_subnets | Private subnet IDs for DB instance. At least 2 is required to make DB subnet group | list |  | yes |
| bitbucket_instance_type | EC2 instance type | string | t2.medium | yes |
| bitbucket_volume_size | Attached EBS volume size | number | 10 | yes |
| bitbucket_url | URL that will be passed down to conifgure Tomcat | string |  | yes |
| jira_instance_type | EC2 instance type | string | t2.small | yes |
| jira_volume_size | Attached EBS volume size | number | 10 | yes |
| jira_url | URL that will be passed down to conifgure Tomcat | string |  | yes |
| confluence_instance_type | EC2 instance type | string | t2.medium | yes |
| confluence_volume_size | Attached EBS volume size | number | 10 | yes |
| confluence_url | URL that will be passed down to conifgure Tomcat | string |  | yes |
| db_instance_class | RDS instance type | string | db.t2.micro | yes |
| db_engine | DB engine to use | string | postgres | yes |
| db_allocated_storage | Amount of storage to allocate | number | 10 | yes |
| db_username | DB username | string |  | yes |
| db_password | DB password | string |  | yes |

## Terraform Outputs

| Name | Description |
|------|-------------|
| db_endpoint | Database endpoint |
| bitbucket_endpoint | Bitbucket static endpoint |
| jira_endpoint | Jira static endpoint |
| confluence_endpoint | Confluence static endpoint |
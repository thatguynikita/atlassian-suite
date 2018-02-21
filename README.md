This template is built to run Atlassian products behind a reverse proxy. Make sure you run all instances in a private network pointing to NAT Gateway/Instance for internet access.

The template instantiates single server for each of the applications, as well as an RDS DB server. All applications use this RDS instance as a data store. 
You are free to tweak modules listed in *main.tf*, e.g remove or add any that might not be needed.

Each application instance runs in isolated Auto-Scaling group for scheduling and "self-healing" purposes. "Self-healing" is achieved by re-attaching Elastic network interface and Block store from failed to freshly spun up instance. Launch configuration, in addition to initial server setup, also has an embedded Ansible playbook for application installation, that is bootstrapped via cloud-init script. 



####Prerequisites:
- Non-default VPC with at least 2 private subnets
- SSH key(s) uploaded to AWS
- Reverse proxy server configured in a public subnet
- Set of registered domain names for each of the applications

  



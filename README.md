# Radioactive-Cloud-Terraform-Example
Example of terraform files to create Cloudstack VM. 
This terraform file provides VM on Radioactive Cloudstack with the following parameters:
- random name
- 4cpu x 1.00 GHz 
- 8096 memory
- Network with real IP 
- Firewall and port forwarding to ports 80 and 22.
The only thing you should put so the terraform script can provide you this machine is Cloudstack User API Key and Secret Key in the variables.tf file. Thereafter you can execute the following commands:
Run terraform plan 
Run terraform apply

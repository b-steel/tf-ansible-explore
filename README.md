Exploration of using Terraform and Ansible to scaffold AWS resources.

# Terraform

Use a single terraform module to set up a public and private subnet in an aws VPC. Provide internet access to both subnets through a NAT and internet gateway. Architecture taken from [this](https://www.youtube.com/watch?v=2doSoMN2xvI) video on aws architecture.

# Ansible

Take the IP output from the terraform module and plug it into the `ansible/hosts` file, run `ansible-playbook provision-frontend.yaml` to install docker and run the example react app in a docker container.
Many of the ansible details are taken from [this](https://dev.to/mariehposa/how-to-deploy-an-application-to-aws-ec2-instance-using-terraform-and-ansible-3e78) resource.

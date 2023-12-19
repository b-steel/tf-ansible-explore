Exploration of using Terraform and Ansible to scaffold AWS resources.

# Terraform

Use a single terraform module to set up a public and private subnet in an aws VPC. Provide internet access to both subnets through a NAT and internet gateway. Architecture taken from [this](https://www.youtube.com/watch?v=2doSoMN2xvI) video on aws architecture but then translated into a terraform module

# Ansible

Teh terraform output is written to a variables files so the hosts are populated automatically when `ansible-playbook provision-frontend.yaml` is run. This playbook installs docker and runs the example react app in a docker container.
Many of the ansible details are taken from [this](https://dev.to/mariehposa/how-to-deploy-an-application-to-aws-ec2-instance-using-terraform-and-ansible-3e78) resource.

# Steps

1. Install ansible and terraform, etc
2. Run `docker build -t remix-demo ./remix-app` to build the docker container. Tag with `docker tag remix-demo <hub-username>/remix-demo:latest`, then push with `docker push <hub-username>/remix-demo:latest` to push to docker hub
3. Set up aws key pair and put the file in `~/.ssh/aws-admin.pem`, or name it something different and change your `ansible.cfg`.
4. `cd terraform/vpc`, `terraform init` and then `terrraform apply`
5. cd over to ansible directory and run `ansible-playbook provision-frontent.yaml`
6. Open up a browser and visit `http://<public ip of frontend>:3000` ot view the app. The public ip will have been written to the `ansible/tf_ansible_vars_file.yml` file

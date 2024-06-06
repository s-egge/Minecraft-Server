# Minecraft-Server

The final project for CS312 - System Administration. A pipeline that will deploy an EC2 instance, then install and run a Minecraft server that auto-starts on instance start up. I ran this in AlmaLinux using VirtualBox, so if you're using a different OS/environment some commands will be different and you may run in to permission issues. Terraform is used to make the EC2 instance on AWS, and Ansible is used to SSH into the instance and set up the Minecraft server.

## Overview

- Clone repo
- Install tooling
- Set up authorization credentials
- Run Terraform commands to instantiate the EC2 instance
- Run Ansible commands to SSH into the server and set up the Minecraft server

## Prerequisites

The following tools need to be installed if they aren't already:

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) v2.13.32
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) v1.8.4
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) v2.10.8

If you haven't already, configure your AWS credentials. You can run `configure aws` or put them manually in the `~/.aws/credentials`. [See here](https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-files.html) for more detailed instructions. Make sure to put your default region as `us-west-2`, unless you would like to use a different region then make sure to change the region in the `terraform` files as well.

## Steps

- Clone the repo
- Navigate to the repo root directory `Minecraft-Server`
- Create your public/private key pair and put them in the correct directories:

  - Create your public/private key pair. Enter a passphrase if desired, otherwise hit `enter` twice to have no passphrase
    - `ssh-keygen -t rsa -b 2048 -m PEM -f minecraft_server_key`
  - Move the public key into the terraform folder so that it can be uploaded to AWS and used with the instance
    - `mv minecraft_server_key.pub terraform/minecraft_server_key.pub`
  - Move the private key to the ansible folder so that it can be used to SSH into the instance. I am also giving it the `.pem` extension because it wouldn't work for me without that
    - `mv minecraft_server_key ansible/minecraft_server_key.pem`

- Navigate to the terraform directory and run commands to set up the EC2 instance on AWS
  - `cd terraform`
  - `terraform init`
  - `terraform apply -auto-approve`
    
- Navigate back to the root

  - `cd ..`

- Fill in the host file with the proper credentials, replace YOUR_EC2_IP_ADDRESS with the public IP address that was output in the previous step

  - `echo "YOUR_EC2_IP_ADDRESS ansible_user=ec2-user ansible_ssh_private_key_file=minecraft_server_key.pem" >> ansible/hosts`

- Run the ansible file to download and set up the Minecraft server. You should wait a minute or two before running the `ansible-playbook` command to give the instance time to finish setting up. If you run the command and it says that it can't connect to host, wait a bit and run it again.

  - `cd ansible`
  - `ansible-playbook -i hosts server-setup.yml`
  - type `yes` when prompted
  - If you get permissions denied, change the key permissions and run the previous command again:
    - `chmod 600 minecraft_server_key.pem`

- Log on to the Minecraft server using the public IP address from earlier. This may also take a minute or two for the connection to start working.

## Citations

- CS312 - System Administration Lab tutorials for Terraform and Ansible
- [Terraform Documentation](https://developer.hashicorp.com/terraform)
- [Ansible Documentation](https://docs.ansible.com/ansible/latest/dev_guide/overview_architecture.html)
- I used two different tutorials for making a Minecraft server on an EC2 instance as a reference, while adapting them to be automated with Terraform and Ansible:
  - https://aws.amazon.com/blogs/gametech/setting-up-a-minecraft-java-server-on-amazon-ec2/
  - https://medium.com/@cedric.lemercierlaos/start-your-minecraft-server-on-amazon-web-services-aws-d35f846a2d7c
- StackOverflow and ChatGPT for debugging errors in my Ansible code, mostly to do with user creation and file permissions

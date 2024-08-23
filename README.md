# AWS Minecraft Server

This project uses Terraform and Ansible to allocate and then initialize a 1.21 Java Minecraft server on an AWS EC2 instance.

## Prerequisites

Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html), the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

[Create an AWS account](https://aws.amazon.com/resources/create-account/) if you haven't one already, and [create an access key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey) for a user that has permissions to manage EC2 resources.

## Terraform Resource Allocation

Navigate to this project directory and run `terraform init`. If you want to a custom AWS secret key that isn't defined in your AWS CLI credentials, you can set the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables for Terraform to use.

Optionally, you can set the `SSH_PUBLIC_KEY` and `INSTANCE_TYPE` Terraform variables by setting the `TF_VAR_SSH_PUBLIC_KEY` and `TF_VAR_INSTANCE_TYPE` environment variables respectively. Otherwise, you'll be prompted to provide them when running the `terraform apply` command later.

After setting the `SSH_PUBLIC_KEY` and `INSTANCE_TYPE` variables, you can run `terraform apply` to allocate the Minecraft server on AWS.

### Variables

Name                    | In          | Purpose
------------------------|-------------|-----------------------------------------
`AWS_ACCESS_KEY_ID`     | `env`       | ID of your custom AWS access key
`AWS_SECRET_ACCESS_KEY` | `env`       | ID of your custom AWS access key secret
`SSH_PUBLIC_KEY`        | `terraform` | Path to the SSH public key you would like to add to the Minecraft server EC2 instance's `authorized_keys` file for SSH key logins
`INSTANCE_TYPE`         | `terraform` | EC2 instance type to host the Minecraft server on
`TF_VAR_SSH_PUBLIC_KEY` | `env`       | Used to set the `SSH_PUBLIC_KEY` Terraform variable
`TF_VAR_INSTANCE_TYPE`  | `env`       | Used to set the `INSTANCE_TYPE` Terraform variable

## Ansible Server Initialization

Navigate to this project directory and run

```sh
ansible-playbooks minecraft --vars-prompt
```

or

```sh
ansible-playbooks minecraft.yml --extra-vars \
    "server_host=<server-host-here> \
     server_user=<server-user-here> \
     server_ssh_key=<server-ssh-key-here>"
```

Alternatively, you can set the `SERVER_HOST`, `SERVER_USER`, and `SERVER_SSH_KEY` environment variables before simply running

```sh
ansible-playbooks minecraft.yml
```

After this, your Minecraft server should be ready for you to enjoy.

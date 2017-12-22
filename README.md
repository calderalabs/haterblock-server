# Terraform Server Template

A very minimal template for Terraform + Ansible + Dokku

## How to Bootstrap

- Clone the repo with `git clone git@github.com:calderalabs/terraform-server-template.git`
- Rename `.env-example` to `.env` and fill in empty variables
- Run `brew install ansible`
- Run `./bin/terraform/init`
- Run `./bin/packer`
- Run `./bin/create-env production`
- Run `./bin/deploy production`

# cuvalleyhack2022
https://cuvalley.com/#zadania



### Terraform

## Install
Run the following commands to install Terraform:
```sh
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```
Verify installation:
```sh
terraform -help
```
## Run
```sh
terraform init
terraform apply
```
# cuvalleyhack2022
https://cuvalley.com/#zadania


### Docker
To build and push the image to the ECR repository use the following command:
```sh
./build_and_push.sh cuvalley-backend latest
```

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

# cuvalleyhack2022
The task for the hackathon (zadanie 3) was concerned with creating a solution for the *"STWORZENIE SYSTEMU AUTOMATYCZNEJ ESTYMACJI POZIOMU WODY W RZECE" ("Creating a system for automatic water level estimation in rivers")*. The solution was developed by a team of Sekcja Sztucznej Inteligencji members, which were: Krzysztof Kwaśniak, Kacper Włodarczyk. 

The official event webpage: https://cuvalley.com/#zadania


### Docker
To build and push the image to the ECR repository use the following command:
```sh
./build_and_push.sh cuvalley-backend latest
```

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

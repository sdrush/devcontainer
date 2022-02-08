# devcontainer

### Personal Development Container

This is my personal development container.  This builds on my Macbook in minikube and on my Windows 
Desktop with Rancher Desktop.  I primarily use it in vscode for Cloud Devops-y things.  I have also 
tested this in Google Cloud Build and it works fine as long as you increse the default build timeout 
to 15 minutes (10 minutes is the default.)

This devcontainer has the following installed:
* zsh/ohmyzsh
* GCloud SDK
* GitHub CLI
* Kubectl/Helm
* Terraform/Terragrunt/TFLint
* OpenSSH Client and Server
* Manpages
* curl/wget and other misc utils
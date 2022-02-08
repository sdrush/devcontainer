# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.202.3/containers/debian/.devcontainer/base.Dockerfile

# [Choice] Debian version (use bullseye or stretch on local arm64/Apple Silicon): bullseye, buster, stretch
ARG VARIANT="bullseye"
# FROM mcr.microsoft.com/vscode/devcontainers/python:3.9-bullseye
FROM debian:bullseye-slim

# Set up all our install options
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="true"
ARG INSTALL_OHMYZSH="true"
ARG INSTALL_NONFREE_PACKAGES="true"

ARG GITHUB_CLI_VERSION="latest"

ARG KUBECTL_VERSION="latest"
ARG HELM_VERSION="latest"
ARG MINIKUBE_VERSION="none"
ARG KUBECTL_SHA256="automatic"
ARG HELM_SHA256="automatic"
ARG MINIKUBE_SHA256="automatic"

ARG SSHD_PORT="2222"
ARG SSHD_USERNAME="automatic"
ARG START_SSHD="false"
ARG SSHD_NEW_PASSWORD="skip"
ARG SSHD_FIX_ENVIRONMENT="true"

ARG TERRAFORM_VERSION="latest"
ARG TFLINT_VERSION="latest"
ARG TERRAGRUNT_VERSION="latest"
ARG TERRAFORM_SHA256="automatic"
ARG TFLINT_SHA256="automatic"
ARG TERRAGRUNT_SHA256="automatic"

# This is the list of Runtime Packages
ARG RUNTIME_PACKAGES="software-properties-common \
    lsb-release \
    curl \
    iputils-ping \
    dnsutils \
    manpages-dev \
    python3 \
    python3-dev \
    python3-setuptools \
    python3-pip \
    python3-crcmod \
    openssh-client \
    procps \
    file \
    gcc \
    apt-transport-https \
    openssh-client \
    git"

# Install base packages and setup non-root user.
ARG DEBIAN_FRONTEND=noninteractive

COPY library-scripts/*.sh /tmp/library-scripts/

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive  && \
    apt-get -y install --no-install-recommends curl ca-certificates && \
    bash -c "$(curl -fsSL "https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/common-debian.sh")" -- "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "${INSTALL_OHMYZSH}" "${INSTALL_NONFREE_PACKAGES}" && \
    apt-get -y install --no-install-recommends $RUNTIME_PACKAGES && \
    bash -c "$(curl -fsSL "https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/github-debian.sh")" -- "${GITHUB_CLI_VERSION}" && \
    bash -c "$(curl -fsSL "https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/kubectl-helm-debian.sh")" -- "${KUBECTL_VERSION}" "${HELM_VERSION}" "${MINIKUBE_VERSION}" "${MINIKUBE_SHA256}" "${HELM_SHA256}" "${MINIKUBE_SHA256}" && \
    bash -c "$(curl -fsSL "https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/sshd-debian.sh")" -- "${SSHD_PORT}" "${SSHD_USERNAME}" "${START_SSHD}" "${SSHD_NEW_PASSWORD}" "${SSHD_FIX_ENVIRONMENT}" && \
    bash -c "$(curl -fsSL "https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/terraform-debian.sh")" -- "${TERRAFORM_VERSION}" "${TFLINT_VERSION}" "${TERRAGRUNT_VERSION}" "${TERRAFORM_SHA256}" "${TFLINT_SHA256}" "${TERRAGRUNT_SHA256}" && \
    bash /tmp/library-scripts/gcloud-debian.sh && \
    
# Run our clean up step
    apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

COPY library-scripts/zshenv /home/vscode/.zshenv
VOLUME ["/root/.config"]
ENTRYPOINT ["/usr/local/share/ssh-init.sh"]
CMD ["sleep", "infinity"]

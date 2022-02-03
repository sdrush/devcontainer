# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.202.3/containers/debian/.devcontainer/base.Dockerfile

# [Choice] Debian version (use bullseye or stretch on local arm64/Apple Silicon): bullseye, buster, stretch
ARG VARIANT="bullseye"
# FROM mcr.microsoft.com/vscode/devcontainers/python:3.9-bullseye
FROM debian:bullseye-slim

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

# Install zsh
ARG INSTALL_ZSH="true"
# Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"

# Install base packages and setup non-root user.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG DEBIAN_FRONTEND=noninteractive

COPY library-scripts/*.sh library-scripts/*.env /tmp/library-scripts/
RUN bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    apt-get update && \
    apt-get -y install --no-install-recommends $RUNTIME_PACKAGES && \
    bash /tmp/library-scripts/github-debian.sh && \
    bash /tmp/library-scripts/kubectl-helm-debian.sh && \
    bash /tmp/library-scripts/sshd-debian.sh && \
    bash /tmp/library-scripts/terraform-debian.sh && \
    bash /tmp/library-scripts/gcloud-debian.sh && \

# Run our clean up step
    apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

COPY library-scripts/zshenv /home/vscode/.zshenv
VOLUME ["/root/.config"]
ENTRYPOINT ["/usr/local/share/ssh-init.sh"]
CMD ["sleep", "infinity"]

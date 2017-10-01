FROM jenkins/jenkins:2.81-slim
USER root
# Add Python 3.5
RUN apt-get update && apt-get install -y python3.5 gnupg

# Add Azure CLI 2.0
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | \
    tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893 && \
    apt-get install apt-transport-https && apt-get update && apt-get install azure-cli && rm -rf /var/lib/apt/lists/*

# Add Kubectl

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl && chown jenkins: /usr/local/bin

# Switch back to Jenkins user
USER jenkins

# Preinstall plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
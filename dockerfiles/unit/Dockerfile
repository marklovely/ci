FROM concourse/golang-builder

# basic setup for adding new apt sources and installing packages
RUN apt-get update && apt-get -y install \
      apt-transport-https \
      ca-certificates \
      curl \
      iproute2 \
      gnupg2 \
      software-properties-common \
      unzip

# install PostgreSQL for DB tests
ENV DEBIAN_FRONTEND noninteractive
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main"
RUN apt-get update && apt-get -y install postgresql-11
ENV PATH $PATH:/usr/lib/postgresql/11/bin

# install Node 12.x
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && apt-get install -y nodejs

# install Yarn for web UI tests
RUN curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN add-apt-repository "deb https://dl.yarnpkg.com/debian/ stable main"
RUN apt-get update && apt-get -y install yarn

# install Docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update && apt-get -y install docker-ce

# install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose && \
      chmod +x /usr/local/bin/docker-compose

# install Chrome for Puppeteer (watsjs/upgrade/downgrade/smoke)
RUN curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN add-apt-repository "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"
RUN apt-get update && apt-get -y install google-chrome-unstable --no-install-recommends
# ensure that Puppeteer uses this Chrome instead of downloading on demand;
# this makes us resilient to breaking changes to the APT dependencies
ENV PUPPETEER_SKIP_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-unstable

# install BOSH CLI for bosh-smoke, bosh-topgun
RUN curl -L "https://github.com/cloudfoundry/bosh-cli/releases/download/v6.3.0/bosh-cli-6.3.0-linux-amd64" \
      -o /usr/local/bin/bosh && \
      chmod +x /usr/local/bin/bosh

# install kubectl for k8s-related jobs
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
      touch /etc/apt/sources.list.d/kubernetes.list && \
      echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
      apt-get update && \
      apt-get install --no-install-recommends -y kubectl && \
      rm -rf /var/lib/apt/lists/*

# install helm for k8s-related jobs
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# install yq
RUN wget https://github.com/mikefarah/yq/releases/download/3.4.0/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq

# TODO: tech-debt for maintaining 6.3.x version of the chart which uses Helm v2
# Remove when 6.3.x no longer needs to be supported
RUN curl https://get.helm.sh/helm-v2.16.12-linux-amd64.tar.gz -o helm-v2.tar.gz && \
        tar xzf helm-v2.tar.gz && \
        mv linux-amd64/helm /usr/local/bin/helm2

# install Vault for bosh-topgun
RUN curl -L https://releases.hashicorp.com/vault/0.7.3/vault_0.7.3_linux_amd64.zip -o /tmp/vault.zip && \
      unzip /tmp/vault.zip -d /usr/local/bin && \
      rm /tmp/vault.zip

# install Terraform, ssh and jq for bin-smoke
RUN curl -fsSL https://releases.hashicorp.com/terraform/0.12.6/terraform_0.12.6_linux_amd64.zip -o /tmp/terraform.zip && \
      unzip /tmp/terraform.zip -d /usr/local/bin && \
      rm /tmp/terraform.zip
RUN apt-get update && apt-get -y install jq openssh-client libnss3-tools
RUN curl -so /etc/ssl/certs/fake_root.pem \
  https://letsencrypt.org/certs/fakelerootx1.pem && \
  chmod 644 /etc/ssl/certs/fake_root.pem && \
  mkdir -p /root/.pki/nssdb && \
  chmod 700 /root/.pki/nssdb && \
  certutil -N -d sql:/root/.pki/nssdb --empty-password && \
  certutil -A \
    -n "LetsEncrypt Staging Fake Root" \
    -t "TCu,Cu,Tu" \
    -i /etc/ssl/certs/fake_root.pem \
    -d sql:/root/.pki/nssdb

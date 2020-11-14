FROM archlinux/base

SHELL ["/bin/bash", "-c"]

RUN pacman --noconfirm -Syu \
    base \
    base-devel \
    bash-completion \
    docker \
    gcc \
    git \
    github-cli \
    go \
    htop \
    inetutils \
    jq \
    libxkbfile \
    man \
    net-tools \
    nodejs \
    npm \
    openssh \
    python \
    rsync \
    shellcheck \
    vim \
    wget \
    yarn \
    zip \
    fish \
    exa

# allow passwordless sudo from all users
RUN echo "root ALL=(ALL) ALL" > /etc/sudoers
RUN echo "ALL ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers

# install gitui
RUN wget https://github.com/extrawurst/gitui/releases/download/v0.10.1/gitui-linux-musl.tar.gz \
  && tar -xvf gitui-linux-musl.tar.gz \
  && rm ./gitui-linux-musl.tar.gz \
  && sudo mv ./gitui /bin/gitui

# download gcloud package
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz \
  && mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh

# adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin
RUN gcloud components install beta

# install kubectl
RUN curl -L http://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
	&& chmod +x /usr/local/bin/kubectl

# install helm
RUN mkdir -p /tmp/helm && \
  curl -L https://get.helm.sh/helm-v3.2.1-linux-amd64.tar.gz | tar -C /tmp/helm --strip-components=1 -xzvf - \
  && mv /tmp/helm/helm /usr/local/bin/helm

# add custom user
ARG user=charlie
RUN useradd -mUs /usr/bin/fish ${user}
USER $user

# install rustc, cargo, etc.
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

ENV HOME /home/${user}
ENV USER=${user}
WORKDIR ${HOME}

# copy dotfiles
COPY . ${HOME}/dotfiles
RUN sh ${HOME}/dotfiles/install.sh

# set ownership of the home dir
RUN sudo chown -R ${user}:${user} ${HOME}

ENTRYPOINT [ "fish", "-l" ]

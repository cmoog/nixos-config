FROM ubuntu:20.04

LABEL org.opencontainers.image.source https://github.com/cmoog/dotfiles

SHELL ["/bin/bash", "-c"]

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y \
  bash \
  build-essential \
  ca-certificates \
  curl \
  docker.io \
  git \
  htop \
  jq \
  locales \
  man \
  python3 \
  python3-pip \
  sudo \
  systemd \
  unzip \
  vim \
  wget \
  zip \
  && rm -rf /var/lib/apt/lists/*

# allow passwordless sudo from all users
RUN echo "ALL ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers

# download gcloud package
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz \
  && mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh

# adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin
RUN gcloud components install beta

# install deno
RUN curl -fsSL https://deno.land/x/install/install.sh \
  | DENO_INSTALL=/usr/local sh

# add custom user
ARG user=charlie
RUN useradd -mUs /usr/bin/fish ${user}
USER $user

ENV HOME /home/${user}
ENV USER=${user}
WORKDIR ${HOME}

# install Homebrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH /home/linuxbrew/.linuxbrew/bin:${PATH}

# install Homebrew packages
RUN brew install \
  exa \
  fish \
  gh \
  go \
  helm \
  jesseduffield/lazydocker/lazydocker \
  jesseduffield/lazygit/lazygit \
  kubernetes-cli \
  node

# install rustc, cargo, etc.
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH ${HOME}/.cargo/bin:${PATH}

ENTRYPOINT [ "fish", "-l" ]

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
  unzip \
  vim \
  wget \
  zip \
  && rm -rf /var/lib/apt/lists/*

# allow passwordless sudo from all users
RUN echo "ALL ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers

# add custom user
ARG user=charlie
RUN useradd -mUs /bin/bash ${user}
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
  rustup-init \
  lazydocker \
  lazygit \
  kubernetes-cli \
  node \
  nvim

# change default shell to fish
RUN sudo chsh ${user} --shell $(which fish)

# install rustc, cargo, etc.
RUN rustup-init -y
ENV PATH ${HOME}/.cargo/bin:${PATH}

# install deno
RUN curl -fsSL https://deno.land/x/install/install.sh | sh
ENV PATH ${HOME}/.deno/bin:${PATH}

ENTRYPOINT [ "fish", "-l" ]

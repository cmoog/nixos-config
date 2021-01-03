FROM archlinux/base

LABEL org.opencontainers.image.source https://github.com/cmoog/dotfiles

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

# download gcloud package
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz \
  && mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh

# adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin
RUN gcloud components install beta

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
  kubernetes-cli \
  helm \
  jesseduffield/lazygit/lazygit \
  jesseduffield/lazydocker/lazydocker

# install rustc, cargo, etc.
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

ENTRYPOINT [ "fish", "-l" ]

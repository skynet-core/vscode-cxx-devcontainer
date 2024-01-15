FROM fedora:39
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN dnf upgrade -y \
  && dnf groupinstall -y 'Development Tools' \
  && dnf in -y neovim \
  sudo \
  gdb \
  gcc \
  valgrind \
  clang \
  libcxx-devel \
  libcxxabi-devel \
  llvm-libunwind-devel \
  llvm-cmake-utils \
  clang-tools-extra \
  glibc-all-langpacks \
  llvm \
  llvm-libs \
  compiler-rt \
  zsh \
  python \
  patch \
  git \
  curl \
  openssh \
  x11-ssh-askpass \
  direnv \
  automake \
  autoconf \
  bison \
  flex \
  fzf \
  pkg-config \
  file \
  patchutils \
  zoxide \
  lsd \
  python-pip \
  zip unzip tar unrar \
  sqlite3 \
  kernel-devel \
  ccache

SHELL [ "/bin/bash", "-o", "pipefail", "-c" ]
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

ENV PATH="/home/linuxbrew/.linuxbrew/bin:/usr/local/bin:${PATH}"
RUN brew install starship cmake ninja go

RUN pip install --break-system-packages --no-cache-dir cmake-format conan

SHELL [ "/bin/bash", "-o", "pipefail", "-c" ]
RUN if [[ "$USER_GID" -ge 1000 ]]; then groupadd --gid $USER_GID $USERNAME; fi
RUN useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers

RUN mkdir /workspaces && chown -R ${USER_UID}:${USER_GID} /workspaces
ENV EDITOR=vim
ENV CC=clang
ENV CXX=clang++
ENV HOME="/home/${USERNAME}"
ENV GOPATH="${HOME}/Dev/go"
ENV PATH="${HOME}/.cargo/bin:${HOME}/.local/bin:${GOPATH}/bin:${PATH}"

USER $USERNAME

RUN git clone https://github.com/Microsoft/vcpkg.git $HOME/.vcpkg \
  && $HOME/.vcpkg/bootstrap-vcpkg.sh -disableMetrics

ENV VCPKG_DEFAULT_BINARY_CACHE="${HOME}/.cache/vcpkg/archives"
ENV VCPKG_DOWNLOADS="${HOME}/.cache/vcpkg/downloads"
ENV VCPKG_BINARY_SOURCES="clear;files,${VCPKG_DEFAULT_BINARY_CACHE}"
VOLUME [ "${HOME}/.cache/vcpkg/archives" ]
VOLUME [ "${HOME}/.cache/vcpkg/downloads" ]
ENV VCPKG_ROOT="${HOME}/.vcpkg"
ENV PATH="${VCPKG_ROOT}:${PATH}"

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended

SHELL [ "/bin/zsh" ]

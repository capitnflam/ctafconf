FROM debian:stable-slim

ARG USERNAME=testuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
  git \
  zsh \
  htop \
  neovim \
  emacs \
  python3 \
  python-is-python3 \
  screen \
  tmux \
  nano \
  bash && \
  apt-get autoremove -y && \
  apt-get clean -y && \
  rm -rf /var/lib/apt/lists/*

RUN groupadd --gid $USER_GID $USERNAME && \
  useradd -ms /usr/bin/zsh $USERNAME --uid $USER_UID --gid $USER_GID
USER $USERNAME

RUN mkdir -p /home/$USERNAME/.config/ctafconf

WORKDIR /home/$USERNAME/.config/ctafconf

RUN mkdir .git && echo "testenv" > .git/HEAD
COPY --chown=${USER_UID}:${USER_GID} bin  bin/
COPY --chown=${USER_UID}:${USER_GID} etc  etc/
COPY --chown=${USER_UID}:${USER_GID} profile  profile/

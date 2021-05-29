FROM ubuntu:rolling
LABEL maintainer="Brennan Fee"

ENV DEBIAN_FRONTEND noninteractive

ENV pip_packages "ansible cryptography yamllint ansible-lint flake8 black molecule"

# Install apt-utils
RUN apt-get update \
  && apt-get install -y --no-install-recommends apt-utils \
  && rm -rf /var/lib/apt/lists/* \
  && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
  && apt-get clean

# Install dependencies
COPY initctl_faker .
RUN apt-get update && apt-get install -y --no-install-recommends \
  ## Include systemd
  systemd systemd-sysv \
  ## Extra packages to better match a non-docker setup
  cron file less locales tzdata gawk gnupg snapd \
  ## Mimic my standard bootstrap setup
  openssh-server openssh-client lsb-release build-essential dkms sudo acl curl \
  wget git vim \
  libffi-dev libssl-dev \
  python3-dev python3-setuptools python3-wheel python3-venv \
  python3-keyring python3-pip \
  ## Clean up
  && rm -rf /var/lib/apt/lists/* \
  && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
  && apt-get clean \
  ## Upgrade pip
  && wget -nv https://bootstrap.pypa.io/get-pip.py \
  && python3 get-pip.py \
  # Make sure systemd doesn't start agettys on tty[1-6].
  && rm -f /lib/systemd/system/multi-user.target.wants/getty.target \
  # Mock initctl
  && chmod +x initctl_faker && rm -fr /sbin/initctl && ln -s /initctl_faker /sbin/initctl

# Install pip packages.
RUN pip3 install $pip_packages \
  # Install Ansible inventory file.
  && mkdir -p /etc/ansible \
  && echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup"]
CMD ["/lib/systemd/systemd"]

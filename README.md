# docker-ubuntu-rolling-systemd

[![CI](https://github.com/brennanfee/docker-ubuntu-rolling-systemd/workflows/Build/badge.svg?branch=main&event=push)](https://github.com/brennanfee/docker-ubuntu-rolling-systemd/actions?query=workflow%3ABuild)
[![Docker Pulls](https://img.shields.io/docker/pulls/brennanfee/docker-ubuntu-rolling-systemd)](https://hub.docker.com/r/brennanfee/docker-ubuntu-rolling-systemd/)

Ubuntu rolling Docker container with Systemd and Ansible.

## Tags

- `latest`: Latest rolling version of Ubuntu.

The latest tag tracks the ubuntu:rolling docker image. Because it has Systemd and Ansible this image
can be used to test Ansible playbooks and roles.

> **Important Note**: This image is intended for testing in an isolated environment—**not for
> production**—and the settings and configuration used may not be suitable for real use beyond
> testing. Use on production servers or in the wild at your own risk!

## How to Build

This image is built on Docker Hub automatically any time the upstream OS container is rebuilt, and
any time a commit is made or merged to the `main` branch, and once per week. But if you need to
build the image on your own locally, do the following:

1. [Install Docker](https://docs.docker.com/install/).
2. `cd` into this directory.
3. Run `docker build -t ubuntu-rolling-systemd .`

## How to Use

1. [Install Docker](https://docs.docker.com/engine/installation/).
2. Pull this image from Docker Hub: `docker pull brennanfee/docker-ubuntu-rolling-systemd:latest`
   (or use the image you build manually above, e.g. `ubuntu-rolling-systemd:latest`).
3. Run a container from the image:
   `docker run --detach --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro brennanfee/docker-ubuntu-rolling-systemd:latest`
   (to test Ansible roles, add in a volume mounted from the current working directory with
   `` --volume=`pwd`:/etc/ansible/roles/role_under_test:ro ``).
4. Use Ansible inside the container:
   - `docker exec --tty [container_id] env TERM=xterm ansible --version`
   - `docker exec --tty [container_id] env TERM=xterm ansible-playbook /path/to/ansible/playbook.yml --syntax-check`

## License

[MIT](license.md) © 2021 [Brennan Fee](https://github.com/brennanfee)

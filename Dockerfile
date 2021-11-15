FROM fedora:35
LABEL maintainer "Chris Zervakis"

# Avoid things that systemd does on actual hardware.
ENV container docker

# Install Ansible via pip so we get the latest version.
ENV ansible_packages "ansible"

RUN dnf -y update && dnf clean all

RUN dnf makecache \
    && dnf -y install \
    systemd \
    python3-pip \
    which \
    && dnf clean all && \
  (cd /lib/systemd/system/sysinit.target.wants/ ; for i in * ; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i ; done) ; \
  rm -f /lib/systemd/system/multi-user.target.wants/* ;\
  rm -f /etc/systemd/system/*.wants/* ;\
  rm -f /lib/systemd/system/local-fs.target.wants/* ; \
  rm -f /lib/systemd/system/sockets.target.wants/*udev* ; \
  rm -f /lib/systemd/system/sockets.target.wants/*initctl* ; \
  rm -f /lib/systemd/system/basic.target.wants/* ;\
  rm -f /lib/systemd/system/anaconda.target.wants/*

RUN pip3 install --no-cache $ansible_packages

VOLUME ["/sys/fs/cgroup"]
CMD [ "/sbin/init" ]

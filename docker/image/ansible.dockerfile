# Docker image to use.
FROM learning/amazonlinux:v1

# Install OpenSSH server.
RUN yum install -y openssh-server passwd

# Configure OpenSSH server.
RUN set -x \
  && mkdir /var/run/sshd \
  && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' \
  && sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Configure OpenSSH user.
RUN set -x \
  && mkdir /root/.ssh \
  && touch /root/.ssh/authorized_keys \
  && touch /root/.ssh/config \
  && echo -e "Host *\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile=/dev/null" >> /root/.ssh/config \
  && chmod 400 /root/.ssh/config
ADD secret/node.pub /root/.ssh/authorized_keys

# Cleanup history.
RUN history -c

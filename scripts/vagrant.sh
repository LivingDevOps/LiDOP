#!/usr/bin/env bash
echo "###########################################################"
echo "Enable password auth for ssh and set password vagrant"
echo "###########################################################"
sudo sed -i -e '/^PasswordAuthentication / s/ .*/ yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd

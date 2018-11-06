#!/bin/sh -eux

# set a default HOME_DIR environment variable if not set
HOME_DIR="${HOME_DIR:-/home/vagrant}";

{ # try

    pubkey_url="https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub";
    mkdir -p $HOME_DIR/.ssh;
    if command -v wget >/dev/null 2>&1; then
        wget --no-check-certificate "$pubkey_url" -O $HOME_DIR/.ssh/authorized_keys;
    elif command -v curl >/dev/null 2>&1; then
        curl --insecure --location "$pubkey_url" > $HOME_DIR/.ssh/authorized_keys;
    elif command -v fetch >/dev/null 2>&1; then
        fetch -am -o $HOME_DIR/.ssh/authorized_keys "$pubkey_url";
    else
        echo "Cannot download vagrant public key";
        exit 1;
    fi
} || { # catch
    echo "Cannot download vagrant public key";
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" >> $HOME_DIR/.ssh/authorized_keys
}

chown -R vagrant $HOME_DIR/.ssh;
chmod -R go-rwsx $HOME_DIR/.ssh;
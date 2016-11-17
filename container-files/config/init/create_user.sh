#!/bin/bash

# Creating the www user
useradd www -d /data/www
# Setting password for the www user
echo 'www:iaw' | chpasswd
# Add 'www' user to sudoers
echo 'www  ALL=(ALL)  NOPASSWD: ALL' > /etc/sudoers.d/www




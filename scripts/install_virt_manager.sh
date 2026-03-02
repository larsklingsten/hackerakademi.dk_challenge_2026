#!/bin/bash

# Installs VM Manager
# untested, just copied what I did

sudo apt update && sudo apt install virt-manager qemu-utils
   
sudo systemctl enable --now libvirtd

sudo virsh net-start default
sudo virsh net-autostart default
sudo reboot now

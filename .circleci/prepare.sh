#!/bin/bash -e

sudo dd if=/dev/zero of=/swap count=4096 bs=1M || true
sudo chmod 600 /swap || true
sudo mkswap /swap || true
sudo swapon /swap || true

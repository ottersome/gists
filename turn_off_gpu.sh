#!/usr/bin/env sh
set -e

PCI="0000:65:00.0"

echo "Unloading NVIDIA drivers..."

modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia_wmi_ec_backlight nvidia

echo "Removing PCI device..."
echo 1 | tee /sys/bus/pci/devices/$PCI/remove

# nvidia-smi --id 0000:65:00.0 --persistence-mode 0
# nvidia-smi drain --pciid 0000:65:00.0 --modify 1
# nvidia-smi --persistence-mode 1
#!/bin/bash

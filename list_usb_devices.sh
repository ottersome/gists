#!/usr/bin/env sh
for device in /sys/bus/usb/devices/*/power/runtime_status; do
      echo "$device: $(cat $device)"
  done


#!/usr/bin/env sh
for cpu in {1..20}; do
    echo 0 | sudo tee /sys/devices/system/cpu/cpu$cpu/online
done


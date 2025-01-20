#!/bin/bash

# TODO: Make it turn off some devices if need be.

HISTORY_FILE="$HOME/scripts/data/bluetooth_device_history"
touch "$HISTORY_FILE"

devices=$(bluetoothctl devices Paired | cut -d ' ' -f 2-)

meep=$(echo "$devices" | sort -rn -t'|' -k1 | cut -d'|' -f2-)
echo "${meep}"

sorted_devices=$(while IFS= read -r device; do
    count=$(grep -c "^$device$" "$HISTORY_FILE")
    echo "$count|$device"
done <<< "$devices" | sort -rn -t'|' -k1 | cut -d'|' -f2-)

echo "Sorted devices: ${sorted_devices}"

selected=$(echo "$sorted_devices"  | rofi -dmenu -p "Select Bluetooth Device")

if [ ! -z "$selected" ]; then
  mac=$(echo "$selected" | cut -d ' ' -f 1)
  device=$(echo "$selected" | cut -d ' ' -f 2)

  # Check if device is already on
  if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
      notify-send "Disconnecting ${device}"
      bluetoothctl disconnect "$mac"
  else
      notify-send "Connecting ${device}"
      bluetoothctl connect "$mac"
      echo "$selected" >> "$HISTORY_FILE"
  fi
fi

#!/bin/bash

# Start bluetoothctl
bluetoothctl << EOF &
scan on
EOF

# Wait for a while to ensure the device is found
sleep 10

# Get the MAC address of the target device
device_mac=$(bluetoothctl devices | grep "GS-BLU-0" | awk '{print $2}')

# If the device is found, attempt to connect
if [ -n "$device_mac" ]; then
    echo "Found GS-BLU-0 with MAC address $device_mac. Connecting..."
    bluetoothctl << EOF
    connect $device_mac
    quit
EOF
else
    echo "Device GS-BLU-0 not found."
    bluetoothctl << EOF
    quit
EOF
fi

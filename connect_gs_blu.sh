#!/bin/bash

# Start bluetoothctl and begin scanning for devices
bluetoothctl << EOF
scan on
EOF

echo "**************************************"
# Wait for a period of time to allow devices to be discovered (adjust the time as needed)
sleep 10


echo "222222222222222222222**************************************"
# Get the MAC address of the device with the name "GS-BLU-0"
device_mac=$(bluetoothctl devices | grep "GS-BLU-0" | awk '{print $2}')
echo "device_mac is $device_mac"
# If the device is found, attempt to connect
if [ -n "$device_mac" ]; then
    echo "Found GS-BLU-0 with MAC address $device_mac. Connecting..."
    bluetoothctl << EOF
    connect $device_mac
EOF
else
    echo "Device GS-BLU-0 not found."
fi


#!/bin/bash

# Set the name of the Bluetooth device you want to connect to
TARGET_DEVICE_NAME="GS-BLU-0"

# Power on the Bluetooth controller
echo "power on" | bluetoothctl

# Start scanning for Bluetooth devices
echo "Starting to scan for Bluetooth devices..."
echo "scan on" | bluetoothctl &

# Wait for the scan results
sleep 5

# Get the list of devices and find the MAC address of the target device
DEVICE_MAC=$(echo "devices" | bluetoothctl | grep "$TARGET_DEVICE_NAME" | awk '{print $2}')

# Stop scanning
echo "scan off" | bluetoothctl

# Check if the target device was found
if [ -z "$DEVICE_MAC" ]; then
    echo "Device $TARGET_DEVICE_NAME not found"
    exit 1
fi

echo "Found device $TARGET_DEVICE_NAME with MAC address $DEVICE_MAC"

# Connect to the target device
echo "connect $DEVICE_MAC" | bluetoothctl

# Wait for the connection to succeed
sleep 2

# Trust the device (optional step)
echo "trust $DEVICE_MAC" | bluetoothctl

# After a successful connection, send or receive data (assuming using rfcomm protocol)
# Assuming the target device supports Serial Port Profile (SPP), we can use rfcomm to communicate
rfcomm connect hci0 $DEVICE_MAC 1 &

# Set the device as a serial port and send/receive data
# You can put your send and receive data commands here
# For example, sending data:
echo "Hello from Linux!" > /dev/rfcomm0

# Receiving data:
cat /dev/rfcomm0

# Disconnect
echo "disconnect $DEVICE_MAC" | bluetoothctl

echo "Script finished"

# Power off the Bluetooth controller (optional)
# echo "power off" | bluetoothctl


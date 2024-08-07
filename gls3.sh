#!/usr/bin/expect -f

# Start bluetoothctl
spawn bluetoothctl
expect "#"

# Start scanning
send "scan on\r"

# Set a timeout for finding the device
set timeout 50

# Wait for the device with the name "GS-BLU-0"
expect {
    -re {Device\s+([A-Fa-f0-9:]+)\s+GS-BLU-0} {
        set mac_address $expect_out(1,string)
        send "connect $mac_address\r"
        expect "#"
    }
    timeout {
        # If the device is not found within the timeout, continue
        send_user "Device not found within timeout.\n"
    }
}

# Keep the bluetoothctl session open for further manual commands
interact


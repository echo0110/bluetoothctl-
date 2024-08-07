#!/usr/bin/expect -f

# Start bluetoothctl
spawn bluetoothctl
expect "#"

# Start scanning
send "scan on\r"
expect {
    "GS-BLU-0" {
        # If the device is found, get its MAC address and connect
        send "connect [lindex [split [lindex [split $expect_out(buffer) \n] end] ] 2]\r"
        expect "#"
    }
    timeout {
        # If the device is not found within the timeout period, continue scanning
        # Here, we can either restart the scan or just wait for user input
        # In this example, we continue to wait indefinitely for user commands
    }
}

# Keep the bluetoothctl session open for further manual commands
interact

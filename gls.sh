#!/usr/bin/expect -f

# Start bluetoothctl
spawn bluetoothctl
expect "#"

# Start scanning
send "scan on\r"

# Wait for the device to be found
set timeout 50
expect {
    "GS-BLU-0" {
        # If the device is found, get its MAC address and connect
        send "connect [lindex [split [lindex [split $expect_out(buffer) \n] end] ] 2]\r"
        expect "#"
    }
    timeout {
        # If the device is not found, exit
        send "quit\r"
    }
}

# Exit bluetoothctl
send "quit\r"
expect eof

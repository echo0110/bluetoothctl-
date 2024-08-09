#!/usr/bin/expect -f

#if { [llength $argv] == 0 } {
#    send_user "Usage: $argv0 <MAC_ADDRESS>\n"
#    exit 1
#}

#set mac_address [lindex $argv 0]

# Start bluetoothctl
spawn bluetoothctl
expect "#"

#send "connect $mac_address\r"
#expect {
#    "Connection successful" {
#        send_user "Connected to $mac_address successfully.\n"
#    }
#    timeout {
#        send_user "Failed to connect to $mac_address.\n"
#        exit 1
#    }
#}

# Enter the gatt menu
send "menu gatt\r"
expect "#"

# Select the attribute for writing data
send "select-attribute 00002af1-0000-1000-8000-00805f9b34fb\r"
expect "#"

sleep 3
# Write data to the selected attribute
set write_data "0x27"  ;
send "write $write_data\r"
expect "#"

# 结束脚本
#send_user "Data written: $write_data\n"


#!/usr/bin/expect -f

# 检查是否提供了MAC地址作为参数
if { [llength $argv] == 0 } {
    send_user "Usage: $argv0 <MAC_ADDRESS>\n"
    exit 1
}

# 获取传入的MAC地址
set mac_address [lindex $argv 0]

# Start bluetoothctl
spawn bluetoothctl
expect "#"

# 连接到传入的MAC地址
send "connect $mac_address\r"
expect {
    "Connection successful" {
        send_user "Connected to $mac_address successfully.\n"
    }
    timeout {
        send_user "Failed to connect to $mac_address.\n"
        exit 1
    }
}

# Enter the gatt menu
send "menu gatt\r"
expect "#"

# Select the attribute for writing data
send "select-attribute 00002af1-0000-1000-8000-00805f9b34fb\r"
expect "#"

# Write data to the selected attribute
set write_data "0x27"  ;# 这里设置你要写的数据
send "write $write_data\r"
expect "#"

# 创建子进程进行读取操作
if {[fork] == 0} {
    # 子进程
    # Select the attribute for reading data
    send "select-attribute 49535343-1e4d-4bd9-ba61-23c647249616\r"
    expect "#"

    # Read data from the selected attribute
    send "read\r"
    expect {
        -re "Characteristic value/descriptor: (.+)" {
            set read_data $expect_out(1,string)
            send_user "Read data: $read_data\n"

            # Compare the written data with the read data
            if {$read_data eq $write_data} {
                send_user "Bluetooth functionality test passed: Read data matches written data.\n"
            } else {
                send_user "Bluetooth functionality test failed: Read data does not match written data.\n"
            }
        }
        timeout {
            send_user "Read operation timed out.\n"
        }
    }
    exit 0
} else {
    # 父进程
    # 等待子进程结束
    wait
}

# Keep the bluetoothctl session open for further manual commands
interact

#!/usr/bin/expect
set username root
set password vagrant
spawn passwd $username
sleep .5
expect "*password:"
send "$password\r"
expect "*password:"
send "$password\r"
expect "*successfully" {exit 0}
expect eof
exit 13

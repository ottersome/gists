#!/usr/bin/env sh

# In case you want to search for yours???
possible_ips=$(sudo adb shell ip route | awak '{print $9}')
adb tcpip 5555 # TUrn on the server I guess
adb connect 192.168.212.202

# Then do the screen copying. 
scrcpy --tcpip=192.168.212.202 --turn-screen-off

echo 'Done!'

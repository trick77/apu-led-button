## apu-led-button

Linux kernel module for PC Engine's APU system board to access the three front LEDs and the reset button. Originally published http://daduke.org/linux/apu/ but slightly modified for Ubuntu Server 14.04 and newer. Tested only with a 3.19 kernel.
After the installation, the first LED will indicate if the system is up (you could also use ledtrig-heartbeat for instance). The second and third led will funcation as RX/TX led for the network port of your choice. The installation is using eth1 because it's the WAN port in my setup. Additionally, pressing the front reset button for at least a second will issue a beep and soft-reboot the APU.

## Installation

```
# sudo apt-get install linux-headers-$(uname -r) build-essentials
# sudo git clone https://github.com/trick77/apu-led-button
# make && sudo make install
```

(as root)
```
# echo "ledtrig-timer" >> /etc/modules
# echo "apuled-button" >> /etc/modules
```

Insert these lines to /etc/rc.local just above exit 0:

```
echo timer > /sys/class/leds/apu\:1/trigger
echo 1750 > /sys/class/leds/apu:\1/delay_on
echo 250 >  /sys/class/leds/apu\:1/delay_off
/usr/local/sbin/apuled eth1 -c nrt -f
/usr/local/sbin/apubutton&
```

...and reboot.

## License
Copyright (c) 2014, Mark Schank
Copyright (C) 2013, Christian Herzog

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License version 2 as published by the Free Software Foundation.

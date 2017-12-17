#! /bin/sh

# enable the GPIO pins
if ! grep -Fxq "enable_uart=1" /boot/config.txt
then
	# add to end of file
	echo "" >> /boot/config.txt
	echo "enable_uart=1" >> /boot/config.txt
fi

# get the location of this script's folder
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# remove the python script if it is present
if [ -f /usr/local/bin/listen-for-shutdown.py ]; then
	sudo rm -f /usr/local/bin/listen-for-shutdown.py
fi

# setup the python script
sudo cp $DIR/listen-for-shutdown.py /usr/local/bin/
sudo chmod +x /usr/local/bin/listen-for-shutdown.py

# remove the bash script if it is present
if [ -f /etc/init.d/listen-for-shutdown.sh ]; then
	sudo rm /etc/init.d/listen-for-shutdown.sh
fi

# setup the bash script
sudo cp $DIR/listen-for-shutdown.sh /etc/init.d/
sudo chmod +x /etc/init.d/listen-for-shutdown.sh
sudo update-rc.d listen-for-shutdown.sh defaults

# shutdown the pie so that the user can use the button to restart it
sudo shutdown -h now

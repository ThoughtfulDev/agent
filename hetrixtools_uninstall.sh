#!/bin/bash
#
#
#	HetrixTools Server Monitoring Agent - Uninstall Script
#	version 1.5.9
#	Copyright 2015 - 2020 @  HetrixTools
#	For support, please open a ticket on our website https://hetrixtools.com
#
#
#		DISCLAIMER OF WARRANTY
#
#	The Software is provided "AS IS" and "WITH ALL FAULTS," without warranty of any kind, 
#	including without limitation the warranties of merchantability, fitness for a particular purpose and non-infringement. 
#	HetrixTools makes no warranty that the Software is free of defects or is suitable for any particular purpose. 
#	In no event shall HetrixTools be responsible for loss or damages arising from the installation or use of the Software, 
#	including but not limited to any indirect, punitive, special, incidental or consequential damages of any character including, 
#	without limitation, damages for loss of goodwill, work stoppage, computer failure or malfunction, or any and all other commercial damages or losses. 
#	The entire risk as to the quality and performance of the Software is borne by you, the user.
#
#

# Set PATH
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Check if install script is run by root
echo "Checking root privileges..."
if [ "$EUID" -ne 0 ]
  then echo "Please run the install script as root."
  exit
fi
echo "... done."

# Fetch Server Unique ID
SID=$1

# Remove old agent (if exists)
echo "Checking if hetrixtools agent folder exists..."
if [ -d /root/hetrixtools ]
then
	echo "Old hetrixtools agent found, deleting it..."
	rm -rf /root/hetrixtools
else
	echo "No old hetrixtools agent folder found..."
fi
echo "... done."

# Killing any running hetrixtools agents
echo "Killing any hetrixtools agent scripts that may be currently running..."
ps aux | grep -ie hetrixtools_agent.sh | awk '{print $2}' | xargs kill -9
echo "... done."


# Cleaning up uninstall file
echo "Cleaning up the installation file..."
if [ -f $0 ]
then
    rm -f $0
fi
echo "... done."

# Let HetrixTools platform know uninstall has been completed
echo "Letting HetrixTools platform know the uninstallation has been completed..."
POST="v=uninstall&s=$SID"
wget -t 1 -T 30 -qO- --post-data "$POST" --no-check-certificate https://sm.hetrixtools.net/ &> /dev/null
echo "... done."

# All done
echo "HetrixTools agent uninstallation completed."

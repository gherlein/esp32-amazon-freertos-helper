# Amazon FreeRTOS ESP32 Helper

This tool is a wrapper intended to help automate quickly using Amazon FreeRTOS on the ESP32.  If nothing else, it's a simple collection of the commands needed to build and test for that chip.

## Installation

Clone this repo locally.  Please make sure that you have make installed.  This tool is tested on linux.  No idea if it will work on MacOS and certainly will not work on Windows.

## Configuration

Copy the makefile.template to 'makefile.local' and change the variables to the correct values for your location.  Example:

```
# these are things you need to change
THINGNAME := <name>
WIFI	  := <ssid>
PASSWORD  := <password>
SECURITY  := eWiFiSecurityWPA2
#SECURITY  := eWiFiSecurityOpen
#SECURITY  := eWiFiSecurityWEP
#SECURITY  := eWiFiSecurityWPA
PORT      := /dev/ttyUSB0 # typical for linux, but you should verify

#
# these should be fairly constant, if you put things where Espressif installs them
#
ESPBASE	  := ${HOME}/esp
FREERTOS  := ${ESPBASE}/amazon-freertos
CONFIG    := ${FREERTOS}/tools/aws_config_quick_start/configure.json
CONFFILE  := configure.json
```

You *must* change the THINGNAME, WIFI and PASSWORD values.  Most WiFi uses eWiFiSecurityWPA2 and most linux machines will have /dev/ttyUSB0 for the port.

This tool expects that your edits will end up in 'makefile.local' and there is a .gitignore rule to ensure that you don't accidentally check in your wifi details into git.  Don't count on this.  Be aware of what you are doing.  You have been warned.  


## Build Script

The 'builder' script that gets copied into the FreeRTOS directory gets around the problem of correctly setting environment variables in a Make sub-shell. That is something I thought I had solved, but alas, no.  But this simple hack makes it work.

## Location

Just to keep things easy I've decided to work in my default 'esp' folder, but you can put this anywhere and it should still work.

## Usage

These are the targets:

```
make all        # builds the whole thing, soup to nuts
make git	# git clone FreeRTOS
make install	# run the Espressif install script - must be done once
make config     # creates the config file and runs the config script for AWS IoT
make build      # builds all the cmake files
make erase 	# erases the ESP32
make flash	# copies the binary to the ESP32
make monitor	# opens a serial port - use 'ctrl-]' to exit
make clean	# cleans the build files
make fullclean  # destroys the build folder, requires running 'make config' again
make localclean # cleans this repo folder
```



# boot.py: this file will be executed on boot
#
# The following code is necessary in order to enable Pycom REPL
import os
import machine

os.dupterm(machine.UART(0, 115200))

#!/bin/bash
ddcutil setvcp 0x60 0x11 --mfg=PHL
sleep 5
ddcutil setvcp 0x86 0x1b --mfg=PHL
#! /usr/bin/bash

# Bash script to control the keyboard backlight using only one key 
# Used in Hyprland configuration

current=$(brightnessctl --device='asus::kbd_backlight' get)
max=$(brightnessctl --device='asus::kbd_backlight' max)
next=$(((current + 1) % (max + 1)))

brightnessctl --device='asus::kbd_backlight' set $next


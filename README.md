# KlipperFlash --- Update all Klipper devices

This is a very simple script I created to update all
[Klipper](https://www.klipper3d.org) devices in my printer in a single shot.
This is mostly useful if your printer has multiple Klipper devices, like a
main MCU and a separate extruder board.  It becomes even more interesting in a
printer with multiple extruders.

WARNING!  This script will flash all Klipper devices found in your printer.
This might brick your devices, if something doesn't work properly.  Use at
your own risk.

To run the script, you need to update the `flashall` script and set the
environment variables `KLIPPER`, `KATAPULT`, and `KATAPULT_ENV` to point to
the locations the respective software is installed on your system.

Next, you need to place config files for all your devices into config files,
similar to the `config.stm32f446xx` file for my Leviathan MCU or the
`config.rp2040` file for my Nitehawk SB toolhead board.

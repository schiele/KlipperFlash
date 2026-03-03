# KlipperFlash --- Update all Klipper devices

This is a simple Makefile I created to update all
[Klipper](https://www.klipper3d.org) devices in my printer in a single shot.
This is mostly useful if your printer has multiple Klipper devices, like a
main MCU and a separate extruder board.  It becomes even more interesting in a
printer with multiple extruders.

WARNING!  This will flash all Klipper devices found in your printer.  This
might brick your devices, if something doesn't work properly.  Use at your own
risk.

To run this, you need to update the Makefile and set `KLIPPER` to the location
of your Klipper installation on your system.

Next, you need to place config files for all your devices into config files,
similar to the `config.stm32f446xx` file for my Leviathan MCU or the
`config.rp2040` file for my Nitehawk SB toolhead board.

Finally, you run this with `make`.  You can run the builds only with
`make buildall`.  You may also do dryruns to mock the actual flashing step with
`make DRYRUN:=1`.

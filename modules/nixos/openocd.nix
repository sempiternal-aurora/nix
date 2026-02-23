{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.mine.udev;
in
{
  options = {
    mine = {
      udev = {
        openocd = lib.mkEnableOption "Enable OpenOCD udev rules";
        vivado = lib.mkEnableOption "Enable UDEV rules for Vivado FPGA devices";
      };
    };
  };

  config = {
    environment.systemPackages = lib.optional cfg.openocd pkgs.openocd;
    services.udev.packages =
      (lib.optional cfg.openocd pkgs.openocd)
      ++ lib.optionals cfg.vivado [
        (pkgs.writeTextFile {
          name = "xilinx-dilligent-usb-udev";
          destination = "/etc/udev/rules.d/52-xilinx-digilent-usb.rules";
          text = ''
            ###########################################################################
            #                                                                         #
            #  52-digilent-usb.rules -- UDEV rules for Digilent USB Devices           #
            #                                                                         #
            ###########################################################################
            #  Author: MTA                                                            #
            #  Copyright 2010 Digilent Inc.                                           #
            ###########################################################################
            #  File Description:                                                      #
            #                                                                         #
            #  This file contains the rules used by UDEV when creating entries for    #
            #  Digilent USB devices. In order for Digilent's shared libraries and     #
            #  applications to access these devices without root privalages it is     #
            #  necessary for UDEV to create entries for which all users have read     #
            #  and write permission.                                                  #
            #                                                                         #
            #  Usage:                                                                 #
            #                                                                         #
            #  Copy this file to "/etc/udev/rules.d/" and execute                     #
            #  "/sbin/udevcontrol reload_rules" as root. This only needs to be done   #
            #  immediately after installation. Each time you reboot your system the   #
            #  rules are automatically loaded by UDEV.                                #
            #                                                                         #
            ###########################################################################
            #  Revision History:                                                      #
            #                                                                         #
            #  04/15/2010(MTA): created                                               #
            #  02/28/2011(MTA): modified to support FTDI based devices                #
            #  07/10/2012(MTA): modified to work with UDEV versions 098 or newer      #
            #  04/19/2013(MTA): modified mode assignment to use ":=" insetead of "="  #
            #       so that our permission settings can't be overwritten by other     #
            #       rules files                                                       #
            #  07/28/2014(MTA): changed default application path                      #
            #                                                                         #
            ###########################################################################

            # Create "/dev" entries for Digilent device's with read and write
            # permission granted to all users.
            ATTRS{idVendor}=="1443", MODE:="666"
            ACTION=="add", ATTRS{idVendor}=="0403", ATTRS{manufacturer}=="Digilent", MODE:="666"

            # The following rules (if present) cause UDEV to ignore all UEVENTS for
            # which the subsystem is "usb_endpoint" and the action is "add" or
            # "remove". These rules are necessary to work around what appears to be a
            # bug in the Kernel used by Red Hat Enterprise Linux 5/CentOS 5. The Kernel
            # sends UEVENTS to remove and then add entries for the endpoints of a USB
            # device in "/dev" each time a process releases an interface. This occurs
            # each time a data transaction occurs. When an FPGA is configured or flash
            # device is written a large number of transactions take place. If the
            # following lines are commented out then UDEV will be overloaded for a long
            # period of time while it tries to process the massive number of UEVENTS it
            # receives from the kernel. Please note that this work around only applies
            # to systems running RHEL5 or CentOS 5 and as a result the rules will only
            # be present on those systems.
          '';
        })
        (pkgs.writeTextFile {
          name = "xilinx-pcusb-udev";
          destination = "/etc/udev/rules.d/52-xilinx-pcusb.rules";
          text = ''
            # version 0002
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="0008", MODE="666"
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="0007", MODE="666"
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="0009", MODE="666"
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="000d", MODE="666"
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="000f", MODE="666"
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="0013", MODE="666"
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="0015", MODE="666"
          '';
        })
        (pkgs.writeTextFile {
          name = "xilinx-ftdi-usb-udev";
          destination = "/etc/udev/rules.d/52-xilinx-ftdi-usb.rules";
          text = ''
            ###########################################################################
            #                                                                         #
            #  52-xilinx-ftdi-usb.rules -- UDEV rules for Xilinx USB Devices          #
            #                                                                         #
            ###########################################################################
            #  Author: EST                                                            #
            #  Copyright 2016 Xilinx Inc.                                             #
            ###########################################################################
            #  File Description:                                                      #
            #                                                                         #
            #  This file contains the rules used by UDEV when creating entries for    #
            #  Xilinx USB devices. In order for Xilinx's shared libraries and         #
            #  applications to access these devices without root privalages it is     #
            #  necessary for UDEV to create entries for which all users have read     #
            #  and write permission.                                                  #
            #                                                                         #
            #  Usage:                                                                 #
            #                                                                         #
            #  Copy this file to "/etc/udev/rules.d/" and execute                     #
            #  "/sbin/udevcontrol reload_rules" as root. This only needs to be done   #
            #  immediately after installation. Each time you reboot your system the   #
            #  rules are automatically loaded by UDEV.                                #
            #                                                                         #
            ###########################################################################
            #  Revision History:                                                      #
            #                                                                         #
            #  10/18/2016(EST): created                                               #
            #                                                                         #
            ###########################################################################
            # version 0001
            # Create "/dev" entries for Xilinx device's with read and write
            # permission granted to all users.
            ACTION=="add", ATTRS{idVendor}=="0403", ATTRS{manufacturer}=="Xilinx", MODE:="666"

            # The following rules (if present) cause UDEV to ignore all UEVENTS for
            # which the subsystem is "usb_endpoint" and the action is "add" or
            # "remove". These rules are necessary to work around what appears to be a
            # bug in the Kernel used by Red Hat Enterprise Linux 6/CentOS 5. The Kernel
            # sends UEVENTS to remove and then add entries for the endpoints of a USB
            # device in "/dev" each time a process releases an interface. This occurs
            # each time a data transaction occurs. When an FPGA is configured or flash
            # device is written a large number of transactions take place. If the
            # following lines are commented out then UDEV will be overloaded for a long
            # period of time while it tries to process the massive number of UEVENTS it
            # receives from the kernel. Please note that this work around only applies
            # to systems running RHEL6 or CentOS 5 and as a result the rules will only
            # be present on those systems.
          '';
        })
      ];
  };
}


# Klipper USB Autocopy    
This script facilitates the automatic mounting and copying of files from USB drives on a Raspberry Pi system.  

## Functionality  
* **Mounting USB Drives**: When a USB drive is plugged in, the script automatically detects it and mounts it to the system.  
* **Copying Files**: Once mounted, the script identifies specified file patterns (e.g., *.gcode) on the USB drive and copies them to a designated destination directory. If no matching files are found, the script exports files from the destination directory to the USB drive.  
* **Unmounting USB Drives**: When a USB drive is removed, the script unmounts it from the system and removes any associated mount points.  
* **Notification**: Upon completion of the copying process, a short beep is emitted. This requires the "beeper" to be declared in Klipper configuration.    
  
## Installation  
This script can be installed using the install.sh script by executing the following command:  
```  
wget -O - https://raw.githubusercontent.com/konk22/3Def_Voron_2.4r2/main/manual/klipper_usb_autocopy/install.sh | bash
```  
Ensure that you have necessary permissions and review the script before executing it on your system.  

For detailed information on how the script works, refer to the comments within the script file.  


Inspired by the project: https://github.com/DrumClock/mount_copy/tree/main

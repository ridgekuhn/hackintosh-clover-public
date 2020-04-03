# Hackintosh with Gigabyte Z390 UD and Intel Coffee Lake

This guide is for Mojave, but should also work for Catalina, which I briefly installed before realizing that there are a few 32-bit apps I need which aren't supported by Catalina.

It's been almost a decade since I've built a Hackintosh, and I learned quite a bit along the way. Hopefully this helps anyone who ran into the same problems I did.

Thanks to [@pastrychef](https://www.tonymacx86.com/members/pastrychef.816738/) at the tonymacx86.com forum, who helped me get up and running. 

## Hardware
* Gigabyte Z390 UD Motherboard, Rev 1.0, Firmware F10c
* Intel Core i3 9100 with UHD 630
* Crucial Ballistix Sport LT RAM, 2x8GB at 3200Mhz (running at 2400Mhz)
* Corsair RM 650x PSU
* Corsair Carbide 200R Mid-Tower ATX Case
* Corsair H55 CPU Water Cooler
* ~~Fenvi FV-T919 AC1900 WiFi/Bluetooth PCIE Card~~ (*Do not use! See below.*)
* Fenvi FV-HB1200 AC1200 WiFi/Bluetooth PCIE Card

---

# What Works
* USB 3.0 Ports, front and rear, via custom SSDT (except for two rear ports which are set to USB 2.0 due to MacOS's 15-port limit)
* HDMI, via custom WhateverGreen framebuffer patch
* Audio I/O, front and rear, via AppleALC
* Intel UHD 630 OpenCL/Metal Hardware Acceleration
* Sleep/Wake
* NVRAM
* Continuity (I can't test all features, but can confirm SMS forwarding, FaceTime cellular calls, and AirPlay all work.)

# What Should Work (but I haven't tested)
* FileVault
* PS/2 Ports
* SATA HDDs

# What Doesn't Work
* Security Updates via Software Installer [(see below)](#note-about-security-updates)

---

# Quick Start
You'll need access to a computer running MacOS to prepare the USB installer. 

1. Format your USB drive with a GUID partition, and install the MacOS Mojave installer to it using the [Vanilla Method](https://hackintosh.gitbook.io/-r-hackintosh-vanilla-desktop-guide/gathering-kexts). 
    
2. Mount the USB installer's EFI partition, and clone this repository to it. 

3. [Generate an SMBIOS](https://khronokernel-2.gitbook.io/opencore-vanilla-desktop-guide/post-install/post-install/iservices) using [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS), and enter these values in the SMBIOS section of your config.plist.

4. Install MacOS!

---

# Not-So-Quick Start
You'll need access to a computer running MacOS to prepare the USB installer. 

## Prepare the USB Installer

1. Install the MacOS Mojave installer

    Make sure the USB drive has a GUID partition map. Get a copy of [Mojave](https://itunes.apple.com/us/app/macos-mojave/id1398502828?ls=1&mt=12) and prepare it using the [Vanilla Method](https://hackintosh.gitbook.io/-r-hackintosh-vanilla-desktop-guide/gathering-kexts).

2. Install Clover

    Get the latest version of [Clover Bootloader](https://github.com/CloverHackyColor/CloverBootloader/releases), and run the .pkg to install it to your USB drive.

    Only select these options, as we'll configure the rest in the next section.
    * Clover for UEFI booting only
    * Install Clover in the ESP 

### Configure the EFI Partition

**Required UEFI Drivers**
Place these in `/EFI/CLOVER/drivers/UEFI`
* [ApfsDriverLoader.efi](https://github.com/acidanthera/AppleSupportPkg/releases/tag/2.0.9)
    Required for reading APFS partitions
* [AppleGenericInput.efi](https://github.com/acidanthera/AppleSupportPkg/releases/tag/2.0.9)
    Required for FileVault and Apple Hot Key support
* [AppleUiSupport.efi](https://github.com/acidanthera/AppleSupportPkg/releases/tag/2.0.9)
    Required for FileVault support
* [AptioMemoryFix.efi](https://github.com/acidanthera/AptioFixPkg/releases) 
    Required for automatic KASLR slide calculation, and other memory fixes
* [VboxHfs.efi](https://github.com/acidanthera/AppleSupportPkg/releases/tag/2.0.9)
    Required for reading HFS+ partitions
* [VirtualSmc.efi](https://github.com/acidanthera/VirtualSMC/releases)
    Required for legacy bootloaders (this may not be necessary)

**Required Kexts**
Place these in `/EFI/CLOVER/kexts/Other`
* [AppleALC.kext](https://github.com/acidanthera/AppleALC/releases)
    Required for audio support
* [Lilu.kext](https://github.com/acidanthera/Lilu/releases)
    Required by other kexts like AppleALC, USBInjectAll, WhateverGreen
* [RealtekRTL8111.kext](https://github.com/Mieze/RTL8111_driver_for_OS_X/releases)
    Required for ethernet support
* SATA-200-series-unsupported.kext
    Required for legacy SATA HDDs. The SATA-300-series-unsupported.kext is probably more appropriate, but I can't locate the source.
* [SMCProcessor.kext](https://github.com/acidanthera/VirtualSMC/releases)
    Plugin for VirtualSMC.kext, required for CPU timing stuff (I think?)
* [SMCSuperIO.kext](https://github.com/acidanthera/VirtualSMC/releases)
    Plugin for VirtualSMC.kext, required for motherboard fan and sensor data
* [USBInjectAll.kext](https://github.com/RehabMan/OS-X-USB-Inject-All#downloads)
    Required for mapping USB ports and working around MacOS's 15-port limit. Needs custom SSDT.
* [VirtualSMC.kext](https://github.com/acidanthera/VirtualSMC/releases)
    Required by all Hackintoshes.
* [VoodooPS2Controller.kext](https://github.com/acidanthera/VoodooPS2/releases)
    Required for PS/2 support.
* [WhateverGreen.kext](https://github.com/acidanthera/whatevergreen/releases)
    Required for Intel UHD 630 support via HDMI

**Required SSDTs**
Compile the linked .dsl files with [MaciASL](https://github.com/acidanthera/MaciASL/releases), and place the resulting .aml files in `/EFI/CLOVER/ACPI/patched`
* [SSDT-EC-USBX](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/AcpiSamples/SSDT-EC-USBX.dsl)
    Required for Catalina, and for forcing USB power properties
* [SSDT-PMC](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/AcpiSamples/SSDT-PMC.dsl) 
    Required for NVRAM support
* [SSDT-UIAC](/includes/ACPI/patches/SSDT-UIAC.dsl)
    Required for USB support. See below.

### Create an SSDT for USBInjectAll
See [RehabMan's guide](https://www.tonymacx86.com/threads/guide-10-11-usb-changes-and-solutions.173616/) for instructions on how to create the SSDT for the Gigabyte Z390 UD. Skip the mapping step, and refer to [this blog post by David Allmon](https://davidallmon.com/projects/hack-build-2), but don't use his bootflag solution, as the SSDT will take care of that!

Alternatively, just download my premade SSDT:
* [Decompiled SSDT-UIAC.dsl](/includes/ACPI/patches/SSDT-UIAC.dsl)
* [Compiled SSDT-UIAC.aml](/EFI/CLOVER/ACPI/patched/SSDT-UIAC.aml)

### Create a UHD 630 Framebuffer Patch for WhateverGreen
See [CaseySJ's guide](https://www.tonymacx86.com/threads/guide-general-framebuffer-patching-guide-hdmi-black-screen-problem.269149/) for instructions on how to create the framebuffer patch and apply it to your `config.plist`.

Note that you may have to create a new patch or change the IGPU settings in BIOS (or both?) if you ever install a discrete graphics card! 

### Generate SMBIOS Settings
To get iServices working, we need a valid SMBIOS. Refer to the [Opencore Vanilla Desktop Guide](https://khronokernel-2.gitbook.io/opencore-vanilla-desktop-guide/post-install/post-install/iservices) for instructions on how to use [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS). I used system definition `iMac18,1`.

Enter the values generated by GenSMBIOS into the SMBIOS section of your config.plist

## Configure BIOS Settings
Adjust as necessary, but "Load Optimized Defaults" works okay to get started.

### Disable CFG-Lock
To get NVRAM working, we'll need to [manually disable CFG-Lock](https://khronokernel-2.gitbook.io/opencore-vanilla-desktop-guide/post-install/post-install/msr-lock).

Double check using the guide, but for my particular Gigabyte Z390 UD board, I needed to run the following in [Modified GRUB Shell](https://github.com/datasone/grub-mod-setup_var/releases):

```shell
setup_var_3 0x5C1 0x0
```

## Finally, Install!
Boot from the USB installer, and you should be good to go!

---

### Note about the Fenvi FV-T919
I chose this card because it works natively and was a cheaper alternative than other options. The card arrived a couple weeks after the rest of the components, and everything was working great until then! After installing the card, it introduced multiple power issues (shutdown on sleep, infinite reboot loop on shutdown, and random infinite reboot loop on power-on before it reaches the Gigabyte splash screen which indicates the problem isn't MacOS related). Enabling ERP and the Dummy Power Load options in BIOS fixed the reboot loop problems, but this wasn't ideal as now I couldn't use wake-on-LAN, wake-on-USB, etc, and I still couldn't put it to sleep. After finding [this thread](https://www.tonymacx86.com/threads/shutdown-and-sleep-issues-with-fenvi-fv-t919-wifi-card.268480/post-2023911), I decided to give the HB1200 a shot, and it works great!

---

### Note about Security Updates 
I tried installing the 2020-002 security update using Software Update, and it seemed to go okay at first, but after rebooting, I got a black screen instead of Clover. After multiple attempts, I concluded that the update somehow corrupted my Clover installation! The [workaround I found](https://www.tonymacx86.com/threads/cannot-install-security-update-2020-001-and-002-for-mojave.291231/post-2069067) is to navigate to `/Library/Updates`, and manually install the update packages. (In this case, SecUpd2020-002Mojave.pkg, and SecUpd2020-002Mojave.RecoveryHDUpdate.pkg.)

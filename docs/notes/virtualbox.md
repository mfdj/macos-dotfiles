### virtualbox settings

**Change the host-key to be Right-command**

- VirtualBox : Preferences : Input : Virtual Machine : Host Key Combination Right-command

### general guest settings

Guest needs to be powered off

**Disable Audio**

Select Guest : Settings : Audio : uncheck Enable Audio

**Chipset**



### useful aliases

- `VBoxManage` aliased `vb`
  - `VirtualBox` is a blocking gui-launcher

### modifying drives

**list all hard-drives**

```
vb list hdds
```

- noticed basic path scheme is `/Users/<user>/VirtualBox VMs/<machine>/<machine>.vdi`
- `vb modifyhd /Users/<user>/VirtualBox\ VMs/<machine>/<machine>.vdi --resize 81920` works on base images but [not snapshots](https://www.virtualbox.org/ticket/9103)
- article about resizing [osx guests](https://forums.virtualbox.org/viewtopic.php?f=22&t=64864)

**mounting an optical media via ISO**

- shutdown guest machine (Powered Off)
- Settings -> Storage -> Optical Disk -> Click on media icon (on right) to select ISO
- next start guest will have disk mounted

**restarting from optical media**

- restart OSX and start holding `c` key (needs to be held before **MACH BOOT** appears in scroll)
- you should see a Boot Manager
- select EFI CD/DVD
  - often the first time you attempt this it will boot directly to the OSX installer; on the second or third try it starts booting from the normal boot from disk screen where it allows you to access the terminal/disk-utility etc.

**resizing a drive with `gpt`**

1. [ref1](https://forums.virtualbox.org/viewtopic.php?f=22&t=64864)
2. [ref2](http://blog.kyodium.net/2010/11/increase-disk-and-partition-size-in.html))

- boot from osx-install-disk and access terminal
- see table of attached disks with `df`
- find disk by name like `/dev/disk<x>s<y> <n> <n> <p>% <n> <n> <p>% /Volumes/<machine-name>`
  - mine was something like `/dev/disk0s2  40263824 22083384 18180440 55% 2760421 2272555 55% /Volumes/el-cap`
- unmount it `diskutil unmountdisk /dev/disk0`
- show it's GPT info `gpt show /dev/disk0` (need this table handy to rebuild)
- reset the GPT info with `gpt destroy /dev/disk0` and `gpt create -f /dev/disk0`
- recreate the table with
  - copy the EFI System partition values to `gpt add -b <start1> -s <size1> -t C12A7328-F81F-11D2-BA4B-00A0C93EC93B /dev/disk0`
  - copy the HFS+ values to `gpt add -b <start2> -s <remaining> -t 48465300-0000-11AA-AA11-00306543ECAC /dev/disk0`
    - re. `<remaining>` assume an Apple Boot partition (Recovery HD) is `1432207` so add `expr <size2> + <size3> - 1432207` to get the correct size
  - unmount disk (again) `diskutil unmountdisk /dev/disk0`
  - copy Apple Boot partition values to `gpt add -b <start3> -s 1432207 -t 426F6F74-0000-11AA-AA11-00306543ECAC /dev/disk0`
  - then something along [these lines](http://apple.stackexchange.com/questions/209167/how-can-i-resize-a-partition-on-osx-10-10-5disk)
    - `diskutil repairVolume /dev/disk0s2`
    - `diskutil verifyVolume /dev/disk0s2`
    - `diskutil resizeVolume /dev/disk0s2 <size>G`

- http://superuser.com/questions/55561/how-can-i-change-the-bios-serial-number-in-virtualbox

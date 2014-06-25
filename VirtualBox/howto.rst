============================================
Rocks Cluster in VirtualBox 
============================================

+ Install VirtualBox software and Extensions per
  your downloaded version installations documents

+ Download VBox Guest Additions ISO (ex. VBoxGuestAdditions_4.3.10.iso)

Install Frontend
------------------

#. Download Rocks boot ISO form rocks web site

#. Create `vb-in.xml` file with your desired settings

#. Run script to create VM settings in VirtualBox::

      ./vb_cluster --type=frontend vb-in.xml 
      
#. Start VM either from a VBox Manager GUI console or::

      vboxmanager startvm <VMName>
    
#. When you see Rocks install screen proceed with normal rocks frontend install
   For public IP use your VBox next available IP. With the default VBox install
   these are the network settings to use (assume frontend is the  first VM that uses the first
   available IP)::
   
         IP = 10.0.3.15  
         gateway = 10.0.3.2  
         DNS server = 10.0.3.3  
         FQDN = fe.public (or any other name)
       
How to Install Guest Additions
----------------------------------

#. Mount Guest Additions ISO to your VM

   + In VirtualBox Manager Start VM for which you want to install extensions `fe611` 
   + In VirtualBox Manager window choose VM `fe611` from the VMs list  and
     click on the `Storage` tab. 
   + From the new VM storage window choose a controller
     that was configured to support CD/DVD drive and click on the CD/DVD image
     under it. This enables CD/DVD icon under `Attributes`.
   + Click on the CD/DVD  image to oepn a menu and choose "Choose a virtual CD/DVD disk file..."
     This opens a file browser window where you can find in your directory
     structure  guest additiosn ISO VBoxGuestAdditions_4.3.10.iso.  Click "Open"
     then in the `fe611 storage` window confirm "Ok"
   + Alternatively, use command line as ::

       vboxmanage storageattach fe611 --storagectl IDE --port 0 --device 0 --type \
              dvddrive --medium /path/to/vbox/ISO/VBoxGuestAdditions_4.3.10.iso

#. Install Guest Addiitons On guest VM `fe611`

   + Login on `fe611` VM as root 

   + Check that ISO is mounted ::  

        [root@fe Desktop]# mount  
        /dev/sda1 on / type ext4 (rw)  
        proc on /proc type proc (rw)  
        sysfs on /sys type sysfs (rw)  
        devpts on /dev/pts type devpts (rw,gid=5,mode=620)  
        tmpfs on /dev/shm type tmpfs (rw)  
        /dev/sda5 on /state/partition1 type ext4 (rw)  
        /dev/sda2 on /var type ext4 (rw)  
        tmpfs on /var/lib/ganglia/rrds type tmpfs (rw,size=501316000,gid=99,uid=99)  
        none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)  
        sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)  
        nfsd on /proc/fs/nfsd type nfsd (rw)  
        /dev/sr0 on /media/VBOXADDITIONS_4.3.10_93012 type iso9660 (ro,nosuid,nodev,uhelper=udisks,uid=0,gid=0,iocharset=utf8,mode=0400,dmode=0500)  
        data1 on /media/sf_data1 type vboxsf (gid=399,rw)  

        [root@fe Desktop]# ls /media/VBOXADDITIONS_4.3.10_93012/  
        32Bit         cert                   VBoxSolarisAdditions.pkg  
        64Bit         OS2                    VBoxWindowsAdditions-amd64.exe  
        AUTORUN.INF   runasroot.sh           VBoxWindowsAdditions.exe  
        autorun.sh    VBoxLinuxAdditions.run VBoxWindowsAdditions-x86.exe  

   + Install Guest Additions ::

        [root@fe Desktop]# /media/VBOXADDITIONS_4.3.10_93012/VBoxLinuxAdditions.run   
        Verifying archive integrity... All good.  
        Uncompressing VirtualBox 4.3.10 Guest Additions for Linux............  
        VirtualBox Guest Additions installer  
        Copying additional installer modules ...  
        Installing additional modules ...  
        Removing existing VirtualBox non-DKMS kernel modules       [  OK  ]  
        Building the VirtualBox Guest Additions kernel modules  
        Building the main Guest Additions module                   [  OK  ]  
        Building the shared folder support module                  [  OK  ]  
        Building the OpenGL support module                         [  OK  ]  
        Doing non-kernel setup of the Guest Additions              [  OK  ]  
        Starting the VirtualBox Guest Additions                    [  OK  ]  
        Installing the Window System drivers  
        Installing X.Org Server 1.13 modules                       [  OK  ]  
        Setting up the Window System to use the Guest Additions    [  OK  ]  
        You may need to restart the hal service and the Window System (or just restart  
        the guest system) to enable the Guest Additions.  

        Installing graphics libraries and desktop services componen[  OK  ]  

   + Verify that mount works  ::

        [root@fe Desktop]# ls /media  
        sf_data1  VBOXADDITIONS_4.3.10_93012  

	 There is now expected `sf_data1` mounted under /media

   + Copy the script to local direcotry (for installing guest additions on compute nodes) ::

        [root@fe Desktop]# mkdir /share/apps/root   
        [root@fe Desktop]# cp /media/VBOXADDITIONS_4.3.10_93012/VBoxLinuxAdditions.run /share/apps/root  

   + Unmount CD: ::

	    click on `Eject` on the `VBOXADDITIONS_4.3.10` window (on VM Desctop) 
	    or  
	    [root@fe Desktop]# umount /media/VBOXADDITIONS_4.3.10_93012/  

   + To install guest additions on compute nodes: ::

        [root@fe Desktop]# rocks run host compute /share/apps/root/VBoxLinuxAdditions.run  

     Note: compute nodes must be installed with the same shared folder enabled as the frontend

#. In VirtualBOx Manger remove the disk from virtual drive in `fe611 Storage` using 
   `Attributes` menu
	

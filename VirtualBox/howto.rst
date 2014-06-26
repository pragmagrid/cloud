.. highlight:: rest

Rocks Cluster in VirtualBox
-----------------------------

#. **Prerequisites**

   + Install VirtualBox software and Extensions per
     your downloaded version installations documents
   + Download VBox Guest Additions ISO (ex. VBoxGuestAdditions_4.3.10.iso)

#. **Install Frontend**

   #. Download Rocks boot ISO form rocks web site

   #. Create ``vb-in.xml`` file with your desired settings

      There is vb-in.template file that is provided for building a frontend and 2 compute nodes.
      See details in the section `File vb-in.xml` below

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
 
#. **Install compute nodes**

   #. use the same vb-in.xml file that was created for installing frontend, it has a separate section
      for compute nodes.
   
   #. Run script to create VM settings in VirtualBox::

         ./vb_cluster --type=compute vb-in.xml 
      
   #. On the frontend VM ::

         insert-ethers
   
      Start first compute node VM either from VBox Manager gui or ::  

         vboxmanager startvm <VMName>

      Quit insert-ethers once all compute nodes that need to be installed are "discovered"
   
   
#. **Install Guest Additions**

   Guest Additiosn allow to mount directories from the host computer to the guest VM and transfer files
   between the two. If you don't need mounting from the host skip this section.

   #. Mount Guest Additions ISO to your VM using one of two methods:

      #. Via VirtualBox Manager GUI console
   
         + In VirtualBox Manager console start VM for which you want to install extensions
           and after it boots choose  this VM from the VMs list  and
           click on the ``Storage`` tab. 
         + From the new ``VMname storage`` window choose a controller
           that was configured to support CD/DVD drive and click on the CD/DVD image
           under it. This enables CD/DVD icon under ``Attributes``.
         + Click on the CD/DVD  image to open a menu and choose ``Choose a virtual CD/DVD disk file...``
           In opened file browser window locate in your directory
           structure the  guest additiosn ISO VBoxGuestAdditions_4.3.10.iso.  Click ``Open``
           then in the ``VMname storage`` window confirm by clicking ``Ok``
   
      #. Via command line. Need to provide VM name, controller specifications
         and ISO location, for example ::
   
          vboxmanage storageattach VMname --storagectl IDE --port 0 --device 0 --type \
                    dvddrive --medium /path/to/vbox/ISO/VBoxGuestAdditions_4.3.10.iso

   #. Install Guest Addiitons On guest VM ``VMname``

      + Login on ``VMname`` VM as root 
      + Check that ISO is mounted ::  

         # mount  
         /dev/sda1 on / type ext4 (rw)  
         proc on /proc type proc (rw)  
         sysfs on /sys type sysfs (rw)  
         ...
         /dev/sr0 on /media/VBOXADDITIONS_4.3.10_93012 type iso9660 (ro,nosuid,nodev,uhelper=udisks,uid=0,gid=0,iocharset=utf8,mode=0400,dmode=0500)  
         data1 on /media/sf_data1 type vboxsf (gid=399,rw)  
             
         # ls /media/VBOXADDITIONS_4.3.10_93012/  
         32Bit         cert                   VBoxSolarisAdditions.pkg  
         64Bit         OS2                    VBoxWindowsAdditions-amd64.exe  
         AUTORUN.INF   runasroot.sh           VBoxWindowsAdditions.exe  
         autorun.sh    VBoxLinuxAdditions.run VBoxWindowsAdditions-x86.exe  
   
      + Install Guest Additions ::
   
         # /media/VBOXADDITIONS_4.3.10_93012/VBoxLinuxAdditions.run   
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
   
         # ls /media  
         sf_data1  VBOXADDITIONS_4.3.10_93012  
   
	There is now expected ``sf_data1`` mounted under /media for a directory that was
	specified in ``Shared Folders`` settings with name ``data1``.

      + Copy the script to local directory (for installing guest additions on compute nodes) ::

         # mkdir /share/apps/root   
         # cp /media/VBOXADDITIONS_4.3.10_93012/VBoxLinuxAdditions.run /share/apps/root  
   
      + Unmount CD::
   
	     click on ``Eject`` on the ``VBOXADDITIONS_4.3.10`` window (on VM Desktop) 
	     or  
	     # umount /media/VBOXADDITIONS_4.3.10_93012/  
   
      + To install guest additions on compute nodes run on frontend ::
   
         # rocks run host compute /share/apps/root/VBoxLinuxAdditions.run  
   
        Note: frontend and compute nodes must have the same shared folders enabled 
   
   #. In VirtualBox Manager remove the disk from virtual drive in ``VMname Storage`` using 
      ``Attributes`` menu
	
#. **File vb-in.xml**

   This file is a set of parameters used  to describe frontend and compute nodes
   VM images of the cluster. The file is parsed by the ``vb_cluster`` script and the values
   are used to create all vboxmanage commands needed to define and register VMs
   with the VirtualBox. Most values are working defaults that don't need changes.::

     <vbc version="0.1">  
      <vm name="x" private="y">  
               describes generic info for the cluster  
               Name refers to VM name, private is a name of internal network   
               Both are relevant on VBox side, not inside the cluster  
         <iso os="Linux_64" path="/path/to/boot-6.1.1.iso"/>  
                  type of VM's os and Rocks boot ISO path  
         <shared name="data1" path="/some/path1/data1"/>  
                  host directory from path  will be automounted on guest VM as /mediasf_data1 
         <shared name="data2" path="/some/path2/data2"/>  
                  host directory  from path will be automounted on guest VM as /media/sf_data2  
         <enable cpuhotplug="on" />  
                  enables changing cpus number on powered off and running VM  
      </vm>    
        
      <frontend cpus="2">  
               number of cpus 
         <memory base="2000" vram="32" />  
               allocate base and video memory to VM  
         <boot order="dvd disk none none" />  
               boot order   
         <private nic="intnet" nictype="82540EM" nicname="default"/>  
               NIC default settings for private network   
         <public nic="nat" nictype="82540EM" />  
               NIC defult settings for public network  
         <hd  size="50000" variant="Standard"/>  
               disk image size and type  
         <syssetting mouse="usbtablet" audio="none"/>  
               mouse and audio  
         <storage name="SATA" type="sata" controller="IntelAhci" attr="hdd" port="0" device="0"/>  
               information for VM disk image  
         <storage name="IDE" type="ide" controller="PIIX4" attr="dvddrive" port="0" device="0"/>  
               information for VM CD/DVD drive  
      </frontend>  
        
      <compute cpus="1" count="2">  
               number of cpus per compute node and number of compute nodes to create  
         <memory base="1000" vram="32" />  
               allocate base and video memory to VM  
         <boot order="net disk none none" />  
               boot order  
         <private nic="intnet" nictype="82540EM" nicname="default"/>  
               NIC settings for private network  
         <hd  size="50000" variant="Standard"/>  
               disk image size  
         <syssetting audio="none"/>  
               audio   
         <storage name="SATA" type="sata" controller="IntelAhci" attr="hdd" port="0" device="0"/>  
               information for VM disk image  
      </compute>   
     </vbc>  

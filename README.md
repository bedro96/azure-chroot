### Azure-chroot in Packer v.1.6.0.
* [Packer Official Documentation](https://www.packer.io/docs/builders/azure/chroot)

Following scripts has been tested with Ubuntu 18.04.

```bash
### Clone this git
git clone https://github.com/bedro96/azure-chroot.git
### Move to folder created as azure-chroot.
cd azure-chroot
### Refer to https://www.packer.io/downloads for most resent linux build. 
wget https://releases.hashicorp.com/packer/1.6.0/packer_1.6.0_linux_amd64.zip
sudo apt-get install -y unzip
sudo mv packer /usr/bin
rm packer_1.6.0_linux_amd64.zip
### packer version check
packer --version
```

### Compose init_chroot.sh file as a env setup file
Please update with your environment information.
For creating Azure Service Principal, refer to this [link](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest#password-based-authentication).

```bash
#init_chroot.sh
#!/bin/bash

export ARM_CLIENT_ID=f5202f78-5383-4463-9d2d-4d88461cxxxx
export ARM_CLIENT_SECRET=580afef1-8dfe-4858-9a01-72f503c2xxxx
export ARM_SUBSCRIPTION_ID=05be085b-86ea-4336-addc-38fd5605xxxx
export ARM_RESOURCE_GROUP=imgRepoRG
export ARM_SOURCE_DISK_RESOURCE_ID="/subscriptions/05be085b-86ea-4336-addc-38fd5605xxxx/resourceGroups/UBUNTUVM02RG/providers/Microsoft.Compute/disks/ubuntuvm03_disk1_9358259837ee45f3a5bf0c9fafea1aa2"
```
Load environment variables which is referenced by json template files.
```bash
source ./init_chroot.sh
```
To execute packer, you need root privilege. Execute with sudo -E.
```bash
sudo -E packer build template.json
```

### Exmaple 1) Source from managed disk and create a Azure managed custom image.
This would be best if packer resides on one of the Azure vm which you want to make the master image from.
With this code, you would make a specialized image but it will provision like a generalized image.
So when this images is deployed the hostname will be changed accordingly but the users' information like authorized_keys will remain. 
```bash
sudo -E packer build example_1.6.0_ubuntu1804.json
```

This is a example code to deploy a VM from the image.
```bash
az vm create -n ubuntuvm04 -g ubuntuvm02rg -l koreacentral --admin-username kunhokoxxx --ssh-key-values @~/.ssh/id_rsa.pub --image /subscriptions/05be085b-86ea-4336-addc-38fd5605xxxx/resourceGroups/imgRepoRG/providers/Microsoft.Compute/images/ubuntu1804img-1593952516
```

### Exmaple 2) Source from managed disk and create a SIG image version.
This would be ideal if you want to stick to specialized image and building the very first image, 
and need to leverage replication feature of Shared Image Gallery.
As this image will be treated as specialize image, the hostname will be preserved as well as user info, making identical twin.
The only fallback is that it takes some time to upload the image.
```bash
sudo -E packer build ubuntu1804disktosig.json
```

### Exmaple 3) Source from managed disk and create a Azure managed custom image.
This would be ideal if you want to update image version on Shared Image Gallery.
```bash
sudo -E packer build ubuntu1804sigtosig.json
```
This is example code to deploy a VM form SIG.
```bash
az vm create -n ubuntuvm08 -g ubuntuvm02rg -l koreacentral --image /subscriptions/05be085b-86ea-4336-addc-38fd5605xxxx/resourcegroups/imgreporg/providers/microsoft.compute/galleries/ubuntu1804sig/images/ubuntu1804image/versions/0.0.8 --specialized
```

### Ubuntu image hasving issue with name resolution.
To mitigate this issue, a scipt has been implmented in ``` /etc/init.d/fixresolv.conf ``` and created a symbolic link ```/etc/rc5.d/S01fixresolv.conf```. Depending on your linux dist., you need to adjust the script accordingly. This happens when resolv.conf is copied to Packer build and get deleted during clean up. There is workaround to pass empty string for ``` "copy_files" but this would be only viable solution when Packer providers doesn't require name resolution.
```bash 
### file: fixresolv.conf
#!/bin/sh

ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
########################
```
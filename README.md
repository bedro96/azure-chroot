### Azure-chroot on Packer v.1.6.0.
..* [Packer Official Documentation]: https://www.packer.io/docs/builders/azure/chroot
```bash
### clone git
git clone https://github.com/bedro96/azure-chroot.git
### folder called azure-chroot is created.
cd azure-chroot
### https://www.packer.io/downloads 
wget https://releases.hashicorp.com/packer/1.6.0/packer_1.6.0_linux_amd64.zip
sudo apt-get install -y unzip
sudo mv packer /usr/bin
rm packer_1.6.0_linux_amd64.zip
### packer version check
packer --version
```

### compose a init_chroot.sh file as a env setup file
```bash
#init_chroot.sh
#!/bin/bash

export ARM_CLIENT_ID=f5202f78-5383-4463-9d2d-4d88461cxxxx
export ARM_CLIENT_SECRET=580afef1-8dfe-4858-9a01-72f503c2xxxx
export ARM_SUBSCRIPTION_ID=05be085b-86ea-4336-addc-38fd5605xxxx
export ARM_RESOURCE_GROUP=imgRepoRG
export ARM_SOURCE_DISK_RESOURCE_ID="/subscriptions/05be085b-86ea-4336-addc-38fd5605xxxx/resourceGroups/UBUNTUVM02RG/providers/Microsoft.Compute/disks/ubuntuvm03_disk1_9358259837ee45f3a5bf0c9fafea1aa2"
```
Load environment variables used in json template.
```bash
source ./init_chroot.sh
```
To execute packer you need root privilege. Execute with sudo -E.
```bash
sudo -E packer build ubuntu1804disktosig.json
```

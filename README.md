### Excute following command from provisioned image

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
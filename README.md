### Excute following command from provisioned image

```bash
### clone git
git clone https://github.com/bedro96/azure-chroot.git
### folder called azure-chroot is created.
cd azure-chroot
chmod +x download_packer.sh
./download_packer.sh
COMPUTENAME=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance/compute/name?api-version=2017-08-01&format=text")
sed -i -e "s/ubuntu1640/$COMPUTENAME/g" ~/azure-chroot/example.json
sudo ./packer build example.json
```
### Reference
https://docs.microsoft.com/en-us/azure/virtual-machines/windows/instance-metadata-service

#!/bin/bash

curl "https://arandom100419.blob.core.windows.net/blobs/packer_linux_amd64?sp=r&st=2019-10-04T23:41:09Z&se=2019-11-09T08:41:09Z&spr=https&sv=2018-03-28&sig=cxDjVgrhZiA2gyAHdfMkapPvwSuzENWmwPpUQ1pOKYs%3D&sr=b" -o packer
sudo chmod +x packer

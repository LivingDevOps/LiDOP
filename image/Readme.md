#Image

## Prerequisites

The following Software must be installed to create LiDOP
- Packer https://www.packer.io/

## Build image
```
git clone https://github.com/LivingDevOps/LiDOP.git
cd lidop/image
packer build lidop.[on|off]line.json
```
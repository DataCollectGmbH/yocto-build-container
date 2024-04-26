# yocto-build container
Docker Container for Yocto Build

## Prerequisites

Mount your yocto directory to /yocto in the container.


Something like:

```shell    
docker run -v /path/to/yocto:/yocto -it ghcr.io/datacollectgmbh/yocto-build-container  <COMMAND>
```


## Build YOCTO with this image

```shell
export TEMPLATECONF=/yocto/templates/<YOUR_TEMPL_DIR> && source /yocto/sources/poky/oe-init-build-env build && bitbake <YOUR_IMAGE_NAME>
``` 

## Clean Build

```shell
source /yocto/sources/poky/oe-init-build-env /yocto/build && bitbake -c cleanall world --continue
```

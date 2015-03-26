# Ralph Docker image configuration

Build docker container to Ralph application

Build docker base image. Base image has the all packages to run Ralph:
```
sudo ./run.sh build base
```

Build docker os image. Os is the sample image data and prepared for scanning (ssh_linux, dns_hostname, snmp):
```
sudo ./run.sh build os
```

Initialize image:
```
sudo ./run.sh init os
```

Start container:
````
sudo ./run.sh start os
```

Open docker (/bin/bash):
```
sudo ./run.sh exec os
```

Upgrade Ralph to new version:
```
sudo ./run.sh upgrade os
```

See more information to Ralph installation: http://ralph.readthedocs.org/en/latest/installation.html 


It is an Open Source project provided on Apache v2.0 License.
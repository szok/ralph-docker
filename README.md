# Ralph Docker image configuration

Build docker container to Ralph application

Before running the script, you must change the configuration file.

Rename file config.json.example to config.json and chnage it:

```
"REPOSITORIES_TYPES": {
    "github": "https://github.com/%(fork)s/%(repo_name)s.git -b% (branch) s"
}
```
Set the url to clone repositories

In the key REPOSITORIES are all repositories that cloning at startup image
```
{
    "owner": "allegro"
    "default_branch": "develop"
    "type": "github"
    "repo_name": "django-bob"
}
```

owner - username from Github
default_branch - default name of branch
type - github (url from REPOSITORIES_TYPES)
repo_name - the name of the repository

You can change the settings before starting for each repository by environmental variables

```
export RALPH_FORK = 'my_fork'
export RALPH_BRANCH = 'my_branch'
```

Then the image of Docker will be built with your changes



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

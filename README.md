# us-right-media-config

This repo contains most of the files required for setting up  US right-wing media project's containers. <br>
The exceptions are the two INCA files, `dockerfile-inca` and `requirements_docker.txt`. <br>

### clone the project-related directories
- create a new directory on your machine and clone these four repos into it. The `inca`, `urlExpander`, and `us-right-media` subdirectories will be mounted to the `inca-myusername` container. <br>
  - https://github.com/wlmwng/inca (usrightmedia/[branch])
  - https://github.com/wlmwng/urlExpander (develop)
  - https://github.com/wlmwng/us-right-media (develop)
  - https://github.com/wlmwng/us-right-media-config (main)

- If you're reviewing a PR, please use `git switch <branch>` to get that version of the repo.

### copy `02-intermediate-data.tar.gz` from the server
- To use the scraping scripts in `<PATH-TO-CLONED-REPO>/us-right-media/usrightmedia/code/04-inca-prep`, copy the compressed data file from the server (378M).
  - does this command work for you too?
```
rsync -chavzP --stats <USERNAME>@tux02ascor.fmg.uva.nl:/home/wailam/us-right-media/usrightmedia/data/02-intermediate-data.tar.gz <PATH-TO-CLONED-REPO>/us-right-media/usrightmedia/data
```
- decompress the file
```
tar -xvzf 02-intermediate-data.tar.gz
```


### setup the config directory
- navigate to `us-right-media-config` directory and add a `.env` file with the following lines
```
COMPOSE_PROJECT_NAME=usrightmedia
USERNAME=myusername
JUPYTER_TOKEN=changeme
```

- while inside the `us-right-media-config` directory, bring up the containers with Docker Compose version 1.27.4
```
docker-compose up -d
```

Check `docker ps` to see if the 4 containers spun up as expected.
```
CONTAINER ID   IMAGE                                             COMMAND                  CREATED          STATUS          PORTS                                NAMES
13127b1c76ad   myusername/us-right-media:kibana-enhanced-6.8.0   "/usr/local/bin/kiba…"   43 seconds ago   Up 42 seconds   127.0.0.1:5601->5601/tcp             kibana-myusername
faff3cf7f453   myusername/us-right-media:inca                    "tini -g -- start-no…"   44 seconds ago   Up 42 seconds   127.0.0.1:8889->8888/tcp             inca-myusername
1898d7fa11d5   myusername/us-right-media:jupyter                 "tini -g -- start-no…"   44 seconds ago   Up 42 seconds   127.0.0.1:8888->8888/tcp             jupyter-myusername
861f92e330db   myusername/us-right-media:elasticsearch-6.8.0     "/usr/local/bin/dock…"   44 seconds ago   Up 43 seconds   127.0.0.1:9200->9200/tcp, 9300/tcp   elasticsearch-myusername
```
- Jupyter minimal-notebook at [localhost:8888](http://localhost:8888/)
- Jupyter INCA at [localhost:8889](http://localhost:8889/)
- Elasticsearch at [localhost:9200](http://localhost:9200/)
- Kibana at [localhost:5601](http://localhost:5601/)


### setup the INCA container
4. access the INCA container as root (just in case you want to use root privileges). <br>
  For example, I installed a few packages after already building the container:
  - `ncdu`: disk utility
  - `tmux`: terminal multiplexer used for running scraping scripts in background
```
docker exec -it --user root inca-myusername /bin/bash
apt-get update && \
apt-get install -y tmux ncdu
```

- switch to the non-root user (`jovyan`) and add its bin directory to `PATH`
```
cd /home/jovyan/work
su jovyan
export PATH="$HOME/.local/bin:$PATH"
echo $PATH
```

- install INCA's requirements
```
python3 -m pip install -r ./inca/requirements_docker.txt
```

- install `inca`, `urlExpander`, and `us-right-media` as editable packages inside the container
```
python3 -m pip install -e ./inca
python3 -m pip install -e ./urlExpander
python3 -m pip install -e ./us-right-media
```

### help with troubleshooting?
- Initially, the INCA container was going to be the only container used for scraping, analyzing, etc. I currently have another `jupyter-myusername` container though, because I'm having trouble getting the INCA installation working with JupyterLab (more notes in `docker_inca_init.sh`).
- For now, the INCA container is just used for running the scraping scripts using `jovyan`'s python3 installation.
- What I've tried: I made a virtual environment and added its Python as a new kernel - it unfortunately fails to start. I think the problem might be due to a dependency conflict for the `tornado` package? If you know of a way around this, that'd be great to know!

```
su jovyan
pip install virtualenvwrapper==4.8.4
```

```
# https://virtualenvwrapper.readthedocs.io/en/latest/install.html#quick-start
# Add these lines to the shell startup file (.bashrc, .profile, etc.)
# to set the location where the virtual environments should live,
# the location of your development project directories,
# and the location of the script installed with this package:
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/work
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3.8
export VIRTUALENVWRAPPER_VIRTUALENV=/home/jovyan/.local/bin/virtualenv
source /home/jovyan/.local/bin/virtualenvwrapper.sh
```
```
nano /home/jovyan/.bashrc
nano /home/jovyan/.profile
```
- make the virtualenvironment
```
source ~/.bashrc
mkvirtualenv usrightmedia
pip list
```
- install the requirements and repos
```
python3 -m pip install -r ./inca/requirements_docker.txt
python3 -m pip install -e ./inca
python3 -m pip install -e ./urlExpander
python3 -m pip install -e ./us-right-media
```

- try to add `usrightmedia` as a kernel

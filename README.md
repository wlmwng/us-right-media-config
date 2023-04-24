# us-right-media-config

This repo contains most of the files required for setting up  US right-wing media project's containers. <br>
The exceptions are the two INCA files, `dockerfile-inca` and `requirements-docker.txt`. <br>

## Clone the project-related repositories
- create a new directory on your machine and clone these four repos into it. The `inca`, `urlExpander`, and `us-right-media` subdirectories will be mounted to the JupyterLab container. <br>
  - https://github.com/wlmwng/inca (`usrightmedia/[branch]`)
  - https://github.com/wlmwng/urlExpander (`news_api`)
  - https://github.com/wlmwng/us-right-media (`develop`)
  - https://github.com/wlmwng/us-right-media-config (`main`)
    - `docker-compose.yml` does not have memory limits as it runs on the server <br>
      `docker-compose up -d`
    - `docker-compose-dev.yml` does not have memory limits as it runs on the server <br>
      `docker-compose -f docker-compose-dev.yml up -d`
    - `docker-compose-local.yml` is useful for local testing by limiting each container's memory usage to 2GB <br>
      `docker-compose -f docker-compose-local.yml up -d`

## Create the Docker containers
### 1. Setup the config directory
- Navigate to the `us-right-media-config` directory and add a `.env` file with the following lines
```
COMPOSE_PROJECT_NAME=usrightmedia
USERNAME=myusername
JUPYTER_TOKEN=changeme
```

- Bring up the containers with Docker Compose version 1.27.4
```
docker-compose up -d
```

- Check `docker ps` to see if the 3 containers spun up as expected.
```
CONTAINER ID   IMAGE                                             COMMAND                  CREATED          STATUS          PORTS                                NAMES
13127b1c76ad   myusername/us-right-media:kibana-enhanced-6.8.0   "/usr/local/bin/kiba…"   43 seconds ago   Up 42 seconds   127.0.0.1:5601->5601/tcp             kibana-myusername
1898d7fa11d5   myusername/us-right-media:inca                    "tini -g -- start-no…"   44 seconds ago   Up 42 seconds   127.0.0.1:8888->8888/tcp             inca-myusername
861f92e330db   myusername/us-right-media:elasticsearch-6.8.0     "/usr/local/bin/dock…"   44 seconds ago   Up 43 seconds   127.0.0.1:9200->9200/tcp, 9300/tcp   elasticsearch-myusername
```
- Jupyter datascience-notebook at [localhost:8888](http://localhost:8888/)
- Elasticsearch at [localhost:9200](http://localhost:9200/)
- Kibana at [localhost:5601](http://localhost:5601/)


### 2. Setup the JupyterLab container (`inca-myusername`)
1. The Dockerfile for this container takes some steps to avoid some errors when installing INCA (i.e., downloading external libraries, modifying header files)
2. Open a terminal in JupyterLab which runs as the non-root `jovyan` user
3. Deactivate the base conda environment
```
conda deactivate
```
4. Create a new conda environment called "usrightmedia" (python 3.8 is used because `cymem` fails to build with the Docker image's default version of Python 3.9)
```
conda create --name usrightmedia python=3.8.12
conda activate usrightmedia
```
5. Make the "Python 3.8 (usrightmedia)" kernel visible in JupyterLab
``` 
conda install ipykernel==6.4.1
python -m ipykernel install --user --name usrightmedia --display-name "Python 3.8 (usrightmedia)"
```
6. Check that the "usrightmedia" virtual environment's pip is active
```
which pip 
pip list
```
7. Downgrade setuptools to avoid an error when installing INCA [(Stack Overflow post)](https://stackoverflow.com/a/69100830)
  - "anyjson setup command: use_2to3 is invalid"
```
pip install setuptools==57.5.0
```
8. Install the requirements for INCA
```
pip install -r ./inca/requirements-docker.txt
```
9. Update ipython so it is compatible with ipykernel
```
# ERROR: pip's dependency resolver does not currently take into account all the packages that are installed. 
# This behaviour is the source of the following dependency conflicts.
# ipykernel 6.4.1 requires ipython<8.0,>=7.23.1, but you have ipython 7.9.0 which is incompatible.

pip install ipython==7.23.1
```
10. Install the project's packages in editable mode
```
pip install -e ./inca
pip install -e ./urlExpander
pip install -e ./us-right-media
```
11. At this point, INCA should work in the terminal. However, the kernel will fail to start in JupyterLab due to a dependency conflict.
```
pip install tornado==6.1
ERROR: pip's dependency resolver does not currently take into account all the packages that are installed. This behaviour is the source of the following dependency conflicts.
flower 0.9.1 requires tornado==4.2.0, but you have tornado 6.1 which is incompatible.
```
12. Uninstall the `flower` package, which is a monitoring tool for `celery`. The package isn't necessary for the project's use of INCA.
```
pip uninstall flower 
```

13. The new kernel should successfully start now. Create a Jupyter notebook, select the new kernel, and run:
```
from inca import Inca
myinca = Inca()
```

### 3. Expand URLs which were (re-)tweeted by congressional Republicans

1. Log into the JupyterLab container as root

```
docker exec -it --user root inca-myusername /bin/bash
```

2. Install `tmux` and `ncdu` (optional)
```
apt-get update && \
apt-get install -y tmux ncdu
```
3. Navigate to the directory containing the URL expansion script (`04-expand-urls.py`)
```
cd /home/jovyan/work/us-right-media/usrightmedia/code/02-twitter
```

4. Create terminal with `tmux`
```
tmux new -s expand_tweeted_urls        # creates a terminal named "expand_tweeted_urls"
conda activate usrightmedia            # activate the usrightmedia environment
python 04_expand_tweeted_urls.py &     # run the script as a background process using "&"
```
- Useful `tmux` commands:
  - Re-attach: `tmux attach -t <name>`
  - Detach from a `tmux` terminal: `Ctrl-b + d `
  - To kill a pane: `Ctrl-b + x`
  - To cleanly and gracefully kill all tmux open sessions (and server): `tmux kill-server`
  - Kill the scraping processes by finding the relevant PIDs: `ps -ef | grep python` and then run `kill <PID>`

### 4. Scrape media outlets' URLs

1. Log into the JupyterLab container as root

```
docker exec -it --user root inca-myusername /bin/bash
```

2. If needed, install `tmux` and `ncdu` (optional)
```
apt-get update && \
apt-get install -y tmux ncdu
```

3. Navigate to the directory containing the scraping scripts
```
cd /home/jovyan/work/us-right-media/usrightmedia/code/04-inca-prep
```

4. Create terminals with `tmux`
- The Media Cloud URLs are divided by publish year. Scraping is parallelized by running Python scripts in `tmux` terminals.
- Time estimate: 38.5 days
  - number of URLs: 924,115
  - fetch rate: ~1,000 URLs/hour
    - Kibana is used to monitor data collection. To check that request aren't sent too quickly to each outlet, a visualization shows that the gap between HTTP requests to the same outlet is ~10 seconds or more per outlet. The Kibana objects are available in this repo's `kibana/kibana-objects.json` file.
  - The URLs are included in the `02-intermediate-data.tar.gz` file (see download instructions). Unpack the archive into the `../us-right-media/usrightmedia/data/02-intermediate` directory. The URLs will be in `04-inca-prep`.

```
tmux new -s scrape_2016       # creates a terminal named "scrape_2016"
conda activate usrightmedia   # activate the usrightmedia environment
python scrape_2016.py &       # run the script as a background process using "&"

tmux new -s scrape_2017
conda activate usrightmedia
python scrape_2017.py &

tmux new -s scrape_2018
conda activate usrightmedia
python scrape_2018.py & 

tmux new -s scrape_2019
conda activate usrightmedia
python scrape_2019.py & 

tmux new -s scrape_2020
conda activate usrightmedia
python scrape_2020.py & 
```

## Copy the data files (restricted)
- Access is limited to project collaborators who have SSH access to the Amsterdam School of Communication Research server (tux02ascor.fmg.uva.nl)
- Terms of Use:
  - [Media Cloud](https://mediacloud.org/terms-of-use)
  - [Twitter](https://developer.twitter.com/en/developer-terms/more-on-restricted-use-cases)

### `01-raw-data.tar.gz` (72MB): stories from Media Cloud
- All stories from 13 right-wing media outlets from 2016-2020 are collected through [Media Cloud's API](https://github.com/mediacloud/api-client)

|outlet|media_id|story_count|
|---|---|---|
|American Renaissance|26186|9865|
|Breitbart|19334|150281|
|Daily Caller|18775|122278|
|Daily Stormer|113988|15641|
|Fox News|1092|284283|
|Gateway Pundit|25444|39689|
|Infowars|18515|28597|
|Newsmax|25349|71093|
|One America News|127733|117775|
|Rush Limbaugh|24669|9268|
|Sean Hannity|28136|29712|
|VDARE|24641|20525|
|Washington Examiner|6443|74479|


### `02-intermediate-data.tar.gz` (378M): congressional Republicans' (re-)tweeted URLs and Media Cloud URLs used for scraping
- The Twitter usernames of congressional Republicans who served during the 2016-2020 period are collected from [unitedstates/congress-legislators](https://github.com/unitedstates/congress-legislators). Their full timelines on Twitter are collected using Twitter's API v2 (academic track).The data are collected through a Twitter2 client in INCA which stores the data in Elasticsearch.
- Each story from Media Cloud is associated with a URL. Stories which are not news articles, which are duplicates, and/or which don't have a publication timestamp are filtered out before the scraping process starts.
- The compressed tar archive contains all the data files created when:
  1. extracting (re-)tweeted URLs, and
  2. preparing Media Cloud's URLs for scraping with INCA.

1. use rsync to transfer the file to your machine
```
rsync -chavzP --stats <USERNAME>@tux02ascor.fmg.uva.nl:/home/wailam/us-right-media/usrightmedia/data/02-intermediate-data.tar.gz <PATH-TO-CLONED-REPO>/us-right-media/usrightmedia/data
```
2. decompress the file
```
tar -xvzf 02-intermediate-data.tar.gz
```

### `esdata-wailam-20211210.tar.gz` (13 GB): copy a snapshot of the collected data to hydrate a local Elasticsearch container
- The compressed tar archive is a backup of a Docker volume. It contains:
  - 889,739 tweet objects from the accounts of congressional Republicans
  - 924,027 scraped documents from 13 outlets
    |Publish year|Count|
    |----|-------|
    |2016|153,352|
    |2017|185,598|
    |2018|165,953| 
    |2019|160,388| 
    |2020|258,736| 

1. make a `volumes_backup` directory
```
cd <PATH-TO-CLONED-REPO>
mkdir volumes_backup
```

2. use rsync to transfer the file to your machine
```
rsync -chavzP --stats <USERNAME>@tux02ascor.fmg.uva.nl:/home/wailam/volumes_backup/esdata-wailam-20211210.tar.gz <PATH-TO-CLONED-REPO>/volumes_backup
```

3. restore the Elasticsearch container by removing any existing data volume and replacing it with a new volume containing the backup data [(see the demo instructions)](https://github.com/wlmwng/docker-elastic-demo#restore-from-backup)

### `esdata-wailam-20230423.tar.gz` (35 GB): copy a snapshot of the collected data to hydrate a local Elasticsearch container
- The compressed tar archive is a backup of a Docker volume. It contains:
  - 889,739 tweet objects from the accounts of congressional Republicans
  - 924,027 scraped documents from 13 outlets
    |Publish year|Count|
    |----|-------|
    |2016|153,352|
    |2017|185,598|
    |2018|165,953| 
    |2019|160,388| 
    |2020|258,736| 
- This volume's data is the final version of the dataset used to produce the analyses. Article documents in this volume contain analysis-related fields such as `should_include`, `softcos06_id`, and `tweets2_url_ids`.

1. make a `volumes_backup` directory
```
cd <PATH-TO-CLONED-REPO>
mkdir volumes_backup
```

2. use rsync to transfer the file to your machine
```
rsync -chavzP --stats <USERNAME>@tux02ascor.fmg.uva.nl:/home/wailam/volumes_backup/esdata-wailam-20220616.tar.gz <PATH-TO-CLONED-REPO>/volumes_backup
```

3. restore the Elasticsearch container by removing any existing data volume and replacing it with a new volume containing the backup data [(see the demo instructions)](https://github.com/wlmwng/docker-elastic-demo#restore-from-backup)

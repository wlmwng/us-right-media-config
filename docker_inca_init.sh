# Instructions for setting up INCA container

# access the INCA container and install the packages interactively
docker exec -it --user root inca-wailam /bin/bash

cd /home/jovyan/work
su jovyan
# to resolve warnings like this:
# WARNING: The scripts twarc and twarc2 are installed in '/home/jovyan/.local/bin' which is not on PATH.
# Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
export PATH="$HOME/.local/bin:$PATH"
echo $PATH

# one-time: original requirements.txt from public repo
# removed dependencies which were causing conflicts
# (a compatible version will be installed by the main package)
# python3 -m pip install -r ./inca-dev/requirements_tmp.txt

# installs all project requirements
python3 -m pip install -r ./inca/requirements_docker.txt

# note: pip freeze adds -e packages to requirements.txt
# remove them manually and install each individually
python3 -m pip install -e ./inca
python3 -m pip install -e ./urlExpander
python3 -m pip install -e ./us-right-media

# if any updated packages, use pip freeze again
# pip freeze > inca/requirements_docker.txt

# optional: useful packages
# https://github.com/tmux/tmux/wiki/Getting-Started
# docker exec -it --user root jupyter-<user> /bin/bash
# return to root
exit
apt-get update && \
apt-get install -y tmux ncdu

su jovyan
cd /home/jovyan/work/us-right-media/usrightmedia/code/04-inca-prep
tmux new -s scrape_2016
python3 scrape_2016.py &

tmux new -s scrape_2017
python3 scrape_2017.py &

tmux new -s scrape_2018
python3 scrape_2018.py &

tmux new -s scrape_2019
python3 scrape_2019.py &

tmux new -s scrape_2020
python3 scrape_2020.py &

# To detach: the C-b d key binding
# To attach: tmux attach -t scrape_2016
# To kill a pane: C-b x
# tmux kill-server to cleanly and gracefully kill all tmux open sessions (and server).

# ISSUE with jupyterlab kernel + INCA
# When using the standard container from the remote server's jupyterhub (uvacwjupyteruser?),
# inca was accessible from jupyter. I think this might be in part b/c I installed pip packages as root
# (can't confirm for sure b/c container was removed during JH updates)
# In any case, it's better not to install as root in a container (https://theorangeone.net/posts/containers-as-root/).

# In addition to preferring installs as a non-root user, I also want to separate my work from the JH processes.
# To do that, I build a container based on the data-science-notebook image and install pip packages as 'jovyan' (default jupyter user).
# After running the steps above to install inca, etc., the scraping scripts are running in tmux and successfully populating Elasticsearch and Kibana.

# However, loading the kernel in jupyter stops working:
# The reason seems to be conflicting dependencies where package versions from INCA's requirements are overwriting the versions
# needed for jupyter (Jupyter's packages were installed through the docker build; the kernel works before inca is installed but fails after).

# To workaround this issue and allow the scraping to keep going:
# 1) leave INCA in its own container (which isn't jupyterlab compatible)
# It will be responsible for data collection (in progress), word2vec preprocessing (to do), and softcosine similarity (to do).
# https://github.com/damian0604/newsevents/tree/master/src/data-processing

# 2) add another container for analysis
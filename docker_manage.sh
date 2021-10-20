# bring up the containers
cd /home/us-right-media-config
docker-compose up -d

# https://linuxconfig.org/remove-all-containners-based-on-docker-image-name
# to remove containers based on image with 'wlmwng'
docker ps -a | awk '{ print $1,$2 }' | grep wlmwng | awk '{print  $1}' | xargs -I {} docker rm {}

# SSH port forwarding to local machine
ssh -f -N -L 127.0.0.1:8888:127.0.0.1:8888 tux02ascor.fmg.uva.nl # jupyter
ssh -f -N -L 127.0.0.1:8889:127.0.0.1:8889 tux02ascor.fmg.uva.nl # INCA
ssh -f -N -L 127.0.0.1:9200:127.0.0.1:9200 tux02ascor.fmg.uva.nl # elasticsearch
ssh -f -N -L 127.0.0.1:5601:127.0.0.1:5601 tux02ascor.fmg.uva.nl # kibana

# https://stackoverflow.com/a/9532938
# to remove port forwarding on the local machine, kill the processes by ID
ps aux | grep 8888
ps aux | grep 8889
ps aux | grep 9200
ps aux | grep 5601

# step 2:
# recursively chown/chmod to fix messy permissions (jovyan, <user>, and root)
# jovyan is part of the users group
# e.g., allows scraping scripts to write logs
# UID on host system
chown <UID>:users -R inca-dev
chown <UID>:users -R urlExpander
chown <UID>:users -R us-right-media
chmod -R 775 inca-dev
chmod -R 775 urlExpander
chmod -R 775 us-right-media
chmod -R 775 us-right-media-config

# push to private registry on DockerHub
docker login
docker push wlmwng/us-right-media:kibana-enhanced-6.8.0
docker push wlmwng/us-right-media:elasticsearch-6.8.0
docker push wlmwng/us-right-media:jupyter
docker push wlmwng/us-right-media:inca
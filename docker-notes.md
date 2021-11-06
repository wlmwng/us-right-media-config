# Docker-Related Notes

## SSH port forwarding to local machine

- enable port forwarding
```
ssh -f -N -L 127.0.0.1:8001:127.0.0.1:8888 tux02ascor.fmg.uva.nl # INCA
ssh -f -N -L 127.0.0.1:8002:127.0.0.1:9200 tux02ascor.fmg.uva.nl # elasticsearch
ssh -f -N -L 127.0.0.1:8003:127.0.0.1:5601 tux02ascor.fmg.uva.nl # kibana
```

- remove port forwarding by killing the process IDs [(link)](https://stackoverflow.com/a/9532938)
```
ps aux | grep 8888
ps aux | grep 9200
ps aux | grep 5601
```

## docker-compose with non-default .yml files
- `docker-compose -f docker-compose-dev.yml up -d`
- `docker-compose -f docker-compose-dev.yml down`

## tux02ascor server permissions
- recursively chown/chmod to fix messy permissions (jovyan, my server UID, and root). This makes files readable/writable whether I'm logged in as myself on the tux02ascor or if I'm logged in as jovyan within the JupyterLab container
    - owner: my UID on the server
    - group: "users" since jovyan is part of this group
```
chown <UID>:users -R inca
chown <UID>:users -R urlExpander
chown <UID>:users -R us-right-media

chmod 775 -R inca
chmod 775 -R urlExpander
chmod 775 -R us-right-media
chmod 775 -R us-right-media-config
```

## Manage Docker images
- Remove containers based on image with <keyword> [(link)](https://linuxconfig.org/remove-all-containners-based-on-docker-image-name)
```
docker ps -a | awk '{ print $1,$2 }' | grep <keyword> | awk '{print  $1}' | xargs -I {} docker rm {}
```

- store images in registry on DockerHub
```
docker login
docker push wlmwng/us-right-media:kibana-enhanced-6.8.0
docker push wlmwng/us-right-media:elasticsearch-6.8.0
docker push wlmwng/us-right-media:inca
```

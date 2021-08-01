#!/bin/bash

echo "**** CLONANDO REPOSITORIO ****"

git clone  https://github.com/chux2000/Examen_tecnico_3.git
cd Examen_tecnico_3
# chmod a+x -R /docker-root/ && chmod 777 -R docker-root/
# ls -la docker-root/sbin/
echo "**** ARMANDO CONTENEDOR   ****"
docker build -t heroku .
echo "**** ACTIVANDO CONTENEDOR ****"
docker run -it -d -p 9000:9000 -p 9001:9001 -p 5901:5901 -e VNC_PASSWD=chux2000  -e USER_PASSWD=chux2000 heroku
clear
sleep 5
ls -la docker-root/sbin/
docker ps

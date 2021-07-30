#!/bin/bash
export DVERSION="19.03.13"
PASSWORD=${1:-password}

dockerInstall() {
  curl -sL "ttps://download.docker.com/linux/static/stable/$(uname -m)/docker-$DVERSION.tgz" -o /tmp/docker-$DVERSION.tgz
  tar xzf /tmp/docker-$DVERSION.tgz -C /tmp
  sudo cp /tmp/docker/* /usr/local/bin/
  rm -f /tmp/docker-$DVERSION.tgz
}

isDocker() {
if [ ! `which docker` ];
then
  echo -e "Docker is not installed ...\nrunning docker install..."
  dockerInstall
else
  CurDocker=$(docker version | grep -A2 Server| awk '/Version/ {print $2}')
  if [ "$CurDocker" != "$DVERSION" ]; then
    echo -e "The current docker version needs to be updated\nRunning docker update..."
    dockerInstall
  fi
fi 2>/dev/null
}

startContainer() {
  for FUNC in `echo stop rm`; do
    echo "$FUNC the container."
    docker container $FUNC $(docker ps -a --filter name=ALFRED -q)
  done 2>/dev/null
  echo "Restarting the container."
  docker build -t local/mymaria .
  openssl enc -aes-256-cbc -d -a -iter 3 -in secret -out .unsecret -k ${PASSWORD}
  docker run -d --name ALFRED --env-file=.unsecret -v /var/lib/mysql:/var/lib/mysql -v /BATCAVE:/BATCAVE local/mymaria
}

execCommands() {
  source .unsecret
  docker exec -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD ALFRED mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "create database clickmedia;" 
  docker exec -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD ALFRED mysql -u root -p${MYSQL_ROOT_PASSWORD} -D wayneindustries -e "create table users (ID integer(5) primary key, NAME varchar(30));" 
  docker exec -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD ALFRED mysql -u root -p${MYSQL_ROOT_PASSWORD} -D wayneindustries -e "INSERT INTO users (ID, NAME) VALUES(50,'BATMOBILE');" 
}

isDocker
startContainer
execCommands

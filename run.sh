docker_name=glances
#docker_image=docker.io/nicolargo/glances
docker_image=arturol76/glances:test
docker_host=$1

docker -H $1 volume create glances_cfg

read -p "Do you want to pull image? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo
    echo pulling image...
    docker -H $1 pull $docker_image
else   
    echo
fi

if [ "$(docker -H $docker_host ps -a | grep $docker_name)" ]; then
    echo container $docker_host already exists

    echo stopping it...
    docker -H $1 stop $docker_name

    echo removing it...
    docker -H $1 rm $docker_name
fi

# create your container
echo creating the container...
docker -H $1 create \
    --restart always \
    -it \
    -p 61208-61209:61208-61209 \
    -v glances_cfg:/glances/conf \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    --pid host \
    --privileged \
    -e GLANCES_OPT="-w" \
    --name $docker_name \
    $docker_image
  
#webserver mode   
#-e GLANCES_OPT="-w"
#-e GLANCES_OPT="--export mqtt"

#copy config files into container

if true; then
    read -p "Do you want to init volumes with config files? " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo

        echo copying files into container...
        docker -H $1 cp ./conf/. $docker_name:/glances/conf
    else
        echo
    fi
fi


#run
echo starting the container...
docker -H $1 start \
    $docker_name

 #   -v letsencrypt_etc:/mosquitto/certs:ro \
    
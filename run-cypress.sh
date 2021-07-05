#!/bin/bash

CYPRESS_DOCKER_IMAGE="cypress/included:6.8.0"
  SAFEPWD=`uuidgen| cut -c -32`
HOST=""

while true; do
  case "$1" in
    -h | --host ) HOST="$HOST--add-host=$2 "; shift 2;;
    -g | --gui ) GUI=1; shift ;;
    * ) break ;;
  esac
done


function show_help() {
    echo "usage: ./run_cypress -c cs_baseurl -a auth_baseurl [-h host:ip] [-g]

    -h host:ip     - add host and IP to /etc/hosts in the docker container, you can use -h multiple times
    -g             - Use GUI"
}

function run_headless_cypress() {
    echo docker run -it -v $PWD:/e2e -w /e2e $HOST $CYPRESS_DOCKER_IMAGE
    docker run --rm -it -v $PWD:/e2e -w /e2e $HOST --entrypoint cypress $CYPRESS_DOCKER_IMAGE run -e "SAFEPWD=$SAFEPWD"
}

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux"

    echo "Running cypress in Docker"
    echo $CYPRESS_DOCKER_IMAGE
    if [[ -n "$GUI" ]]; then
          echo "Permitting local non-network X11 connections"
          xhost local:
          echo "Running cypress in Docker"
          echo run --rm -v ${PWD}:/e2e -w /e2e --net=host -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=${DISPLAY} ${HOST} --entrypoint cypress ${CYPRESS_DOCKER_IMAGE} open --project .
          docker run --rm -v $PWD:/e2e -w /e2e -h $HOSTNAME --net=host -v /tmp/.X11-unix:/tmp/.X11-unix -v ~/.Xauthority:/root/.Xauthority -e DISPLAY $HOST --entrypoint cypress $CYPRESS_DOCKER_IMAGE open --project . -e "SAFEPWD=$SAFEPWD"
    else
		echo "Running cypress headless"
        run_headless_cypress
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then

    if [[ -n "$GUI" ]]; then
        if [[ -z `which Xquartz` ]]; then
            echo "No XQuartz installation found. Please install it with:

       brew install xquartz

Then remember to go to xquartz preferences -> Security tab -> Enable 'Allow connections from network clients'

Then it would be very nice of you if you could reboot your computer computer.

Thank you"
            exit 1
        fi
        echo "Running XQuartz"
        open -a XQuartz
        sleep 3

        export IP=$(ipconfig getifaddr en0)
        export DISPLAY=:0

        xhost + $IP

        echo "Running cypress in Docker"
        echo DISPLAY=$IP:0 docker run -d --rm -v $PWD:/e2e -w /e2e -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY $HOST --entrypoint cypress $CYPRESS_DOCKER_IMAGE open --project .
        DISPLAY=$IP:0 docker run -d --rm -v $PWD:/e2e -w /e2e -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY $HOST --entrypoint cypress $CYPRESS_DOCKER_IMAGE open --project . -e "SAFEPWD=$SAFEPWD"
    else
		echo "Running cypress headless"
        run_headless_cypress
    fi
fi


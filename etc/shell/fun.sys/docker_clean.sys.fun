#!/bin/sh

function docker_clean() {
    local cont=$(docker ps -qa --no-trunc)
    if [ -n "${cont}" ]; then
        docker rm $(docker ps -qa --no-trunc)
    fi
    docker volume ls -qf dangling=true | xargs docker volume rm
    local img=$(docker images -q --no-trunc)
    if [ -n "${img}" ]; then
        docker rmi $(docker images -q --no-trunc) --force
    fi
}

alias my_docker_clean=docker_clean

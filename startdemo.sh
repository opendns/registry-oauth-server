#!/bin/bash

username="admin"
pass="password"
cred="${username}:${pass}"
encoded_cred=`echo -n ${cred} | base64`
service="demo_registry"

if [ "$(uname)" == "Darwin" ]; then
    docker_ip="$(docker-machine ip default)"
else
    docker_ip="0.0.0.0"
fi


echo
echo "curl https://${docker_ip}:5000/v2/_catalog"
echo
curl -skv "https://${docker_ip}:5000/v2/_catalog"
read input
clear

echo
echo "curl http://${docker_ip}:8080/tokens?service=${service}&scope=registry:catalog:*"
echo
curl -sv -H "Authorization: Basic ${encoded_cred}" "http://${docker_ip}:8080/tokens?service=${service}&scope=registry:catalog:*"

token=`curl -s -H "Authorization: Basic ${encoded_cred}" "http://${docker_ip}:8080/tokens?service=${service}&scope=registry:catalog:*" | jq .token | tr -d '"'`
read input
clear

echo
echo  "curl \"https://${docker_ip}:5000/v2/_catalog\""
curl -skv -H "Authorization: Bearer ${token}" "https://${docker_ip}:5000/v2/_catalog"
echo

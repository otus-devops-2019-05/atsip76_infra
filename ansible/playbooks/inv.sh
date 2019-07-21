#!/bin/bash
dynamic_json_file=$(gcloud compute instances list | tail -n +2 | tr -s ' ' | cut -d ' ' -f1,5)
internal_ip=$(gcloud compute instances list | tail -n +2 | tr -s ' ' | cut -d ' ' -f1,4)
db_internal_ip=$(echo ${internal_ip} | awk -F"db " '{ print $2 }')
/bin/sed -i "s/db_host: *.*.*.*/db_host: ${db_internal_ip}/" ~/OTUS/DEVOPS/atsip76_infra/ansible/\
roles/app/defaults/main.yml
/bin/sed -i "s/mongo_bind_ip: *.*.*.*/mongo_bind_ip: 0.0.0.0/" ~/OTUS/DEVOPS/atsip76_infra/ansible/\
roles/db/defaults/main.yml


if [ "$1" == "--list" ] ; then
        app=$(echo ${dynamic_json_file} | awk -F"app | reddit" '{ print $2 }')
        db=$(echo ${dynamic_json_file} | awk -F"db " '{ print $2 }')
        echo -e "{\"app\": [\"$app\"], \"db\": [\"$db\"]}" > inventory.json
        cat ./inventory.json
elif [ "$1" == "--host" ]; then
        app=$(echo ${dynamic_json_file} | awk -F"app | reddit" '{ print $2 }')
        db=$(echo ${dynamic_json_file} | awk -F"db " '{ print $2 }')
        echo -e "{\"app\": [\"$app\"], \"db\": [\"$db\"]}" > inventory.json
        cat ./inventory.json
else
       echo "External IP:
$dynamic_json_file"
        echo "Internal IP:
$internal_ip"
fi

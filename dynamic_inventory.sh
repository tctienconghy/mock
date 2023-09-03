#!/bin/bash

environment="$1"
instance_ips_file="${environment}_list_ec2_ip.txt"

# Read instance IPs from Terraform step
IFS=$'\n' read -d '' -r -a instance_ips < "$instance_ips_file"

# Generate the dynamic inventory JSON structure
inventory='{
    "_meta": {
        "hostvars": {}
    },
    "all": {
        "hosts": [],
        "vars": {}
    }
}'

for ip in "${instance_ips[@]}"; do
    instance_id="${environment}_ec2-${ip//./-}"  # Convert IP to a valid Ansible host name
    inventory=$(echo "$inventory" | jq --arg id "$instance_id" --arg ip "$ip" \
        '.all.hosts += [$id] | ._meta.hostvars[$id] = {"ansible_host": $ip}')
done

echo "$inventory" > "${environment}_dynamic_inventory.json"
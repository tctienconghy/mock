#!/bin/bash

# get workspace from input param
workspace_name="$1"
cd env/$workspace_name

# Check if the workspace exists
if ! terraform workspace select $workspace_name 2>/dev/null; then
  # If the workspace doesn't exist, create it and select it
  echo "Start to choose workspace!"
  terraform workspace new $workspace_name
  terraform workspace select $workspace_name
  terraform workspace show
fi

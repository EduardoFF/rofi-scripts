#!/bin/bash

function gen_workspaces()
{
    i3-msg -t get_workspaces | tr ',' '\n' | grep "name" | sed 's/"name":"\(.*\)"/\1/g' | sort -n
}


WORKSPACE=$( (echo empty; gen_workspaces)  | rofi -dmenu -p "Select workspace:")

if [ x"empty" = x"${WORKSPACE}" ]
then
    i3_empty_workspace.sh
elif [ -n "${WORKSPACE}" ]
then
    # https://www.reddit.com/r/i3wm/comments/wgcpae/help_with_keybind_for_moving_workspace_to/
    message=$(i3-msg -t get_workspaces)
    output=$(echo "${message}" | jq '.[] | select(.focused==true).output')
    curr_output=$(echo "${message}" | jq ".[] | select(.name==\"${WORKSPACE}\").output")
    if [ -n "${curr_output}" ] && [ "${output}" != "${curr_output}" ]
    then
	i3-msg "workspace \"${WORKSPACE}\"; move workspace to output ${output}"
    else
	i3-msg "workspace \"${WORKSPACE}\""
    fi
    #i3-msg workspace "${WORKSPACE}"
fi

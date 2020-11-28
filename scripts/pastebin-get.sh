#!/bin/bash

# Bazza's pastebin.com script for retrieving a paste
# Feel free to look me up at: https://twitter.com/mcbazza
#
# This is a script to pull down a paste using your
# pastebin.com account. This could be a hidden paste
# that is not pubicly accessible.

# Example:
#  e.g. To download the paste from https://pastebin.com/Us21pdYs
#    ./pastebin-get.sh -i Us21pdYs

# Required, see http://pastebin.com/api#1
## DON'T LEAK YOUR PRIVATE CREDS!
API_DEV_KEY=''

## DON'T LEAK YOUR PRIVATE CREDS!
API_USER_NAME=''
API_USER_PASSWORD=''

#########################################################################################

# default values
PASTE=

while getopts "i:h" OPTION
do
    case $OPTION in
    i)
        PASTE=$OPTARG
        ;;
    ?)
        echo "\
Pastebin.com Bash Script to Retreive a Paste \

Usage : $0 [ -i <pasteID> ]

Input data using STDIN.

-i Specify the ID of paste to be download
"
        exit
        ;;
    esac
done

# Build up the string to auth as
querystring="api_dev_key=${API_DEV_KEY}&api_user_name=${API_USER_NAME}&api_user_password=${API_USER_PASSWORD}"

# Call pastebin.com with user/pass to get back API_USER_KEY
API_USER_KEY="$(curl -s -d "${querystring}" https://pastebin.com/api/api_login.php)"

# Build up the string used to retreive the paste
querystring="api_option=show_paste&api_dev_key=${API_DEV_KEY}&api_user_key=${API_USER_KEY}&api_paste_key=${PASTE}"

# Download the paste, display to stdout
curl -s -d "${querystring}" https://pastebin.com/api/api_raw.php

echo ""

#!/bin/bash

# Bazza's pastebin.com script for writing a paste
# Feel free to look me up at: https://twitter.com/mcbazza
#
# This is a script that takes the output from stdin
# and writes it to a paste in your pastebin.com account
# Example:
#  To take save the passwd file to a paste named 'ServerPasswd'
#    cat /etc/passwd | ./pastebin.sh -n ServerPasswd

# Edit to add your own Pastebin.org API Dev key
# Required, see http://pastebin.com/api#1
## DON'T LEAK YOUR PRIVATE CREDS!
API_DEV_KEY=''

# To upload to a private paste you MUST apply user/password
## DON'T LEAK YOUR PRIVATE CREDS!
API_USER_NAME=''
API_USER_PASSWORD=''

# Name to save the paste as
# use the -n switch to supply name via CLI
NAME=

# Format of the paste
FORMAT=

# Whether the paste is to be public/private
# For private you must supply API_USER_NAME and API_USER_PASSWORD
# 0=public 1=unlisted 2=private
PRIVATE=2

# How long until the paste should expire?
EXPIRE_DATE=1W

while getopts "n:f:e:hpu" OPTION
do
    case $OPTION in
    n)
        NAME=$OPTARG
        ;;
    f)
        FORMAT="&api_paste_format=${OPTARG}"
        ;;
    e)
        EXPIRE_DATE=$OPTARG
        ;;
    p)
        PRIVATE=2
        ;;
    u)
        PRIVATE=1
        ;;
    ?)
        echo "\
Pastebin.com Bash Script to Save a Paste\

Usage : $0 [ -n <name> ] [ -f <format> ] [ -e <expiration> ] [ -p | -u ] [ -h ]

Input data using STDIN.

-n Specify the name of paste to be used
-f Specify code format used, use any of the values here http://pastebin.com/api#5
-e Specify expiration time, default never, examples here http://pastebin.com/api#6
-p Set paste private, requires a userkey, default public
-u Set paste unlisted, default public
"
        exit
        ;;
    esac
done

# Build up the string to auth as
querystring="api_dev_key=${API_DEV_KEY}&api_user_name=${API_USER_NAME}&api_user_password=${API_USER_PASSWORD}"

# Call pastebin.com with user/pass to get back API_USER_KEY
API_USER_KEY="$(curl -s -d "${querystring}" https://pastebin.com/api/api_login.php)"

# Input is supplied via pipe from stdin
INPUT="$(</dev/stdin)"

# Build up the string to send the paste as
querystring="api_option=paste&api_dev_key=${API_DEV_KEY}&api_user_key=${API_USER_KEY}&api_paste_expire_date=${EXPIRE_DATE}&api_paste_private=${PRIVATE}&api_paste_code=${INPUT}&api_paste_name=${NAME}${FORMAT}"

# Send the file as a paste
echo "Saving paste..."
curl -d "${querystring}" https://pastebin.com/api/api_post.php

echo ""

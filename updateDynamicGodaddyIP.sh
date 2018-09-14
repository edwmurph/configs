#!/bin/bash

##
# Use this script in a cronjob to update Godaddy domain to point to dynamic IP when it changes
##

##
# Usage:
# To have this script run every hour, append the following cron script to the file opened via `sudo crontab -e`:
#
# 0 * * * * /path/to/file/updateDynamicGodaddyIp.sh
##

##
# Imports:
##

ENV_FILE_PATH="$HOME/.env"
. $ENV_FILE_PATH               # source file containing common env variables (CACHED_ROUTER_IP)
. "$HOME/.secrets/secrets.sh"  # source file containing secrets (SLACK_SERVICE_URL: url used to send messages to certain slack room)


##
# Helper functions:
##

function sendToSlack() {
	msg="${1-Error: empty message}"
	curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"${msg}\"}" $SLACK_SERVICE_URL
}


##
# Script parameters:
# For this script to work, make sure the following variables resolve to the correct values:
##

SCRIPT_NAME='updateDynamicGodaddyIP.sh'

# godaddy variables used to get/update dynamic IP with godaddy when it changes
GODADDY_RECORD_URL='https://api.godaddy.com/v1/domains/voyria.com/records/A'
GODADDY_KEY=$(cat /home/edwmurph/.secrets/godaddy.key)
GODADDY_SECRET=$(cat /home/edwmurph/.secrets/godaddy.secret)
if [ -z "$GODADDY_RECORD_URL" ] || [ -z "$GODADDY_KEY" ] || [ -z "$GODADDY_SECRET" ]; then
	sendToSlack "Problem in $SCRIPT_NAME getting godaddy key or secret"
	exit 1
fi

# true current IP of router
IP_INFO_HEADERS_FILE='.ipInfoHeaders.txt'
CURRENT_IP="$(curl -D ${IP_INFO_HEADERS_FILE} --silent ipinfo.io/ip)"
if [ -z "$CURRENT_IP" ]; then
	sendToSlack "Problem in $SCRIPT_NAME getting current IP address\n$(cat ${IP_INFO_HEADERS_FILE})"
	exit 1
fi

# IP address known by Godaddy
GODADDY_HEADERS_FILE='.godaddyHeaders.txt'
GODADDY_IP=$(curl -D ${GODADDY_HEADERS_FILE} --silent "$GODADDY_RECORD_URL" -H "accept: application/json" -H "Authorization: sso-key ${GODADDY_KEY}:${GODADDY_SECRET}" | jq -r '.[0].data')
if [ -z "$GODADDY_IP" ]; then
	sendToSlack "Problem in $SCRIPT_NAME getting current IP address known by Godaddy\n$(cat ${GODADDY_HEADERS_FILE})"
	exit 1
fi


##
# Main logic:
# If IP addresses are out of sync, update the cached IP, and Godaddy IP to be the same as the current actual IP.
##

if [ "$CURRENT_IP" != "$CACHED_ROUTER_IP" ] || [ "$CURRENT_IP" != "$GODADDY_IP" ]; then
	sendToSlack "GODADDY_IP: '${GODADDY_IP}'\nCACHED_ROUTER_IP: '${CACHED_ROUTER_IP}'\nCURRENT_IP: '${CURRENT_IP}'"

	if [ "$GODADDY_IP" != "$CURRENT_IP" ]; then
		curl -X PUT "${GODADDY_RECORD_URL}/%40" \
			-H "accept: application/json" \
			-H "Content-Type: application/json" \
			-H "Authorization: sso-key ${GODADDY_KEY}:${GODADDY_SECRET}" \
			-d "[ { \"data\": \"${CURRENT_IP}\", \"ttl\": 600 }]"
	fi

	# if everything above succeeds, update file containing currently known IP
	sed -i "s/^export CACHED_ROUTER_IP='.*'$/export CACHED_ROUTER_IP='${CURRENT_IP}'/g" $ENV_FILE_PATH

	sendToSlack "Successfully synchronized IPs to ${CURRENT_IP}"
fi


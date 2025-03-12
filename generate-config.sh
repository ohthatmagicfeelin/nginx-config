#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Default to .env if no environment specified
ENV_FILE="${SCRIPT_DIR}/.env"
if [ ! -z "$1" ]; then
    ENV_FILE="${SCRIPT_DIR}/$1"
fi

if [ ! -f "$ENV_FILE" ]; then
    echo "Environment file $ENV_FILE not found!"
    exit 1
fi

# Load environment variables
set -a  # automatically export all variables
source "$ENV_FILE"
set +a


# Generate main config
envsubst '${DOMAIN} ${SERVER_IP} ${WEBSITE_ROOT} ${SSL_CERT} ${SSL_KEY} ${SSL_OPTIONS} ${SSL_DHPARAM}' \
    < sites-available/coreyb.dev.conf.template \
    > sites-available/coreyb.dev.conf

# Generate app configs
# Weather
envsubst '${WEATHER_ROOT} ${WEATHER_PORT}' \
    < sites-available/includes/apps/weather.conf.template \
    > sites-available/includes/apps/weather.conf

# Spotify Seasons
envsubst '${SPOTIFY_ROOT} ${SPOTIFY_PORT}' \
    < sites-available/includes/apps/spotifyseasons.conf.template \
    > sites-available/includes/apps/spotifyseasons.conf

# Properties
envsubst '${PROPERTIES_ROOT} ${PROPERTIES_MAP}' \
    < sites-available/includes/apps/properties.conf.template \
    > sites-available/includes/apps/properties.conf

# Chatbot
envsubst '${CHATBOT_ROOT} ${CHATBOT_PORT}' \
    < sites-available/includes/apps/chatbot.conf.template \
    > sites-available/includes/apps/chatbot.conf

# app_name_here
envsubst '${TEMPLATE_ROOT} ${TEMPLATE_PORT}' \
    < sites-available/includes/apps/app_name_here.conf.template \
    > sites-available/includes/apps/app_name_here.conf

# payment_template
envsubst '${PAYMENT_ROOT} ${PAYMENT_PORT}' \
    < sites-available/includes/apps/payment_template.conf.template \
    > sites-available/includes/apps/payment_template.conf


# planets
envsubst '${PLANETS_ROOT} ${PLANETS_PORT}' \
    < sites-available/includes/apps/planets.conf.template \
    > sites-available/includes/apps/planets.conf

# event
envsubst '${EVENT_ROOT} ${EVENT_PORT}' \
    < sites-available/includes/apps/event.conf.template \
    > sites-available/includes/apps/event.conf

# bank
envsubst '${BANK_ROOT} ${BANK_PORT}' \
    < sites-available/includes/apps/bank.conf.template \
    > sites-available/includes/apps/bank.conf

# listen
envsubst '${LISTEN_ROOT} ${LISTEN_PORT}' \
    < sites-available/includes/apps/listen.conf.template \
    > sites-available/includes/apps/listen.conf

envsubst '${CHARTER_ROOT} ${CHARTER_PORT}' \
    < sites-available/includes/apps/charter.conf.template \
    > sites-available/includes/apps/charter.conf

envsubst '${TRAVEL_ROOT} ${TRAVEL_PORT} ${TRAVEL_WS_PORT}' \
    < sites-available/includes/apps/travel.conf.template \
    > sites-available/includes/apps/travel.conf

envsubst '${HOUSZR_ROOT} ${HOUSZR_PORT}' \
    < sites-available/includes/apps/houszr.conf.template \
    > sites-available/includes/apps/houszr.conf

envsubst '${BILLBOARD_ROOT} ${BILLBOARD_PORT}' \
    < sites-available/includes/apps/billboard.conf.template \
    > sites-available/includes/apps/billboard.conf

envsubst '${GROOVER_ROOT} ${GROOVER_PORT}' \
    < sites-available/includes/apps/groover.conf.template \
    > sites-available/includes/apps/groover.conf

echo "Configuration files generated successfully"

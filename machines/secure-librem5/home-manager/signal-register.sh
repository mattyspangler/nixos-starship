#!/bin/sh
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <phone_number>"
  exit 1
fi

PHONE_NUMBER="$1"

echo "Registering $PHONE_NUMBER..."

curl -X POST -H "Content-Type: application/json" -d "{\"use_voice\": false}" "http://localhost:8080/v1/register/$PHONE_NUMBER"

echo "\nRegistration request sent. You should receive an SMS with a verification code."
echo "Once you receive the code, run the following command, replacing '<code>' with the code you received:"
echo "./signal-verify.sh $PHONE_NUMBER <code>"
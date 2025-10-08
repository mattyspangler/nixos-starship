#!/bin/sh
set -e

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <phone_number> <verification_code>"
  exit 1
fi

PHONE_NUMBER="$1"
VERIFICATION_CODE="$2"

echo "Verifying $PHONE_NUMBER with code $VERIFICATION_CODE..."

curl -X POST -H "Content-Type: application/json" "http://localhost:8080/v1/register/$PHONE_NUMBER/verify/$VERIFICATION_CODE"

echo "\nVerification complete. Your number should now be registered."
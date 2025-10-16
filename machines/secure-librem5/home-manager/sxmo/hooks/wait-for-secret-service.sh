#!/usr/bin/env bash
# wait until the secret service is up, then launch program

TIMEOUT=${TIMEOUT:-300} # seconds

counter=0
while ! busctl --user exist org.freedesktop.secrets >/dev/null 2>&1; do
  sleep 1
  counter=$((counter + 1))
  if [ $counter -ge "$TIMEOUT" ]; then
    exit 1
  fi
done

exec "$@"
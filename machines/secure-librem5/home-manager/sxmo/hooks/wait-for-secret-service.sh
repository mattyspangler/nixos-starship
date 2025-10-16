#!/usr/bin/env bash
# wait until the secret service is up, then launch program

while ! busctl --user exist org.freedesktop.secrets >/dev/null 2>&1; do
  sleep 1
done

exec "$@"
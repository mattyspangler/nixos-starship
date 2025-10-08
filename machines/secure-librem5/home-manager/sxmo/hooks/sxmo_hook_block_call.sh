#!/bin/sh
# configversion: 4408f29a464ab22d7c978fa0475cf80e

# This hook is executed to check if a call should be blocked
# If the hook return 0 the call will be blocked

INCOMINGNUMBER="$1"

cut -f1 "$SXMO_BLOCKFILE" 2>/dev/null | grep -q "^$INCOMINGNUMBER$"

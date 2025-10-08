#!/bin/sh
# configversion: 9ebf1802276513c4eefc8da4e5f2eda9

# Runs after wm has been stopped., useful for cleanup

# clean up misc. stale files (if any)
rm -rf "$XDG_RUNTIME_DIR"/sxmo*

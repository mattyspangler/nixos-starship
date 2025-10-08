#!/bin/sh
# configversion: 01fd10d27b7d66531ea7ecb4f92ce00d
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright 2022 Sxmo Contributors

# This script is executed (asynchronously) when you discard an incoming call
# i.e., click Hangup on Pickup menu when call is coming in (without picking
# up the call).

# kill existing ring playback
sxmo_jobs.sh stop ringing

sxmo_playerctl.sh resume_all

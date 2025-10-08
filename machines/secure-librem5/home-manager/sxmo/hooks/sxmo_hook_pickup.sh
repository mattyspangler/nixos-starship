#!/bin/sh
# configversion: 4ba2c7036efd412bcc470e7de3f923db
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright 2022 Sxmo Contributors

# This script is executed (asynchronously) when you pick up an incoming call

# kill existing ring playback
sxmo_jobs.sh stop ringing

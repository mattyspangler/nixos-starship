#!/bin/sh
# configversion: 723b508e3ab28c10933e4c7cc730fb76
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright 2022 Sxmo Contributors

# include common definitions
# shellcheck source=scripts/core/sxmo_common.sh
. sxmo_common.sh

WINNAME="$1"
CHOICE="$2"

sxmo_log "Unknown choice <$CHOICE> selected from contextmenu <$WINNAME>"

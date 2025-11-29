#!/bin/bash
# Stdio MCP wrapper - keeps MCP server alive
MCP_COMMAND="$@"
while true; do
    echo "Starting MCP server: $MCP_COMMAND"
    $MCP_COMMAND
    echo "MCP server exited, restarting in 5 seconds..."
    sleep 5
done
{
  virtualisation.oci-containers.containers.filesystem-mcp = {
    
    image = "node:20-alpine";
    autoStart = true;
    
    volumes = [
      "filesystem-mcp-cache:/tmp/npm-cache"
      "/home/nebula/nixos-starship:/workspace:rw"
      "/home/nebula/nixos-starship/common/desktop/virtualisation/podman/mcp-wrapper.sh:/wrapper.sh:ro"
    ];
    
    # Use wrapper to keep MCP server alive
    cmd = [ "sh" "-c" "
      export npm_config_cache=/tmp/npm-cache &&
      npm install -g --no-audit --no-fund @modelcontextprotocol/server-filesystem &&
      chmod +x /wrapper.sh &&
      exec /wrapper.sh mcp-server-filesystem /workspace
    " ];
    
    extraOptions = [
      # Remove --restart as it conflicts with oci-containers autoStart
    ];
  };
}
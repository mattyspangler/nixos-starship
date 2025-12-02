{
  virtualisation.oci-containers.containers.git-mcp = {
    
    image = "node:20-alpine";
    autoStart = false;
    
    volumes = [
      "/home/nebula/nixos-starship:/workspace:rw"
    ];
    
    # Clone, build and run as HTTP server on port 3002
    cmd = [ "sh" "-c" "
      apk add --no-cache git &&
      git clone https://github.com/idosal/git-mcp.git /tmp/git-mcp &&
      cd /tmp/git-mcp &&
      npm install &&
      npm run build &&
      cd /workspace &&
      exec node /tmp/git-mcp/dist/index.js --transport http --port 3002 /workspace
    " ];
    
    ports = [ "3002:3002" ];
    
    extraOptions = [
      # Remove --restart as it conflicts with oci-containers autoStart
    ];
  };
}

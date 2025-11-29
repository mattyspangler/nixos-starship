{
  virtualisation.oci-containers.containers.nixos-mcp = {
    
    image = "ghcr.io/utensils/mcp-nixos:latest";
    autoStart = true;
    
    # Run as HTTP server on port 3004
    cmd = [ "sh" "-c" "exec nixos-mcp --transport http --port 3004" ];
    
    ports = [ "3004:3004" ];
    
    extraOptions = [
      "--pull=always"  # Always get the latest version
    ];
  };
}
{
  virtualisation.oci-containers.containers.context7-mcp = {
    
    # Use a simpler approach with npm global install
    image = "node:18-alpine";
    autoStart = true;
    
    # Install once and run directly
    cmd = [ "sh" "-c" "npm install -g @upstash/context7-mcp && exec context7-mcp --transport stdio" ];
    
    # Environment variables (add your API key if needed)
    environment = {
      # CONTEXT7_API_KEY = "your-api-key-here";
    };
    
    # Keep STDIN open for MCP communication
    extraOptions = [
      "-i" "--rm"
    ];
  };
}
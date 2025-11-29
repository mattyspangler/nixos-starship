{
  virtualisation.oci-containers.containers.context7-mcp = {
    
    # Use Node 20 for context7 compatibility (requires Node 20+)
    image = "node:20-alpine";
    autoStart = true;
    
    # Install and run HTTP transport for better container compatibility
    cmd = [ "sh" "-c" "npm install -g @upstash/context7-mcp && exec context7-mcp --transport http --port 3000" ];
    
    # Environment variables (add your API key if needed)
    environment = {
      # CONTEXT7_API_KEY = "your-api-key-here";
    };
    
    # Expose MCP HTTP port
    ports = [ "3000:3000" ];
    
    # Keep container running
    extraOptions = [
      # Remove --restart as it conflicts with oci-containers autoStart
    ];
  };
}
{
  virtualisation.oci-containers.containers.playwright-mcp = {
    
    image = "mcr.microsoft.com/playwright/mcp:latest";
    #autoStart = true;
    
    # Use default command but override port for HTTP transport
    cmd = [ "node" "cli.js" "--headless" "--browser" "chromium" "--no-sandbox" "--port" "8931" ];
    
    ports = [ "8931:8931" ];
    
    # Additional flags for proper container operation
    extraOptions = [
      "--init"
      "--pull=always"
    ];
  };
}
{
  virtualisation.oci-containers.containers.postmarketos-gitlab-mcp = {
    
    image = "node:20-alpine";
    autoStart = false;
    
    # Run mcp-remote as HTTP proxy on port 3003
    cmd = [ "sh" "-c" "
      npm install -g mcp-remote &&
      exec mcp-remote --transport http --port 3003 https://gitlab.postmarketos.org/api/v4/mcp
    " ];
    
    ports = [ "3003:3003" ];
    
    extraOptions = [
      # Remove --restart as it conflicts with oci-containers autoStart
    ];
  };
}

{ lib, ... }:
{
  # Enable specific containers for this machine
  virtualisation.oci-containers.containers = {
    # PostmarketOS GitLab MCP (currently disabled in common config)
    postmarketos-gitlab-mcp = {
      autoStart = lib.mkForce true;
    };
    
    # Windmill services (all currently disabled in common config)
    windmill-postgres = {
      autoStart = lib.mkForce true;
    };
    
    windmill-server = {
      autoStart = lib.mkForce true;
    };
    
    windmill-worker = {
      autoStart = lib.mkForce true;
    };
    
    windmill-worker-native = {
      autoStart = lib.mkForce true;
    };
    
    windmill-lsp = {
      autoStart = lib.mkForce true;
    };
    
    windmill-caddy = {
      autoStart = lib.mkForce true;
    };
  };
}
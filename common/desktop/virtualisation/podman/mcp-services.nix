# Make MCP services start asynchronously with simpler approach
{
  systemd.services = {
    # Configure MCP services with longer timeouts but simple type
    "podman-filesystem-mcp.service" = {
      serviceConfig = {
        Type = "simple";
        TimeoutStartSec = 300;  # Allow 5 minutes for initial npm install
        RestartSec = 30;
      };
      unitConfig = {
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };
    };
    
    "podman-git-mcp.service" = {
      serviceConfig = {
        Type = "simple";
        TimeoutStartSec = 300;
        RestartSec = 30;
      };
      unitConfig = {
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };
    };
    
    "podman-postmarketos-gitlab-mcp.service" = {
      serviceConfig = {
        Type = "simple";
        TimeoutStartSec = 300;
        RestartSec = 30;
      };
      unitConfig = {
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };
    };
    
    "podman-nixos-mcp.service" = {
      serviceConfig = {
        Type = "simple";
        TimeoutStartSec = 300;
        RestartSec = 30;
      };
      unitConfig = {
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };
    };
  };
}
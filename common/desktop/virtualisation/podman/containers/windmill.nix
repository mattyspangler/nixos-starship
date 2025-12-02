{
  # Generate Caddyfile inline
  environment.etc."windmill-Caddyfile".text = ''
{
	layer4 {
		:25 {
			proxy {
				to windmill-server:2525
			}
		}
	}
}

{$BASE_URL} {
        bind {$ADDRESS}
        reverse_proxy /ws/* http://windmill-lsp:3001
        # reverse_proxy /ws_mp/* http://multiplayer:3002
        # reverse_proxy /api/srch/* http://windmill_indexer:8002
        reverse_proxy /* http://windmill-server:8000
        # tls /certs/cert.pem /certs/key.pem
}
'';

  # PostgreSQL database for Windmill
  virtualisation.oci-containers.containers.windmill-postgres = {
    image = "postgres:16";
    autoStart = false;  # Disabled by default, enabled per-machine
    
    environment = {
      POSTGRES_DB = "windmill";
      POSTGRES_USER = "postgres";
      POSTGRES_PASSWORD = "changeme";
    };
    
    volumes = [
      "windmill_db_data:/var/lib/postgresql/data"
    ];
    
    extraOptions = [
      "--network=podman"
      "--shm-size=1g"
    ];
  };

  # Windmill server
  virtualisation.oci-containers.containers.windmill-server = {
    image = "ghcr.io/windmill-labs/windmill:main";
    autoStart = false;  # Disabled by default, enabled per-machine
    
    environment = {
      DATABASE_URL = "postgres://postgres:changeme@windmill-postgres:5432/windmill?sslmode=disable";
      MODE = "server";
    };
    
    ports = [
      "8001:8000"  # Windmill API and web UI (moved to 8001 to avoid conflict with SillyTavern)
      "2525:2525"  # SMTP server
    ];
    
    volumes = [
      "windmill_worker_logs:/tmp/windmill/logs"
    ];
    
    extraOptions = [
      "--network=podman"
    ];
  };

  # Windmill workers (3 replicas for job execution)
  virtualisation.oci-containers.containers.windmill-worker = {
    image = "ghcr.io/windmill-labs/windmill:main";
    autoStart = false;  # Disabled by default, enabled per-machine
    
    environment = {
      DATABASE_URL = "postgres://postgres:changeme@windmill-postgres:5432/windmill?sslmode=disable";
      MODE = "worker";
      WORKER_GROUP = "default";
    };
    
    volumes = [
      "windmill_worker_dependency_cache:/tmp/windmill/cache"
      "windmill_worker_logs:/tmp/windmill/logs"
    ];
    
    extraOptions = [
      "--network=podman"
      "--cpus=1"
      "--memory=2g"
    ];
  };

  # Windmill native worker (1 replica for lightweight jobs)
  virtualisation.oci-containers.containers.windmill-worker-native = {
    image = "ghcr.io/windmill-labs/windmill:main";
    autoStart = false;  # Disabled by default, enabled per-machine
    
    environment = {
      DATABASE_URL = "postgres://postgres:changeme@windmill-postgres:5432/windmill?sslmode=disable";
      MODE = "worker";
      WORKER_GROUP = "native";
      NUM_WORKERS = "8";
      SLEEP_QUEUE = "200";
    };
    
    volumes = [
      "windmill_worker_logs:/tmp/windmill/logs"
    ];
    
    extraOptions = [
      "--network=podman"
      "--cpus=1"
      "--memory=2g"
    ];
  };

  # Windmill LSP for intellisense
  virtualisation.oci-containers.containers.windmill-lsp = {
    image = "ghcr.io/windmill-labs/windmill-lsp:latest";
    autoStart = false;  # Disabled by default, enabled per-machine
    
    ports = [
      "3001:3001"  # LSP service
    ];
    
    volumes = [
      "windmill_lsp_cache:/pyls/.cache"
    ];
    
    extraOptions = [
      "--network=podman"
    ];
  };

  # Caddy reverse proxy
  virtualisation.oci-containers.containers.windmill-caddy = {
    image = "ghcr.io/windmill-labs/caddy-l4:latest";
    autoStart = false;  # Disabled by default, enabled per-machine
    
    ports = [
      "80:80"    # HTTP
      "25:25"    # SMTP
    ];
    
    volumes = [
      "/etc/windmill-Caddyfile:/etc/caddy/Caddyfile"
      "windmill_caddy_data:/data"
    ];
    
    environment = {
      BASE_URL = ":80";
    };
    
    extraOptions = [
      "--network=podman"
    ];
  };

  # Define the podman network
  virtualisation.oci-containers.backend = "podman";
}
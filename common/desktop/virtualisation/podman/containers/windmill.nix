{
  # PostgreSQL database for Windmill
  virtualisation.oci-containers.containers.windmill-postgres = {
    
    image = "postgres:16-alpine";
    autoStart = true;
    
    environment = {
      POSTGRES_DB = "windmill";
      POSTGRES_USER = "postgres";
      POSTGRES_PASSWORD = "changeme";  # Change this in production!
    };
    
    volumes = [
      "/var/lib/windmill-postgres:/var/lib/postgresql/data"
    ];
    
    extraOptions = [
      "--network=podman"
      "--shm-size=1g"
    ];
  };
  
  # Windmill server
  virtualisation.oci-containers.containers.windmill-server = {
    
    image = "ghcr.io/windmill-labs/windmill:main";
    autoStart = true;
    
    environment = {
      DATABASE_URL = "postgres://postgres:changeme@windmill-postgres:5432/windmill?sslmode=disable";
      MODE = "server";
    };
    
    ports = [
      "8000:8000"  # Windmill API and web UI
      "2525:2525"  # SMTP server
    ];
    
    extraOptions = [
      "--network=podman"
    ];
  };
  
  # Windmill workers (3 replicas for different tasks)
  virtualisation.oci-containers.containers.windmill-worker1 = {
    
    image = "ghcr.io/windmill-labs/windmill:main";
    autoStart = true;
    
    environment = {
      DATABASE_URL = "postgres://postgres:changeme@windmill-postgres:5432/windmill?sslmode=disable";
      MODE = "worker";
      WORKER_GROUP = "default";
    };
    
    volumes = [
      "/var/lib/windmill-dependency-cache:/tmp/windmill/dep"
      "/var/lib/windmill-logs:/tmp/windmill/logs"
    ];
    
    extraOptions = [
      "--network=windmill-network"
      "--cpus=1"
      "--memory=2g"
    ];
  };
  
  # Native worker for lightweight jobs
  virtualisation.oci-containers.containers.windmill-native-worker = {
    
    image = "ghcr.io/windmill-labs/windmill:main";
    autoStart = true;
    
    environment = {
      DATABASE_URL = "postgres://postgres:changeme@windmill-postgres:5432/windmill?sslmode=disable";
      MODE = "worker_native";
      WORKER_GROUP = "native";
    };
    
    volumes = [
      "/var/lib/windmill-dependency-cache:/tmp/windmill/dep"
      "/var/lib/windmill-logs:/tmp/windmill/logs"
    ];
    
    extraOptions = [
      "--network=windmill-network"
      "--cpus=1"
      "--memory=2g"
    ];
  };
  
  # Caddy reverse proxy
  virtualisation.oci-containers.containers.windmill-caddy = {
    
    image = "ghcr.io/windmill-labs/windmill-l4:latest";
    autoStart = true;
    
    ports = [
      "80:80"   # HTTP
      "25:25"   # SMTP for webhooks
    ];
    
    volumes = [
      "/var/lib/windmill-caddy:/data"
    ];
    
    environment = {
      BASE_URL = ":80";
    };
    
    extraOptions = [
      "--network=podman"
    ];
  };
}
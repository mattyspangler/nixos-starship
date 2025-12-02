{
  virtualisation.oci-containers.containers.qdrant = {
    image = "qdrant/qdrant";
    autoStart = false;  # Disabled by default, enabled per-machine
    ports = [ "6333:6333" ];
  };
}
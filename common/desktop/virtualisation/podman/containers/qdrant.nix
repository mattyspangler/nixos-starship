{
  virtualisation.oci-containers.containers.qdrant = {
    image = "qdrant/qdrant";
    ports = [ "6333:6333" ];
  };
}
{ lib, ... }: {
  virtualisation.oci-containers.containers = {
    container-name = {
      image = "";
      autoStart = true;
      ports = [ "" ];
    };
  };
}

{
  lib,
  stdenv,
  gcc,
  fetchFromGitHub,
  cmake,
  dtc,
  ...
}: let
  pname = "rpi-utils";
  version = "current-20241010";
  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "utils";
    rev = "371ae96ff6d8b869d4125137fdc73b86fe154245";
    hash = "sha256-qYpfy3PtPXzzunKsKSgsQXRUALQz6FSCsHQLe7djSt0=";
  };
in
  stdenv.mkDerivation {
    inherit pname version src;
    nativeBuildInputs = [gcc cmake];
    buildInputs = [dtc];

    makeFlags = [
      "prefix=${placeholder "out"}"
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      install -m755 ./pinctrl/pinctrl $out/bin/pinctrl
      runHook postInstall
    '';

    meta = with lib; {
      homepage = "https://github.com/raspberrypi/utils";
      description = "A collection of scripts and simple applications for Raspberry PI";
      license = licenses.bsd3;
      platforms = ["aarch64-linux"];
    };
  }

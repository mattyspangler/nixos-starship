{ config, pkgs, ... }: {
{
  security.apparmor.enable = true;
  
  #security.apparmor.policies."application".profile = ''
  #  include "${profile-path-here}"
  #'';

  

}

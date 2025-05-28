self: super:
{
  weechat = super.weechat.override {
    configure = { availablePlugins, ... }: {
      plugins = builtins.attrValues (availablePlugins // {
        python = availablePlugins.python.withPackages (ps: with ps; [
          pycrypto
          #python-dbus
        ]);
      });

      init = ''
      /server add bitlbee localhost/6667 -autoconnect
      /set irc.server.bitlbee.tls_verify off
      /set irc.server.bitlbee.tls off
      '';
    };
  };
}



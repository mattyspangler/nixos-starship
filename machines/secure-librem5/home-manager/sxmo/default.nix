{
  pkgs,
  ...
}:
{

  home = {
    # All packages relevant to my Sway environment:
    packages = with pkgs; [
      xorg.xrdb
    ];

    file = {
      # For adding applications to the swipe down menu
      # https://wiki.postmarketos.org/wiki/Sxmo/Tips_and_Tricks
      #".config/sxmo/hooks/sxmo_hook_after_call.sh".source = ./hooks/sxmo_hook_after_call.sh;
      ".config/sxmo/hooks/sxmo_hook_apps.sh".source = ./hooks/sxmo_hook_apps.sh;
      #".config/sxmo/hooks/sxmo_hook_battery.sh".source = ./hooks/sxmo_hook_battery.sh;
      #".config/sxmo/hooks/sxmo_hook_block_call.sh".source = ./hooks/sxmo_hook_block_call.sh;
      #".config/sxmo/hooks/sxmo_hook_block_suspend.sh".source = ./hooks/sxmo_hook_block_suspend.sh;
      #".config/sxmo/hooks/sxmo_hook_call_audio.sh".source = ./hooks/sxmo_hook_call_audio.sh;
      #".config/sxmo/hooks/sxmo_hook_contextmenu_fallback.sh".source = ./hooks/sxmo_hook_contextmenu_fallback.sh;
      #".config/sxmo/hooks/sxmo_hook_contextmenu.sh".source = ./hooks/sxmo_hook_contextmenu.sh;
      #".config/sxmo/hooks/sxmo_hook_desktop_widget.sh".source = ./hooks/sxmo_hook_desktop_widget.sh;
      #".config/sxmo/hooks/sxmo_hook_discard.sh".source = ./hooks/sxmo_hook_discard.sh;
      #".config/sxmo/hooks/sxmo_hook_hangup.sh".source = ./hooks/sxmo_hook_hangup.sh;
      #".config/sxmo/hooks/sxmo_hook_icons.sh".source = ./hooks/sxmo_hook_icons.sh;
      #".config/sxmo/hooks/sxmo_hook_inputhandler.sh".source = ./hooks/sxmo_hook_inputhandler.sh;
      #".config/sxmo/hooks/sxmo_hook_lisgdstart.sh".source = ./hooks/sxmo_hook_lisgdstart.sh;
      #".config/sxmo/hooks/sxmo_hook_lock.sh".source = ./hooks/sxmo_hook_lock.sh;
      #".config/sxmo/hooks/sxmo_hook_locker.sh".source = ./hooks/sxmo_hook_locker.sh;
      #".config/sxmo/hooks/sxmo_hook_lockstatusbar.sh".source = ./hooks/sxmo_hook_lockstatusbar.sh;
      #".config/sxmo/hooks/sxmo_hook_logout.sh".source = ./hooks/sxmo_hook_logout.sh;
      #".config/sxmo/hooks/sxmo_hook_missed_call.sh".source = ./hooks/sxmo_hook_missed_call.sh;
      #".config/sxmo/hooks/sxmo_hook_mnc.sh".source = ./hooks/sxmo_hook_mnc.sh;
      #".config/sxmo/hooks/sxmo_hook_modem.sh".source = ./hooks/sxmo_hook_modem.sh;
      #".config/sxmo/hooks/sxmo_hook_mute_ring.sh".source = ./hooks/sxmo_hook_mute_ring.sh;
      #".config/sxmo/hooks/sxmo_hook_network_down.sh".source = ./hooks/sxmo_hook_network_down.sh;
      #".config/sxmo/hooks/sxmo_hook_network_pre_down.sh".source = ./hooks/sxmo_hook_network_pre_down.sh;
      #".config/sxmo/hooks/sxmo_hook_network_pre_up.sh".source = ./hooks/sxmo_hook_network_pre_up.sh;
      #".config/sxmo/hooks/sxmo_hook_network_up.sh".source = ./hooks/sxmo_hook_network_up.sh;
      #".config/sxmo/hooks/sxmo_hook_notification.sh".source = ./hooks/sxmo_hook_notification.sh;
      #".config/sxmo/hooks/sxmo_hook_notifications.sh".source = ./hooks/sxmo_hook_notifications.sh;
      #".config/sxmo/hooks/sxmo_hook_pickup.sh".source = ./hooks/sxmo_hook_pickup.sh;
      #".config/sxmo/hooks/sxmo_hook_postwake.sh".source = ./hooks/sxmo_hook_postwake.sh;
      #".config/sxmo/hooks/sxmo_hook_power.sh".source = ./hooks/sxmo_hook_power.sh;
      #".config/sxmo/hooks/sxmo_hook_restart_modem_daemons.sh".source = ./hooks/sxmo_hook_restart_modem_daemons.sh;
      #".config/sxmo/hooks/sxmo_hook_ring.sh".source = ./hooks/sxmo_hook_ring.sh;
      #".config/sxmo/hooks/sxmo_hook_rotate.sh".source = ./hooks/sxmo_hook_rotate.sh;
      #".config/sxmo/hooks/sxmo_hook_screenoff.sh".source = ./hooks/sxmo_hook_screenoff.sh;
      #".config/sxmo/hooks/sxmo_hook_scripts.sh".source = ./hooks/sxmo_hook_scripts.sh;
      #".config/sxmo/hooks/sxmo_hook_sendsms.sh".source = ./hooks/sxmo_hook_sendsms.sh;
      #".config/sxmo/hooks/sxmo_hook_sms.sh".source = ./hooks/sxmo_hook_sms.sh;
      #".config/sxmo/hooks/sxmo_hook_smslog.sh".source = ./hooks/sxmo_hook_smslog.sh;
      #".config/sxmo/hooks/sxmo_hook_start.sh".source = ./hooks/sxmo_hook_start.sh;
      #".config/sxmo/hooks/sxmo_hook_statusbar.sh".source = ./hooks/sxmo_hook_statusbar.sh;
      #".config/sxmo/hooks/sxmo_hook_stop.sh".source = ./hooks/sxmo_hook_stop.sh;
      #".config/sxmo/hooks/sxmo_hook_tailtextlog.sh".source = ./hooks/sxmo_hook_tailtextlog.sh;
      #".config/sxmo/hooks/sxmo_hook_unlock.sh".source = ./hooks/sxmo_hook_unlock.sh;
      #".config/sxmo/hooks/sxmo_hook_wallpaper.sh".source = ./hooks/sxmo_hook_wallpaper.sh;
      ".config/sxmo/bonsai_tree.json".source = ./bonsai_tree.json;
      #".config/conky/conky.conf".source = ./conky.conf;
      ".config/sxmo/conky.conf".source = ./conky.conf;
      ".config/sxmo/profile".source = ./profile;
      ".config/sxmo/sway".source = ./sway;
      ".Xresources".source = ./.Xresources;
      ".config/sxmo/userscripts/macchanger.sh" = ./macchanger.sh;
    };

  }; # end home block

  xdg.configFile."sway/config".source = ./sway;
}

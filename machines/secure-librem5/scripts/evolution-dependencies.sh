# Gnome's Evolution, Contacts, and Calendar apps wouldn't work in flatpak on postmarketos unless I installed these first:
sudo apk add dconf-systemd evolution-data-server evolution-data-server-systemd
sudo chmod -x $(type -p gnome-keyring-daemon) # conflicts with keepassxc secret service which I prefer to use
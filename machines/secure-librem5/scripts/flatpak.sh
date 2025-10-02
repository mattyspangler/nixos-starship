# Configures postmarketos for flatpak
sudo apk add postmarketos-base-ui-flatpak

# Enable apparmor
sudo apk add postmarketos-apparmor-profiles apparmor apparmor-utils
sudo rc-update add apparmor boot

sudo cp ./90-user-namespaces.conf /etc/sysctl.d/
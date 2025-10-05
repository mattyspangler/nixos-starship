# The purpose of this script is to get xdg desktop portals working so flatpaks can open links with the default browser properly

# Install the accountsservice package
sudo apk add accountsservice

# Enable and start the service
sudo systemctl enable --now accounts-daemon.service
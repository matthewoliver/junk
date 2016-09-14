# This should be done as root.
apt-get update; apt-get install -y git htop tmux vim-nox unzip fontconfig; adduser matt; gpasswd -a matt sudo; sudo su - matt

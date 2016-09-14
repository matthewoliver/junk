# This should be done as root.
apt-get update; apt-get install -y git htop tmux vim-nox unzip fontconfig; adduser matt; gpasswd -a matt sudo; sudo su - matt

# yum install git htop tmux vim unzip fontconfig; adduser matt; gpasswd -a matt wheel; passwd matt; sudo su - matt

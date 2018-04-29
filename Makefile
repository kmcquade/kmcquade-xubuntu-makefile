#
# Ubuntu 18.04 (Bionic Beaver)
#
# Basic packages i usually install.
#
# Author: Julius Beckmann <github@h4cc.de>
#
# Upgraded Script from 17.04: https://gist.github.com/h4cc/09b7fe843bb737c8039ac62d831f244e
# Upgraded Script from 16.04: https://gist.github.com/h4cc/fe48ed9d85bfff3008704919062f5c9b
# Upgraded Script from 14.04: https://gist.github.com/h4cc/7be7f940325614dc59fb
#

.PHONY:	all preparations libs update upgrade fonts python ruby virtualbox graphics networking dropbox slack archives system harddisk ansible filesystem nodejs postgresql encfs_manager wine xmind spotify tfenv packer vagrant vault consul
SHELL := /bin/bash

all:
	@echo "Installation of ALL targets"
	@echo ${USER}
	make preparations libs
	make upgrade
	make fonts
	make graphics networking
	make dropbox slack
	make archives system harddisk filesystem encfs_manager
	make ansible virtualbox
	make nodejs
	make mysql mysql-workbench postgresql
	make wine
	make ruby
	make xmind
	make spotify
	make tfenv packer vagrant vault consul


preparations:
	make update
	sudo apt -y install software-properties-common build-essential checkinstall wget curl git libssl-dev apt-transport-https ca-certificates gdebi-core

libs:
	sudo apt -y install libavahi-compat-libdnssd-dev

update:
	sudo apt update

upgrade:
	sudo apt -y upgrade

fonts:
	mkdir -p ~/.fonts/
	sudo DEBIAN_FRONTEND=noninteractive apt -y install ttf-mscorefonts-installer # Install Microsoft fonts.
	rm -f ~/.fonts/FiraCode-*
	wget https://github.com/tonsky/FiraCode/raw/master/distr/otf/FiraCode-Bold.otf -O ~/.fonts/FiraCode-Bold.otf
	wget https://github.com/tonsky/FiraCode/raw/master/distr/otf/FiraCode-Light.otf -O ~/.fonts/FiraCode-Light.otf
	wget https://github.com/tonsky/FiraCode/raw/master/distr/otf/FiraCode-Medium.otf -O ~/.fonts/FiraCode-Medium.otf
	wget https://github.com/tonsky/FiraCode/raw/master/distr/otf/FiraCode-Regular.otf -O ~/.fonts/FiraCode-Regular.otf
	wget https://github.com/tonsky/FiraCode/raw/master/distr/otf/FiraCode-Retina.otf -O ~/.fonts/FiraCode-Retina.otf
	fc-cache -v

python:
	make preparations
	sudo -H apt -y install python-pip
	sudo -H apt -y install python3-pip
	sudo -H pip install --upgrade pip

archives:
	sudo apt -y install unace unrar zip unzip p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract file-roller

virtualbox:
	echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian bionic contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
	wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
	sudo apt -y install virtualbox
	# currently a bug with the extension pack installation on 18.04, as noted here:
	# https://ubuntuforums.org/showthread.php?t=2390333#post_13760715
	#sudo apt -y install virtualbox-ext-pack

networking:
	echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections # Remove prompt for wireshark
	sudo apt -y install remmina wireshark-gtk zenmap samba ethtool transmission-gtk

dropbox:
	sudo apt -y install nautilus-dropbox

ansible:
	#sudo apt-add-repository -y ppa:ansible/ansible
	#make update
	sudo apt -y install ansible

graphics:
	sudo apt -y install gimp gimp-data gimp-plugin-registry gimp-data-extras shutter graphviz

ruby:
	sudo apt -y install git curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev yarn
	curl -sSL https://rvm.io/mpapis.asc | gpg --import -
	curl -sSL https://get.rvm.io | bash -s stable --ruby
	rvm install 2.5.1
	rvm --create --ruby-version ruby-2.5.1@devgeneral
	gem install bundler
	#gem install rails

sublime-text:
	for name in {bash,awk,sed,grep,ls,cp,tar,curl,gunzip,bunzip2,git,svn} ; do which $name ;  done
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt update
	sudo apt install sublime-text

nodejs:
	curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

mysql:
	sudo apt -y install mysql-server mysql-client libmysqlclient-dev

mysql-workbench:
	sudo apt -y install mysql-workbench

postgresql:
	sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
	wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
	sudo apt update
	sudo apt -y install postgresql-common
	sudo apt -y install postgresql-9.5 libpq-dev

system:
	sudo apt -y install icedtea-8-plugin openjdk-8-jre subversion git curl vim network-manager-openvpn gparted gnome-disk-utility inotify-tools usb-creator-gtk traceroute cloc whois mssh sqlite3 stress ntp
	#--- Raise inotify limit
	echo "fs.inotify.max_user_watches = 524288" | sudo tee /etc/sysctl.d/60-inotify.conf
	sudo service procps restart

wine:
	sudo DEBIAN_FRONTEND=noninteractive apt -y install ttf-mscorefonts-installer # Install Microsoft fonts.
	# Based on https://wiki.winehq.org/Ubuntu
	rm -f winerelease.key
	wget -nc https://dl.winehq.org/wine-builds/Release.key -q -O /tmp/winerelease.key
	sudo dpkg --add-architecture i386
	sudo apt-key add /tmp/winerelease.key
	sudo apt-add-repository -s "deb https://dl.winehq.org/wine-builds/ubuntu/ artful main" #hack until bionic packages are released
	sudo apt -y install --install-recommends winehq-devel fonts-wine

harddisk:
	sudo apt -y install smartmontools gsmartcontrol smart-notifier hardinfo

xmind:
	wget http://dl2.xmind.net/xmind-downloads/xmind-7-update1-linux_amd64.deb -P /tmp/
	sudo apt -y install lame libwebkitgtk-1.0-0
	yes y | sudo gdebi /tmp/xmind-7-*

spotify:
	sudo snap install spotify

tfenv:
	sudo chown ${USER}:${USER} /opt/
	git clone git clone https://github.com/kamatama41/tfenv.git /opt/
	sudo ln -sf /opt/tfenv/bin/tfenv /usr/local/bin/tfenv
	sudo ln -sf /opt/tfenv/bin/terraform /usr/local/bin/terraform
	tfenv list
	tfenv install latest
	terraform --version

packer:
	wget https://releases.hashicorp.com/packer/1.2.3/packer_1.2.3_linux_amd64.zip -P /tmp/
	unzip /tmp/packer_*
	mkdir /opt/packer
	cp /tmp/packer /opt/packer
	sudo ln -sf /opt/packer/packer /usr/local/bin/packer

vagrant:
	wget https://releases.hashicorp.com/vagrant/2.0.4/vagrant_2.0.4_x86_64.deb -P /tmp/
	yes y | sudo gdebi /tmp/vagrant_*

vault:
	wget https://releases.hashicorp.com/vault/0.10.1/vault_0.10.1_linux_amd64.zip -P /tmp/
	unzip /tmp/vault_*
	mkdir /opt/vault
	cp /tmp/vault /opt/vault
	sudo ln -sf /opt/vault/vault /usr/local/bin/vault

consul:
	wget https://releases.hashicorp.com/consul/1.0.7/consul_1.0.7_linux_amd64.zip -P /tmp/
	unzip /tmp/consul_*
	mkdir /opt/consul
	cp /tmp/consul/ /opt/consul
	sudo ln -sf /opt/consul/consul /usr/local/bin/consul

awscli:
	sudo pip install awscli
	sudo pip install aws-shell

azure:
	sudo apt install apt-transport-https
	sudo echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bionic main binary-amd64" > sudo tee /etc/apt/sources.list.d/azure-cli.list
	sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893
	curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
	sudo apt update
	sudo apt install libssl-dev libffi-dev
	sudo apt install python-dev
	# workaround until bionic is added properly - https://github.com/Azure/azure-cli/issues/5731#issuecomment-383232119
	wget https://azurecliprod.blob.core.windows.net/release-2-0-31/azure-cli_2.0.31-1~bionic_all.deb -P /tmp/
	yes y | sudo gdebi /tmp/azure-cli_*
	#sudo apt -y install azure-cli
	az
	# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest
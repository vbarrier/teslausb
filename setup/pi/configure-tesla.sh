#!/bin/bash

echo "Install go"
cd $HOME
wget "https://dl.google.com/go/$(curl https://go.dev/VERSION?m=text | head -n1).linux-armv6l.tar.gz" -O go.tar.gz
sudo tar -C /usr/local -xzf go.tar.gz

echo "update bash"
cd $HOME
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=/usr/local/go/bin:$PATH:$GOPATH/bin' >> ~/.bashrc
echo 'export TESLA_PUBLIC_KEY=$HOME/tesla/public-key.pem' >> ~/.bashrc
echo 'export TESLA_PRIVATE_KEY=$HOME/tesla/private-key.pem' >> ~/.bashrc
echo 'export TESLA_VIN=$VIN' >> ~/.bashrc
source ~/.bashrc

echo "Install Tesla Command"
cd $HOME
mkdir tesla
wget https://github.com/teslamotors/vehicle-command/archive/refs/heads/main.zip
unzip main.zip
cd vehicle-command-main
go get ./...
go build ./...
go install ./...
cd $HOME
rm main.zip
rm vehicle-command-main

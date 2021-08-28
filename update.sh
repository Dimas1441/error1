#!/bin/bash

if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- ifconfig.me/ip);
clear
echo "Start Update"
# update
cd /usr/bin

wget -O v2raay "https://raw.githubusercontent.com/Dimas1441/error1/main/update/v2raay.sh"
wget -o bbr "https://raw.githubusercontent.com/Dimas1441/error1/main/update/bbr.sh"
wget -O l2tp "https://raw.githubusercontent.com/Dimas1441/error1/main/update/l2tp.sh"
wget -O ssh "https://raw.githubusercontent.com/Dimas1441/error1/main/update/ssh.sh"
wget -O ssssr "https://raw.githubusercontent.com/Dimas1441/error1/main/update/ssssr.sh"
wget -O sstpp "https://raw.githubusercontent.com/Dimas1441/error1/main/update/sstpp.sh"
wget -O trojaan "https://raw.githubusercontent.com/Dimas1441/error1/main/update/trojaan.sh"
wget -O vleess "https://raw.githubusercontent.com/Dimas1441/error1/main/update/vleess.sh"
wget -O wgr "https://raw.githubusercontent.com/Dimas1441/error1/main/update/wgr.sh"
wget -O menu "https://raw.githubusercontent.com/Dimas1441/error1/main/update/menu.sh"
wget -O resett "https://raw.githubusercontent.com/Dimas1441/error1/main/resett.sh"
wget -O status "https://raw.githubusercontent.com/Dimas1441/error1/main/status.sh"
wget -O add-trgo "https://raw.githubusercontent.com/Dimas1441/error1/main/update/add-trgo.sh"
wget -O del-trgo "https://raw.githubusercontent.com/Dimas1441/error1/main/update/del-trgo.sh"
wget -O renew-trgo "https://raw.githubusercontent.com/Dimas1441/error1/main/update/renew-trgo.sh"
wget -O cek-trgo "https://raw.githubusercontent.com/Dimas1441/error1/main/update/cek-trgo.sh"
wget -O trojanGO "https://raw.githubusercontent.com/Dimas1441/error1/main/update/trojanGO.sh"
chmod +x v2raay
chmod +x bbr
chmod +x l2tp
chmod +x ssh
chmod +x ssssr
chmod +x sstpp
chmod +x trojaan
chmod +x vleess
chmod +x wgr
chmod +x menu
chmod +x resett
chmod +x status
chmod +x add-trgo
chmod +x del-trgo
chmod +x renew-trgo
chmod +x cek-trgo
chmod +x trojanGO
echo "done"

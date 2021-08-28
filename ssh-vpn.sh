#!/bin/bash
# initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ifconfig.me/ip);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

#detail nama perusahaan
country=ID
state=Indonesia
locality=Indonesia
organization=www.premium-server.xyz
organizationalunit=www.premium-server.xyz
commonname=www.premium-server.xyz
email=admin@premium-server.xyz

# simple password minimal
wget -O /etc/pam.d/common-password "https://raw.githubusercontent.com/Dimas1441/error1/main/password"
chmod +x /etc/pam.d/common-password

# go to root
cd

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/bin/wstunnel
cat > /etc/bin/wstunnel <<-END
#!/bin/sh -e
# wstunnel
# By default this script does nothing
exit 0
END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/bin/wstunnel

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#update
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y

# install wget and curl
apt -y install wget curl
apt -y install python

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# install
apt-get --reinstall --fix-missing install -y bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl neofetch git lsof
echo "clear" >> .profile
echo "neofetch" >> .profile
echo "echo by Brody" >> .profile

# install webserver
apt -y install nginx
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/Dimas1441/error1/main/nginx.conf"
mkdir -p /home/vps/public_html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/Dimas1441/error1/main/vps.conf"
/etc/init.d/nginx restart

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/Dimas1441/error1/main/badvpn-udpgw64"
chmod +x /usr/bin/badvpn-udpgw
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500' /etc/bin/wstunnel
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500

# setting port ssh
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config

# install dropbear
apt -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart

# install squid
cd
apt -y install squid3
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/Dimas1441/error1/main/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf

# setting vnstat
apt -y install vnstat
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6

# install stunnel
apt install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 222
connect = 127.0.0.1:109

[dropbear]
accept = 777
connect = 127.0.0.1:22

[openvpn]
accept = 442
connect = 127.0.0.1:1194

[wsssl]
accept = 445
connect = 700

END

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

#OpenVPN
wget https://raw.githubusercontent.com/Dimas1441/error1/main/vpn.sh && dos2unix vpn.sh &&  chmod +x vpn.sh && ./vpn.sh

# install fail2ban
apt -y install fail2ban

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'

# xml parser
cd
apt install -y libxml-parser-perl

# banner /etc/issue.net
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

#install bbr dan optimasi kernel
wget https://raw.githubusercontent.com/Dimas1441/error1/main/bbr.sh && dos2unix bbr.sh && chmod +x bbr.sh && ./bbr.sh
wget https://raw.githubusercontent.com/Dimas1441/error1/main/set-br.sh && chmod +x set-br.sh && ./set-br.sh

# blockir torrent
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# install python
apt -y install ruby
gem install lolcat
apt -y install figlet
apt -y install dos2unix

# download script
cd /usr/bin
wget -O /usr/bin/add-host https://raw.githubusercontent.com/Dimas1441/error1/main/add-host.sh && dos2unix /usr/bin/add-host && chmod +x /usr/bin/add-host
wget -O /usr/bin/about https://raw.githubusercontent.com/Dimas1441/error1/main/about.sh && dos2unix /usr/bin/about && chmod +x /usr/bin/about
wget -O /usr/bin/menuu https://raw.githubusercontent.com/Dimas1441/error1/main/menuu.sh && dos2unix /usr/bin/menuu && chmod +x /usr/bin/menuu
wget -O /usr/bin/usernew https://raw.githubusercontent.com/Dimas1441/error1/main/usernew.sh && dos2unix /usr/bin/usernew && chmod +x /usr/bin/usernew
wget -O /usr/bin/trial https://raw.githubusercontent.com/Dimas1441/error1/main/trial.sh && dos2unix /usr/bin/trial && chmod +x /usr/bin/trial
wget -O /usr/bin/hapus https://raw.githubusercontent.com/Dimas1441/error1/main/hapus.sh && dos2unix /usr/bin/hapus && chmod +x /usr/bin/hapus
wget -O /usr/bin/member https://raw.githubusercontent.com/Dimas1441/error1/main/member.sh && dos2unix /usr/bin/member && chmod +x /usr/bin/member
wget -O /usr/bin/delete https://raw.githubusercontent.com/Dimas1441/error1/main/delete.sh && dos2unix /usr/bin/delete && chmod +x /usr/bin/delete
wget -O /usr/bin/cek https://raw.githubusercontent.com/Dimas1441/error1/main/cek.sh && dos2unix /usr/bin/cek && chmod +x /usr/bin/cek
wget -O /usr/bin/restart https://raw.githubusercontent.com/Dimas1441/error1/main/restart.sh && dos2unix /usr/bin/restart && chmod +x /usr/bin/restart
wget -O /usr/bin/speedtest https://raw.githubusercontent.com/Dimas1441/error1/main/speedtest_cli.py && dos2unix /usr/bin/speedtest && chmod +x /usr/bin/speedtest
wget -O /usr/bin/info https://raw.githubusercontent.com/Dimas1441/error1/main/info.sh && dos2unix /usr/bin/info && chmod +x /usr/bin/info
wget -O /usr/bin/ram https://raw.githubusercontent.com/Dimas1441/error1/main/ram.sh && dos2unix /usr/bin/ram && chmod +x /usr/bin/ram
wget -O /usr/bin/renew https://raw.githubusercontent.com/Dimas1441/error1/main/renew.sh && dos2unix /usr/bin/renew && chmod +x /usr/bin/renew
wget -O /usr/bin/autokill https://raw.githubusercontent.com/Dimas1441/error1/main/autokill.sh && dos2unix /usr/bin/autokill && chmod +x /usr/bin/autokill
wget -O /usr/bin/ceklim https://raw.githubusercontent.com/Dimas1441/error1/main/ceklim.sh && dos2unix /usr/bin/ceklim && chmod +x /usr/bin/ceklim
wget -O /usr/bin/tendang https://raw.githubusercontent.com/Dimas1441/error1/main/tendang.sh && dos2unix /usr/bin/tendang && chmod +x /usr/bin/tendang
wget -O /usr/bin/clear-log https://raw.githubusercontent.com/Dimas1441/error1/main/clear-log.sh && dos2unix /usr/bin/clear-log && chmod +x /usr/bin/clear-log
wget -O /usr/bin/change-port https://raw.githubusercontent.com/Dimas1441/error1/main/change.sh && dos2unix /usr/bin/change && chmod +x /usr/bin/change
wget -O /usr/bin/port-ovpn https://raw.githubusercontent.com/Dimas1441/error1/main/port-ovpn.sh && dos2unix /usr/bin/port-ovpn && chmod +x /usr/bin/port-ovpn
wget -O /usr/bin/port-ssl https://raw.githubusercontent.com/Dimas1441/error1/main/port-ssl.sh && dos2unix /usr/bin/port-ssl && chmod +x /usr/bin/port-ssl
wget -O /usr/bin/port-wg https://raw.githubusercontent.com/Dimas1441/error1/main/port-wg.sh && dos2unix /usr/bin/port-wg && chmod +x /usr/bin/port-wg
wget -O /usr/bin/port-tr https://raw.githubusercontent.com/Dimas1441/error1/main/port-tr.sh && dos2unix /usr/bin/port-tr && chmod +x /usr/bin/port-tr
wget -O /usr/bin/port-sstp https://raw.githubusercontent.com/Dimas1441/error1/main/port-sstp.sh && dos2unix /usr/bin/port-sstp && chmod +x /usr/bin/port-sstp
wget -O /usr/bin/port-squid https://raw.githubusercontent.com/Dimas1441/error1/main/port-squid.sh && dos2unix /usr/bin/port-squid && chmod +x /usr/bin/port-squid
wget -O /usr/bin/port-ws https://raw.githubusercontent.com/Dimas1441/error1/main/port-ws.sh && dos2unix /usr/bin/port-ws && chmod +x /usr/bin/port-ws
wget -O /usr/bin/port-vless https://raw.githubusercontent.com/Dimas1441/error1/main/port-vless.sh && dos2unix /usr/bin/port-vless && chmod +x /usr/bin/port-vless
wget -O /usr/bin/wbmn https://raw.githubusercontent.com/Dimas1441/error1/main/webmin.sh && dos2unix /usr/bin/wbmn && chmod +x /usr/bin/wbmn
wget -O /usr/bin/xp https://raw.githubusercontent.com/Dimas1441/error1/main/xp.sh && dos2unix /usr/bin/xp && chmod +x /usr/bin/xp
wget -O /usr/bin/update https://raw.githubusercontent.com/Dimas1441/error1/main/update.sh && dos2unix /usr/bin/update && chmod +x /usr/bin/update
wget -O /usr/bin/bbr https://raw.githubusercontent.com/Dimas1441/error1/main/bbr.sh && dos2unix /usr/bin/bbr && chmod +x /usr/bin/bbr
wget -O /usr/bin/user-limit https://raw.githubusercontent.com/Dimas1441/error1/main/user-limit.sh && dos2unix /usr/bin/user-limit && chmod +x /usr/bin/user-limit
wget -O /usr/bin/cfd https://raw.githubusercontent.com/Dimas1441/error1/main/cfd.sh && dos2unix /usr/bin/cfd && chmod +x /usr/bin/cfd
wget -O /usr/bin/cff https://raw.githubusercontent.com/Dimas1441/error1/main/cff.sh && dos2unix /usr/bin/cff && chmod +x /usr/bin/cff
wget -O /usr/bin/cfh https://raw.githubusercontent.com/Dimas1441/error1/main/cfh.sh && dos2unix /usr/bin/cfh && chmod +x /usr/bin/cfg
wget -O /usr/bin/ autoreboot https://raw.githubusercontent.com/Dimas1441/error1/main/autoreboot.sh && dos2unix /usr/bin/autoreboot && chmod +x /usr/bin/
wget -O /usr/bin/bannerku https://raw.githubusercontent.com/Dimas1441/error1/main/bannerku && dos2unix /usr/bin/bannerku && chmod +x /usr/bin/bannerku
wget -O /usr/bin/running https://raw.githubusercontent.com/Dimas1441/error1/main/running.sh && dos2unix /usr/bin/running && chmod +x /usr/bin/running

echo "0 5 * * * root clear-log && reboot" >> /etc/crontab
echo "0 0 * * * root xp" >> /etc/crontab
# remove unnecessary files
cd
apt autoclean -y
apt -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt autoremove -y
# finishing
cd
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/stunnel4 restart
/etc/init.d/vnstat restart
/etc/init.d/squid restart
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500
history -c
echo "unset HISTFILE" >> /etc/profile

cd
rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh-vpn.sh

apt install dnsutils jq -y
apt-get install net-tools -y
apt-get install tcpdump -y
apt-get install dsniff -y
apt install grepcidr -y

# finihsing
clear

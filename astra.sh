#!/bin/sh



# Deshabilitar IPv6
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1

# Instalar Drivers TBS
apt install curl -y
curl -sSf https://cdn.cesbo.com/astra/scripts/drv-tbs.sh | sh

# Cambiar el modo de la TBS SAT
echo "options stid135 mode=1" > /etc/modprobe.d/stid135.conf

# Validar TBS
ls /dev/dvb
sleep 10

# Instalar Astra
curl -Lo /usr/bin/astra https://cesbo.com/astra-latest
chmod +x /usr/bin/astra
astra -v
astra init

# Habilitar para cambiar puerto
systemctl start astra
systemctl enable astra

# EPG - Aggregator
#curl -Lo /etc/astra/epg-aggregator.lua https://cdn.cesbo.com/astra/scripts/epg-aggregator/epg-aggregator.lua
#cd /etc/systemd/system/
#wget https://cdn.cesbo.com/astra/scripts/epg-aggregator/astra-epg.service
#systemctl start astra-epg
#systemctl enable astra-epg
#(crontab -l ; echo "0 4 * * * systemctl restart astra-epg") | crontab -

# Configuración Astra
cd /etc/astra
rm astra.conf
wget https://raw.githubusercontent.com/josemestre3009/config-server-catv/refs/heads/main/astra.conf
systemctl restart astra

# Instalar Oscam
cd /home/adminsky
apt-get update
apt-get -y install subversion dialog
svn co http://svn.speedbox.me/svn/oscam-install/trunk oscam
chmod -R 0755 oscam
cd oscam
./install.sh

# Reiniciar
reboot

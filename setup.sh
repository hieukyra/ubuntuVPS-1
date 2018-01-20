#!/bin/sh
adduser user
apt-get update && apt-get upgrade -y && apt-get install nano software-properties-common python-software-properties fail2ban nano xfce4 xfce4-goodies tightvncserver firefox htop nload -y
sleep 1s
myuser="user"
sleep 1s
mypasswd=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w8 | head -n1)
sleep 1s
mkdir /home/$myuser/.vnc
sleep 1s
echo $mypasswd | vncpasswd -f > /home/$myuser/.vnc/passwd
sleep 1s
chown -R $myuser:$myuser /home/$myuser/.vnc
sleep 1s
chmod 0600 /home/$myuser/.vnc/passwd
sleep 1s
echo "VNC Pass: $mypasswd" >> ~/vncpasswd
sleep 1s
su - user -c "vncserver -kill :1"
su - user -c "mv ~/.vnc/xstartup ~/.vnc/xstartup.bak"
su - user -c "echo '#!/bin/bash' >> ~/.vnc/xstartup"
su - user -c "echo 'xrdb ~/.Xresources' >> ~/.vnc/xstartup"
su - user -c "echo 'startxfce4 &' >> ~/.vnc/xstartup"
su - user -c "chmod +x ~/.vnc/xstartup"
su - user -c "vncserver"
echo "[Unit]" >> /etc/systemd/system/vncserver@1.service
echo "Description=Start TightVNC server at startup" >> /etc/systemd/system/vncserver@1.service
echo "After=syslog.target network.target" >> /etc/systemd/system/vncserver@1.service
echo "" >> /etc/systemd/system/vncserver@1.service
echo "[Service]" >> /etc/systemd/system/vncserver@1.service
echo "Type=forking" >> /etc/systemd/system/vncserver@1.service
echo "User=user" >> /etc/systemd/system/vncserver@1.service
echo "PAMName=login" >> /etc/systemd/system/vncserver@1.service
echo "PIDFile=/home/user/.vnc/%H:%i.pid" >> /etc/systemd/system/vncserver@1.service
echo "ExecStartPre=-/usr/bin/vncserver -kill :%i > /dev/null 2>&1" >> /etc/systemd/system/vncserver@1.service
echo "ExecStart=/usr/bin/vncserver -depth 24 -geometry 1280x800 -localhost :%i" >> /etc/systemd/system/vncserver@1.service
echo "ExecStop=/usr/bin/vncserver -kill :%i" >> /etc/systemd/system/vncserver@1.service
echo "" >> /etc/systemd/system/vncserver@1.service
echo "[Install]" >> /etc/systemd/system/vncserver@1.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/vncserver@1.service
systemctl daemon-reload
systemctl enable vncserver@1.service
su - user -c "vncserver -kill :1"
systemctl start vncserver@1
add-apt-repository ppa:webupd8team/java -y
apt-get update
# temp fix to webupd8 issue
cd /var/lib/dpkg/info
sed -i 's|JAVA_VERSION=8u151|JAVA_VERSION=8u161|' oracle-java8-installer.*
sed -i 's|PARTNER_URL=http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/|PARTNER_URL=http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/|' oracle-java8-installer.*
sed -i 's|SHA256SUM_TGZ="c78200ce409367b296ec39be4427f020e2c585470c4eed01021feada576f027f"|SHA256SUM_TGZ="6dbc56a0e3310b69e91bb64db63a485bd7b6a8083f08e48047276380a0e2021e"|' oracle-java8-installer.*
sed -i 's|J_DIR=jdk1.8.0_151|J_DIR=jdk1.8.0_161|' oracle-java8-installer.*
# end of fix.
apt-get install oracle-java8-installer -y
apt purge --autoremove xscreensaver -y
echo "DONE!"

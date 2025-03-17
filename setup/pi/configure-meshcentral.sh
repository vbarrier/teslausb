#!/bin/bash

grep -qxF 'export HOME=/root' ~/.bashrc || echo 'export HOME=/root' >> ~/.bashrc
source ~/.bashrc

cd $HOME
mkdir -p meshagent
cd meshagent

(wget "$MESHCENTRAL_SERVER/meshagents?script=1" -O ./meshinstall.sh || wget "$MESHCENTRAL_SERVER/meshagents?script=1" --no-proxy -O ./meshinstall.sh) && chmod 755 ./meshinstall.sh && sudo -E ./meshinstall.sh https://meshcentral.cam.goflexla.com "$MESHCENTRAL_TOKEN_AGENT" || ./meshinstall.sh https://meshcentral.cam.goflexla.com "$MESHCENTRAL_TOKEN_AGENT"

echo "wait 20sec"
sleep 20s

echo "stop meshagent"
systemctl stop meshagent

echo "copy meshagent.db"
mv /usr/local/mesh_services/meshagent/meshagent.db /usr/local/mesh_services/meshagent/meshagent.db.tmp
mkdir -p /var/log/nginx/meshagent
chmod 700 /var/log/nginx/meshagent
cp -rp /usr/local/mesh_services/meshagent/meshagent.db.tmp /var/log/nginx/meshagent/meshagent.db
ln -s /var/log/nginx/meshagent/meshagent.db /usr/local/mesh_services/meshagent/meshagent.db
touch /usr/local/mesh_services/meshagent/meshagentstartup.sh

echo "create startup script"
cat <<EOF > /usr/local/mesh_services/meshagent/meshagentstartup.sh
#!/bin/bash
mkdir -p /var/log/nginx/meshagent
chmod 700 /var/log/nginx/meshagent
cp -rp /usr/local/mesh_services/meshagent/meshagent.db.tmp /var/log/nginx/meshagent/meshagent.db
/usr/local/mesh_services/meshagent/meshagent --installedByUser=0
EOF
chmod +x /usr/local/mesh_services/meshagent/meshagentstartup.sh

cd $HOME/meshagent
echo "update startup agent"
cat <<EOF > meshagent.service
[Unit]
Description=meshagent background service
Wants=network-online.target
After=network-online.target
[Service]
WorkingDirectory=/usr/local/mesh_services/meshagent/
ExecStart=/usr/local/mesh_services/meshagent/meshagentstartup.sh
StandardOutput=null
Restart=on-failure
RestartSec=3
[Install]
WantedBy=multi-user.target
Alias=meshagent.service
EOF
mv meshagent.service /lib/systemd/system/meshagent.service
chmod 777 /lib/systemd/system/meshagent.service
echo "restart meshagent"
systemctl daemon-reload
systemctl start meshagent

cd $HOME
rm $HOME/meshagent -Rf

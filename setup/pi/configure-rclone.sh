#!/bin/bash -eu

curl https://rclone.org/install.sh | sudo bash

mkdir -p $HOME/.config/rclone

echo "create rclone config"
cat <<EOF > $HOME/.config/rclone/rclone.conf
[FlexlaCam]
type = s3
provider = Minio
access_key_id = $RCLONE_ACCESS_KEY_ID 
secret_access_key = $RCLONE_ACCESS_KEY_SECRET
endpoint = $RCLONE_ENDPOINT 
EOF


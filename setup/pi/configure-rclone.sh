#!/bin/bash -eu

if ! command -v "rclone" > /dev/null 2>&1; then
    curl https://rclone.org/install.sh | sudo bash
fi

mkdir -p $HOME/.config/rclone
rm -f $HOME/.config/rclone/rclone.conf

echo "create rclone config"
cat <<EOF > $HOME/.config/rclone/rclone.conf
[$RCLONE_DRIVE]
type = s3
provider = Minio
access_key_id = $RCLONE_ACCESS_KEY_ID 
secret_access_key = $RCLONE_ACCESS_KEY_SECRET
endpoint = $RCLONE_ENDPOINT 
EOF


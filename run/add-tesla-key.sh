#!/bin/bash

setcap 'cap_net_admin=eip' "$(which tesla-control)"
tesla-keygen -key-file ${TESLA_PRIVATE_KEY} -keyring-type file create > ${TESLA_PUBLIC_KEY}
tesla-control -ble add-key-request ${TESLA_PUBLIC_KEY} owner cloud_key

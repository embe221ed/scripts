#!/bin/sh

# contract filename
CONTRACT=$1

# constructor arg[s]
ARG1=$2
# ARG2=$2

# http://...:8545
RPC_URL=$(cat info.json | jq '.rpc_endpoint' -r)

# account private key
PRIVATE_KEY=$(cat info.json | jq '.private_key' -r)


forge \
    create \
    --rpc-url           "${RPC_URL}" \
    --private-key       "${PRIVATE_KEY}" \
    --constructor-args  "${ARG1}" \
    -- \
    ${CONTRACT}

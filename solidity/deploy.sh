#!/bin/sh

# constructor arg
ARG1=$1

# http://...:8545
RPC_URL=$(cat info.json | jq '.rpc_endpoint' -r)

PRIVATE_KEY=$(cat info.json | jq '.private_key' -r)


forge create --rpc-url "${RPC_URL}" \
    --private-key "${PRIVATE_KEY}" \
    --constructor-args "${ARG1}" \
    -- \
    src/Solve.sol:Solve

# tool to deploy and interact with Ethereum smart contracts
# written by @embe221ed
# for CTFs

from pwn import *
import argparse

from web3 import Web3, types
from eth_account import Account
from solcx import compile_standard, install_solc

HOST = "" if args.REMOTE else "localhost"
PORT = 1337
TICKET = ""

INFO = {
    'rpc_endpoint'  : 'RPC ENDPOINT HERE',
    'private_key'   : 'PRIVATE KEY HERE',
    'setup_contract': 'CHALLENGE CONTRACT ADDRESS HERE'
}

def _sign_and_send_transaction(web3: Web3, tx: types.TxParams, private_key: (bytes | str)) -> types.TxReceipt:
    signed_tx = web3.eth.account.sign_transaction(tx, private_key=private_key)
    txhash = web3.eth.send_raw_transaction(signed_tx.rawTransaction)
    tx_receipt = web3.eth.wait_for_transaction_receipt(txhash)
    log.debug(f"tx_receipt: {tx_receipt}")
    return tx_receipt

def compile(fname: str, contract_name: str) -> tuple[dict, str]:
    if args.INSTALL:
        # install Solidity compiler.
        _solc_version = "0.6.6"
        install_solc(_solc_version)

    # compile Exploit smart contract with solcx.
    with open(fname, "r") as contract_file:
        compiled_sol = compile_standard(
            {
                "language": "Solidity",
                "sources": {fname: {"content": contract_file.read()}},
                "settings": {
                    "outputSelection": {
                        "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
                    }
                },
            },
            # solc_version=_solc_version,
        )
    abi         = compiled_sol["contracts"][fname][contract_name]["abi"]
    bytecode    = compiled_sol["contracts"][fname][contract_name]["evm"]["bytecode"]["object"]

    assert abi is not None
    assert bytecode is not None

    return (abi, bytecode)

def deploy_contract(contract_filename: str, contract_name: str):
    abi, bytecode = compile(contract_filename, contract_name)

    web3 = Web3(Web3.HTTPProvider(INFO["rpc_endpoint"], request_kwargs={"timeout":60}))

    account = Account.from_key(INFO["private_key"])

    contract = web3.eth.contract(abi=abi, bytecode=bytecode)

    tx = contract.constructor().build_transaction({
        "gas"       : 9_500_000,
        "from"      : account.address,
        "nonce"     : web3.eth.get_transaction_count(
            Web3.to_checksum_address(account.address)
        ),
    })
    tx_receipt = _sign_and_send_transaction(web3, tx, INFO["private_key"])
    contract_addr = tx_receipt["contractAddress"]

    assert contract_addr is not None

    contract = web3.eth.contract(address=contract_addr, abi=abi)
    tx = contract.functions.exploit().build_transaction({
        "gas"       : 9_500_000,
        "from"      : Web3.to_checksum_address(account.address),
        "value"     : web3.to_wei(20, "ether"),
        "nonce"     : web3.eth.get_transaction_count(
            Web3.to_checksum_address(account.address)
        ),
    })
    tx_receipt = _sign_and_send_transaction(web3, tx, INFO["private_key"])

def submit_sol():
    r = remote(HOST, PORT)
    if args.REMOTE:
        r.sendlineafter(b'ticket? ', TICKET.encode())
    r.sendlineafter(b'action? ', b'3')
    return r.recvline().strip()

def create_parser():
    parser = argparse.ArgumentParser(
        prog='solve',
        description='Ethereum smart contract CTF solver',
    )
    parser.add_argument('contract_filename')
    parser.add_argument('contract_name')

    return parser.parse_args()

### exploit
_args = create_parser()

deploy_contract(_args.contract_filename, _args.contract_name)
flag = submit_sol()
log.info(f"flag: {flag}")

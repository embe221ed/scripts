# tool to deploy and interact with Ethereum smart contracts
# written by @embe221ed
# for CTFs

from pwn import *

import json
import argparse

from web3 import Web3, types
from eth_account import Account

HOST = args.HOST if args.REMOTE else "localhost"
PORT = 1337
TOKEN = b"1Ww4Y9DIRzqEqrAX9zGZ5g=="
TICKET = ""

INFO = {}
if os.path.exists("info.json"):
    with open("info.json", "r") as fp:
        INFO = json.load(fp)


def deploy_instance(host="localhost", port="1337", dump=False):
    io = remote(host, port)
    if args.REMOTE:
        io.sendlineafter(b"team token? ", TOKEN)
    io.sendlineafter(b"action? ", b"1")
    io.recvuntil(b"rpc endpoint:\n")
    INFO["rpc_endpoint"]    = io.recvregex(br"\s*-\s(.*)\n", capture=True).group(1).decode()
    log.info(f"rpc_endpoint:\t{INFO['rpc_endpoint']}")
    INFO["private_key"]     = io.recvregex(br"private key:\s*(.*)\n", capture=True).group(1).decode()
    log.info(f"private_key:\t\t{INFO['private_key']}")
    INFO["setup_contract"]  = io.recvregex(br"challenge contract:\s*(.*)\n", capture=True).group(1).decode()
    log.info(f"setup_contract:\t{INFO['setup_contract']}")

    if not dump:
        io.close()
        return

    with open("info.json", "w") as fp:
        json.dump(obj=INFO, fp=fp)


def kill_instance(host="localhost", port="1337"):
    io = remote(host, port)
    if args.REMOTE:
        io.sendlineafter(b"team token? ", TOKEN)
    io.sendlineafter(b"action? ", b"2")
    if io.recvline() == b"no instance found\n":
        log.info("instance not found")
    io.close()


def forge_deploy(dump: bool = True):
    web3 = Web3(Web3.HTTPProvider(INFO["rpc_endpoint"]))

    with open("./out/Challenge.sol/Challenge.json", "r") as chal:
        abi = json.load(chal)["abi"]

    chal_contract = web3.eth.contract(address=INFO["setup_contract"], abi=abi)
    arg = chal_contract.functions.ARG().call()
    log.info(f"arg @ {arg}")
    io = process(["./deploy.sh", arg])

    _       = io.recvregex(br'Deployer:\s*(.*)\n', capture=True).group(1).decode()
    address = io.recvregex(br'Deployed to:\s*(.*)\n', capture=True).group(1).decode()
    INFO["solve"] = address

    if dump:
        with open("info.json", "w") as fp:
            json.dump(INFO, fp)

    account = Account.from_key(INFO["private_key"])
    with open("./out/Solve.sol/Solve.json") as solve:
        abi = json.load(solve)["abi"]
    contract = web3.eth.contract(address=INFO["solve"], abi=abi)
    tx = contract.functions.setChallenge(INFO["setup_contract"]).build_transaction({
        "gas"       : 9_500_000,
        "from"      : Web3.to_checksum_address(account.address),
        "nonce"     : web3.eth.get_transaction_count(
            Web3.to_checksum_address(account.address)
        ),
    })
    tx_receipt = _sign_and_send_transaction(web3, tx, INFO["private_key"])
    assert(tx_receipt["status"] != 0)

    return


def interactive():
    from IPython import embed

    web3 = Web3(Web3.HTTPProvider(INFO["rpc_endpoint"]))
    account = Account.from_key(INFO["private_key"])

    print("variables:")
    print("\t- web3: connection")
    print("\t- account: your account")
    print("\t- contract: initialized contract")

    with open("./out/Solve.sol/Solve.json") as solve:
        abi = json.load(solve)["abi"]
    contract = web3.eth.contract(address=INFO["solve"], abi=abi)

    print("-"*40)

    transaction = {
        'from': account.address,
        'to': contract.address,
        'value': web3.to_wei(10, "ether"),
        'nonce': web3.eth.get_transaction_count(account.address),
        'gas': 200000,
        'maxFeePerGas': 2000000000,
        'maxPriorityFeePerGas': 1000000000,
        'chainId': web3.eth.chain_id
    }
    signed = web3.eth.account.sign_transaction(transaction, account.key)
    tx_hash = web3.eth.send_raw_transaction(signed.rawTransaction)
    assert(web3.eth.get_transaction_receipt(tx_hash)["status"] != 0)

    embed(colors="neutral")


def _sign_and_send_transaction(web3: Web3, tx: types.TxParams, private_key: (bytes | str)) -> types.TxReceipt:
    signed_tx = web3.eth.account.sign_transaction(tx, private_key=private_key)
    txhash = web3.eth.send_raw_transaction(signed_tx.rawTransaction)
    tx_receipt = web3.eth.wait_for_transaction_receipt(txhash)
    log.debug(f"tx_receipt: {tx_receipt}")
    return tx_receipt


def submit_sol():
    r = remote(HOST, PORT)
    if args.REMOTE:
        r.sendlineafter(b"team token? ", TOKEN)
    r.sendlineafter(b'action? ', b'3')
    return r.recvline().strip()

def create_parser():
    parser = argparse.ArgumentParser(
        prog='solve',
        description='Ethereum smart contract CTF solver',
    )
    parser.add_argument("action", choices=[
        "kill_instance",
        "deploy_instance",
        "deploy_contract",
        "solve",
        "compile",
        "interactive",
    ])
    parser.add_argument("--dump", action="store_true", default=True, help="dump instance data to JSON file")
    parser.add_argument('--contract_filename', help="path to the contract", default="")
    parser.add_argument('--contract_name', help="name of the contract", default="")

    return parser.parse_args()

### exploit
_args = create_parser()

if _args.action == "deploy_instance":
    deploy_instance(host=HOST, port=str(PORT), dump=_args.dump)
if _args.action == "kill_instance":
    kill_instance(host=HOST, port=str(PORT))
elif _args.action == "deploy_contract":
    forge_deploy(dump=_args.dump)
elif _args.action == "solve":
    flag = submit_sol()
    log.info(f"flag: {flag}")
    pass
elif _args.action == "interactive":
    interactive()
else:
    pass


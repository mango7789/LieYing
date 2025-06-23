# utils/crypto.py
import json
import base64
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad
import hashlib

SECRET_KEY = hashlib.sha256(b"lieying").digest()


def encrypt_params(params_dict: dict) -> str:
    raw = json.dumps(params_dict, ensure_ascii=False).encode()
    cipher = AES.new(SECRET_KEY, AES.MODE_ECB)
    encrypted = cipher.encrypt(pad(raw, AES.block_size))
    return base64.urlsafe_b64encode(encrypted).decode()


def decrypt_params(encrypted_str: str) -> dict:
    encrypted = base64.urlsafe_b64decode(encrypted_str)
    cipher = AES.new(SECRET_KEY, AES.MODE_ECB)
    decrypted = unpad(cipher.decrypt(encrypted), AES.block_size)
    return json.loads(decrypted.decode())

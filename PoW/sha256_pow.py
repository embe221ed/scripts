#!/usr/bin/env python3
from hashlib import sha256


def is_valid(digest: bytes, difficulty: int) -> bool:
    zeros = '0' * difficulty
    bits = ''.join(bin(i)[2:].zfill(8) for i in digest)
    return bits[-difficulty:] == zeros


def solve(prefix: bytes, difficulty: int = 20) -> bytes:
    trial = 0
    while True:
        trial += 1
        suffix = str(trial).encode()
        message = prefix + suffix
        if is_valid(sha256(message).digest(), difficulty):
            return suffix 

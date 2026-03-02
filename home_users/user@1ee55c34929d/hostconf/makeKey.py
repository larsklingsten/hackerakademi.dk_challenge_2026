#!/usr/bin/env python3

# apt install -y python3-pycryptodome
from Cryptodome.Util.number import getPrime, isPrime


def modinv(a, m):
    def egcd(a, b):
        if a == 0:
            return b, 0, 1
        g, y, x = egcd(b % a, a)
        return g, x - (b // a) * y, y

    g, x, _ = egcd(a, m)
    if g != 1:
        raise ValueError("Modular inverse does not exist")
    return x % m


def make_openssl_asn1_conf(n, e, d, p, q, outfile="key_in_text.txt"):
    # Compute CRT parameters
    dmp1 = d % (p - 1)
    dmq1 = d % (q - 1)
    iqmp = modinv(q, p)

    with open(outfile, "w") as f:
        f.write("asn1=SEQUENCE:rsa_key\n\n")
        f.write("[rsa_key]\n")
        f.write("version=INTEGER:0\n")
        f.write(f"modulus=INTEGER:{n}\n")
        f.write(f"pubExp=INTEGER:{e}\n")
        f.write(f"privExp=INTEGER:{d}\n")
        f.write(f"p=INTEGER:{p}\n")
        f.write(f"q=INTEGER:{q}\n")
        f.write(f"e1=INTEGER:{dmp1}\n")
        f.write(f"e2=INTEGER:{dmq1}\n")
        f.write(f"coeff=INTEGER:{iqmp}\n")

    print(f"[+] OpenSSL ASN.1 config written to {outfile}")


WHEEL = [4, 2, 4, 2, 4, 6, 2, 6]


def primeGet(prime):
    n = prime + 2^1024
    while n % 2 == 0 or n % 3 == 0 or n % 5 == 0:
        n += 1

    i = 0
    while True:
        if isPrime(n):
            return n
        n += WHEEL[i]
        i = (i + 1) % len(WHEEL)


if __name__ == "__main__":
    p = getPrime(1024)
    q = primeGet(p)
    n = p * q
    e = 65537
    phi = (p - 1) * (q - 1)
    d = modinv(e, phi)

    make_openssl_asn1_conf(n, e, d, p, q)

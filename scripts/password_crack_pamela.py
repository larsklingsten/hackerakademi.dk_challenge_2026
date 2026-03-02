#!/usr/bin/env python3

def count_one_bits(s):
    total = 0
    for c in s:
        byte_val = ord(c)
        total += bin(byte_val).count('1')
    return total

def is_palindrome(s):
    return s == s[::-1]

def sum_of_digits(s):
    return sum(int(c) for c in s if c.isdigit())

def is_cube(n):
    cubes = [1, 8, 27, 64, 125, 216, 343, 512, 729]
    return n in cubes

def has_roman(s):
    return any(c in 'IVXLCDM' for c in s.upper())

def has_n_consecutive_letters(s, n):
    count = 0
    for c in s:
        if c.isalpha():
            count += 1
            if count >= n:
                return True
        else:
            count = 0
    return False

def check_all(pwd):
    if len(pwd) < 10 or len(pwd) > 20:
        return False, "length"
    if not any(c.isupper() for c in pwd):
        return False, "uppercase"
    if not any(c.islower() for c in pwd):
        return False, "lowercase"
    if not any(c.isdigit() for c in pwd):
        return False, "digit"
    if not any(c in '!@#$%^&*()_+-=[]{}|;:,.<>?/' for c in pwd):
        return False, "special"
    if not has_roman(pwd):
        return False, "roman"
    if not is_palindrome(pwd):
        return False, "palindrome"
    
    digit_sum = sum_of_digits(pwd)
    if not is_cube(digit_sum):
        return False, f"cube (sum={digit_sum})"
    
    if not has_n_consecutive_letters(pwd, 5):
        return False, "5 consecutive letters"
    
    one_bits = count_one_bits(pwd)
    if one_bits < 60:
        return False, f"one bits < 60 (got {one_bits})"
    if one_bits % 17 != 0:
        return False, f"one bits mod 17 != 0 (got {one_bits})"
    
    return True, f"VALID! (bits={one_bits})"

# Need palindrome with 5+ consecutive letters
# Format: XabcdeZedcbaX where abcde are 5+ letters

# High bit-count characters: ~, }, |, {, DEL (127)
# We need exactly 68, 85, or 102 one-bits

candidates = []

# Try patterns with many letters and high-bit chars
for d1 in range(10):
    for d2 in range(10):
        if is_cube(d1 + d2 + d2 + d1):
            # Pattern: digit + 5 letters + special + special + 5 letters + digit
            pwd = f"{d1}VabcdI!!Idcbav{d1}"
            ok, msg = check_all(pwd)
            if ok:
                candidates.append((pwd, msg))
            
            # Try with different letters/specials
            pwd = f"{d1}Vwxyz{{!!{{zyxwv{d1}"
            ok, msg = check_all(pwd)
            if ok:
                candidates.append((pwd, msg))

print("Valid candidates:")
for pwd, msg in candidates:
    print(f"  {pwd} - {msg}")

# Brute force with specific structure
print("\nSearching systematically...")
import string

for letter_combo in ['abcde', 'vwxyz', 'VWXYZ', 'VWxyz']:
    for spec in ['!', '@', '#', '~', '|']:
        for d1 in range(10):
            for d2 in range(10):
                if is_cube(d1*2 + d2*2):
                    # Build palindrome
                    left = f"{d1}{letter_combo}{spec}{d2}"
                    pwd = left + left[::-1]
                    
                    ok, msg = check_all(pwd)
                    if ok:
                        print(f"FOUND: {pwd} - {msg}")


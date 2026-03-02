# Finding Pamela's Password - Walkthrough

## Overview
We successfully gained access to pamela's account by reverse-engineering a custom PAM authentication module with extremely complex password requirements.

## Step-by-Step Process

### 1. Initial Discovery
- Found `/tmp/pamela.log` file in the Docker container showing failed authentication attempts
- Log revealed a custom PAM module called `pam_pamela` that only applies to users in group 1337
- Pamela is a member of group 1337 (called "pwpolicy")

### 2. Extracting the PAM Module to Kali-Linux
```bash
# In the container
cp /usr/lib/x86_64-linux-gnu/security/pam_pamela.so /tmp/pam_pamela.so

# copy to the Kali machine
scp -P 20022 user@10.0.0.42:/tmp/pam_pamela.so ./
```

### 3. Analyzing the Binary
Used reverse engineering tools to extract password requirements:

```bash
strings pam_pamela.so     # Extract readable strings
objdump -d pam_pamela.so  # Disassemble to find hardcoded values
```

### 4. Discovered Password Requirements
The custom PAM module enforced **13 different requirements**:

**Basic Requirements:**
1. 10-20 characters long
2. Must be ASCII only
3. Contains uppercase letter
4. Contains lowercase letter
5. Contains digit
6. Contains special character

**Advanced Requirements:**
7. **Contains a Roman numeral** (I, V, X, L, C, D, M)
8. **Sum of all digits must be a perfect cube** (1, 8, 27, 64, 125...)
9. **Must be a palindrome** (reads same forwards and backwards)
10. **At least 5 consecutive letters**
11. **At least 60 one-bits** in binary representation of all characters
12. **One-bits modulo 17 must equal 0** (total must be 68, 85, 102, 119...)
13. **User must be in group 1337**

### 5. Finding Magic Numbers
From the disassembly, we found the exact hardcoded values:

```assembly
mov    $0x5,%esi      # 5 consecutive letters required
mov    $0x3c,%esi     # 0x3c = 60 decimal (minimum one-bits)
mov    $0x11,%esi     # 0x11 = 17 decimal (modulo value)
```

### 6. Building a Password Generator
Created a Python script to generate candidates meeting all requirements:

```python
# Key insight: Use high bit-count characters like 'z', 'y', 'x', 'W', 'V'
# to reach the 68 one-bit requirement (68 is divisible by 17)

# Format: palindrome with 5+ consecutive letters
# Example structure: digit + 5letters + special + digit + digit + special + 5letters + digit
```

### 7. The Solution
**Password: `2VWxyz|22|zyxWV2`**

Breaking it down:
- ✓ Length: 16 characters
- ✓ Palindrome: reads same forwards/backwards
- ✓ Uppercase: V, W
- ✓ Lowercase: x, y, z
- ✓ Digit: 2, 2, 2, 2
- ✓ Special: |, |
- ✓ Roman numeral: V (5 in Roman)
- ✓ Sum of digits: 2+2+2+2 = 8 (which is 2³, a perfect cube)
- ✓ 5 consecutive letters: "VWxyz" and "zyxWV"
- ✓ One-bits: Exactly 68 (divisible by 17)

### 8. Key Techniques Used
1. **Log file analysis** - Found `/tmp/pamela.log` showing the custom PAM module
2. **Binary reverse engineering** - Used `strings` and `objdump` to extract requirements
3. **Assembly code analysis** - Found hardcoded magic numbers (5, 60, 17)
4. **Constraint satisfaction** - Wrote Python to generate passwords meeting all 13 requirements
5. **Bit manipulation** - Calculated one-bit counts for characters to reach exactly 68

## Tools Used
- `ssh` - Remote access
- `scp` - File transfer
- `strings` - Extract readable text from binary
- `objdump` - Disassemble binary code
- Python - Password generation and validation
- `hydra` - Password testing (though manual testing also worked)

## Lessons Learned
1. Custom PAM modules can enforce arbitrary password complexity
2. Log files often contain valuable debugging information
3. Binary reverse engineering is essential when source code isn't available
4. Complex password requirements can still be satisfied with systematic analysis
5. Palindromes with specific character sets can meet multiple constraints simultaneously
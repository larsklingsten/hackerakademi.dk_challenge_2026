import string
import os

# Global Parameters for the lcg
a = 6700419 
c = 1331
m = 2**32 - 1 
lcgSeed = 0xfedd15
size = 2**24


def lcg(seed, a, c, m, size):
    """
    Linear Congruential Generator (LCG) function.
    
    Parameters
    ----------
    seed : `int`
        The initial value (X0) for the LCG.
    a : `int`
        The multiplier.
    c : `int`
        The increment.
    m : `int`
        The modulus.
    size : `int`
        The number of random numbers to generate.
    
    Returns
    -------
    `array[int]`
        An array containing the generated sequence.
    """
    # Initialize the sequence array with zeros
    sequence = [0] * size

    # Run through the lcg to the initial state
    state = lcgSeed % m
    for i in range(1, seed):
        state = (a * state + c) % m

    # Set the initial value
    sequence[0] = state % m

    # Generate the sequence
    for i in range(1, size):
        sequence[i] = (a * sequence[i - 1] + c) % m
    
    return sequence

def passwordGen(seed, passLen=16):
    """
    Password generator

    Parameters
    ----------
    seed : `int`
        The initial value (X0) for the LCG.
    passLen : `int`
        The lenght of the password, i.e. the number of chars in the password.

    Returns
    -------
    'string'
        A string which is the generated password.
    """
    # Initializing the password
    password = ""

    # Initializing the list of characters
    characterList = ""
    characterList += string.ascii_letters
    characterList += string.digits
    characterList += string.punctuation

    # Generating the sequence of random integers
    random_sequence = lcg(seed, a, c, m, passLen)

    # transforming the integers to characters and adding them to the password
    for i in range(passLen):
        char = characterList[random_sequence[i] % len(characterList)]
        password += char

    return password

    

if __name__ == "__main__":
    # Defining the seed for the lcg
    seed = int.from_bytes(os.urandom(3), 'big')

    # Generate the password with default length
    password = passwordGen(seed)

    print(password)

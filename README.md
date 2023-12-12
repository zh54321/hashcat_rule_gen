# Rule Generator For Hashcat
Generate Hashcat rules file based on permutation of input files

### Rule Components

The script uses the following components in the rule generation:

- **%Word Case Operator%**: Example "l" which uses the word from the wordlist in lowercase
- **%Number or common chars%**: Numbers like "123", "007", or common patterns like "aaa", "abc"
- **%Specialchar%**: The common ".","!", or "?" which people use in their password
- **%Character replacement%**: Replace "a" with an "@" or "s" with a "$"

### Position Matters

Example the "!" could be at the end (Summer2023!), in the middle (Summer!2023) or even at the start (!Summer2023).
But it could be 2023Summer!, 2023!Summer, !2023Summer, Summer2023, 2023Summer, Summer!, !Summer, Summer as well...
To cover all those cases the script will generate the rule files for it.

### Example Content and Generated Rules

The script reads the content of the file with the correct Hashcat rule syntax and generates various combinations. 

**Example Content:**
File in the content of the file with the correct Hashcat rule syntax. Example:
- `prefix.txt`: `c`
- `numbers_append.txt`: `$1`
- `numbers_prepend.txt`: `^1`
- `special_append.txt`: `$!`
- `special_prepend.txt`: `^!`
- `charrep.txt`: `sa@`

This will generate:
- `c`
- `c $1`
- `c $1 $!`
- `c $! $1`
- `c $1 $! sa@`
- `c $! $1 sa@`
- `c $1 ^!`
- `c $1 ^! sa@`
- `c ^1`
- `c $! ^1`
- `c ^1 $! sa@`
- `c ^!`
- `c ^! sa@`
- `c $!`
- `c $! sa@`

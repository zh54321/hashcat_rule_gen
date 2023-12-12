# Rule Generator For Hashcat
Genereate Hashcat rules file based on permutation of input files.

This script is designed to create rule files for password cracking with Hashcat. The main idea is that each rule can contain different elements, combined in various ways.

### Rule Components

The script uses the following components in the rule generation:

- `%Word Case Operator%`: Utilizes the word from the wordlist. Example: `"l"` for lowercase.
- `%Number or Common Chars%`: Includes numbers or common patterns. Examples: `"123"`, `"007"`, `"aaa"`, `"abc"`.
- `%Specialchar%`: Common special characters. Examples: `"."`, `"!"`, `"?"`.
- `%Character Replacement%`: Replaces characters with symbols. Examples: Replace `"a"` with `"@"`, `"s"` with `"$"`.

### Position Matters

The position of components like special characters is crucial. They could be at the start, middle, or end of a pattern. For example, `"!"` could appear in `"Summer2023!"`, `"Summer!2023"`, or `"!Summer2023"`. The script generates rules to cover all these cases.

### Example Content and Generated Rules

The script reads the content of the file with the correct Hashcat rule syntax and generates various combinations. 

**Example Content:**

- `prefix.txt`: `c`
- `numbers_append.txt`: `$1`
- `numbers_prepend.txt`: `^1`
- `special_append.txt`: `$!`
- `special_prepend.txt`: `^!`
- `charrep.txt`: `sa@`

**Generated Rules:**
c
c $1
c $1 $!
c $! $1
c $1 $! sa@
c $! $1 sa@
c $1 ^!
c $1 ^! sa@
c ^1
c $! ^1
c ^1 $! sa@
c ^!
c ^! sa@
c $!
c $! sa@

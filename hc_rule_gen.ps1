<#
	.SYNOPSIS
	Genereate Hashcat rules file based on permutation of input files
	
	.DESCRIPTION
    Does not take parameters everything is hardcoded.
    
    The main idea is that each rule can contain:
    %Word Case Operator% : Example "l" which uses the word from the wordlist in lowercase
    %Number or common chars% : Numbers like "123", "007", or common patterns like "aaa", "abc"
    %Specialchar% : The common ".","!", or "?" which people use in their password
    %Character replacement%: Replace "a" with an "@" or "s" with a "$"
    
    Position matters: Example the "!" could be at the end (Summer2023!), in the middle (Summer!2023) or even at the start (!Summer2023).
    But it could be 2023Summer!, 2023!Summer, !2023Summer, Summer2023, 2023Summer, Summer!, !Summer, Summer as well...
    To cover all those cases the script will generate the rule files for it.

    Use input files with the correct Hashcat rule syntax.
    Example content:
   - prefix.txt: c
   - numbers_append.txt: $1
   - numbers_prepend.txt: ^1
   - special_append.txt: $!
   - special_prepend.txt: ^!
   - charrep.txt: sa@

    This will generate the rule file:
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


	.EXAMPLE
	hc_rule_gen

	.LINK
	https://github.com/zh54321/hashcat_rule_gen
#>
# Output file
$File   = 'big.rule'

#Input files
$prefix_file = "prefix.txt"
$numbers_append = "numbers_append.txt"
$numbers_prepend = "numbers_prepend.txt"
$specialchar_append = "special_append.txt"
$specialchar_prepend = "special_prepend.txt"
$char_replacement = "charrep.txt"


class cls {
    [string] $txt
    cls(
      [string] $t
     ) {
       $this.txt = $t
     }
 }


#Read files and store in lists
$list_prefix = new-object System.Collections.Generic.List[cls]
$prefix_read = Get-Content -Path $prefix_file

ForEach ($Line in $prefix_read ) {
    $obj = [cls]::new($Line)
    $list_prefix.add($obj)
}

$list_numbers_app = new-object System.Collections.Generic.List[cls]
$numbers_app_read = Get-Content -Path $numbers_append

ForEach ($Line in $numbers_app_read ) {
    $obj = [cls]::new($Line)
    $list_numbers_app.add($obj)
}

$list_numbers_prep = new-object System.Collections.Generic.List[cls]
$numbers_prep_read = Get-Content -Path $numbers_prepend

ForEach ($Line in $numbers_prep_read ) {
    $obj = [cls]::new($Line)
    $list_numbers_prep.add($obj)
}

$list_special_app = new-object System.Collections.Generic.List[cls]
$special_app_read = Get-Content -Path $specialchar_append

ForEach ($Line in $special_app_read ) {
    $obj = [cls]::new($Line)
    $list_special_app.add($obj)
}

$list_special_prep = new-object System.Collections.Generic.List[cls]
$special_prep_read = Get-Content -Path $specialchar_prepend

ForEach ($Line in $special_prep_read ) {
    $obj = [cls]::new($Line)
    $list_special_prep.add($obj)
}

$list_charrep = new-object System.Collections.Generic.List[cls]
$charrep_read = Get-Content -Path $char_replacement

ForEach ($Line in $charrep_read ) {
    $obj = [cls]::new($Line)
    $list_charrep.add($obj)
}




 $Stream = [System.IO.StreamWriter]::new($File)

# I will never be able to understand this anymore...
 foreach ($prefix in $list_prefix) {
    $Stream.WriteLine("$($prefix.txt)")
    foreach ($number in $list_numbers_app) {
        $Stream.WriteLine("$($prefix.txt) $($number.txt)")
        foreach ($special in $list_special_app) {
            $Stream.WriteLine("$($prefix.txt) $($number.txt) $($special.txt)")
            $Stream.WriteLine("$($prefix.txt) $($special.txt) $($number.txt)")
            foreach ($charrep in $list_charrep) {
                $Stream.WriteLine("$($prefix.txt) $($number.txt) $($special.txt) $($charrep.txt)")
                $Stream.WriteLine("$($prefix.txt) $($special.txt) $($number.txt) $($charrep.txt)")
            }
         }
         foreach ($special in $list_special_prep) {
            $Stream.WriteLine("$($prefix.txt) $($number.txt) $($special.txt)")
            foreach ($charrep in $list_charrep) {
                $Stream.WriteLine("$($prefix.txt) $($number.txt) $($special.txt) $($charrep.txt)")

            }
        }
     }
    foreach ($number in $list_numbers_prep) {
    $Stream.WriteLine("$($prefix.txt) $($number.txt)")
        foreach ($special in $list_special_app) {
            $Stream.WriteLine("$($prefix.txt) $($special.txt) $($number.txt)")
            foreach ($charrep in $list_charrep) {
                $Stream.WriteLine("$($prefix.txt) $($number.txt) $($special.txt) $($charrep.txt)")
            }
        }
    }

    ##Remove this loop if you don't want the special char without the number part (c ^!, c ^! sa@)
    foreach ($special in $list_special_prep) {
        $Stream.WriteLine("$($prefix.txt) $($special.txt)")
        foreach ($charrep in $list_charrep) {
            $Stream.WriteLine("$($prefix.txt) $($special.txt) $($charrep.txt)")

        }
    }

    ##Remove this loop if you don't want the special char without the number part (c $!, c $! sa@)
    foreach ($special in $list_special_app) {
        $Stream.WriteLine("$($prefix.txt) $($special.txt)")
        foreach ($charrep in $list_charrep) {
            $Stream.WriteLine("$($prefix.txt) $($special.txt) $($charrep.txt)")

        }
    }

 }

 # Close the stream
 $Stream.Close()

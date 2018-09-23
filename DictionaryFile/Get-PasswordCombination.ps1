function Get-PasswordCombination {
<#
.SYNOPSIS

Creates all possbile passwords

.DESCRIPTION

Creates all possible passowrds based on your input
and provides the results in output.

.PARAMETER CharacterSet

Specifies the characters (letters, numbers, symbols) that
need to be included. Parameter is mandatory.

.PARAMETER MinCharacters

Specifies the minimum characters of the generated passwords.
Parameter is mandatory.

.PARAMETER MaxCharacters

Specifies the maximum characters of the generated passwords.
Parameter is mandatory.

.PARAMETER IncludeCapital

Specifies whether or not to include upper case letters along with
the lower case letters.

.PARAMETER CapitalOnly

Specifies whether or not all lower case letters to be converted to
upper case letters.

.INPUTS

System.String. Get-PasswordCombination can accept a string value to
determine the CharacterSet parameter.

.OUTPUTS

System.String. Get-PasswordCombination returns the generated password.

.EXAMPLE

PS C:\> Get-PasswordCombination -CharacterSet "a,b,c" -MinCharacters 1 -MaxCharacters 2
a
b
c
aa
ab
ac
ba
bb
bc
ca
cb
cc

.EXAMPLE

PS C:\> Get-PasswordCombination -CharacterSet "a,b,c" -MinCharacters 1 -MaxCharacters 2 -IncludeCapital
a
b
c
A
B
C
aa
ab
ac
aA
aB
aC
ba
bb
bc
bA
bB
bC
ca
cb
cc
cA
cB
cC
Aa
Ab
Ac
AA
AB
AC
Ba
Bb
Bc
BA
BB
BC
Ca
Cb
Cc
CA
CB
CC

.EXAMPLE

PS C:\> Get-PasswordCombination -CharacterSet "a,b,c" -MinCharacters 1 -MaxCharacters 2 -CapitalOnly
A
B
C
AA
AB
AC
BA
BB
BC
CA
CB
CC

.EXAMPLE

PS C:\> Get-PasswordCombination -CharacterSet "alphabet" -MinCharacters 1 -MaxCharacters 3
a
b
c
d
e
f
g
h
i
j
k
l
m
n
...
xu
xv
xw
xx
xy
xz
ya
yb
yc
yd
ye
yf
yg
...
zzz

.EXAMPLE

PS C:\> Get-PasswordCombination "av,b,c" -MinCharacters 2 -MaxCharacters 2
avav
avb
avc
bav
bb
bc
cav
cb
cc

.EXAMPLE

PS C:\> "a,b,c" | Get-PasswordCombination -MinCharacters 2 -MaxCharacters 2
aa
ab
ac
ba
bb
bc
ca
cb
cc

.EXAMPLE

PS C:\> Get-PasswordCombination -CharacterSet "ad,b,c" -MinCharacters 3 -MaxCharacters 3 | Where-Object {$_ -like "*db*"}
adadb
adbad
adbb
adbc
badb
cadb


.LINK

https://www.sconstantinou.com/get-passwordcombination

.LINK

New-DictionaryFile

.LINK

Get-PasswordNumber

.LINK

Get-DictionaryFile
#>

    [cmdletbinding()]

    param(
        [parameter(Mandatory = $true,ValueFromPipeline = $true)][alias("c")][String]$CharacterSet,
        [parameter(Mandatory = $true)][alias("min")][Uint32]$MinCharacters,
        [parameter(Mandatory = $true)][alias("max")][Uint32]$MaxCharacters,
        [alias("ic")][Switch]$IncludeCapital,
        [alias("co")][Switch]$CapitalOnly)

    if ($CharacterSet -eq "alphabet"){
        $CharacterSet = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"
    }

    if ($CapitalOnly -eq $True){
        $CharacterSet = $CharacterSet.ToUpper()
    }

    if ($IncludeCapital -eq $True){
        $CharactersCapital = $CharacterSet.ToUpper()
        $CharacterSetLow = $CharacterSet
        $CharacterSet = ""
        $CharacterSet = $CharacterSetLow, $CharactersCapital -join ","
    }

    $pool = $CharacterSet -split ','
    [Array]$pool = $pool | Select-Object -Unique

    for ($i = $MinCharacters; $i -le $MaxCharacters; $i++){
        $Passwords = @()

        for ($p = 1;$p -le $i;$p++){
            [Object[]]$Passwords += ,$pool
        }

        Get-Password $Passwords
    }
}
New-Alias -Name gpc -Value Get-PasswordCombination
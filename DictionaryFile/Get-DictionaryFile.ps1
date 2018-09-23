function Get-DictionaryFile {
<#
.SYNOPSIS

Imports a dictionary file

.DESCRIPTION

Imports a previously created dictionary file into
memory.

.PARAMETER CharacterSet

Specifies the characters (letters, numbers, symbols) that
need to be included. Parameter is mandatory.

.INPUTS

System.String. Get-DictionaryFile can accept a string value to
determine the path of the dictionary file.

.OUTPUTS

System.Array. Get-DictionaryFile will provide the passwords that
where included in the dictionary file in an array.

.EXAMPLE

PS C:\> Get-DictionaryFile -Path C:\Scripts\DictionaryFile.txt
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

PS C:\> "C:\Scripts\DictionaryFile.txt" | Get-DictionaryFile
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

Get-DictionaryFile -Path "C:\Scripts\DictionaryFile.txt" | ForEach-Object {$_ + "a"}
aaa
aba
aca
baa
bba
bca
caa
cba
cca

.EXAMPLE

"C:\Scripts\DictionaryFile.txt" | Get-DictionaryFile | Where-Object {$_ -like "*b*"}
ab
ba
bb
bc
cb

.LINK

https://www.sconstantinou.com/get-dictionaryfile

.LINK

Get-PasswordCombination

.LINK

Get-PasswordNumber

.LINK

New-DictionaryFile
#>

    [cmdletbinding()]

    param([parameter(Mandatory = $true,ValueFromPipeline = $true)][alias("p")][String]$Path)

    [Array]$DictionaryFile = Get-Content -Path $Path

    Write-Output $DictionaryFile
}
New-Alias -Name gdf -Value Get-DictionaryFile
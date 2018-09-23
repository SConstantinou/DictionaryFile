function Get-PasswordNumber {
<#
.SYNOPSIS

Calculates the number of possible passwords

.DESCRIPTION

Calculates the number of possible passwords based
on the input so you will know the actual number before
you proceed to create your dictionary file.

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

System.String. Get-PasswordNumber can accept a string value to
determine the CharacterSet parameter.

.OUTPUTS

System.Double. Get-PasswordNumber returns the number of passwords that
can be created.

.EXAMPLE

PS C:\> Get-PasswordNumber -CharacterSet "a,b,c,1,2,3,$,*,&" -MinCharacters 2 -MaxCharacters 5
66420

.EXAMPLE

PS C:\> Get-PasswordNumber -Characters "a,b,c,1,2,3,$,*,&" -MinCharacters 2 -MaxCharacters 5 -IncludeCapital
271440

.EXAMPLE

PS C:\> Get-PasswordNumber -Characters "a,b,c,1,2,3,$,*,&" -MinCharacters 2 -MaxCharacters 5 -CapitalOnly
66420

.EXAMPLE

PS C:\> Get-PasswordNumber -Characters alphabet -MinCharacters 2 -MaxCharacters 5
12356604

.EXAMPLE

PS C:\> Get-PasswordNumber "av,b,c" -MinCharacters 2 -MaxCharacters 2
9

.EXAMPLE

PS C:\> "a,b,c" | Get-PasswordNumber -MinCharacters 2 -MaxCharacters 2
9

.EXAMPLE

PS C:\> Get-PasswordNumber -CharacterSet "ad,b,c" -MinCharacters 2 -MaxCharacters 2 | ForEach-Object {$_ * 2}
18

.LINK

https://www.sconstantinou.com/get-passwordnumber

.LINK

Get-PasswordCombination

.LINK

New-DictionaryFile

.LINK

Get-DictionaryFile
#>

    [cmdletbinding()]

    param(
        [parameter(Mandatory = $true,ValueFromPipeline = $true)][alias("c")][String]$CharacterSet,
        [parameter(Mandatory = $true)][alias("min")][Uint32]$MinCharacters,
        [parameter(Mandatory = $true)][alias("max")][Uint32]$MaxCharacters,
        [alias("ic")][switch]$IncludeCapital,
        [alias("co")][switch]$CapitalOnly)

    if ($MinCharacters -eq "0"){
        throw "MinCharacters value cannot zero."
    }

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
    $pool = $pool | Select-Object -Unique
    [Uint32]$n = $pool.count

    switch ($MinCharacters){
        {$_ -eq $MaxCharacters}{
            [Uint32]$n = $pool.count
            [Uint32]$r = $_
            [Double]$TotalPossibilities = [math]::Pow($n,$r)
            Write-Output $TotalPossibilities
        }
        {$_ -gt $MaxCharacters}{
            throw "MinCharacters value cannot be greater than MaxCharacters value"
        }
        {$_ -lt $MaxCharacters}{
            [int]$TotalPossibilities = 0

            for ($i = $MinCharacters;$i -le $MaxCharacters; $i++){
                [Uint32]$n = $pool.count
                [Uint32]$r = $i
                [Double]$TempPossibilities = [math]::Pow($n,$r)
                [Double]$TotalPossibilities = $TotalPossibilities + $TempPossibilities
            }

            Write-Output $TotalPossibilities
        }
    }
}
New-Alias -Name gpn -Value Get-PasswordNumber
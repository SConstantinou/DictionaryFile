function New-DictionaryFile {
<#
.SYNOPSIS

Creates a dictionary file.

.DESCRIPTION

Creates a dictionary file containing all possible
passwords that can be created based on your input.

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

.PARAMETER Path

Specifies the path and file that generated passwords will be saved.
Parameter is mandatory.

.INPUTS

System.String. New-DictionaryFile can accept a string value to
determine the CharacterSet parameter.

.OUTPUTS

None. New-DictionaryFile will save all the generated passwords to
the specified path.

.EXAMPLE

PS C:\> New-DictionaryFile -CharacterSet "a,b,c,1,$" -MinCharacters 2 -MaxCharacters 5 -Path C:\Scripts_Output\MyFile.txt

.EXAMPLE

PS C:\> New-DictionaryFile -CharacterSet "a,b,c,1,$" -MinCharacters 2 -MaxCharacters 5 -IncludeCapital -Path C:\Scripts_Output\MyFile.txt

.EXAMPLE

PS C:\> New-DictionaryFile -CharacterSet "a,b,c,1,$" -MinCharacters 2 -MaxCharacters 5 -CapitalOnly -Path C:\Scripts_Output\MyFile.txt

.EXAMPLE

PS C:\> New-DictionaryFile -CharacterSet "alphabet" -MinCharacters 1 -MaxCharacters 3 -Path C:\Scripts_Output\MyFile.txt

.EXAMPLE

PS C:\> New-DictionaryFile "av,b,c" -MinCharacters 2 -MaxCharacters 2 -Path C:\Scripts_Output\MyFile.txt

.EXAMPLE

PS C:\> "a,b,c" | New-DictionaryFile -MinCharacters 2 -MaxCharacters 2 -Path C:\Scripts_Output\MyFile.txt

.LINK

https://www.sconstantinou.com/new-dictionaryfile

.LINK

Get-PasswordCombination

.LINK

Get-PasswordNumber

.LINK

Get-DictionaryFile
#>

    [cmdletbinding(SupportsShouldProcess, ConfirmImpact='Medium')]

    param(
        [parameter(Mandatory = $true,ValueFromPipeline = $true)][alias("c")][String]$CharacterSet,
        [parameter(Mandatory = $true)][alias("min")][Uint32]$MinCharacters,
        [parameter(Mandatory = $true)][alias("max")][Uint32]$MaxCharacters,
        [alias("ic")][Switch]$IncludeCapital,
        [alias("co")][Switch]$CapitalOnly,
        [parameter(Mandatory = $true)][alias("p")][String]$Path = "")

    $Directory = Split-Path $Path
    $File = [System.IO.Path]::GetFileName($Path)

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

    if (-not (Test-Path -Path $Directory -PathType Container)){
        New-Item -Path $Directory -ItemType Directory -Force |
            Out-Null
    }

    if (-not (Test-Path -Path $Path -PathType Leaf)){
        New-Item -Path $Directory -Name $File -ItemType File -Force |
            Out-Null
    }
    else{
        Remove-Item -Path "$Path" -Force | Out-Null
        New-Item -Path $Directory -Name $File -ItemType File -Force |
            Out-Null
    }

    $pool = $CharacterSet -split ','
    [Array]$pool = $pool | Select-Object -Unique

    for ($i = $MinCharacters; $i -le $MaxCharacters; $i++){
        $Passwords = @()

        for ($p = 1;$p -le $i;$p++){
            [Object[]]$Passwords += ,$pool
        }

        Get-Password $Passwords -OutFile "$Path"
    }
}
New-Alias -Name ndf -Value New-DictionaryFile
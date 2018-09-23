Function Get-Password {

    Param(
        [Object[]]$FullSet,
        [String]$Comma,
        [Uint32]$CurrentIndex = 0,
        [String]$TemporaryText = "",
        [String]$OutFile)

    $MaximumIndex = $FullSet.Count - 1

    foreach ($_ in $FullSet[$CurrentIndex]){
        [Array]$Password = "$($TemporaryText)$($Comma)$($_)".Trim($Comma)

        If ($CurrentIndex -lt $MaximumIndex) {
            $Password = Get-Password $FullSet -CurrentIndex ($CurrentIndex + 1) -TemporaryText $Password -OutFile $OutFile
        }

        if ($OutFile -eq ""){Write-Output $Password}
        else{Add-Content -Path $OutFile -Value $Password}
    }
}
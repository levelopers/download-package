
$Source_file = "./package-lock.json"
$Reg1 = [regex]'resolved.*'
$Reg2 = [regex]'https?:\/\/.*\.\w+'
$Reg3 = [regex]'([^/]+)?\.(\w+)$'

[System.Collections.ArrayList]$Lines = @()
new-item "./packs" -Type Directory -Force | Out-Null

foreach ($line in Get-Content $Source_file) {

    if ($line -match $Reg1) {
        # Work here
        $url = $line | Select-String $Reg2 -AllMatches | ForEach-Object { $_.Matches.Value }
        $Lines.Add($url) | Out-Null
    }
}
echo "$($Lines.Count) packages"
foreach ($url in $Lines) {
    $File_name = $url | Select-String $Reg3 -AllMatches | ForEach-Object { $_.Matches.Value }
    # echo $File_name
    Invoke-WebRequest $url -OutFile "./packs/$($File_name)"
}



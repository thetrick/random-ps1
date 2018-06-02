#$sourceDir = read-host "Please enter source Dir"
#$extension = read-host "extension to look for"
#$destDir = read-host "Please enter output Dir:"

$sourceDir = "D:\qtor\loading-zone\"
$destDir = "D:\plex\TV Shows\"
$extension = "*.mkv"
$runScan = $false


$fileList = Get-ChildItem $sourceDir -recurse -include $extension
foreach ($file in $filelist) {
    $splitFile = $file.Name -split 'S\d\dE\d\d'
    $tvshow = $splitFile[0].Substring(0, $splitFile[0].Length-1).Replace(".", " ").Replace("'", "").Replace("S H I E L D", "S.H.I.E.L.D")
    $tvShowDestDir = $destDir + $tvshow
    #Write-Output $tvShowDestDir
    #Write-Output $file.FullName
    if(!(Test-Path -Path $tvShowDestDir)) 
    {
        Write-Output "tvShowDestDir: $($tvShowDestDir) does NOT exist!"    
    }
    else
    {
        $runScan = $true
        Move-Item -LiteralPath $file.FullName -Destination $tvShowDestDir -Verbose #-WhatIf
        Remove-Item -LiteralPath $file.DirectoryName -Recurse -Verbose #-WhatIf
        #Remove-Item -Path "D:\qtor\loading-zone\*" -Recurse -Verbose #-WhatIf
    }
}

if($runScan -eq $true) {
    cd "C:\Program Files (x86)\Plex\Plex Media Server\"
    $plexcmd = "'.\Plex Media Scanner.exe' --scan --refresh --section 1"
    iex "& $plexcmd"
}

Pause
Clear

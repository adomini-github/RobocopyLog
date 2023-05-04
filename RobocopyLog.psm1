function PrefixCalc($Array){
    $ArrayResult = @()
    $Diff = 0
    for($i=0;$i -lt $Array.Count;$i++){
        switch -Regex($Array[$i]){
            'k'{$ArrayResult[$i-1-$Diff] = [double]$Array[$i-1] * [math]::Pow(1024,1);$Diff++}
            'm'{$ArrayResult[$i-1-$Diff] = [double]$Array[$i-1] * [math]::Pow(1024,2);$Diff++}
            'g'{$ArrayResult[$i-1-$Diff] = [double]$Array[$i-1] * [math]::Pow(1024,3);$Diff++}
            't'{$ArrayResult[$i-1-$Diff] = [double]$Array[$i-1] * [math]::Pow(1024,4);$Diff++}
            '\d+'{$ArrayResult += [double]$Array[$i]}
            default{return 'ERROR'}
        }
    }
    return $ArrayResult
}

function Get-RobocopyLogSummary{
    <#
    .DESCRIPTION
    return object that robocopy log summary information.
    .PARAMETER path
    robocopy log file path.
    .INPUTS
    cannot use pipe object.
    .OUTPUTS
    PSCustomObject. For detail information, Please reference to readme.txt file.
    .EXAMPLE
    $RCLog = Get-RobocopyLogSummary -path <path>
    if($RCLog.IsFailed){Write-Host 'failed copy some files or directories'}
    #>
    param($path)
    
    if($path -eq $null){
        Write-Host "Get-RobocopyLogSummary <path> `r`npath:Robocopy Log file path"
        return
    }elseif(-not(Test-Path $path)){
        Write-Host 'Log File Not Found.'
        return
    }

    $pattern = '-{10,}'
    :Loop for($i = 1;$i -lt 50;$i++){
        $Text = Get-Content $path -Tail $i
        foreach($t in $Text){
            $DelimitHyphen = $t | Select-String -Pattern $pattern
            if($DelimitHyphen -ne $null){break Loop}
        }
    }
    
    $pattern = '\s+\d+\s*\w*\s+\d+\s*\w*\s+\d+\s*\w*\s+\d+\s*\w*\s+\d+\s*\w*\s+\d+\s*\w*'
    for($i=0;$i -lt $Text.Count;$i++){
        $t = $Text[$i]
        $ResultData = $t | Select-String -Pattern $pattern
        if($ResultData -ne $null){break;}
    }
    $DirectoryLog = $Text[$i]
    $FileLog = $Text[$i+1]
    $ByteLog = $Text[$i+2]
    $TimeLog = $Text[$i+3]
    $SpeedBpsLog = $Text[$i+6]
    
    $DirectoryLog = $DirectoryLog -replace '^[^:]*:','' -replace '\s+',',' -replace '^,',''
    $FileLog = $FileLog -replace '^[^:]*:','' -replace '\s+',',' -replace '^,',''
    $ByteLog = $ByteLog -replace '^[^:]*:','' -replace '\s+',',' -replace '^,',''
    $TimeLog = $TimeLog -replace '^[^:]*:','' -replace '\s+',',' -replace '^,',''
    $SpeedBpsLog = $SpeedBpsLog -replace '\D',''
        
    $DirectoryLogArray = $DirectoryLog.Split(',')
    $FileLogArray = $FileLog.Split(',')
    $ByteLogArray = $ByteLog.Split(',')
    $TimeLogArray = $TimeLog.Split(',')
        
    $DirectoryLogArray = PrefixCalc($DirectoryLogArray)
    $FileLogArray = PrefixCalc($FileLogArray)
    $ByteLogArray = PrefixCalc($ByteLogArray)
        
    $Obj = New-Object -TypeName psobject
    if($DirectoryLogArray[2]+$FileLogArray[2]+$ByteLogArray[2] -ne 0){$Obj | Add-Member IsSkipped $true}else{$Obj | Add-Member IsSkipped $false}
    if($DirectoryLogArray[3]+$FileLogArray[3]+$ByteLogArray[3] -ne 0){$Obj | Add-Member IsMismatch $true}else{$Obj | Add-Member IsMismatch $false}
    if($DirectoryLogArray[4]+$FileLogArray[4]+$ByteLogArray[4] -ne 0){$Obj | Add-Member IsFailed $true}else{$Obj | Add-Member IsFailed $false}
    if($DirectoryLogArray[5]+$FileLogArray[5]+$ByteLogArray[5] -ne 0){$Obj | Add-Member IsExtras $true}else{$Obj | Add-Member IsExtras $false}
    $Obj | Add-Member DirsTotal $DirectoryLogArray[0]
    $Obj | Add-Member DirsCopied $DirectoryLogArray[1]
    $Obj | Add-Member DirsSkipped $DirectoryLogArray[2]
    $Obj | Add-Member DirsMismatch $DirectoryLogArray[3]
    $Obj | Add-Member DirsFAILED $DirectoryLogArray[4]
    $Obj | Add-Member DirsExtras $DirectoryLogArray[5]
    $Obj | Add-Member DirsArray $DirectoryLogArray

    $Obj | Add-Member FilesTotal $FileLogArray[0]
    $Obj | Add-Member FilesCopied $FileLogArray[1]
    $Obj | Add-Member FilesSkipped $FileLogArray[2]
    $Obj | Add-Member FilesMismatch $FileLogArray[3]
    $Obj | Add-Member FilesFAILED $FileLogArray[4]
    $Obj | Add-Member FilesExtras $FileLogArray[5]
    $Obj | Add-Member FilesArray $FileLogArray

    $Obj | Add-Member BytesTotal $ByteLogArray[0]
    $Obj | Add-Member BytesCopied $ByteLogArray[1]
    $Obj | Add-Member BytesSkipped $ByteLogArray[2]
    $Obj | Add-Member BytesMismatch $ByteLogArray[3]
    $Obj | Add-Member BytesFAILED $ByteLogArray[4]
    $Obj | Add-Member BytesExtras $ByteLogArray[5]
    $Obj | Add-Member BytesArray $ByteLogArray

    $Obj | Add-Member TimesTotal ([timespan]$TimeLogArray[0])
    $Obj | Add-Member TimesCopied ([timespan]$TimeLogArray[1])
    $Obj | Add-Member TimesFailed ([timespan]$TimeLogArray[2])
    $Obj | Add-Member TimesExtras ([timespan]$TimeLogArray[3])

    $Obj | Add-Member Speed ([long]$SpeedBpsLog)

    return $Obj
}
Export-ModuleMember -Function Get-RobocopyLogSummary

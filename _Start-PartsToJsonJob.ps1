# Based on code from
#  https://stackoverflow.com/questions/71429973/powershell-register-objectevent-io-filesystemwatcher-can-a-single-registratio

$Watcher = New-Object IO.FileSystemWatcher "$PWD\parts", "*.html" -Property @{ 
  IncludeSubdirectories = $false
  NotifyFilter          = [IO.NotifyFilters]'FileName, LastWrite'
}

$Action = {
  $path = $Event.SourceEventArgs.FullPath

  $BaseName = Split-Path -LeafBase $path
  $PartsDirectory = Split-Path -Parent $path
  $ProjectDirectory = Split-Path -Parent $PartsDirectory
      
  Write-Host "Actioning... Path: $path Name: $name"
  $part = @{
    html = Get-Content $path
  }
  $part | ConvertTo-Json | Out-File "$ProjectDirectory\json\$BaseName.json"
}

Register-ObjectEvent $Watcher -EventName "Created" -SourceIdentifier "a *.parts.html created" -Action $Action
Register-ObjectEvent $Watcher -EventName "Changed" -SourceIdentifier "a *.parts.html changed" -Action $Action

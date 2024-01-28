# Based on code from
#  https://stackoverflow.com/questions/71429973/powershell-register-objectevent-io-filesystemwatcher-can-a-single-registratio

using namespace System.Text.RegularExpressions

$Watcher = New-Object IO.FileSystemWatcher "$PWD\parts", "*.html" -Property @{ 
  IncludeSubdirectories = $false
  NotifyFilter          = [IO.NotifyFilters]'FileName, LastWrite'
}

$Action = {
  $path = $Event.SourceEventArgs.FullPath

  $BaseName = Split-Path -LeafBase $path
  $PartsDirectory = Split-Path -Parent $path
  $ProjectDirectory = Split-Path -Parent $PartsDirectory
  $partUpper = $BaseName.ToUpper()

  $headerPart = "<!--$partUpper-->"
  $begin = "<!-- This $partUpper part included automatically DO NOT EDIT in index.html -->`n"
  $end = "<!-- END $partUpper part included automatically DO NOT EDIT in index.html -->`n"

  $indexPath = "$ProjectDirectory\index.html"

  $indexHtml = Get-Content $indexPath
  $indexHtmlText = "" ; $indexHtml | % { $indexHtmlText += $_ + "`n" }
  $partHtml = Get-Content $path
  $partHtmlText = "" ; $partHtml | % { $partHtmlText+= $_ + "`n" }
      
  Write-Host "Actioning... Path: $path Name: $name index.html update"
  # convert to text
  $partText = $begin + $partHtmlText + $end

  $fullPartText = $headerPart + $partText

  $partRegex = [Regex]::New("$([Regex]::Escape($begin))[\w\W]*$([Regex]::Escape($end))", [RegexOptions]::MultiLine)

  $indexHtmlPartRemoved = $indexHtmlText -replace $partRegex,""

  #DEBUG Write-Host "DEBUG: After replace all partHtml:`n$indexHtmlText"
  $indexHtmlText2 = $indexHtmlPartRemoved.Replace($headerPart, $fullPartText)

  #DEBUG Write-Host "DEBUG: Before final part written:`n$indexHtml"
  $indexHtmlText2 | Out-File $indexPath
}

Register-ObjectEvent $Watcher -EventName "Created" -SourceIdentifier "Created *.parts.html to index.html" -Action $Action
Register-ObjectEvent $Watcher -EventName "Changed" -SourceIdentifier "Changed *.parts.html to index.html" -Action $Action

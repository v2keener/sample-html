#!/usr/bin/pwsh
dir parts\ | % { 
  gc $_.FullName | ConvertTo-Json | Out-File "json\$($_.BaseName).json"
}

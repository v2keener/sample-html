# PowerShell / .NET Regex work for index.html insertion of parts for screen reader compatibility

```powershell
Line 32, $partText set

using namespace System.Text.RegularExpressions

# NOPE seems not to work
$partRegex = [Regex]::New("$([Regex]::Escape($begin))[\s\w\r\n]*$([Regex]::Escape($end))", [RegexOptions]::MultiLine)

# NOPE trying...
$partRegex = [Regex]::New("$begin[\s\w\r\n]*$end", [RegexOptions]::MultiLine)

# NOPE 
$partRegex = [Regex]::New("$([Regex]::Escape($begin))[\s\w\r\n]*`n$([Regex]::Escape($end))", [RegexOptions]::MultiLine)

# YES, but only replaces the $begin..., so NOPE
$partRegex = [Regex]::New("$([Regex]::Escape($begin))[\s\w\r\n]*", [RegexOptions]::MultiLine)

# trying
$partRegex = [Regex]::New("$([Regex]::Escape($begin))[.\s\w\r\n]*", [RegexOptions]::MultiLine)

# YES for beginning for $fullPartText using $partRegex.Replace()
$partRegex = [Regex]::New("$([Regex]::Escape($begin))[\w\W]*", [RegexOptions]::MultiLine) 

# COMPLETED!! 
$partRegex = [Regex]::New("$([Regex]::Escape($begin))[\w\W]*$([Regex]::Escape($end))", [RegexOptions]::MultiLine) 
# Example usage:
$partRegex.Replace($fullPartText,"")
# also works as:
$fullPartText -replace $partRegex,""
```
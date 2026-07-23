$files = Get-ChildItem -Path "e:\Kirnature\porto" -Filter "*.html" | Select-Object -ExpandProperty Name

foreach ($f in $files) {
    $path = "e:\Kirnature\porto\$f"
    $content = Get-Content $path -Raw
    
    $changed = $false
    
    # Remove footer link to cookie-policy.html
    $pattern1 = '<a href="cookie-policy\.html">Cookie Policy</a>'
    if ($content -match $pattern1) {
        $content = $content -replace $pattern1, ''
        $changed = $true
    }
    
    # Remove cookie banner IIFE block
    $pattern2 = '// Cookie\s*\(function\(\)\{[^}]*localStorage\.getItem\([^}]*\}\(\)\);?'
    $temp = $content -replace $pattern2, ''
    if ($temp -ne $content) {
        $content = $temp
        $changed = $true
    }
    
    # Also try the long-form cookie banner (index.html style)
    $pattern3 = '\s*// ── Cookie consent banner ────────────────────────────────────────────\s*\(function\(\) \{[^}]*document\.body\.insertAdjacentHTML[^}]*\}\(\)\);'
    $temp = $content -replace $pattern3, ''
    if ($temp -ne $content) {
        $content = $temp
        $changed = $true
    }
    
    if ($changed) {
        Set-Content $path $content -NoNewline
        Write-Host "Fixed: $f"
    } else {
        Write-Host "No change: $f"
    }
}

Write-Host "Done!"


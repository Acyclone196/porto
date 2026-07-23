$files = Get-ChildItem -Path "e:\Kirnature\porto" -Filter "*.html" | Select-Object -ExpandProperty Name

foreach ($f in $files) {
    $path = "e:\Kirnature\porto\$f"
    $content = Get-Content $path -Raw
    $original = $content
    $changed = $false
    
    # Remove footer link: <a href="cookie-policy.html">Cookie Policy</a>
    $content = $content -replace '<a href="cookie-policy\.html">Cookie Policy</a>', ''
    
    # Remove cookie JS blocks — multiline IIFE with "cookie-banner" inside
    $content = $content -replace '(?s)// Cookie( consent)?\s*\(function\(\).*?document\.getElementById\(''cookie-banner''\).*?\n\s*\}\(\)\);?', ''
    # Also try single-line version (no line breaks)
    $content = $content -replace '(?s)// Cookie\n\(function\(\)\{if\(localStorage\.getItem\(''cookieConsent''\)!==null\)return;const b=''<div id="cookie-banner".*?setTimeout\(\(\)=>banner\.remove\(\),500\);\}\)?\(\)\);?', ''
    # Another pattern: // Lightbox + Cookie comment
    $content = $content -replace '(?s)// Lightbox \+ Cookie.*?\n\s*\(function\(\)\{if\(localStorage.*?setTimeout\(\(\)=>banner\.remove\(\),500\);\}\)?\(\)\);?', ''
    # Remove leftover cookie-banner related HTML that might be stored in JS strings
    # Remove any standalone (function(){if(localStorage.getItem('cookieConsent')... blocks
    $content = $content -replace '(?s)\(function\(\)\{if\(localStorage\.getItem\(\\?[''""]cookieConsent[''""]\).*?setTimeout\(\(\)=>\w+\.remove\(\),500\);\}\)?\(\)\);?', ''
    
    if ($content -ne $original) {
        Set-Content $path $content -NoNewline
        Write-Host "Fixed: $f"
        $changed = $true
    }
    
    # Check if still has cookie references
    if ($content -match 'cookie-policy|cookie-banner|cookieConsent') {
        Write-Host "  WARNING: $f still has cookie references!"
    }
}

Write-Host "Done!"


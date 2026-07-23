$files = @(
    'bigcats.html','fieldnotes.html','guide-dan.html','guide-jou.html',
    'guide-mashatu.html','guide-rob.html','guides.html','pantanal.html',
    'story-botswana.html','story-mashatu-iphone.html','story-mashatu.html',
    'story-pantanal.html','story-shoebill.html','story-uganda.html',
    'street-india.html','street.html','travel.html','wildlife.html'
)

foreach ($f in $files) {
    $path = "e:\Kirnature\porto\$f"
    $content = Get-Content $path -Raw
    $original = $content
    
    # Remove the inline cookie IIFE block: (function(){if(localStorage.getItem('cookieConsent')...})();
    $pattern = '\(function\(\)\{if\(localStorage\.getItem\(''cookieConsent''\)\)'
    $content = $content -replace '(?s)\(function\(\)\{if\(localStorage\.getItem\(''cookieConsent''\)[^}]*setTimeout\(\(\)=>bn\.remove\(\),500\);\}\)?\(\)\);?', ''
    $content = $content -replace '(?s)\(function\(\)\{if\(localStorage\.getItem\(''cookieConsent''\)[^}]*setTimeout\(\(\)=>banner\.remove\(\),500\);\}\)?\(\)\);?', ''
    $content = $content -replace '(?s)\(function\(\)\{if\(localStorage\.getItem\(''cookieConsent''\)[^}]*setTimeout\(\(\)=>\w+\.remove\(\),500\);\}\)?\(\)\);?', ''
    
    if ($content -ne $original) {
        Set-Content $path $content -NoNewline
        Write-Host "Fixed: $f"
    } else {
        Write-Host "Not fixed: $f"
    }
}

Write-Host "Done!"
</｜｜DSML｜｜parameter>
</invoke>
</｜｜DSML｜｜tool_calls>

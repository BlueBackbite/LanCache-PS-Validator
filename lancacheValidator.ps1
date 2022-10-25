


$LANCACHE_IP = "192.168.1.141"

pushd ".\cache-domains"
git fetch
git pull
popd

# Get Lists
$List = Get-Content -Path ".\cache-domains\*.txt" 
$List = $List | Where-Object {$_[0] -ne "#"}



foreach($domain in $List)
{
    
    if($domain[0] -eq '*')
    {
        $domain = $domain.replace('*', 'a')
    }
    Write-Host -NoNewLine -ForegroundColor White "Lookup for $($domain)`tis`t"
    $lookup = Resolve-DNSName -Name $domain
    if($lookup.IPAddress -eq $LANCACHE_IP)
    {
        Write-Host -ForegroundColor Green "$($lookup.IPAddress)"
    }
    else {
        Write-Host -ForegroundColor Red "$($lookup.IPAddress)"
    }
    
    # Optional sleep, just to keep from being overwhelmed by instant data.
    Start-Sleep -Milliseconds 100
}

trap
{
    Write-Host -ForegroundColor Red "ERROR $($_)"
}
do {
    Start-Sleep 60
    Write-Host "Ngen still running"
}
until (!(get-process ngen -ErrorAction SilentlyContinue))


do {
    Start-Sleep 60
    Write-Host "tiworker still running"
}
until (!(get-process tiworker -ErrorAction SilentlyContinue))
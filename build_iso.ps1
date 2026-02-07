
Write-Host "Waiting for Docker Desktop to start..."
$timeout = 120
$startTime = Get-Date

while ($true) {
    docker info 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Docker is running!"
        break
    }
    if ((Get-Date) - $startTime -gt (New-TimeSpan -Seconds $timeout)) {
        Write-Host "Timed out waiting for Docker. Please start Docker Desktop manually."
        exit 1
    }
    Start-Sleep -Seconds 5
}

Write-Host "Starting GravityOS Build..."
docker run --rm --privileged -v ${PWD}:/profile archlinux:latest bash -c "pacman -Syu --noconfirm archiso git && cd /profile && ./build.sh"

Write-Host "Build Complete! Check the 'out' folder for your ISO."

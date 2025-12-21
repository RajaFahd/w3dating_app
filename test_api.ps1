# Test Send OTP API
$headers = @{
    'Content-Type' = 'application/json'
    'Accept' = 'application/json'
}

$body = @{
    phone_number = '812345678'
    country_code = '+61'
} | ConvertTo-Json

Write-Host "Testing Send OTP API..." -ForegroundColor Cyan
Write-Host "URL: http://127.0.0.1:8000/api/auth/send-otp" -ForegroundColor Yellow
Write-Host "Body: $body" -ForegroundColor Yellow
Write-Host ""

try {
    $response = Invoke-RestMethod -Uri 'http://127.0.0.1:8000/api/auth/send-otp' `
        -Method POST `
        -Headers $headers `
        -Body $body `
        -ErrorAction Stop
    
    Write-Host "✅ SUCCESS!" -ForegroundColor Green
    Write-Host ($response | ConvertTo-Json -Depth 10)
} catch {
    Write-Host "❌ ERROR!" -ForegroundColor Red
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)"
    Write-Host "Message: $($_.Exception.Message)"
    if ($_.ErrorDetails.Message) {
        Write-Host "Details:" -ForegroundColor Yellow
        Write-Host $_.ErrorDetails.Message
    }
}

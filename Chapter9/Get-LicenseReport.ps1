# PowerShell script: Get-MgLicenseReport.ps1

param(
    [Parameter(Mandatory=$true)][string]$TenantId,
    [Parameter(Mandatory=$true)][string]$ClientId,
    [Parameter(Mandatory=$true)][string]$ClientSecret,
    [Parameter(Mandatory=$false)][string]$OutFile = ".\license_report.csv"
)

# Get an access token using client credentials
$Scopes = "https://graph.microsoft.com/.default"
$TokenResponse = Get-MsalToken -ClientId $ClientId -ClientSecret $ClientSecret -TenantId $TenantId -Scopes $Scopes
$AccessToken = $TokenResponse.AccessToken

# Get all license SKUs
$skusUrl = "https://graph.microsoft.com/v1.0/subscribedSkus"
$skus = Invoke-RestMethod -Headers @{Authorization = "Bearer $AccessToken"} -Uri $skusUrl -Method Get

$results = @()
foreach ($sku in $skus.value) {
    $obj = [PSCustomObject]@{
        SKUName          = $sku.skuPartNumber
        SKUId            = $sku.skuId
        TotalPurchased   = $sku.prepaidUnits.enabled
        Assigned         = $sku.consumedUnits
        Available        = $sku.prepaidUnits.enabled - $sku.consumedUnits
    }
    $results += $obj
}

# Export to CSV
$results | Export-Csv -Path $OutFile -NoTypeInformation -Encoding UTF8

Write-Host "License report saved to $OutFile"

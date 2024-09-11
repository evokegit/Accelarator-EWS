param (
    [string]$ApiUrl,
    [string]$StorageAccountName,
    [string]$StorageAccountKey,
    [string]$ResourceGroupName,
    [string]$FileShareName,
    [string]$ImageUrl
)

# Validate parameters
if (-not $ApiUrl -or -not $StorageAccountName -or -not $StorageAccountKey -or -not $FileShareName -or -not $ImageUrl) {
    Write-Error "One or more required parameters are missing."
    exit 1
}

# Construct the API URL
$ApiUrl = "https://$ApiUrl.azurewebsites.net/api"
Write-Output "API_URL: $ApiUrl"

# Create JSON object and convert to string
$jsonObject = @{
    "API_URL" = $ApiUrl
    "ImageUrl" = $ImageUrl
}

# Convert the JSON object to a string
$jsonString = $jsonObject | ConvertTo-Json

# Write JSON to file
$jsonFilePath = "appConfig.json"
$jsonString | Out-File -FilePath $jsonFilePath
Write-Output "JSON configuration written to $jsonFilePath"

# Create Azure Storage context
try {
    $storageContext = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
} catch {
    Write-Error "Failed to create Azure Storage context: $_"
    exit 1
}

# Upload JSON to Azure File Share
try {
    Set-AzStorageFileContent -Context $storageContext -ShareName $FileShareName -Source $jsonFilePath -Path $jsonFilePath
    Write-Output "File successfully uploaded to Azure File Share: $FileShareName"
} catch {
    Write-Error "Failed to upload file to Azure File Share: $_"
    exit 1
}

# Uncomment and adjust if needed for Azure Web App configuration
# $storagePath = New-AzWebAppAzureStoragePath -Name "mount" -AccountName $StorageAccountName -Type AzureFiles -ShareName $FileShareName -AccessKey $StorageAccountKey -MountPath "/usr/share/nginx/html/assets"
# Set-AzWebApp -ResourceGroupName $ResourceGroupName -Name $Appname -AzureStoragePath $storagePath -Verbose

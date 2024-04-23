param (
    [string]$ApiUrl,
    [string]$StorageAccountName,
    [string]$StorageAccountKey,
    [string]$ResourceGroupName,
    [string]$FileShareName
   
)

$ApiUrl="https://"+$ApiUrl+".azurewebsites.net/api"
$ApiUrl
# Set the JSON object with the API URL
$jsonObject = @{
    "API_URL" = $ApiUrl
}

# Convert the JSON object to a string
$jsonString = $jsonObject | ConvertTo-Json

# Write the JSON string to a file
$jsonString | Out-File -FilePath appConfig.json

# Create the storage context
$storageContext = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey

# Upload the file to the file share
Set-AzStorageFileContent -Context $storageContext -ShareName $FileShareName -Source appConfig.json -Path appConfig.json





#$storagePath = New-AzWebAppAzureStoragePath -Name "mount" -AccountName $StorageAccountName -Type AzureFiles -ShareName $FileShareName -AccessKey $StorageAccountKey -MountPath "/usr/share/nginx/html/assets"
#Set-AzWebApp -ResourceGroupName $ResourceGroupName -Name $Appname -AzureStoragePath $storagePath -Verbose 

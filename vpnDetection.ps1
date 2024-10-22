# Define the path for the CSV file
$csvFilePath = "vpn_connections_log.csv"

# Check if the CSV file exists, and if not, create it with headers
if (-not (Test-Path $csvFilePath)) {
    "Timestamp,EventID,InterfaceAlias,NetworkCategory" | Out-File -FilePath $csvFilePath
}

# Loop through each event and extract relevant information
foreach ($event in (Get-WinEvent -LogName 'Microsoft-Windows-NetworkProfile/Operational' -FilterXPath "*[System[(EventID=10000)]]")) {
    $properties = $event.Properties

    # Check for "Identifying..." and skip the event
    if ($properties[0].Value -eq "Identifying...") {
        continue
    }

    # Get details about the network profile change event
    $eventID = $event.Id
    $interfaceAlias = $properties[0].Value  # Adjust index based on your system
    $networkCategory = $properties[1].Value  # Adjust index based on your system

    # Get timestamp for the current event
    $timestamp = $event.TimeCreated.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss")

    # Log information about the network profile change event
    $logMessage = "$timestamp,$eventID,$interfaceAlias,$networkCategory"
    Add-Content -Path $csvFilePath -Value $logMessage
}

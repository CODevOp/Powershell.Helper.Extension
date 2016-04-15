# Modify the version number of the Powershell manifest file
# Modify the release notes for the current release
    #vUpdate-ModuleManifest -Path $(join-path($path)"$name.psd1") -Tags $tag -FunctionsToExport $functionsToExport -AliasesToExport $AliasesToExport 
# Add the release notes to the Readme.md file

#deploy module to the PowershellGallery
$name = "Powershell.Helper.Extension"
$apiKey = read-host "Enter the API Key"
$path = (join-path(Split-Path -parent $PSCommandPath)"$name.psd1")



Publish-Module -Name $path -NuGetApiKey $apiKey
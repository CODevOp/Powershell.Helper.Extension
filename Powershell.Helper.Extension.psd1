#
# Module manifest for module 'NewManifest'
#
# Generated by: Bret Knoll
#
# Generated on: 3/25/2016
#

@{

# Script module or binary module file associated with this manifest.
RootModule = '.\Powershell.Helper.Extension.psm1'

# Version number of this module.
ModuleVersion = '1.9'

# ID used to uniquely identify this module
GUID = 'd419801b-dfdf-44b3-a452-796f4c954172'

# Author of this module
Author = 'Bret Knoll'

# Company or vendor of this module
CompanyName = 'Unknown'

# Copyright statement for this module
Copyright = '(c) 2016 Bret Knoll. All rights reserved.'

# Description of the functionality provided by this module
Description = '# Powershell.Helper.Extension
Provides helper functions to assist in the use of powershell

This powershell module has been distributed on the powershell gallery at 
https://www.powershellgallery.com/packages/Powershell.Helper.Extension. 
The purpose for adding this to GitHub is to collaborate with other developers 
and to increase proficiency in Git repositories and continue to build powershell skills.

Please report issues to the github repository at https://github.com/CODevOp/Powershell.Helper.Extension

'

# Minimum version of the Windows PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
ProcessorArchitecture = 'None'

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module
FunctionsToExport = 'Format-OrderedList', 'Add-Path', 'Limit-Job'

# Cmdlets to export from this module
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module
AliasesToExport = 'Format-NumberedList', 'Build-Path'

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'Helper','utility','Format-NumberedList','Format', 'Path', 'Add-Path', 'Limit-Job'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/CODevOp/Powershell.Helper.Extension/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/CODevOp/Powershell.Helper.Extension'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = 'Fixed issue with Format-OrderedList where array of items would come back with the array length as the item names. '

        # External dependent modules of this module
        # ExternalModuleDependencies = ''

    } # End of PSData hashtable
    
 } # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}


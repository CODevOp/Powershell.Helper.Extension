# Powershell.Helper.Extension
Provides helper functions to assist in the use of powershell

This powershell module has been distributed on the powershell gallery at 
https://www.powershellgallery.com/packages/Powershell.Helper.Extension. 
The purpose for adding this to GitHub is to collaborate with other developers 
and to increase proficiency in Git repositories and continue to build powershell skills.

4/1/2016: v1.3 - The first Pester Unit tests were added, a blog entry from simple-talk.com. Here is the URL https://www.simple-talk.com/sysadmin/powershell/practical-powershell-unit-testing-getting-started/

4/2/2016: v1.4 - Changed the function Build-Path to Add-Path to prevent unapproved verb warning. Pester was updated to test for both Add-Path and Build-Path alias. Updated Tags, LicenseURI and ProjectURI.

4/12/2016: v1.5 - Added the function Limit-Job allowing scripters to create multiple jobs or commands and control how many run at once.

4/17/2016: v1.6 - Added pester test for format-OrderedList. Fix bug where Format-OrderList would be empty if a propery was not specified. 
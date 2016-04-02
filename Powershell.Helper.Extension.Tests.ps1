#Reference: https://www.simple-talk.com/sysadmin/powershell/practical-powershell-unit-testing-getting-started/
$srcModule = $MyInvocation.MyCommand.Path `
    -replace '\.Tests\.', '.' -replace "ps1", "psd1"
    $srcModule
Test-ModuleManifest $srcModule
Import-Module $srcModule 

InModuleScope "Powershell.Helper.Extension" {
    Import-Module $srcModule 


    Describe "Add-Path" {
        Context "Test1" {
            $pattern = "([\w\:]+)[\\]"
            $match = $MyInvocation.MyCommand.Path -match $pattern            
            $path = $Matches[0] + $(New-Guid).ToString() + "\" + $(New-Guid).ToString()
            It "does something useful" {
                $true | Should Be $true
            }
            It "with a path it should return the path" {
                Add-Path $path | Should Be $path
            }
            It "After using Add-Path the path is confirmed with test-path" {
                $newpath = Add-Path $path;
                Test-Path $newpath  | Should Be $true
            }
            It "Build-Path still exists as an alias to prevent a breaking change" {
                !(Get-Command "Build-Path" -errorAction SilentlyContinue) | Should Be $false
            }
            It "Build-Path is an alias." {
                get-alias -Name Build-Path | Should Be $true
            }
            BeforeEach {
                if(Test-Path $path){
                rd $path
                }
            }
            AfterEach {
                if(Test-Path $path){
                rd $path
                }
            }
            

        }
    }
    Describe "Format-OrderedList" {
        It "does something useful" {
            $true | Should Be $true
        }
    }


}
Remove-Module "Powershell.Helper.Extension"
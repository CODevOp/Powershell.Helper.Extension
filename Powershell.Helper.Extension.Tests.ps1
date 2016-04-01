#Reference: https://www.simple-talk.com/sysadmin/powershell/practical-powershell-unit-testing-getting-started/
$srcModule = $MyInvocation.MyCommand.Path `
    -replace '\.Tests\.', '.' -replace "ps1", "psd1"
    $srcModule
Import-Module $srcModule 

InModuleScope "Powershell.Helper.Extension" {
    Import-Module $srcModule 


    Describe "Build-Path" {
        Context "Test1" {
            $pattern = "([\w\:]+)[\\]"
            $match = $MyInvocation.MyCommand.Path -match $pattern            
            $path = $Matches[0] + $(New-Guid).ToString() + "\" + $(New-Guid).ToString()
            It "does something useful" {
                $true | Should Be $true
            }
            It "with a path it should return the path" {
                Build-Path $path | Should Be $path
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
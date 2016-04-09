#Reference: https://www.simple-talk.com/sysadmin/powershell/practical-powershell-unit-testing-getting-started/
$srcModule = $MyInvocation.MyCommand.Path `
    -replace '\.Tests\.', '.' -replace "ps1", "psd1"
Import-Module $srcModule 

InModuleScope "Powershell.Helper.Extension" {
    Describe "Add-Path" {
        Context "Test1" {
            #use $env:ALLUSERSPROFILE which usually points to c:\programdata            
            $path = Join-Path(Join-Path($env:ALLUSERSPROFILE)$(New-Guid).ToString())$(New-Guid).ToString()
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
                    $parentPath = (get-item $path).Parent.FullName                 
                    if(Test-Path $parentPath){
                        "it exists"
                        rd $parentPath -Force
                    }            
                }
            }
            AfterEach {                
                if(Test-Path $path){
                    $parentPath = (get-item $path).Parent.FullName                 
                    if(Test-Path $parentPath){
                        "it exists"
                        rd $parentPath -Force
                    }            
                }
            }
        }
    }
    Describe "Format-OrderedList" {
        It "does something useful" {
            $true | Should Be $true
        }
    }
    Describe "Limit-Job" {
        
        It "The method exists when calling Get-Command" {
            !(Get-Command "Limit-Job" -errorAction SilentlyContinue) | Should Be $false
        }        
        It "Starts a job to manage running jobs" {
            $StartJob = @("{}" )
            $job = Limit-Job $StartJob
            ($job | select -First 1 -Property PSJobTypeName).PSJobTypeName | Should Be "BackgroundJob"
        
        }
        It "Can start multiple jobs" {
            $JobsCountBefore = get-job | Receive-Job -Keep
            $StartJob = @({start-job -ScriptBlock { sleep -Milliseconds 10 }},{start-job -ScriptBlock { sleep -Milliseconds 20 }},{start-job -ScriptBlock { sleep -Milliseconds 30 }}  )
            
            $job = Limit-Job -StartJob $StartJob
            sleep -Milliseconds 1000
            $JobsCountAfter = get-job $job.Id | Receive-Job -Keep
            $JobsCountAfter.Count | Should Be $StartJob.Count
        }
    }

}
Remove-Module "Powershell.Helper.Extension"
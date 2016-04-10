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
        It "Can start multiple Jobs" {
            #Create a list of jobs to start 
            $StartJob = @({start-job -ScriptBlock { sleep -Milliseconds 10 }},{start-job -ScriptBlock { sleep -Milliseconds 20 }},{start-job -ScriptBlock { sleep -Milliseconds 30 }}  )
            $job = Limit-Job -StartJob $StartJob
            $JobsCountAfter = get-job  
            $JobsCountAfter.Count | Should Be $StartJob.Count
        }              
        It "Can start multiple commands as Jobs" {
            #Create a list of jobs to start 
            $StartJob = @({ sleep -Milliseconds 10 },{ sleep -Milliseconds 20 },{ sleep -Milliseconds 30 })
            $job = Limit-Job -StartJob $StartJob
            $JobsCountAfter = get-job  
            $JobsCountAfter.Count | Should Be $StartJob.Count
        }
        It "Can limit how many jobs running to 1 " {
            $StartJob = @({start-job -ScriptBlock { sleep -Milliseconds 101 }},{start-job -ScriptBlock { sleep -Milliseconds 1002 }},{start-job -ScriptBlock { sleep -Milliseconds 1003 }}  )
            $Limit = 1
            $job = Limit-Job -StartJob $StartJob -Limit $Limit
            $JobsCountAfter = get-job -State Running 
            $JobsCountAfter.Count | Should Be $Limit

        }
        It "Can limit how many jobs running to 2 " {
            $StartJob = @({start-job -ScriptBlock { sleep -Milliseconds 0101 }},{start-job -ScriptBlock { sleep -Milliseconds 5002 }},{start-job -ScriptBlock { sleep -Milliseconds 5003 }}  )
            $Limit = 2
            Limit-Job -StartJob $StartJob -Limit $Limit
            
            $(get-job -State Running).Count | Should Be $Limit

        }

        BeforeEach{
            #remove any jobs in this session
            get-job | Stop-Job 
            get-job | remove-job
        }
        AfterEach{
            #remove any jobs in this session
            get-job | Stop-Job 
            get-job | remove-job

        }
    }

}
Remove-Module "Powershell.Helper.Extension"
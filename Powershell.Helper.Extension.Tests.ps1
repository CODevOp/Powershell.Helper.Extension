#Reference: https://www.simple-talk.com/sysadmin/powershell/practical-powershell-unit-testing-getting-started/
$srcModule = $MyInvocation.MyCommand.Path `
    -replace '\.Tests\.', '.' -replace "ps1", "psd1"
Import-Module $srcModule 

InModuleScope "Powershell.Helper.Extension" {
    Describe "Add-Path" {
        $path = Join-Path(Join-Path($env:temp)$(New-Guid).ToString())$(New-Guid).ToString()

        Context "Path exists"{
            Mock Test-Path{return $true;}
            Mock Write-Verbose
            $returnedPath = Add-Path -path $path
            It "Returns the path "{
                $returnedPath | Should Be $path                
            }
            It "Never calls Write-Verbose"{
                Assert-MockCalled Write-Verbose 0
                
            }
        }
        Context "Test1" {
            #Mock Test-Path{if($Path -eq ""){Write-Error "Test-Path : Cannot bind argument to parameter 'Path' because it is an empty string."; } else{return $true;}}
            #Mock New-Item {return $Path; }
            #Mock Get-Item {return $Path;}

            #use $env:ALLUSERSPROFILE which usually points to c:\programdata            
            It "After using Add-Path the path is confirmed with test-path" {
                $newpath = Add-Path $path;
                Test-Path $newpath  | Should Be $true
            }

            It "Build-Path is not a command" {
                !(Get-Command "Build-Path" -errorAction SilentlyContinue) | Should Be $false
            }
            It "Build-Path is an alias." {
                get-alias -Name Build-Path | Should Be $true
            }
            It "Build-Path works with a UNC path." {
                $pattern = "([a-zA-Z:]{2,2})*"
                $found =  $path -match $pattern
                if($found){
                 $replace = $Matches[0]
                 $givenPath = $path -replace $replace, "\\$($env:COMPUTERNAME)\$($replace.Replace(":", "`$" ))"
                                
                $testPath = Add-Path $givenPath
                $testPath | Should Be $givenPath                
                }                
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
        Context "Test Get-Help"{
            It "Can get-help and see examples" {
                $(get-help Add-Path ).examples.example.Count -gt 0 | Should Be $true
            }
        }
    }
    Describe "Format-OrderedList" {
        Mock Read-Host { }
        Context "Mock Out-Host confirm it is called" {
            Mock Get-Service { $count = 0; while($count -lt 5 ){"" | select -property @{Expression={"Stopped"}; Label="Status"},@{Expression={"ServiceName$count"}; Label="Name"},@{Expression={"Service Diplay Name $count"}; Label="DisplayName"};                   $count++;}}
            Mock Out-Host {return 1;}
            It "It calls Get-Service returns without selecting an item " {
                Get-Service | Format-OrderedList #| Write-Verbose # | Should Be ""
                Assert-MockCalled Out-Host -Times 1 
            }
        }
        
        Context "Mock out-host return object" {
            Mock Get-Service { $count = 0; $returnObject = @(); while($count -lt 100 ){$item = "" | select -property @{Expression={"Stopped"}; Label="Status"},@{Expression={"ServiceName$count"}; Label="Name"},@{Expression={"Service Diplay Name $count"}; Label="DisplayName"}; $returnObject = $returnObject + $item; $count++;} return $returnObject;}
            
            Mock Out-Host { 
            begin{$object=@(); }
            process{
                $object = $object + $InputObject
            }
            end{
                return $object
            }
        }
            It "The object returned has the correct count " {
                $(Get-Service | Format-OrderedList).Count  | Should Be 100
            }
            It "The returned object is formatted correctly when property is provided " {
                $getService = Get-Service | Format-OrderedList -property Name
                $pattern = "[0-9]{1,} :[\t]{1}[\w\d ]{1,}[\t]{1}"
                $getService | select -First 1 | Should Match $pattern

            }
            It "The returned object is formatted correctly multiple properties" {
                $getService = Get-Service | Format-OrderedList -property Name,DisplayName
                $pattern = "[0-9]{1,} :[\t]{1}[\w\d ]{1,}[\t]{1}[\w\d ]{1,}[\t]{1}"
                $getService | select -First 1 | Should Match $pattern

            }
            It "The returned object is formatted correctly when property is not provided " {
                $getService = Get-Service | Format-OrderedList
                $pattern = "[0-9]{1,} :[\t]{1}[\w\d ]{1,}[\t]{1}"
                $getService | select -First 1 | Should Match $pattern
            }
            It "The returned array of items is formated with the Array Items" {
                $testArray = @("Item1","Item2","Item3","Item4","Item5","Item6","Item7","Item8","Item9")
                $pattern = "[0-9]{1,} :[\t]{1}Item[1-9]{1}"
                $testArray | Format-OrderedList| select -First 1 | Should Match $pattern
            }

        }
        Context "Test Get-Help"{
            It "Can get-help and see examples" {
                $(get-help Format-OrderedList ).examples.example.Count -gt 0 | Should Be $true
            }
        }
    
    }
    Describe "Limit-Job" {
        Context "Test Limit-Job"{    
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
        Context "Test Get-Help"{
            It "Can get-help and see examples" {
                $(get-help Limit-Job).examples.example.Count -gt 0 | Should Be $true
            }
        }

    }

}
Remove-Module "Powershell.Helper.Extension"
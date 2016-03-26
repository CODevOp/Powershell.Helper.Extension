<#
.VERSION 1.0

.GUID 4ea20bcd-b174-46bc-ba48-08d10066ec5d

.AUTHOR Bret Knoll


#>
<#
 .Synopsis Used by function Format-OrderedList when receiving input from user

.DESCRIPTION Uses pattern match to determine if a entry is numeric

  .Version 1.0
#>
function isNumeric{
    param([object]$item)
    return $($item -match "^[1-9]{1}[0-9]{0,2}$")
    
}
<#
 .Synopsis Used by function Format-OrderedList to format a single row.

.DESCRIPTION Formats each line of input into a number list.

  .Version 1.0
#>
function Format-Item{
    param($item = @{},
        [array]$property
    )

    $property | foreach{

        $column = $_
        "$($item."$column")`t "
    }
    

}
<#
 .Synopsis
 Many of powershells functions return streams or lists of items. This function allows the user to choose items by a number in
 a list without have to sort by name. 

.DESCRIPTION 
 Format-NumberedList formats lists in to a numbered list, allowing user to choose one or more items in the list.  

 .Version 1.0
#>
function Format-OrderedList{
param( [array]$property )
begin{
    if($property){
        $arrayOfProperties = $property.Split(",")
    }
    $count=0;
    #"$count : Choose None!"
    $objectHash = @{"$count" = "DoNothing"}
    $formattedTable = @()
    }
process{
    $count++
    if(!$arrayOfProperties){
        $propertyList = $_.PSStandardMembers.DefaultDisplayPropertySet.Value #  | Get-Member PSStandardMembers -Force
        $arrayOfProperties = $propertyList.ReferencedPropertyNames
     
    }
    
    $item = $_ | select -Property $arrayOfProperties
    $formattedTable = $formattedTable +  "$count :`t$(Format-Item -item $item -property $arrayOfProperties )"
    $objectHash.Add("$count", $_)
}
end{
    $formattedTable |  Out-Host
    Write-host -BackgroundColor Black "`tChoose an item by #"; 
    $listOfItems = @();
    $item="0"
    while($item){
        $item = read-host "[$($listOfItems.length)] "
        if(isNumeric -item $item){
            $listOfItems = $listOfItems + $item    
        }
    }
    $listOfItems | foreach{
        $objectHash["$($_)"]        
    }
}
}
<#
  
  .DESCRIPTION Creates each level of a path. Requires elevated permissions to create a path. Currently, does not check if
  adequate permissions exist to create a path.
  
  .Version 1.0

  .EXAMPLE 1
  Build-Path -Path "c:\temp\ouptut\Time0930"
  each portion of the path is checked, if it does not exist it is created.

#>
function Build-Path{
    param([string]$Path)
    [string]$testPath = ""
    if(!(test-path $Path) ){
        
        $Path.Split("\") | foreach{
            if($_ -like "*:" ){
                $testPath = $_
            }
            if($_ -notlike "*:" ){
                $testPath = Join-Path($testPath)$($_)
            }
            Write-Verbose $testPath
            If(!(test-path $testPath)){
                New-Item $testPath -ItemType directory
            }
        }     
    }
    [string]$Path
}        
New-Alias -Name Format-NumberedList -Value Format-OrderedList
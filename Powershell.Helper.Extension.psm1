﻿<#
.VERSION 1.6

.GUID 4ea20bcd-b174-46bc-ba48-08d10066ec5d

.AUTHOR Bret Knoll

#>
<#
.SYNOPSIS 
    Used by function Format-OrderedList when receiving input from user

.DESCRIPTION 
    Uses pattern match to determine if a entry is numeric
#>

function isNumeric{
    param([object]$item)
    return $($item -match "^[1-9]{1}[0-9]{0,2}$")
    
}
<#
.SYNOPSIS 
    Used by function Format-OrderedList to format a single row.

.DESCRIPTION 
    Formats each line of input into a number list.
#>

function Format-Item{
    param($item = @{},
        [array]$property
    )
    if($property){
        $property | foreach{

            $column = $_
            "$($item."$column")`t "
        }
    }
    else{
        "$($item)`t "
    }


}
############### Place external functions here alphabetically

function Add-Path{
    <#
    .SYNOPSIS
        when creating a new script the script sometimes needs to work with files or output files into specific folder structures.
        Add-Path allows the developer to focus on the code, not the folder creation.    
    .DESCRIPTION 
        Creates each level of a path. Requires elevated permissions to create a path. Currently, does not check if
        adequate permissions exist to create a path.
    .EXAMPLE
        Build-Path -Path "c:\temp\ouptut\Time0930"
        Each portion of the path is checked, if it does not exist it is created.
    .EXAMPLE
        Build-Path -Path "\\servername\ShareName\NewFolder1\NewFolder2"

    #>
    param([string]$Path)
    [string]$testPath = ""
    if(!(test-path $Path) ){        
        $pathArray = $Path.Split("\");
        for($forCounter = 0;$forCounter -lt $pathArray.length;$forCounter++){
            $pathItem = $pathArray[$forCounter];
            Write-Verbose $pathItem
            if($pathItem -eq ""){
                
                $forCounter = 2; #reset the counter
                $testPath = "\\$($pathArray[$forCounter];)";
                $forCounter = 3;
                $pathItem = $pathArray[$forCounter];                
            }
            if($pathItem -like "*:"  ){
                $testPath = $pathItem
            }
            if($pathItem -notlike "*:" ){
                $testPath = Join-Path($testPath)$($pathItem)
            }
            Write-Verbose $testPath
            If(!(test-path -Path $testPath)){
                $createfolder = New-Item $testPath -ItemType directory
            }
        }     
    }
    return [string]$Path
}

function Format-OrderedList{
    <#
    .SYNOPSIS
        Many of powershells functions return streams or lists of items. This function allows the user to choose items by a number in
        a list without have to sort by name. 

    .DESCRIPTION 
        Format-NumberedList formats lists in to a numbered list, allowing user to choose one or more items in the list.  

    .EXAMPLE
        PS> Get-Service | SELECT -First 100 | Format-OrderedList
        1 :	Stopped	  AJRouter	  AllJoyn Router Service	 
        2 :	Stopped	  ALG	  Application Layer Gateway Service	 
        3 :	Running	  AppHostSvc	  Application Host Helper Service	 
        4 :	Stopped	  AppIDSvc	  Application Identity	 
        5 :	Running	  Appinfo	  Application Information	 
        6 :	Stopped	  AppMgmt	  Application Management	 
        7 :	Stopped	  AppReadiness	  App Readiness	 
        8 :	Stopped	  AppXSvc	  AppX Deployment Service (AppXSVC)	 
        9 :	Stopped	  aspnet_state	  ASP.NET State Service	 
        10 :	Running	  Asset Management Daemon	  Asset Management Daemon	 
        11 :	Running	  AudioEndpointBuilder	  Windows Audio Endpoint Builder	 
        12 :	Running	  Audiosrv	  Windows Audio	 
        13 :	Stopped	  AxInstSV	  ActiveX Installer (AxInstSV)	 
        14 :	Stopped	  BDESVC	  BitLocker Drive Encryption Service	 
        15 :	Running	  BFE	  Base Filtering Engine	 
        16 :	Running	  BITS	  Background Intelligent Transfer Service	 
        17 :	Running	  BrokerInfrastructure	  Background Tasks Infrastructure Service	 
        18 :	Running	  Browser	  Computer Browser	 
        19 :	Stopped	  BthHFSrv	  Bluetooth Handsfree Service	 
        20 :	Running	  bthserv	  Bluetooth Support Service	 
        21 :	Stopped	  CDPSvc	  Connected Device Platform Service	 
        22 :	Stopped	  CertPropSvc	  Certificate Propagation	 
        23 :	Running	  ClickToRunSvc	  Microsoft Office Click-to-Run Service	 
        24 :	Stopped	  ClipSVC	  Client License Service (ClipSVC)	 
        25 :	Stopped	  COMSysApp	  COM+ System Application	 
        26 :	Running	  CoreMessagingRegistrar	  CoreMessaging	 
        27 :	Stopped	  cphs	  Intel(R) Content Protection HECI Service	 
        28 :	Running	  CryptSvc	  Cryptographic Services	 
        29 :	Running	  CscService	  Offline Files	 
        30 :	Running	  DcomLaunch	  DCOM Server Process Launcher	 
        31 :	Stopped	  DcpSvc	  DataCollectionPublishingService	 
        32 :	Stopped	  defragsvc	  Optimize drives	 
        33 :	Running	  DeviceAssociationService	  Device Association Service	 
        34 :	Stopped	  DeviceInstall	  Device Install Service	 
        35 :	Stopped	  DevQueryBroker	  DevQuery Background Discovery Broker	 
        36 :	Running	  Dhcp	  DHCP Client	 
        37 :	Stopped	  diagnosticshub.standardcollector.service	  Microsoft (R) Diagnostics Hub Standard Collector Service	 
        38 :	Running	  DiagTrack	  Connected User Experiences and Telemetry	 
        39 :	Stopped	  DmEnrollmentSvc	  Device Management Enrollment Service	 
        40 :	Stopped	  dmwappushservice	  dmwappushsvc	 
        41 :	Stopped	  Dnscache	  DNS Client	 
        42 :	Running	  DoSvc	  Delivery Optimization	 
        43 :	Stopped	  dot3svc	  Wired AutoConfig	 
        44 :	Running	  DPS	  Diagnostic Policy Service	 
        45 :	Stopped	  DsmSvc	  Device Setup Manager	 
        46 :	Running	  DsSvc	  Data Sharing Service	 
        47 :	Running	  DTSRVC	  Portrait Displays Display Tune Service	 
        48 :	Stopped	  Eaphost	  Extensible Authentication Protocol	 
        49 :	Stopped	  EFS	  Encrypting File System (EFS)	 
        50 :	Stopped	  embeddedmode	  embeddedmode	 
        51 :	Stopped	  EntAppSvc	  Enterprise App Management Service	 
        52 :	Running	  EventLog	  Windows Event Log	 
        53 :	Running	  EventSystem	  COM+ Event System	 
        54 :	Running	  FA_Scheduler	  FortiClient Service Scheduler	 
        55 :	Stopped	  Fax	  Fax	 
        56 :	Stopped	  fdPHost	  Function Discovery Provider Host	 
        57 :	Stopped	  FDResPub	  Function Discovery Resource Publication	 
        58 :	Stopped	  fhsvc	  File History Service	 
        59 :	Running	  FontCache	  Windows Font Cache Service	 
        60 :	Running	  FontCache3.0.0.0	  Windows Presentation Foundation Font Cache 3.0.0.0	 
        61 :	Stopped	  gpsvc	  Group Policy Client	 
        62 :	Stopped	  gupdate	  Google Update Service (gupdate)	 
        63 :	Stopped	  gupdatem	  Google Update Service (gupdatem)	 
        64 :	Running	  hidserv	  Human Interface Device Service	 
        65 :	Stopped	  HomeGroupProvider	  HomeGroup Provider	 
        66 :	Running	  HvHost	  HV Host Service	 
        67 :	Running	  IBMPMSVC	  Lenovo PM Service	 
        68 :	Stopped	  icssvc	  Windows Mobile Hotspot Service	 
        69 :	Stopped	  IEEtwCollectorService	  Internet Explorer ETW Collector Service	 
        70 :	Running	  igfxCUIService2.0.0.0	  Intel(R) HD Graphics Control Panel Service	 
        71 :	Running	  IKEEXT	  IKE and AuthIP IPsec Keying Modules	 
        72 :	Stopped	  Intel(R) Capability Licensing Service TCP IP Interface	  Intel(R) Capability Licensing Service TCP IP Interface	 
        73 :	Running	  iphlpsvc	  IP Helper	 
        74 :	Running	  jhi_service	  Intel(R) Dynamic Application Loader Host Interface Service	 
        75 :	Running	  KeyIso	  CNG Key Isolation	 
        76 :	Stopped	  KtmRm	  KtmRm for Distributed Transaction Coordinator	 
        77 :	Running	  LanmanServer	  Server	 
        78 :	Running	  LanmanWorkstation	  Workstation	 
        79 :	Running	  LENOVO.CAMMUTE	  Lenovo Camera Mute	 
        80 :	Running	  LENOVO.MICMUTE	  Lenovo Microphone Mute	 
        81 :	Running	  LENOVO.TPKNRSVC	  Lenovo Keyboard Noise Reduction	 
        82 :	Running	  LENOVO.TVTVCAM	  Lenovo Virtual Camera Controller	 
        83 :	Running	  Lenovo.VIRTSCRLSVC	  Lenovo Auto Scroll	 
        84 :	Stopped	  LenovoProdRegManager	  PowerENGAGE Maintenance Service	 
        85 :	Running	  lfsvc	  Geolocation Service	 
        86 :	Running	  LicenseManager	  Windows License Manager Service	 
        87 :	Stopped	  lltdsvc	  Link-Layer Topology Discovery Mapper	 
        88 :	Running	  lmhosts	  TCP/IP NetBIOS Helper	 
        89 :	Running	  LMS	  Intel(R) Management and Security Application Local Management Service	 
        90 :	Running	  lnvDiscoveryWinSvc	  lnvDiscoveryWinSvc	 
        91 :	Stopped	  LSCWinService	  LSCWinService	 
        92 :	Running	  LSM	  Local Session Manager	 
        93 :	Stopped	  MapsBroker	  Downloaded Maps Manager	 
        94 :	Running	  MpsSvc	  Windows Firewall	 
        95 :	Stopped	  MSDTC	  Distributed Transaction Coordinator	 
        96 :	Stopped	  MSiSCSI	  Microsoft iSCSI Initiator Service	 
        97 :	Stopped	  msiserver	  Windows Installer	 
        98 :	Running	  MSMQ	  Message Queuing	 
        99 :	Stopped	  NcaSvc	  Network Connectivity Assistant	 
        100 :	Running	  NcbService	  Network Connection Broker	 
	        Choose an item by #
        [0] : 1
        [1] : 10
        [2] : 100
        [3] : 

        Status   Name               DisplayName                           
        ------   ----               -----------                           
        Stopped  AJRouter           AllJoyn Router Service                
        Running  Asset Managemen... Asset Management Daemon               
        Running  NcbService         Network Connection Broker  

    .EXAMPLE
        PS> Get-Service  | SELECT -First 100 | Format-OrderedList -property Name
        1 :	AJRouter	 
        2 :	ALG	 
        3 :	AppHostSvc	 
        4 :	AppIDSvc	 
        5 :	Appinfo	 
        6 :	AppMgmt	 
        7 :	AppReadiness	 
        8 :	AppXSvc	 
        9 :	aspnet_state	 
        10 :	Asset Management Daemon	 
        11 :	AudioEndpointBuilder	 
        12 :	Audiosrv	 
        13 :	AxInstSV	 
        14 :	BDESVC	 
        15 :	BFE	 
        16 :	BITS	 
        17 :	BrokerInfrastructure	 
        18 :	Browser	 
        19 :	BthHFSrv	 
        20 :	bthserv	 
        21 :	CDPSvc	 
        22 :	CertPropSvc	 
        23 :	ClickToRunSvc	 
        24 :	ClipSVC	 
        25 :	COMSysApp	 
        26 :	CoreMessagingRegistrar	 
        27 :	cphs	 
        28 :	CryptSvc	 
        29 :	CscService	 
        30 :	DcomLaunch	 
        31 :	DcpSvc	 
        32 :	defragsvc	 
        33 :	DeviceAssociationService	 
        34 :	DeviceInstall	 
        35 :	DevQueryBroker	 
        36 :	Dhcp	 
        37 :	diagnosticshub.standardcollector.service	 
        38 :	DiagTrack	 
        39 :	DmEnrollmentSvc	 
        40 :	dmwappushservice	 
        41 :	Dnscache	 
        42 :	DoSvc	 
        43 :	dot3svc	 
        44 :	DPS	 
        45 :	DsmSvc	 
        46 :	DsSvc	 
        47 :	DTSRVC	 
        48 :	Eaphost	 
        49 :	EFS	 
        50 :	embeddedmode	 
        51 :	EntAppSvc	 
        52 :	EventLog	 
        53 :	EventSystem	 
        54 :	FA_Scheduler	 
        55 :	Fax	 
        56 :	fdPHost	 
        57 :	FDResPub	 
        58 :	fhsvc	 
        59 :	FontCache	 
        60 :	FontCache3.0.0.0	 
        61 :	gpsvc	 
        62 :	gupdate	 
        63 :	gupdatem	 
        64 :	hidserv	 
        65 :	HomeGroupProvider	 
        66 :	HvHost	 
        67 :	IBMPMSVC	 
        68 :	icssvc	 
        69 :	IEEtwCollectorService	 
        70 :	igfxCUIService2.0.0.0	 
        71 :	IKEEXT	 
        72 :	Intel(R) Capability Licensing Service TCP IP Interface	 
        73 :	iphlpsvc	 
        74 :	jhi_service	 
        75 :	KeyIso	 
        76 :	KtmRm	 
        77 :	LanmanServer	 
        78 :	LanmanWorkstation	 
        79 :	LENOVO.CAMMUTE	 
        80 :	LENOVO.MICMUTE	 
        81 :	LENOVO.TPKNRSVC	 
        82 :	LENOVO.TVTVCAM	 
        83 :	Lenovo.VIRTSCRLSVC	 
        84 :	LenovoProdRegManager	 
        85 :	lfsvc	 
        86 :	LicenseManager	 
        87 :	lltdsvc	 
        88 :	lmhosts	 
        89 :	LMS	 
        90 :	lnvDiscoveryWinSvc	 
        91 :	LSCWinService	 
        92 :	LSM	 
        93 :	MapsBroker	 
        94 :	MpsSvc	 
        95 :	MSDTC	 
        96 :	MSiSCSI	 
        97 :	msiserver	 
        98 :	MSMQ	 
        99 :	NcaSvc	 
        100 :	NcbService	 
	        Choose an item by #
        [0] : 5
        [1] : 10
        [2] : 16
        [3] : 25
        [4] : 

        Status   Name               DisplayName                           
        ------   ----               -----------                           
        Running  Appinfo            Application Information               
        Running  Asset Managemen... Asset Management Daemon               
        Running  BITS               Background Intelligent Transfer Ser...
        Stopped  COMSysApp          COM+ System Application 
    #>
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
    if(!$arrayOfProperties){ #arrayOfProperties is created in the begin portion of the function. if it does not exists use it to format the list
        $propertyList = $_.PSStandardMembers.DefaultDisplayPropertySet.Value #  | Get-Member PSStandardMembers -Force
        if($propertyList){
            $arrayOfProperties = $propertyList.ReferencedPropertyNames
        }

    }
    
    if(!$arrayOfProperties){    
        #$arrayOfProperties = $($_ |Get-Member -MemberType NoteProperty | select -First 1 -Property Name).Name
        $propertyList = $($_ |Get-Member -MemberType NoteProperty)
        if($propertyList){
            $arrayOfProperties = $($propertyList | Select -First 1 -property Name).Name
        }

    }
    if(!$arrayOfProperties){    
        #$arrayOfProperties = $($_ |Get-Member -MemberType NoteProperty | select -First 1 -Property Name).Name
        $propertyList = $($_ |Get-Member -MemberType AliasProperty)
        if($propertyList){
            $arrayOfProperties = $($propertyList | Select -First 1 -property Name).Name
        }

    }    
    
    $item = $_ | select -Property $arrayOfProperties;
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

function Limit-Job {
    <#
    .SYNOPSIS
        The Powershell script Start-Job allows the execution of many processes in parallel as background jobs. 
        It would be nice to kick off a process that can control how many jobs run at one time. 

    .DESCRIPTION 
        Limit-Job will run Start-Job once foreach item and but will limit how many jobs run simultaneously. 

    .EXAMPLE
    The following starts 3 jobs one a at a time.
            $StartJob = @({start-job -ScriptBlock { sleep -Milliseconds 0500 }},{start-job -ScriptBlock { sleep -Milliseconds 5002 }},{start-job -ScriptBlock { sleep -Milliseconds 5003 }}  )
            $Limit = 1
            $job = Limit-Job -StartJob $StartJob -Limit $Limit
            $job | ft
            "Number of running jobs: $($(get-job -State Running).Count)"

            Output:

            Id     Name            PSJobTypeName   State         HasMoreData     Location             Command                  
            --     ----            -------------   -----         -----------     --------             -------                  
            49     Job49           BackgroundJob   Completed     True            localhost            start-job -ScriptBlock...
            51     Job51           BackgroundJob   Completed     True            localhost            start-job -ScriptBlock...
            53     Job53           BackgroundJob   Running       True            localhost            start-job -ScriptBlock...




    .EXAMPLE
            get-job | remove-job # remove any existing jobs
            # Build  a list of jobs/comands to run
            $StartJob = @({start-job -ScriptBlock { get-service | select -First 10 }},{start-job -ScriptBlock { Get-ChildItem c:\  | select -First 10 }},{start-job -ScriptBlock { get-process | select -First 10 }}  )
            $Limit = 1
            $job = Limit-Job -StartJob $StartJob -Limit $Limit #start the jobs 1 at a time
            get-job | Wait-Job # wait for the jobs to stop running
            get-job | ft # get a list of the jobs

            # loop through the list of jobs, print the command and receive the job data
            get-job | foreach {
                write-host $_.Command
                $_ | Receive-Job | ft
           }
            
            Id     Name            PSJobTypeName   State         HasMoreData     Location             Command                  
            --     ----            -------------   -----         -----------     --------             -------                  
            141    Job141          BackgroundJob   Completed     True            localhost             get-service | select ...
            143    Job143          BackgroundJob   Completed     True            localhost             Get-ChildItem c:\  | ...
            145    Job145          BackgroundJob   Completed     True            localhost             get-process | select ...


             get-service | select -First 10 

            Status   Name               DisplayName                           
            ------   ----               -----------                           
            Stopped  AJRouter           AllJoyn Router Service                
            Stopped  ALG                Application Layer Gateway Service     
            Running  AppHostSvc         Application Host Helper Service       
            Stopped  AppIDSvc           Application Identity                  
            Running  Appinfo            Application Information               
            Running  AppMgmt            Application Management                
            Stopped  AppReadiness       App Readiness                         
            Stopped  AppXSvc            AppX Deployment Service (AppXSVC)     
            Stopped  aspnet_state       ASP.NET State Service                 
            Running  Asset Managemen... Asset Management Daemon               


             Get-ChildItem c:\  | select -First 10 


                Directory: C:\


            Mode                LastWriteTime         Length Name                                                                    
            ----                -------------         ------ ----                                                                    
            d-----       12/15/2015     10:47                5938dfc30ab6bda1c4a2                                                    
            d-----        1/30/2016     16:10                chef-repo                                                               
            d-----        8/26/2015     12:05                DRIVERS                                                                 
            da----        9/20/2015     08:59                Go                                                                      
            d-----        2/13/2016     09:15                Hyper-V                                                                 
            d-----        2/10/2016     13:33                inetpub                                                                 
            d-----        12/9/2015     07:35                Intel                                                                   
            d-----        2/13/2016     08:57                iso                                                                     
            d-----        8/14/2015     15:07                mfg                                                                     
            d-----        1/22/2016     16:27                opscode                                                                 


             get-process | select -First 10 

            Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id  SI ProcessName                                                
            -------  ------    -----      ----- -----   ------     --  -- -----------                                                
                323      20     8044      26020 ...01     1.78   8528   1 ApplicationFrameHost                                       
                157      11     2664       8104    86     1.41  10744   1 AppVShNotify                                               
                169      13     2948      12492   115     1.63  10528   1 BleServicesCtrl                                            
               1323      12     2860       7960    69     2.67   2956   0 CamMute                                                    
               2117     100    49108      41568   349 2,066.53   2724   0 ccSvcHst                                                   
                433      33     6020       7008   121    26.38   7492   1 ccSvcHst                                                   
                231      21    31928      35016   210    11.84   1760   1 chrome                                                     
                265      10     1952       6592    77     0.09  14712   1 chrome                                                     
                267      26    60216      73412   265   415.14  16100   1 chrome                                                     
                411      27    66400     124972   320    59.33  19904   1 chrome                                                     


    #>
    param([string[]]$StartJob,[int]$Limit=0) #, [int]$Limit, [string]$Name
    Write-Verbose "The Limit is: $Limit"

    $StartJob | foreach {             
        try{
            $ScriptBlock = $executioncontext.invokecommand.NewScriptBlock( $_.Trim() ) #Found information about converting a string to a script block http://www.get-powershell.com/post/2008/12/15/ConvertTo-ScriptBlock.aspx
            while($(get-job | where {$_.State -eq "Running"}).Count -eq $Limit -and $Limit -ne 0 ){
                sleep -Milliseconds 1
           }    
            Write-Verbose "Starting Job $($ScriptBlock) at $(get-date)"
            # if we use start-job for script blocks that have proper job formatted commands, the user cannot use receive-job        
            if($_ -like "*start-job*"){
                Invoke-Command -ScriptBlock $ScriptBlock # start job as invoke-command
            }
            else{
                Start-Job -ScriptBlock $ScriptBlock # the script block is a powershell command not a job.
            }
            
            sleep -Milliseconds 5 # wait for the job to start
        }
        catch{
            Write-Error "could not start $($scriptblock.tostring())"
        }            
    }
    Write-Verbose "Number of Jobs Running $($(get-job -State Running).Count)"
 }
        
New-Alias -Name Format-NumberedList -Value Format-OrderedList -Description "Allias for Format-OrderedList."
New-Alias -Name Build-Path -Value Add-Path -Description "Alias for Add-Path, to prevent a breaking change. "
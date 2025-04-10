[CmdletBinding()]
param([switch] $Force)
Import-Module au

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition)
$userAgent = 'Update checker of Chocolatey Community Package ''sandisk-dashboard'''

function Set-DocumentVersion($RelativeFilePath) {
    $fileContents = Get-Content -Path $RelativeFilePath -Encoding UTF8
    $fileContents = $fileContents -replace '/blob/v.*\/', "/blob/v$($Latest.Version)/"

    $encoding = New-Object System.Text.UTF8Encoding($false)
    $output = $fileContents | Out-String
    $absoluteFilePath = (Get-Item -Path $RelativeFilePath).FullName
    [System.IO.File]::WriteAllText($absoluteFilePath, $output, $encoding)
}

function global:au_BeforeUpdate ($Package) {
    #Check whether the ETag value has changed before proceeding with a checksum verification
    $headRequest = Invoke-WebRequest -Uri $Latest.Url32 -Method Head -UserAgent $userAgent
    $currentETagValue = $headRequest.Headers['ETag']
    $etagFilePath = Join-Path -Path $currentPath -ChildPath 'ETag.txt'

    $lastETagValue = Get-Content -Path $etagFilePath -Encoding UTF8 -TotalCount 1
    if (!($global:au_Force -or $Force) -and $lastETagValue -eq $currentETagValue) {
        throw "$($Latest.PackageName) v$($Latest.Version) has been published, but the binary used by the package does not appear to have been updated yet!"
    }
    else {
        "$currentETagValue" | Out-File -FilePath $etagFilePath -Encoding UTF8
    }

    #Archive this version for future development, since SanDisk only keeps the latest version available
    $filePath = ".\DashboardSetupSA_$($Latest.Version).exe"
    Invoke-WebRequest -Uri $Latest.Url32 -OutFile $filePath -UserAgent $userAgent
    
    #Avoid executing chocolateyInstall.ps1 to accommodate environments with the software installed
    $Latest.ChecksumType32 = 'sha256'
    $Latest.Checksum32 = (Get-FileHash -Path $filePath -Algorithm $Latest.ChecksumType32).Hash.ToLower()
    
    $installScriptPath = Join-Path -Path $currentPath -ChildPath 'tools' | Join-Path -ChildPath 'chocolateyInstall.ps1'
    $installScriptChecksum = (Select-String -Path $installScriptPath -Pattern "(^[$]?\s*checksum\s*=\s*)('(.*)')").Matches.Groups[3].Value
    if (!($global:au_Force -or $Force) -and $installScriptChecksum -eq $Latest.Checksum32) {
        Remove-Item -Path $filePath -Force
        throw "$($Latest.PackageName) v$($Latest.Version) has been published, but the binary used by the package hasn't been updated yet!"
    }

    $descriptionRelativePath = '.\DESCRIPTION.md'
    Set-DocumentVersion -RelativeFilePath $descriptionRelativePath
    Set-DescriptionFromReadme -Package $Package -ReadmePath $descriptionRelativePath -SkipFirst 1
}

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1'   = @{
            "(^[$]softwareVersion\s*=\s*)'.*'"    = "`$1'$($Latest.Version)'"
            "(^[$]?\s*url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(^[$]?\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(^[$]?\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32.ToLower())'"
        }
        "$($Latest.PackageName).nuspec" = @{
            '(<packageSourceUrl>)[^<]*(</packageSourceUrl>)' = "`$1https://github.com/brogers5/chocolatey-package-$($Latest.PackageName)/tree/v$($Latest.Version)`$2"
            '(<copyright>)[^<]*(</copyright>)'               = "`$1(c) $($(Get-Date -Format yyyy)) SanDisk Corporation`$2"
        }
    }
}

function global:au_GetLatest {
    $uri = 'https://support-en.sandisk.com/app/answers/detailweb/a_id/31759'

    $page = Invoke-WebRequest -Uri $uri -UseBasicParsing -UserAgent $userAgent
    $url = $page.Links | Where-Object href -Match 'DashboardSetupSA.exe' | Select-Object -First 1 -ExpandProperty href

    $updateUri = 'https://sddashboarddownloads.sandisk.com/wdDashboard/config/lista_updater.xml'
    $xmlDocument = Invoke-RestMethod -Uri $updateUri -UseBasicParsing -UserAgent $userAgent

    $version = $xmlDocument.lista.Application_Installer.version

    return @{
        URL32   = $url
        Version = $version
    }
}

try {
    Update-Package -ChecksumFor None -NoReadme -Force:$Force
}
catch {
    $ignore = 'the binary used by the package (does not appear to have|hasn''t) been updated yet!'
    if ($_ -match $ignore) { Write-Warning $_ ; 'ignore' }  else { throw $_ }
}

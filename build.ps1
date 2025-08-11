# This script builds the Python package and uploads it to TestPyPI.
# Usage:
# - To build and upload with a specific release version:
#   ./build.ps1 -ReleaseVersion "0.1.0" -Publish
# - To build and upload with the current Unix epoch as version:     
#   ./build.ps1 -Publish
# - To build locally without publishing:
#   ./build.ps1    
param(
    [Parameter(Mandatory = $false)]
    [string]$ReleaseVersion,

    [Parameter(Mandatory = $true)]
    [switch]$Publish = $false
)

function main {
    Write-Host "Starting build process..."
    python.exe -m build
    python.exe -m twine upload --repository testpypi dist/*
}

function ConvertTo-Base62 {
    param(
        [Parameter(Mandatory=$true)]
        [int64]$Number
    )

    $Base62Chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    $result = ""

    if ($Number -eq 0) {
        return $Base62Chars[0]
    }

    while ($Number -gt 0) {
        $remainder = $Number % 62
        $result = $Base62Chars[$remainder] + $result
        $Number = [int64]($Number / 62)
    }

    return $result
}

if (-not $ReleaseVersion) {
    Write-Host "No release version specified. Generating version number using unix epoch."
    
    $unixTime = [int64](Get-Date -UFormat %s)

    $base62Version = ConvertTo-Base62 -Number $unixTime

    # Pad the result with leading zeros to ensure a consistent 6-character length
    # Needed for correct sorting in Windows
    $version = $base62Version.PadLeft(6, '0')

    Write-Host "Unix Time: $unixTime"
    Write-Host "Generated Version: $version"

    # Leave the code as is, but use the generated version
    $ReleaseVersion = "0.0.$unixTime"
}

if (-not $Publish) {# For local builds, use a fixed version
    $patchVersion = (Get-Date).ToString("yyyyMMdd")
    $localVersionIdentifier = (Get-Date).ToString("HHmmss")
    $ReleaseVersion = "0.0.$patchVersion+$localVersionIdentifier"
}

$env:RELEASE_VERSION="$ReleaseVersion"
Write-Host "Building package with version: $env:RELEASE_VERSION"

& main
function Get-URL() {
    $VERSION = "2.304.0"

    $os_type = (Get-WmiObject -Class Win32_ComputerSystem).SystemType

    if ($os_type -match "arm64") {
        $os_type = "arm64"
    } elseif ($os_type -match '(x64)') {
        $os_type = "x64"
    } else {
        $os_type = ""
        echo "Unsupported System Architecture"
        exit 1
    }

    return "https://github.com/actions/runner/releases/download/v$VERSION/actions-runner-win-$os_type-$VERSION.zip", "actions-runner-win-$os_type-$VERSION.zip"
}

function Get-Runner {
    # Delete old directory if present
    if (Test-Path actions-runner) {
        Remove-Item actions-runner -Recurse
    }

    $tmp = Get-URL

    $URL = $tmp[0]

    $OUTPUTFILE = $tmp[1]

    # Create a folder under the drive root
    
    New-Item actions-runner -ItemType Directory | Out-Null

    # Download the latest runner package
    Start-BitsTransfer -Source $URL -Destination "actions-runner\$OUTPUTFILE"

    # Extract the installer
    Add-Type -AssemblyName System.IO.Compression.FileSystem ;
    [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD\actions-runner\$OUTPUTFILE", "$PWD\actions-runner")
}

function Install-Runner() {
    $GITHUB_USERNAME = Read-Host "Enter GitHub Username"
    $GITHUB_REPO = Read-Host "Enter GitHub Repo Name"
    echo "Runner Token found here: https://github.com/${GITHUB_USERNAME}/${GITHUB_REPO}/settings/actions/runners/new"
    $GITHUB_RUNNER_TOKEN = Read-Host "Enter Runner Token"

    Set-Location actions-runner

    ./config.cmd --url https://github.com/${GITHUB_USERNAME}/${GITHUB_REPO} --token $GITHUB_RUNNER_TOKEN

    Start-Service "actions.runner.*"
}

Get-Runner

Install-Runner
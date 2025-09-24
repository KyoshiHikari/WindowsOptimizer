#Requires -Version 5.1
# Security Check Script - Checks for sensitive data before GitHub push
# Author: Windows Optimizer Team
# Version: 1.0.0

param(
    [switch]$Detailed,
    [switch]$Fix,
    [switch]$Help
)

$Colors = @{
    Success = "Green"
    Warning = "Yellow"
    Error = "Red"
    Info = "Cyan"
    Header = "Magenta"
}

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Show-Help {
    Write-ColorOutput "Security Check Script" $Colors.Header
    Write-ColorOutput "====================" $Colors.Header
    Write-ColorOutput ""
    Write-ColorOutput "Usage:" $Colors.Info
    Write-ColorOutput "  .\SecurityCheck.ps1 [Parameters]" $Colors.Info
    Write-ColorOutput ""
    Write-ColorOutput "Parameters:" $Colors.Info
    Write-ColorOutput "  -Detailed    Detailed output" $Colors.Info
    Write-ColorOutput "  -Fix         Automatic fixes" $Colors.Info
    Write-ColorOutput "  -Help        Show this help" $Colors.Info
}

function Test-SensitivePatterns {
    Write-ColorOutput "Checking for sensitive data..." $Colors.Info
    
    $patterns = @{
        "Passwords" = @("password\s*=\s*['`"][^'`"]+['`"]", "passwd\s*=\s*['`"][^'`"]+['`"]", "pwd\s*=\s*['`"][^'`"]+['`"]")
        "API Keys" = @("api[_-]?key\s*=\s*['`"][^'`"]+['`"]", "apikey\s*=\s*['`"][^'`"]+['`"]", "access[_-]?key\s*=\s*['`"][^'`"]+['`"]")
        "Tokens" = @("token\s*=\s*['`"][^'`"]+['`"]", "bearer\s*=\s*['`"][^'`"]+['`"]", "auth[_-]?token\s*=\s*['`"][^'`"]+['`"]")
        "Credentials" = @("credential\s*=\s*['`"][^'`"]+['`"]", "username\s*=\s*['`"][^'`"]+['`"]", "user\s*=\s*['`"][^'`"]+['`"]")
        "Connection Strings" = @("connectionstring\s*=\s*['`"][^'`"]+['`"]", "connection\s*=\s*['`"][^'`"]+['`"]", "server\s*=\s*['`"][^'`"]+['`"]")
        "Sensitive Files" = @("\.env$", "config\.json$", "secrets\.json$", "credentials\.json$", "\.key$", "\.pem$", "\.p12$")
    }
    
    $issues = @()
    $totalIssues = 0
    
    foreach ($category in $patterns.Keys) {
        Write-ColorOutput "  Checking $category..." $Colors.Info
        
        foreach ($pattern in $patterns[$category]) {
            $files = Get-ChildItem -Recurse -File | Where-Object { 
                $_.Extension -match '\.(ps1|psm1|json|xml|txt|config|env)$' -and
                $_.Name -notmatch '\.gitignore$' -and
                $_.Name -notmatch 'SecurityCheck\.ps1$' -and
                $_.Name -notmatch 'PushToGitHub\.ps1$'
            }
            
            foreach ($file in $files) {
                $matches = Select-String -Path $file.FullName -Pattern $pattern -CaseSensitive:$false
                if ($matches) {
                    foreach ($match in $matches) {
                        $issue = @{
                            Category = $category
                            File = $match.Filename
                            Line = $match.LineNumber
                            Content = $match.Line.Trim()
                            Pattern = $pattern
                        }
                        $issues += $issue
                        $totalIssues++
                    }
                }
            }
        }
    }
    
    return $issues, $totalIssues
}

function Show-Issues {
    param($Issues, [bool]$Detailed)
    
    if ($Issues.Count -eq 0) {
        Write-ColorOutput "No sensitive data found!" $Colors.Success
        return
    }
    
    Write-ColorOutput ""
    Write-ColorOutput "FOUND PROBLEMS:" $Colors.Error
    Write-ColorOutput "===============" $Colors.Error
    
    $groupedIssues = $Issues | Group-Object Category
    
    foreach ($group in $groupedIssues) {
        Write-ColorOutput ""
        Write-ColorOutput "$($group.Name):" $Colors.Warning
        foreach ($issue in $group.Group) {
            Write-ColorOutput "  File: $($issue.File):$($issue.Line)" $Colors.Error
            if ($Detailed) {
                Write-ColorOutput "     Content: $($issue.Content)" $Colors.Error
            }
        }
    }
}

function Remove-SensitiveFiles {
    param($Issues)
    
    $sensitiveFiles = $Issues | Where-Object { $_.Category -eq "Sensitive Files" } | 
                      Select-Object -ExpandProperty File -Unique
    
    foreach ($file in $sensitiveFiles) {
        if (Test-Path $file) {
            Write-ColorOutput "Deleting sensitive file: $file" $Colors.Warning
            Remove-Item $file -Force
        }
    }
}

function New-SecureGitIgnore {
    $gitignoreContent = @'
# PowerShell
*.ps1.bak
*.psm1.bak
*.log
*.tmp

# Logs
logs/
*.log

# Temporary files
temp/
tmp/
*.tmp

# Sensitive data - NEVER COMMIT!
*.env
*.config
secrets.json
credentials.json
*.key
*.pem
*.p12
*.pfx
*.crt
*.cer

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
desktop.ini

# Backup files
*.bak
*.backup
*~

# User-specific
user.config

# Windows specific
*.lnk
*.url

# PowerShell specific
*.ps1xml
*.psd1.bak
*.psm1.bak

# Test files
test-*.ps1
*test*.ps1

# Database files
*.db
*.sqlite
*.mdb

# Certificate files
*.crt
*.cer
*.p7b
*.p7c
'@

    if (-not (Test-Path ".gitignore")) {
        Write-ColorOutput "Creating secure .gitignore..." $Colors.Info
        $gitignoreContent | Out-File -FilePath ".gitignore" -Encoding UTF8
    } else {
        Write-ColorOutput "Updating .gitignore..." $Colors.Info
        $gitignoreContent | Out-File -FilePath ".gitignore" -Encoding UTF8 -Append
    }
}

# Main function
Write-ColorOutput "Security Check started" $Colors.Header
Write-ColorOutput "=====================" $Colors.Header

if ($Help) {
    Show-Help
    exit
}

$issues, $totalIssues = Test-SensitivePatterns

Show-Issues -Issues $issues -Detailed $Detailed

if ($totalIssues -gt 0) {
    Write-ColorOutput ""
    Write-ColorOutput "SUMMARY:" $Colors.Header
    Write-ColorOutput "Found issues: $totalIssues" $Colors.Error
    
    if ($Fix) {
        Write-ColorOutput ""
        Write-ColorOutput "AUTOMATIC FIXES:" $Colors.Info
        Remove-SensitiveFiles -Issues $issues
        New-SecureGitIgnore
        Write-ColorOutput "Fixes applied successfully" $Colors.Success
    } else {
        Write-ColorOutput ""
        Write-ColorOutput "RECOMMENDATIONS:" $Colors.Info
        Write-ColorOutput "1. Use environment variables for sensitive data" $Colors.Info
        Write-ColorOutput "2. Add sensitive files to .gitignore" $Colors.Info
        Write-ColorOutput "3. Use -Fix parameter for automatic fixes" $Colors.Info
    }
} else {
    Write-ColorOutput ""
    Write-ColorOutput "All security checks passed!" $Colors.Success
}
param(
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

function Read-TextFile {
    param(
        [string]$Path
    )

    return [System.IO.File]::ReadAllText(
        $Path,
        [System.Text.UTF8Encoding]::new($false, $false)
    )
}

function Get-MarkdownLinks {
    param(
        [string]$Content
    )

    $pattern = '\[[^\]]+\]\(([^)]+)\)'
    return [regex]::Matches($Content, $pattern)
}

$rootPath = (Resolve-Path -LiteralPath $Root).Path
$markdownFiles = Get-ChildItem -LiteralPath $rootPath -Recurse -File -Filter *.md
$brokenLinks = @()

foreach ($file in $markdownFiles) {
    $content = Read-TextFile -Path $file.FullName
    $matches = Get-MarkdownLinks -Content $content

    foreach ($match in $matches) {
        $target = $match.Groups[1].Value.Trim()
        if ([string]::IsNullOrWhiteSpace($target)) {
            continue
        }

        if ($target -match '^(https?:|mailto:|#)') {
            continue
        }

        $pathPart = $target.Split('#')[0].Split('?')[0]
        if ([string]::IsNullOrWhiteSpace($pathPart)) {
            continue
        }

        $candidatePath = Join-Path $file.DirectoryName $pathPart
        if (-not (Test-Path -LiteralPath $candidatePath)) {
            $brokenLinks += [PSCustomObject]@{
                File   = $file.FullName.Substring($rootPath.Length + 1)
                Target = $target
            }
        }
    }
}

if ($brokenLinks.Count -eq 0) {
    Write-Host "No broken local markdown links found."
    exit 0
}

Write-Host "Broken local markdown links:"
$brokenLinks |
    Sort-Object File, Target |
    Format-Table -AutoSize |
    Out-String |
    Write-Host

Write-Host ("Total broken links: " + $brokenLinks.Count)
exit 1

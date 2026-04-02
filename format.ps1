param($InputPath)

if (-not (Test-Path $InputPath)) {
    Write-Host "Error: File not found" -ForegroundColor Red
    return
}

$file = Get-Item $InputPath
$outputPath = Join-Path $file.DirectoryName ("formatted_" + $file.Name)

# 読み込み
try {
    $content = Get-Content $InputPath -Encoding UTF8 -ErrorAction Stop
} catch {
    $content = Get-Content $InputPath -Encoding Default
}

$outputLines = @()
$lastSpeaker = 0 # 0: None/Aku, 1: Tamura

foreach ($line in $content) {
    if ([string]::IsNullOrWhiteSpace($line)) {
        $outputLines += ""
        continue
    }

    # 行頭が全角スペースかチェック
    if ($line.StartsWith("　")) {
        $outputLines += "　　" + $line
    }
    else {
        # 名前を交互に付与 (1なら田村、0なら灰汁)
        if ($lastSpeaker -eq 0) {
            $name = "田村"
            $lastSpeaker = 1
        } else {
            $name = "灰汁"
            $lastSpeaker = 0
        }
        $outputLines += ($name + "：" + $line)
    }
}

# UTF8で保存
$outputLines | Out-File -FilePath $outputPath -Encoding utf8
Write-Host "Success! Created: $outputPath" -ForegroundColor Green
﻿#Set-ExecutionPolicy RemoteSigned

Set-Location $PSScriptRoot
$ErrorActionPreference = "Inquire"
$youtubedl_version="2021.01.16"

if (!(Test-Path -Path '.\YoutubeAudioAutoDownloader-resources')) {
    Write-output "  Making Directory..."
    New-Item -Force -Type Directory -Path YoutubeAudioAutoDownloader-resources
} elseif (Test-Path -Path '.\YoutubeAudioAutoDownloader-resources\ffmpeg') {
    Remove-Item -Path '.\YoutubeAudioAutoDownloader-resources\ffmpeg' -Recurse
}


if (Test-Path -Path '.\YoutubeAudioAutoDownloader-resources\ydlver.txt') {
    $youtubedl_version = Get-Content ".\YoutubeAudioAutoDownloader-resources\ydlver.txt" -Encoding UTF8 -Raw
    Remove-Item -Path '.\YoutubeAudioAutoDownloader-resources\ydlver.txt'
}

Write-output "  youtube-dl version : $youtubedl_version"

Set-content  -NoNewline -Path '.\YoutubeAudioAutoDownloader-resources\ydlver.txt' -Value "$youtubedl_version" -Encoding UTF8

Write-output "  Downloading ffmpeg..."

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri 'https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip' -OutFile '.\YoutubeAudioAutoDownloader-resources\ffmpeg.zip'

Write-output "  Expanding Archive..."
Expand-Archive -LiteralPath '.\YoutubeAudioAutoDownloader-resources\ffmpeg.zip' -DestinationPath '.\YoutubeAudioAutoDownloader-resources'

Write-Output "  Renaming Archive..."
$dirs = Get-ChildItem '.\YoutubeAudioAutoDownloader-resources' -filter "ffmpeg*" -Directory

foreach($d in $dirs) {
    Rename-Item "$PSScriptRoot\YoutubeAudioAutoDownloader-resources\$d" -NewName "ffmpeg" -Force
}
Remove-Item -Path ".\YoutubeAudioAutoDownloader-resources\ffmpeg.zip"

Write-output "  Downloading youtube-dl..."
Invoke-WebRequest -Uri "https://github.com/ytdl-org/youtube-dl/releases/download/$youtubedl_version/youtube-dl.exe" -OutFile  '.\YoutubeAudioAutoDownloader-resources\ffmpeg\bin\youtube-dl.exe'


Write-output "  Done!"
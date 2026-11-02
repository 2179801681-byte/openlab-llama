# Build llama.cpp from source with MSVC and capture the complete stdout.
# Run from an ordinary PowerShell window; vcvars64.bat is loaded here.

$ErrorActionPreference = 'Stop'

$repo    = 'D:\openlab\openlab-llama'
$src     = Join-Path $repo 'src\llama.cpp'
$build   = Join-Path $repo 'build'
$log     = Join-Path $repo 'logs\build_log.txt'
$vcvars  = 'C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvars64.bat'

if (-not (Test-Path -LiteralPath $src)) {
    throw "Source not found: $src"
}

New-Item -ItemType Directory -Force -Path $build, (Split-Path $log) | Out-Null

$bat = Join-Path $env:TEMP 'openlab-build-llama.bat'
@"
@echo off
call "$vcvars"
if errorlevel 1 exit /b 1
cd /d "$src"
echo ===== CONFIGURE START =====
cmake -S . -B "$build" -G Ninja -DCMAKE_BUILD_TYPE=Release -DLLAMA_CURL=OFF
if errorlevel 1 exit /b 1
echo ===== CONFIGURE END =====
echo ===== BUILD START =====
cmake --build "$build" --config Release
if errorlevel 1 exit /b 1
echo ===== BUILD END =====
"@ | Set-Content -LiteralPath $bat -Encoding ASCII

cmd /c "`"$bat`" > `"$log`" 2>&1"
$code = $LASTEXITCODE

Write-Host "exit code: $code"
Write-Host "log: $log"
if ($code -ne 0) {
    Get-Content -LiteralPath $log -Tail 40
    exit $code
}

Get-ChildItem -Path (Join-Path $build 'bin') -Filter *.exe | Select-Object Name, Length

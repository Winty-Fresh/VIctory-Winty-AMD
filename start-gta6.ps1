Set-Location $PSScriptRoot
$gameExe = (Get-ChildItem "D:\GTA6.Xbox.v1.0.2.1-CYBERLEEK" -Recurse -Filter *.exe | Sort-Object Length -Descending | Select-Object -First 1).FullName

$env:VICTORY_LOG = "error"
$env:DISABLE_VK_LAYER_VALVE_steam_overlay_1 = "1"
$env:DISABLE_VULKAN_OBS_CAPTURE = "1"
Remove-Item Env:VICTORY_RAYS -ErrorAction SilentlyContinue
Remove-Item Env:VICTORY_D3D12_DEBUG -ErrorAction SilentlyContinue
Remove-Item Env:VICTORY_D3D12_WARP -ErrorAction SilentlyContinue

.\target\fast\victory.exe run --execute "$gameExe" 2>&1 | Tee-Object -FilePath .\launch.log

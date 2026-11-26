cd "I:\gta-vi-github-data-mine\git-builds\VIctory-Winty-AMD"

@'
@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0"

echo ========================================================
echo  Updating VIctory-Winty-AMD (5700X3D + RX 9070 XT Build)
echo ========================================================

:: 1. Ensure upstream remote points to Belobug's fork
git remote get-url upstream >nul 2>&1
if errorlevel 1 (
    echo [1/6] Adding upstream remote...
    git remote add upstream https://github.com/Belobug/VIctory-Belobug-AMD.git
)

:: 2. Pull any edits made directly on your GitHub fork (e.g. README edits)
echo.
echo [2/6] Pulling latest commits from your fork (origin/znver3-9070xt-opt)...
git pull origin znver3-9070xt-opt
if errorlevel 1 (
    echo [ERROR] Failed to pull from origin. Check for uncommitted local changes.
    pause
    exit /b 1
)

:: 3. Fetch and merge latest AMD fixes from Belobug's upstream repo
echo.
echo [3/6] Fetching and merging upstream fixes from Belobug/VIctory-Belobug-AMD...
git fetch upstream
git show-ref --verify --quiet refs/remotes/upstream/rx9070xt
if %errorlevel%==0 (
    git merge upstream/rx9070xt --no-edit
) else (
    git merge upstream/main --no-edit
)
if errorlevel 1 (
    echo.
    echo [CONFLICT] Merge conflict detected! Resolve the conflicted files,
    echo then run: git commit ^&^& git push origin znver3-9070xt-opt
    pause
    exit /b 1
)

:: 4. Push the synced branch back up to your GitHub fork
echo.
echo [4/6] Pushing synced branch to your GitHub fork...
git push origin znver3-9070xt-opt

:: 5. Recompile your hardware-tuned znver3 + fat-LTO binary
echo.
echo [5/6] Compiling target\fast\victory.exe (znver3 + fat LTO)...
cargo build --profile fast -p victory
if errorlevel 1 (
    echo [ERROR] Cargo build failed! Check compiler errors above.
    pause
    exit /b 1
)

:: 6. Re-translate shaders and re-warm AMD pipeline cache for the new build
echo.
echo [6/6] Updating shader translation and AMD driver pipeline cache...
.\target\fast\victory.exe shaders "D:\GTA6.Xbox.v1.0.2.1-CYBERLEEK"
.\target\fast\victory.exe warm

echo.
echo ========================================================
echo  Update complete! Run start-gta6.ps1 to launch.
echo ========================================================
pause
'@ | Set-Content -Path .\update-victory.bat -Encoding ASCII

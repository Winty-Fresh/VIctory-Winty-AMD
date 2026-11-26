cd "I:\gta-vi-github-data-mine\git-builds\VIctory-Winty-AMD"

@'
@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0"

echo ========================================================
echo  Publish Local Edits to VIctory-Winty-AMD (GitHub)
echo ========================================================

:: 1. Verify current branch is znver3-9070xt-opt
for /f "delims=" %%b in ('git branch --show-current') do set CURRENT_BRANCH=%%b
if not "%CURRENT_BRANCH%"=="znver3-9070xt-opt" (
    echo [WARNING] You are on branch "%CURRENT_BRANCH%" instead of "znver3-9070xt-opt".
    set /p SWITCH="Switch to znver3-9070xt-opt before publishing? (y/n): "
    if /i "!SWITCH!"=="y" (
        git checkout znver3-9070xt-opt
    ) else (
        echo Aborting publish.
        pause
        exit /b 1
    )
)

:: 2. Show modified and untracked files
echo.
echo [1/4] Checking changed files...
git status -s
echo.

git status --porcelain | findstr /r "." >nul
if errorlevel 1 (
    echo No local changes found to publish.
    pause
    exit /b 0
)

:: 3. Ask for confirmation and commit message
set /p CONFIRM="Stage and publish all listed changes above? (y/n): "
if /i not "%CONFIRM%"=="y" (
    echo Publish cancelled.
    pause
    exit /b 0
)

echo.
set /p COMMIT_MSG="Enter commit message (or press Enter for default): "
if "%COMMIT_MSG%"=="" set COMMIT_MSG=Update fork configuration and scripts

:: 4. Stage tracked modifications and safe new scripts/docs (excludes target/ and logs)
echo.
echo [2/4] Staging changes...
git add -u
if exist start-gta6.ps1 git add start-gta6.ps1
if exist update-victory.bat git add update-victory.bat
if exist publish-updates.bat git add publish-updates.bat
if exist .cargo\config.toml git add .cargo\config.toml

:: Keep local deletion of victory.example.toml out of commits if present
git reset -- victory.example.toml >nul 2>&1

:: 5. Commit and push to your GitHub fork
echo.
echo [3/4] Committing changes...
git commit -m "%COMMIT_MSG%"
if errorlevel 1 (
    echo [ERROR] Nothing staged to commit or commit failed.
    pause
    exit /b 1
)

echo.
echo [4/4] Pushing to origin/znver3-9070xt-opt...
git push origin znver3-9070xt-opt
if errorlevel 1 (
    echo.
    echo [ERROR] Push failed. If you made web edits on GitHub, run update-victory.bat first to pull them.
    pause
    exit /b 1
)

echo.
echo ========================================================
echo  Published successfully to GitHub!
echo ========================================================
pause
'@ | Set-Content -Path .\publish-updates.bat -Encoding ASCII
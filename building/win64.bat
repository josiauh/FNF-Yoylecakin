@echo off
set old=%CD%
cd ..
set goopie="false"
for %%A in (%*) do (
    if "%%A"=="/F" (
        set goopie="true"
        echo Skipping export stuff (fast mode)
    )
)
if exist "%CD%/export" (
    echo found it!
) else (
    cd %old%
    if exist "%CD%/export" (
        echo found in old directory
    )
)
if exist "%CD%/Project.xml" (
    echo this is a valid project!
) else (
    echo not a valid project. CD to the right directory!
)
if exist "%CD%/export/windows" (
    if %goopie%=="true" (
        REM --> we skip to the build process because it's faster
        goto build
    )
    goto clean
) else (
    goto build
)
echo goto didn't work
exit /B
:clean
echo cleaning out exports folder (stuff can be left behind)
rmdir /S /Q %CD%\export\windows
:build
echo building the game
if exist "%CD%/export/windows" (
    echo this will take a few seconds to minutes, but not too much
) else (
    echo this will take a few minutes, since there's no export folder to build on
)
haxelib run lime build windows > %CD%\build.log
echo done! the output can be found in %CD%\build.log
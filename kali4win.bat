@echo off
cls
set username=%USERNAME%
set hostname=%COMPUTERNAME%

:loop
set /p command=%username%@%hostname%:~$ 

:: Check if the command is "pwd"
if /i "%command%"=="pwd" (
    echo %cd%
) else if /i "%command%"=="ls" (
    dir
) else if /i "%command%"=="clear" (
    cls
    goto loop
) else if /i "%command:~0,3%"=="cd " (
    set "dirPath=%command:~3%"
    cd /d "%dirPath%" 2>nul
    if errorlevel 1 (
        echo No such directory.
    )
) else if /i "%command:~0,6%"=="mkdir " (
    set "newDir=%command:~6%"
    mkdir "%newDir%" 2>nul
    if errorlevel 1 (
        echo Failed to create directory.
    ) else (
        echo Directory created: %newDir%
    )
) else if /i "%command:~0,3%"=="rm " (
    set "target=%command:~3%"
    if exist "%target%" (
        if exist "%target%\*" (
            rmdir /s /q "%target%" 2>nul
            if errorlevel 1 (
                echo Failed to remove directory.
            ) else (
                echo Removed directory: %target%
            )
        ) else (
            del /q "%target%" 2>nul
            if errorlevel 1 (
                echo Failed to remove file.
            ) else (
                echo Removed file: %target%
            )
        )
    ) else (
        echo No such file or directory.
    )
) else if /i "%command:~0,4%"=="cat " (
    set "filePath=%command:~4%"
    if exist "%filePath%" (
        type "%filePath%"
    ) else (
        echo File not found: "%filePath%"
    )
) else if /i "%command:~0,8%"=="download " (
    set "url=%command:~8%"
    echo Downloading from %url%...
    curl -O "%url%"
    if errorlevel 1 (
        echo Download failed.
    ) else (
        echo Download complete.
    )
) else if /i "%command:~0,5%"=="kill " (
    set "pid=%command:~5%"
    taskkill /PID %pid% /F 2>nul
    if errorlevel 1 (
        echo Failed to kill process with PID %pid%.
    ) else (
        echo Killed process with PID: %pid%.
    )
) else if /i "%command%"=="exit" (
    echo Exiting...
    exit /B
) else (
    echo command not found.
)

goto loop

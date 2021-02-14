@echo off

goto check_Permissions

:check_Permissions

    net session >nul 2>&1
    if %errorLevel% == 0 (
        goto setup
    ) else (
		echo.
        echo Please run this script again with admin priviliges.
		echo.
	    pause
		exit

	)

:setup
setlocal enableDelayedExpansion
color 70


IF NOT EXIST %appdata%\5kblHotspotFix (
	mkdir %appdata%\5kblHotspotFix
	echo.
)

cd %appdata%\5kblHotspotFix

IF not EXIST "hotspotstart.ps1" (
    (
        ECHO $connectionProfile = [Windows.Networking.Connectivity.NetworkInformation,Windows.Networking.Connectivity,ContentType=WindowsRuntime]::GetInternetConnectionProfile(^)
        ECHO.
        ECHO $tetheringManager = [Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager,Windows.Networking.NetworkOperators,ContentType=WindowsRuntime]::CreateFromConnectionProfile($connectionProfile^)
        ECHO.
        ECHO $tetheringManager.StartTetheringAsync(^)
    )>hotspotstart.ps1

	echo.
	echo The 
)


IF NOT EXIST ".\interface.txt" (
	echo.
	echo                                      ---WIRELESS INTERFACE SETUP---
	echo.

	netsh interface show interface
	set /P "interface=Please copy-paste your wifi interface's name from the last column: "
	echo.
	echo !interface!>.\interface.txt
	pause
	cls
)

:menu

set /p "interfacename="<"interface.txt"
echo.
echo                                      ---WINDOWS HOTSPOT FIX/SETUP---
echo.

echo Created by 5kbl(Github)/tostiwee(Reddit). Go to https://skbl.ml/VRScript for more info.

echo.
echo Current Wireless Interface: %interfacename%
echo.
echo MENU:
echo [1] Turn on hotspot with fix - [2] Restore AutoConfig - [3] Change Wireless Interface - [4] Exit - [5] Uninstall
echo.


set /p Input=Choose(1/2/3/4/5):

If /I "%Input%"=="1" goto 1
If /I "%Input%"=="2" goto 2
If /I "%Input%"=="3" goto 3
If /I "%Input%"=="4" goto 4
If /I "%Input%"=="5" goto 5
goto other

:1
netsh wlan set autoconfig enabled=yes interface="%interfacename%"
timeout 2

powershell .\hotspotstart.ps1
timeout 2

netsh wlan set autoconfig enabled=no interface="%interfacename%"
pause
cls
goto menu

:2
netsh wlan set autoconfig enabled=yes interface="%interfacename%"
pause
cls
goto menu

:3
cls
echo.
echo                                      ---WIRELESS INTERFACE SETUP---
echo.
echo Current interface: %interfacename%
echo.
netsh interface show interface
set /P "interface=Please copy-paste your wifi interface's name from the last column:"
echo.
echo !interface!>.\interface.txt
pause
cls
goto menu

:4
exit

:5
set /p uninstallchoice=Are you sure?(y/n):

If /I "%uninstallchoice%"=="y" goto y
goto n

:y
cls
cd %appdata%
rmdir /s /q "%appdata%\5kblHotspotFix"
echo Thanks for using 5kbl's Windows Hotspot Fix. Delete this script, and that's it. If you want to reinstall, simply run the script again.
pause
exit

:n
cls
goto menu

:other
echo.
echo Sorry, that's not an option!
echo.
pause
cls
goto menu
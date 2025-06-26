@echo off
:: UTF Encoding
@chcp 65001 > nul
:: Título Ventana
title GalletasSMP Server

:: Mensaje de Bienvenida
echo Hola Admin, estamos preparando todo para ti.
pause

::Variables a Configurar
call env.bat

:: Se Imprimen por Pantalla
echo ....................................
echo Comenzando GalletasSMP
echo Minecraft %MinecraftVersion% - PurpurMC
echo Memoria Ram [Min/Max]: %MinRam%/%MaxRam%
echo Port: %NetPort%
echo Vanila GUI: %VanilaGUI%
echo Auto Restart: %AutoRestart%
echo ....................................

:askcorrecto
set /P c=¿Está todo correcto [S/N]? 
if /I "%c%" EQU "S" goto :todocorrecto
if /I "%c%" EQU "N" goto :solicitudcambio
goto :askcorrecto

:solicitudcambio

echo Cambie los valores de las variables abriendo "env.bat" con el Bloc de Notas
pause
exit

:: TODAS LAS VARIABLES CORRECTAS
:todocorrecto

:askdownload
set /P c=¿Desea actualizar el jar del servidor [S/N]? 
if /I "%c%" EQU "S" goto :descargarjar
if /I "%c%" EQU "N" goto :iniciarservidor
goto :askdownload

:descargarjar

echo ....................................
echo Descargando la última versión de PurpurMC para Minecraft %MinecraftVersion%

curl https://api.purpurmc.org/v2/purpur/%MinecraftVersion%/latest/download --output server.jar

echo ....................................

:iniciarservidor

echo ....................................
echo Iniciando servidor, sea paciente...

:start

:: Vanila GUI
if %VanilaGUI%==true set %GUI%=
if %VanilaGUI%==false set GUI=nogui

:: Ram Parameters
set Ram=-Xmx%MaxRam% -Xms%MinRam%

:: Parámetros de Java creados con esta herramienta
:: https://docs.papermc.io/misc/tools/start-script-gen
java %Ram% -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1HeapRegionSize=8M -XX:G1HeapWastePercent=5 -XX:G1MaxNewSizePercent=40 -XX:G1MixedGCCountTarget=4 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1NewSizePercent=30 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:G1ReservePercent=20 -XX:InitiatingHeapOccupancyPercent=15 -XX:MaxGCPauseMillis=200 -XX:MaxTenuringThreshold=1 -XX:SurvivorRatio=32 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar server.jar %GUI% 

if %AutoRestart%==true goto :autorestart
if %AutoRestart%==false goto :fin

:autorestart

echo .
echo .
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo .
echo Servidor reiniciandose, (debido a stop manual o crash)...
echo Pulsa CTRL + C para pararlo.
echo .
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
timeout 5

goto :start

:fin

echo .
echo .
echo GalletasSMP
echo Por Pablo Portas López
echo Presione cualquier tecla para salir...
pause > nul
exit
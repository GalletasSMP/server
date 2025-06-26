#!/bin/bash

# Título en terminal (no todos los terminales lo soportan)
echo -ne "\033]0;GalletasSMP Server\007"

# Mensaje de bienvenida
echo "Hola Admin, estamos preparando todo para ti."
read -p "Presiona ENTER para continuar..."

# Cargar variables desde env.sh
source ./env.sh

# Imprimir variables
echo "...................................."
echo "Comenzando GalletasSMP"
echo "Minecraft $MinecraftVersion - PurpurMC"
echo "Memoria Ram [Min/Max]: $MinRam/$MaxRam"
echo "Port: $NetPort"
echo "Vanila GUI: $VanilaGUI"
echo "Auto Restart: $AutoRestart"
echo "...................................."

# Confirmar configuración
while true; do
  read -p "¿Está todo correcto [S/N]? " c
  case "$c" in
    [Ss]*) break ;;
    [Nn]*)
      echo "Cambie los valores de las variables abriendo \"env.sh\" con un editor de texto"
      read -p "Presiona ENTER para salir..."
      exit 0
      ;;
    *) echo "Por favor, responda S o N." ;;
  esac
done

# Confirmar si se desea descargar el JAR
while true; do
  read -p "¿Desea actualizar el jar del servidor [S/N]? " c
  case "$c" in
    [Ss]*)
      echo "...................................."
      echo "Descargando la última versión de PurpurMC para Minecraft $MinecraftVersion"
      curl -L "https://api.purpurmc.org/v2/purpur/$MinecraftVersion/latest/download" -o server.jar
      echo "...................................."
      break
      ;;
    [Nn]*) break ;;
    *) echo "Por favor, responda S o N." ;;
  esac
done

# Iniciar servidor
echo "...................................."
echo "Iniciando servidor, sea paciente..."

while true; do
  # GUI flag
  if [ "$VanilaGUI" = "true" ]; then
    GUI=""
  else
    GUI="nogui"
  fi

  # RAM flags
  Ram="-Xmx$MaxRam -Xms$MinRam"

  # Ejecutar servidor con flags de Aikar
  # https://docs.papermc.io/misc/tools/start-script-gen
  java $Ram \
    -XX:+AlwaysPreTouch \
    -XX:+DisableExplicitGC \
    -XX:+ParallelRefProcEnabled \
    -XX:+PerfDisableSharedMem \
    -XX:+UnlockExperimentalVMOptions \
    -XX:+UseG1GC \
    -XX:G1HeapRegionSize=8M \
    -XX:G1HeapWastePercent=5 \
    -XX:G1MaxNewSizePercent=40 \
    -XX:G1MixedGCCountTarget=4 \
    -XX:G1MixedGCLiveThresholdPercent=90 \
    -XX:G1NewSizePercent=30 \
    -XX:G1RSetUpdatingPauseTimePercent=5 \
    -XX:G1ReservePercent=20 \
    -XX:InitiatingHeapOccupancyPercent=15 \
    -XX:MaxGCPauseMillis=200 \
    -XX:MaxTenuringThreshold=1 \
    -XX:SurvivorRatio=32 \
    -Dusing.aikars.flags=https://mcflags.emc.gs \
    -Daikars.new.flags=true \
    -jar server.jar $GUI

  if [ "$AutoRestart" = "true" ]; then
    echo
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo
    echo "Servidor reiniciandose, (debido a stop manual o crash)..."
    echo "Pulsa CTRL + C para pararlo."
    echo
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    sleep 5
  else
    break
  fi
done

# Fin del script
echo
echo "GalletasSMP"
echo "Por Pablo Portas López"
read -p "Presione ENTER para salir..."

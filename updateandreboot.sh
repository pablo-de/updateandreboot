#!/bin/bash

#Update & reboot semanal
#sudo crontab -e -> 30 2 * * 0 usr/bin/tareasemanal/updateandreboot.sh

BOT_TOKEN="<your bot token>"
CHAT_ID="<your chat ID>"

MESSAGE_OK="✅ Raspberry: Upgrade realizado con éxito."
MESSAGE_FAIL="⛔ Raspberry: Fallo en alguna actualización o reinicio."
LOG_FILE="$DIR/updates_logs.log"

set -e

patching() {
  sudo apt-get update &&
  sudo apt-get upgrade -y &&
  sudo apt-get dist-upgrade -y &&
  sudo pihole -up &&
  sudo apt-get autoremove -y &&
  sudo apt-get clean

  return $?
}

if patching; then
  curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d parse_mode=Markdown -d text="$MESSAGE_OK" >/dev/null
  echo "$(date '+%d/%m/%Y %H:%M:%S'): $HOSTNAME: Todas las actualizaciones y reinicio exitosos" >> "$LOG_FILE"
  sleep 5s
  sudo reboot
else
  curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d parse_mode=Markdown -d text="$MESSAGE_FAIL" >/dev/null
  echo "$(date '+%d/%m/%Y %H:%M:%S'): $HOSTNAME: Fallo en alguna actualización o reinicio" >> "$LOG_FILE"
fi

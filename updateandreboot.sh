#!/bin/bash

#Update & reboot semanal
#sudo crontab -e -> 30 2 * * 0 usr/bin/tareasemanal/updateandreboot.sh

BOT_TOKEN="<your bot token>"
CHAT_ID="<your chat ID>"

MESSAGE_OK="$HOSTNAME: Upgrade reboot realizado con exito."
MESSAGE_FAIL="$HOSTNAME: Fallo en alguna actualización o reinicio."

# Actualizar el sistema
if sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y && sudo pihole -up && sudo apt-get autoremove -y && sudo apt-get clean; then
  echo "$(date -d 'now' '+%d/%m/%Y %H:%M:%S'): $HOSTNAME: Todas las actualizaciones y reinicio exitosos" >>/usr/bin/tareasemanal/updates_logs.log

  curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d parse_mode=Markdown -d text="$MESSAGE_OK" >/dev/null

  sleep 5s

  sudo reboot
else
  echo "$(date -d 'now' '+%d/%m/%Y %H:%M:%S'): $HOSTNAME: Fallo en alguna actualización o reinicio" >>/usr/bin/tareasemanal/updates_logs.log
  sleep 5s
  curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d parse_mode=Markdown -d text="$MESSAGE_FAIL" >/dev/null
fi

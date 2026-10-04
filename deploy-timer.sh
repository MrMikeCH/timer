#!/bin/bash
# Lädt den Timer per SFTP zu one.com -> https://mrmike.ch/timer/
# Zugangsdaten aus ~/.netrc (chmod 600).
set -euo pipefail
HOST="ssh.cw9e0lu8r.service.one"
PORT="22"
USER="mrmike.ch"
LOCAL="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REMOTE="timer"

command -v lftp >/dev/null || { echo "lftp fehlt: brew install lftp"; exit 1; }
[ -f "$HOME/.netrc" ] || { echo "~/.netrc fehlt"; exit 1; }

lftp "sftp://$USER@$HOST:$PORT" <<EOT
set sftp:auto-confirm yes
set net:max-retries 2
set net:timeout 20
cd webroots/www
mkdir -f -p $REMOTE
put -O $REMOTE "$LOCAL/index.html" -o index.html
bye
EOT
echo "OK: https://mrmike.ch/$REMOTE/"

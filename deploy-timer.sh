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

# Hash aus dem Aufgaben-Login (lokal, nicht im Repo) in eine Kopie einsetzen
HASHFILE="$LOCAL/../../../tasks/.htpasswd"
[ -f "$HASHFILE" ] || { echo ".htpasswd fehlt: $HASHFILE"; exit 1; }
BUILD="$(mktemp -d)"; trap 'rm -rf "$BUILD"' EXIT
HASH="$(cut -d: -f2 "$HASHFILE" | head -1)"
python3 - "$LOCAL/index.html" "$BUILD/index.html" "$HASH" <<'PY'
import sys
s = open(sys.argv[1], encoding="utf-8").read().replace("__HASH__", sys.argv[3])
open(sys.argv[2], "w", encoding="utf-8").write(s)
PY
printf 'AddDefaultCharset UTF-8\n<IfModule mod_authz_core.c>\n  Require all granted\n</IfModule>\n<IfModule !mod_authz_core.c>\n  Satisfy any\n  Allow from all\n</IfModule>\n' > "$BUILD/.htaccess"

lftp "sftp://$USER@$HOST:$PORT" <<EOT
set sftp:auto-confirm yes
set net:max-retries 2
set net:timeout 20
cd webroots/www
mkdir -f -p $REMOTE
put -O $REMOTE "$BUILD/index.html" -o index.html
put -O $REMOTE "$BUILD/.htaccess" -o .htaccess
bye
EOT
echo "OK: https://mrmike.ch/$REMOTE/"

# Timer

Präsentations-Timer fürs Browserfenster. Ring mit Abschnitten, grosse Restzeit in der Mitte, Leertaste startet.
Live: https://mrmike.ch/timer/ (Login im Browser wie bei den Aufgaben, merkt sich das Gerät)

- Eine Datei: `index.html`, keine Abhängigkeiten.
- Ablauf (Abschnitte und Minuten) per `E` änderbar, wird im Browser gespeichert.
- Deploy: `./deploy-timer.sh` oder Doppelklick auf `Timer-deployen.command`.
- `index.html` enthält den Platzhalter `__HASH__`. `deploy-timer.sh` setzt beim Hochladen den Hash aus `tasks/.htpasswd` ein, im Repo steht kein Hash.

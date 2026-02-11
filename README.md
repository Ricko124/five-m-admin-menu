# five-m-admin-menu (LuxuAdmin)

Ein einfaches **Admin-Menü für FiveM** mit NUI-Oberfläche.

## Features
- Menü per `F10` oder `/luxuadmin` öffnen
- Spieler kicken
- Server Announcement senden
- Wetter und Uhrzeit synchronisieren
- Selbst heilen / wiederbeleben
- Zum Wegpunkt teleportieren

## Installation
1. Ordner als Resource einbinden (z. B. `resources/[admin]/five-m-admin-menu`).
2. In `server.cfg` starten:
   ```cfg
   ensure five-m-admin-menu
   ```
3. ACE-Rechte vergeben:
   ```cfg
   add_ace group.admin luxuadmin.menu allow
   add_principal identifier.license:DEINE_LICENSE group.admin
   ```

## Dateien
- `fxmanifest.lua`
- `config.lua`
- `client.lua`
- `server.lua`
- `html/` (NUI)

## Hinweise
- Berechtigungen laufen über ACE (`Config.RequiredAce`).
- Du kannst Wettertypen im NUI direkt anpassen.

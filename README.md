# Hunter Hunted - BeamNG.drive Multiplayer Mod

Ein spannender Multiplayer-Spielmodus für BeamNG.drive mit drei verschiedenen Rollen: Jäger, Gejagte und Neutrale Spieler.

## Spielprinzip

### Rollen
- **Jäger (Hunter)**: Versuchen die Gejagten zu fangen und sie daran zu hindern, Zielpunkte zu erreichen
- **Gejagte (Hunted)**: Müssen Zielpunkte erreichen und dort verweilen, während sie Punkten sammeln
- **Neutral**: Können jederzeit ihre Rolle wechseln

### Spielregeln
- **Punkte**: Alle Gejagten teilen sich ein gemeinsames Punktekonto (Start: 1000 Punkte)
- **Punkteverlust**: Wenn Gejagte langsamer als 2-3 km/h fahren und Jäger in 10m Nähe sind, verlieren sie Punkte
- **Zielsystem**: Gejagte erhalten zufällige Zielpunkte auf der Karte mit Navigation
- **Sieg Gejagte**: 3 Minuten am Zielpunkt verharren ohne dass Jäger in 5m Radius kommen
- **Sieg Jäger**: Verhindern dass Gejagte das Ziel erreichen oder alle Punkte aufbrauchen

## Installation

1. Lade die Mod-Dateien herunter
2. Kopiere den gesamten Ordner in dein BeamNG.drive Mods-Verzeichnis:
   ```
   Documents/BeamNG.drive/mods/
   ```
3. Starte BeamNG.drive neu
4. Aktiviere die Mod im Spiel unter "Mods"

## Verwendung

### Multiplayer-Session starten
1. Erstelle einen Multiplayer-Server
2. Andere Spieler können beitreten
3. Öffne das Hunter Hunted UI (standardmäßig aktiviert)

### Spielablauf
1. Alle Spieler wählen ihre Rollen über das UI
2. Klicke auf "Start Game" um das Spiel zu beginnen
3. Gejagte sehen Navigation zum aktuellen Zielpunkt
4. Jäger versuchen die Gejagten zu stoppen

### UI-Bedienung
- **Rollenwahl**: Radiobuttons im "Role Selection" Bereich
- **Spielkontrolle**: Start/Stop Buttons für Admins
- **Navigation**: Automatisch für Gejagte sichtbar
- **Spielerübersicht**: Zeigt alle Spieler und ihre Rollen

## Konfiguration

Die Spieleinstellungen können in der Datei `hunterHuntedConfig.lua` angepasst werden:

```lua
-- Beispiel-Konfiguration
startingPoints = 1000        -- Start-Punkte für Gejagte
speedThreshold = 2.0         -- km/h Grenze für Punkteverlust  
hunterCatchRadius = 10       -- Meter - Fang-Radius
targetCaptureRadius = 5      -- Meter - Ziel-Radius
targetCaptureTime = 180      -- Sekunden am Ziel für Sieg
```

## Map-Unterstützung

Die Mod funktioniert auf allen BeamNG.drive Maps. Für optimale Ergebnisse können für spezielle Maps vordefinierte Zielpunkte in der Konfiguration eingetragen werden.

## Bekannte Einschränkungen

- Benötigt BeamNG.drive 0.30.5.0 oder neuer
- Funktioniert nur im Multiplayer-Modus
- Navigation zeigt aktuell nur Koordinaten (keine Karten-Integration)

## Entwicklung

Die Mod ist in Lua geschrieben und nutzt BeamNG's Extension-System. Hauptdateien:
- `hunterHunted.lua` - Kern-Spiellogik
- `hunterHuntedUI.lua` - Benutzeroberfläche  
- `hunterHuntedConfig.lua` - Konfiguration und Einstellungen

## Lizenz

Open Source - Frei verwendbar und modifizierbar

## Autor

KaiB85

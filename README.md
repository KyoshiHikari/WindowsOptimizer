# 🔧 Windows 11 Optimizer

Ein umfassendes PowerShell-Tool zur Diagnose, Reparatur und Optimierung von Windows 11 Systemen.

## ✨ Features

### 🔍 Systemdiagnose
- **Umfassende Systemanalyse**: Hardware, Software, Performance und Sicherheit
- **Problem-Erkennung**: Automatische Identifikation von Systemproblemen
- **Performance-Monitoring**: CPU, RAM, Festplatten und Netzwerk
- **Sicherheitsprüfung**: Windows Defender, Firewall und Updates

### 🔧 Fehlerreparatur
- **Windows Update Reparatur**: Behebt Update-Probleme und Cache-Fehler
- **System-Dateien Reparatur**: SFC und DISM Reparatur
- **Registry-Reparatur**: Behebt Registry-Probleme und Konflikte
- **Netzwerk-Reparatur**: Repariert Netzwerk-Adapter und Verbindungen
- **Dienst-Reparatur**: Startet fehlerhafte Dienste neu
- **Festplatten-Reparatur**: CHKDSK und Defragmentierung
- **Windows Defender Reparatur**: Aktiviert und repariert Defender

### ⚡ Performance-Optimierung
- **Startup-Optimierung**: Deaktiviert unnötige Startup-Programme
- **Dienst-Optimierung**: Optimiert Windows-Dienste für bessere Performance
- **Registry-Optimierung**: Optimiert Registry-Einträge für bessere Performance
- **Speicher-Optimierung**: Optimiert Virtual Memory und RAM-Nutzung
- **Netzwerk-Optimierung**: Optimiert TCP/IP-Parameter und DNS
- **Festplatten-Optimierung**: Defragmentierung und SSD-Optimierung
- **Visual Effects**: Optimiert Windows-Animationen und Effekte
- **Power Settings**: Optimiert Energieeinstellungen

### 🛡️ Sicherheitsoptimierung
- **Windows Defender**: Aktiviert und optimiert Defender
- **Firewall**: Konfiguriert Windows Firewall für maximale Sicherheit
- **Benutzerkonten**: Optimiert Benutzerkonten und Berechtigungen
- **Registry-Sicherheit**: Härtet Registry-Einträge
- **Netzwerk-Sicherheit**: Deaktiviert unsichere Protokolle
- **Windows Update**: Optimiert Update-Einstellungen

### 🧹 Systembereinigung
- **Temp-Dateien**: Bereinigt temporäre Dateien und Caches
- **Browser-Cache**: Bereinigt Browser-Caches (Chrome, Firefox, Edge)
- **Windows Update Cache**: Bereinigt Update-Cache und Downloads
- **Registry-Bereinigung**: Entfernt ungültige Registry-Einträge
- **System-Dateien**: Bereinigt Windows-Dateien mit DISM
- **Unnötige Programme**: Deinstalliert unnötige Software
- **Festplatten-Defragmentierung**: Optimiert Festplatten-Performance

### 📊 Systemberichte
- **HTML-Berichte**: Detaillierte HTML-Systemberichte
- **Performance-Analyse**: Umfassende Performance-Metriken
- **Sicherheits-Status**: Detaillierte Sicherheitsanalyse
- **Empfehlungen**: Personalisierte Optimierungsempfehlungen

## 🚀 Installation

1. **Repository klonen oder herunterladen**
   ```powershell
   git clone https://github.com/your-repo/WindowsOptimizer.git
   cd WindowsOptimizer
   ```

2. **PowerShell-Execution-Policy setzen**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. **Als Administrator ausführen**
   ```powershell
   .\WindowsOptimizer.ps1
   ```

## 📖 Verwendung

### Interaktiver Modus
```powershell
.\WindowsOptimizer.ps1
```

### Automatische Reparatur
```powershell
.\WindowsOptimizer.ps1 -AutoFix
```

### Systemdiagnose
```powershell
.\WindowsOptimizer.ps1 -Diagnose
```

### Performance-Optimierung
```powershell
.\WindowsOptimizer.ps1 -Optimize
```

### Stiller Modus
```powershell
.\WindowsOptimizer.ps1 -Silent
```

## 🎯 Hauptmenü

Das Tool bietet ein benutzerfreundliches Hauptmenü mit folgenden Optionen:

1. **🔍 Systemdiagnose durchführen** - Umfassende Systemanalyse
2. **🔧 Fehler automatisch reparieren** - Automatische Problembehebung
3. **⚡ Performance optimieren** - Systemleistung verbessern
4. **🛡️ Sicherheitseinstellungen optimieren** - Sicherheit erhöhen
5. **🧹 System bereinigen** - Speicherplatz freigeben
6. **📊 Systembericht erstellen** - Detaillierte Berichte generieren
7. **⚙️ Erweiterte Optionen** - Zusätzliche Tools und Funktionen

## 🔧 Erweiterte Optionen

- **🔄 Windows Update reparieren** - Update-Probleme beheben
- **💾 Registry bereinigen** - Registry optimieren
- **🌐 Netzwerk-Adapter zurücksetzen** - Netzwerk-Probleme beheben
- **🔧 Windows-Features verwalten** - Features aktivieren/deaktivieren
- **📱 Treiber aktualisieren** - Treiber-Updates durchführen

## 📁 Projektstruktur

```
WindowsOptimizer/
├── WindowsOptimizer.ps1          # Hauptmodul
├── Modules/
│   ├── SystemDiagnostics.ps1    # Systemdiagnose
│   ├── ErrorRepair.ps1          # Fehlerreparatur
│   ├── PerformanceOptimizer.ps1 # Performance-Optimierung
│   ├── SecurityOptimizer.ps1    # Sicherheitsoptimierung
│   ├── SystemCleaner.ps1        # Systembereinigung
│   └── SystemReporter.ps1       # Systemberichte
└── README.md                     # Dokumentation
```

## ⚠️ Wichtige Hinweise

### Systemanforderungen
- **Windows 11** (alle Versionen)
- **PowerShell 5.1+**
- **Administrator-Rechte** erforderlich
- **Mindestens 4 GB RAM** empfohlen

### Sicherheit
- **Backup erstellen**: Vor der Verwendung ein System-Backup erstellen
- **Administrator-Rechte**: Das Tool benötigt Administrator-Rechte
- **Virenschutz**: Temporär deaktivieren falls nötig
- **Registry-Backup**: Automatische Registry-Backups werden erstellt

### Kompatibilität
- **Windows 11**: Vollständig kompatibel
- **Windows 10**: Teilweise kompatibel (nicht getestet)
- **PowerShell Core**: Nicht kompatibel (verwendet Windows-spezifische Module)

## 🐛 Fehlerbehebung

### Häufige Probleme

1. **"Execution Policy" Fehler**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. **"Administrator-Rechte" Fehler**
   - PowerShell als Administrator ausführen

3. **"Module nicht gefunden" Fehler**
   - Alle Module-Dateien im `Modules/` Ordner prüfen

4. **"Registry-Zugriff verweigert" Fehler**
   - Als Administrator ausführen
   - Virenschutz temporär deaktivieren

### Log-Dateien
- **Log-Pfad**: `%TEMP%\WindowsOptimizer.log`
- **HTML-Berichte**: `%TEMP%\WindowsOptimizer_SystemReport_*.html`

## 🤝 Beitragen

Wir freuen uns über Beiträge! Bitte:

1. Fork das Repository
2. Erstelle einen Feature-Branch
3. Committe deine Änderungen
4. Push zum Branch
5. Erstelle einen Pull Request

## 📄 Lizenz

Dieses Projekt steht unter der MIT-Lizenz. Siehe `LICENSE` für Details.

## 👥 Autoren

- **Windows Optimizer Team** - Hauptentwicklung
- **PowerShell Community** - Beiträge und Feedback

## 🙏 Danksagungen

- **Microsoft PowerShell Team** - Für das großartige PowerShell-Framework
- **Windows Community** - Für Feedback und Verbesserungsvorschläge
- **Open Source Community** - Für Inspiration und Best Practices

## 📞 Support

Bei Fragen oder Problemen:

1. **GitHub Issues** - Für Bug-Reports und Feature-Requests
2. **Dokumentation** - Ausführliche Anleitung in diesem README
3. **Community** - PowerShell und Windows Communities

## 🔄 Changelog

### Version 1.0.0
- ✅ Erstes Release
- ✅ Vollständige Systemdiagnose
- ✅ Automatische Fehlerreparatur
- ✅ Performance-Optimierung
- ✅ Sicherheitsoptimierung
- ✅ Systembereinigung
- ✅ HTML-Systemberichte
- ✅ Benutzerfreundliche Oberfläche

## 🎯 Roadmap

### Geplante Features
- **🔄 Automatische Updates** - Tool-Updates automatisch
- **📱 Mobile App** - Companion-App für Smartphones
- **☁️ Cloud-Backup** - System-Backups in die Cloud
- **🤖 KI-Optimierung** - Machine Learning für bessere Optimierungen
- **🌐 Web-Interface** - Browser-basierte Oberfläche
- **📊 Dashboard** - Echtzeit-System-Monitoring

---

**🔧 Windows Optimizer - Ihr zuverlässiger Begleiter für ein optimales Windows 11 System!**

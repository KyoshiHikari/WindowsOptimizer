# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- GUI version of the Windows Optimizer
- Modern WPF interface with navigation
- Real system report generation with HTML output
- Performance counter integration
- Robust error handling for performance metrics

### Changed
- System report path changed to `C:\SystemReport.html`
- Improved performance counter handling
- Extended recommendation logic with current values

### Fixed
- StaticResource errors in WPF GUI fixed
- Performance counter "N/A" problem solved
- UTF-8 encoding for correct umlauts

## [2.0.0] - 2024-09-24

### Added
- **Hauptmodul** (`WindowsOptimizer.ps1`)
  - Benutzerfreundliche Menüoberfläche
  - Kommandozeilen-Parameter für Automatisierung
  - Umfassendes Logging-System
  - Farbige Konsolenausgabe
  - Administrator-Rechte-Prüfung

- **Systemdiagnose-Modul** (`SystemDiagnostics.ps1`)
  - System-Grundinformationen (Windows Version, Hardware, etc.)
  - Performance-Analyse (CPU, RAM, Festplatten)
  - Sicherheitsprüfung (Windows Defender, Firewall, Updates)
  - Netzwerk-Diagnose (Adapter, Internet-Verbindung, DNS)
  - Speicher-Analyse (Festplatten, Temp-Dateien, große Dateien)
  - Dienst-Analyse (kritische Dienste, fehlerhafte Dienste)
  - Automatische Problem-Erkennung
  - Detaillierte Ergebnisanzeige

- **Fehlerreparatur-Modul** (`ErrorRepair.ps1`)
  - Windows Update Reparatur (Cache leeren, Dienste neu starten)
  - System-Dateien Reparatur (SFC, DISM)
  - Registry-Reparatur (Windows Update, Defender, Netzwerk, Dienste)
  - Netzwerk-Reparatur (Adapter zurücksetzen, DNS, Winsock)
  - Dienst-Reparatur (kritische Dienste, fehlerhafte Dienste)
  - Festplatten-Reparatur (CHKDSK, Defragmentierung)
  - Windows Defender Reparatur (Dienste, Registry, Definitionen)
  - Umfassende Ergebnisanzeige

- **Performance-Optimierung-Modul** (`PerformanceOptimizer.ps1`)
  - Startup-Programme optimieren (unnötige Programme deaktivieren)
  - Windows-Dienste optimieren (unnötige Dienste deaktivieren)
  - Registry optimieren (Boot-Zeit, Menü, Explorer, Netzwerk, Speicher)
  - Speicher optimieren (Virtual Memory, Superfetch, Memory Leaks)
  - Netzwerk optimieren (TCP/IP, DNS, Adapter, Windows Update)
  - Festplatten optimieren (Defragmentierung, SSD-Optimierung, Cache)
  - Visual Effects optimieren (Animationen, Transparenz, Windows 11)
  - Power Settings optimieren (High Performance, USB, Festplatten, CPU)
  - Performance-Empfehlungen

- **Sicherheitsoptimierung-Modul** (`SecurityOptimizer.ps1`)
  - Windows Defender optimieren (Aktivierung, Echtzeitschutz, Cloud-Schutz)
  - Firewall optimieren (Profile, Regeln, Logging)
  - Benutzerkonten optimieren (lokale Konten, Gast-Konto, Administrator)
  - Registry-Sicherheit optimieren (AutoRun, Remote Registry, Script Host)
  - Netzwerk-Sicherheit optimieren (SMB v1, NetBIOS, IPv6, ICMP)
  - Windows Update optimieren (automatische Updates, Dienste, Sicherheit)
  - Sicherheitsempfehlungen

- **Systembereinigung-Modul** (`SystemCleaner.ps1`)
  - Temp-Dateien bereinigen (Windows Temp, App Temp, Browser Temp)
  - Browser-Cache bereinigen (Chrome, Firefox, Edge, Internet Explorer)
  - Windows Update Cache bereinigen (Download, DataStore, catroot2)
  - Registry bereinigen (ungültige Einträge, Startup-Programme, Dateizuordnungen)
  - System-Dateien bereinigen (Windows-Dateien, DISM, alte Versionen, Logs)
  - Unnötige Programme deinstallieren (Edge, Teams, Adobe, Java, etc.)
  - Festplatten-Defragmentierung (HDD, SSD-Optimierung)
  - Bereinigung-Empfehlungen

- **Systembericht-Modul** (`SystemReporter.ps1`)
  - Umfassende System-Informationen sammeln
  - Performance-Daten sammeln (CPU, RAM, Festplatten, Prozesse)
  - Sicherheits-Status sammeln (Defender, Firewall, Updates, UAC)
  - Netzwerk-Status sammeln (Adapter, Internet, DNS, IP)
  - Speicher-Status sammeln (Festplatten, Temp-Dateien, große Dateien)
  - Dienst-Status sammeln (kritische Dienste, fehlerhafte Dienste)
  - Problem-Identifikation
  - System-Empfehlungen
  - HTML-Bericht-Erstellung
  - Detaillierte Ergebnisanzeige

- **Dokumentation**
  - Umfassendes README.md mit Installation, Verwendung und Features
  - MIT-Lizenz
  - Changelog für Versionsverwaltung
  - Detaillierte Projektstruktur
  - Fehlerbehebung und Support-Informationen

### Security
- **Administrator-Rechte** erforderlich für alle Operationen
- **Registry-Backups** vor kritischen Änderungen
- **Sichere Standardwerte** für alle Optimierungen
- **Keine schädlichen Operationen** ohne Benutzerbestätigung

### Deprecated
- Keine veralteten Features in dieser Version

### Removed
- Keine entfernten Features in dieser Version

### Fixed
- Keine behobenen Fehler in dieser Version

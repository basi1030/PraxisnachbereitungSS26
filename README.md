# PraxisnachbereitungSS26

# Arbeitsablauf:
Im ersten Schritt haben wir ein Git-Repository erstellt und in VS Code geclont.
Anschließend haben wir alle CSV-Dateien im Repository Ordner abgelegt und die Änderungen committed.
Im nächten Schritt importierten wir die CSV-Dateien Mitarbeiter, Ausleihen und Geräte als Arbeitsblätter in unsere erstellte Excelarbeitsmappe Praxisnachbereitung.
Wir überprüften dabei die Datentypen und änderten beim Feld Kaufpreis netto den Datentyp in Nummer und gaben als Dezimaltrennzeichen Punkt an.

Mit einem XVERWEIS verknüoften wir die drei separaten Tabellen. 
Dadurch erstellten wir eine Gesamttabelle.

Für die Bearbeitung von Aufgabe D bereinigten wir zunächst unsere Gesamttabelle und entfernten Duplikate. Basierend darauf erstellten wir eine PIVOT-Tabelle, um den Gesamtwert aller Geräte, die aktuell nicht im Einsatz sind zu ermitteln.
Aufbau der Auswertung: 
- Zeilen: Gerätenummer 
- Werte: Kaufpreis (netto)
- Filter: Rückgabe am

Für Aufgabe D 2 filterten wir die unbereinigte Gesamttabelle auf den Gerätetyp "laptop".
Es war nicht fachlich plausibel, dass einer Person zwei Laptops ausgeliehen wurden.

Aufgabe D 3: Wir erstellten eine PIVOT-Tabelle auf Basis der unbereinigten Gesamttabelle, um herauszufinden, wie oft ein Gerätetyp ausgeliehen wurde. Dies visualisierten wir anschließend in einem Säulendiagramm.

Aufgabe D 4: Auf Grundlage von Aufgabe D 3 fügten wir das Attribut Standort als Spalten der PIVOT hinzu. Abschließend änderten wir die Darstellung aus Diagramm D 3 in ein gestapeltes Säulendiagramm.

# Entdecket Probleme
- Duplikate --> haben wir entfernt
- Datentyp Nummer --> CSV nochmal korrekt importiert

# Erkenntnisse
- nützliches Tool, Importe allerdings sehr fehleranfällig
- nicht selbsterklärend --> Grundkenntnisse notwendig
# Instrucțiuni pentru utilizarea aplicației Running Tracker

## Descriere generală
Running Tracker este o aplicație Android pentru monitorizarea activităților de alergare, care oferă utilizatorilor posibilitatea de a urmări viteza, distanța parcursă, caloriile consumate, efortul depus și orientarea (azimut) în timpul alergării.

## Funcționalități principale
- Monitorizarea în timp real a alergării cu GPS
- Afișarea traseului pe hartă
- Calculul vitezei, distanței și caloriilor consumate
- Măsurarea efortului și a ritmului cardiac
- Afișarea orientării (azimut) cu busolă
- Salvarea sesiunilor de alergare
- Vizualizarea statisticilor și istoricului alergărilor

## Configurarea proiectului
1. Deschideți Android Studio
2. Selectați "Open an existing Android Studio project"
3. Navigați la directorul unde ați dezarhivat proiectul RunningTrackerJava
4. Așteptați finalizarea sincronizării Gradle

## Configurarea API-ului Google Maps
Pentru a utiliza funcționalitățile de hartă, trebuie să configurați o cheie API Google Maps:
1. Accesați [Google Cloud Console](https://console.cloud.google.com/)
2. Creați un proiect nou sau selectați unul existent
3. Activați API-ul Maps SDK for Android
4. Generați o cheie API
5. Înlocuiți "YOUR_API_KEY" din AndroidManifest.xml cu cheia dvs. API

## Rularea aplicației
1. Conectați un dispozitiv Android sau porniți un emulator
2. Apăsați butonul "Run" (săgeata verde) din Android Studio
3. Selectați dispozitivul țintă și așteptați instalarea

## Utilizarea aplicației
1. La prima rulare, aplicația va solicita permisiunile necesare pentru localizare
2. Navigați între secțiuni folosind meniul din partea de jos:
   - "Your Runs" - lista alergărilor salvate
   - "Statistics" - statistici generale și grafice
   - "Settings" - setări aplicație

### Înregistrarea unei alergări
1. În ecranul "Your Runs", apăsați butonul "+" din colțul dreapta jos
2. În ecranul de tracking, apăsați "Start" pentru a începe înregistrarea
3. În timpul alergării, puteți vedea:
   - Harta cu traseul
   - Cronometrul
   - Ritmul cardiac (dacă dispozitivul are senzor)
   - Orientarea (azimut)
4. Apăsați "Stop" pentru a întrerupe temporar înregistrarea
5. Apăsați "Finish Run" pentru a finaliza și salva alergarea
6. Pentru a anula o alergare, apăsați iconița X din bara de sus

### Vizualizarea statisticilor
1. Accesați secțiunea "Statistics" din meniul de jos
2. Veți vedea:
   - Timpul total de alergare
   - Distanța totală parcursă
   - Viteza medie
   - Caloriile totale consumate
   - Efortul mediu
   - Grafic cu evoluția vitezei medii

## Structura proiectului
- `data` - conține modelele de date, baza de date și repository
- `di` - modulele pentru injecția dependențelor
- `service` - serviciul de tracking în fundal
- `ui` - activități, fragmente și ViewModel-uri
- `util` - clase utilitare și constante

## Cerințe tehnice
- Android 7.0 (API 24) sau mai recent
- Permisiuni pentru localizare (ACCESS_FINE_LOCATION, ACCESS_COARSE_LOCATION)
- Permisiuni pentru servicii în fundal (FOREGROUND_SERVICE)
- Google Play Services pentru Maps

## Depanare
- Dacă harta nu se încarcă, verificați cheia API Google Maps
- Dacă tracking-ul GPS nu funcționează, verificați permisiunile de localizare
- Pentru probleme cu senzorul de ritm cardiac, verificați dacă dispozitivul are acest senzor

## Personalizare
- Puteți modifica culorile aplicației în fișierul colors.xml
- Puteți ajusta intervalele de actualizare GPS în Constants.java
- Puteți modifica algoritmul de calcul al caloriilor în TrackingUtility.java

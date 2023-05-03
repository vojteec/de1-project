# **Semestrální projekt předmětu BPC-DE1 22/23L**
## *Časovač na intervalový (kruhový) trénink s možností nastavit počet kol, dobu kola a pauzy mezi nimi za běhu aplikace*
### Autoři:
- Vojtěch Tlamka (*architektura, menu driver, timer driver*)
- Vojtěch Kuchař (*dokumentace, display driver*)

### Teoretický úvod do problematiky

Cílem projektu je vytvořit časovač pro kruhový trénink – intervalové cvičení s vysokou intenzitou sloužící k rychlému zlepšení fyzické kondice. Provádí se na určitém počtu stanovišť s jednotlivými cviky probíhajícími po stanovený čas a se stanovenými přestávkami mezi nimi. Z hlediska funkcionality uživatel očekává primárně dva režimy provozu:
  1. Menu, obsahující nastavení počtu kol, cviků a doby trvání cvičení a pauzy
  2. Režim samotného počítání času a indikace kola/pauzy

Implementace návrhu je plánována pro FPGA desku Nexys A7-50T, která nám nabízí využití dvou polí o čtyřech sedmisegmentových displejích. Dále máme k dispozici dvojici RGB LED a 16 jednobarevných LED. K ovládání zařízení máme k dispozici pětici tlačítek a 16 dvoupolohových přepínačů. Co se týče použité logiky, využíváme konečného automatu, čítačů, ovladačů pro soustavu sedmisegmentových displejů s převaděčem z BCD a dalších zařízení složených z logických obvodů a součástek.

### Technický popis a schéma návrhu

![schéma návrhu](img/schematic.png)

### Popis programového vybavení řešení



### Uživatelská příručka a návod k použití

Zařízení pracuje ve dvou režimech, MENU MODE a COUNTER MODE. Pro přepínání mezi režimy použijte přepínač SWITCH 1. V režimu MENU MODE máte možnost nastavit dobu trvání kola (L t = lap time), dobu trvání odpočinku (P t = pause time) a počet kol (LAPS). Po displeji se pohybujete tlačítky BTN L/R, nastavovaná čtveřice sedmisegmentovek je indikována blikáním. Změna hodnoty se provádí tlačítky BTN U/D. Po nastavení hodnot přepněte pomocí SWITCH 1 do COUNTER MODE. Zařízení začne odpočítávat nastavený čas kola. Jeho zbývající hodnota je zobrazena na pravé části displeje, na levé části displeje je indikováno, zda se jedná o kolo nebo pauzu (L/P) a pořadové číslo.


# OPERATION BAD PRIMATE KLASSIFIKATION: FORHOLDSVIS FORTROLIGT
- https://hackerakademi.dk/challenge

DATO: 2026-01-29 FRA: Afdeling for Strategiske Bekymringer og
Overvejelser TIL: Afdeling for Computer Network Exploitation
(CNE)-træning DEADLINE: 2026-02-30

En partnertjeneste har meddelt at virksomheden MonkEZ/EDO muligvis er
involveret i sanktionsbelagt våbenproduktion, udover deres officielle
handel med foderprodukter til landbrug og zoologiske haver.

Efterforskning har afsløret, at virksomheden sandsynligvis bruger handel
med foderprodukter som et dække for deres ulovlige aktiviteter.

Vi har behov for indsigt i hvad der foregår i virksomheden, herunder
adgang til regnskab, leverandøroversigter og intern kommunikation for at
be- eller afkræfte mistanken.

Vi har ved hjælp fra en HUMINT-kilde exfiltreret en gammel backup af en
af virksomhedens servere. Din opgave er at analysere denne backup for at
finde og identificere sårbarheder, der kan give os adgang til
virksomhedens servere og systemer. Serveren er ikke tilgængelig på
internet, men vi har mulighed for netværksadgang via HUMINT.

Vores kilde melder endvidere at siden backup-filen blev anskaffet, har
MonkEZ/EDO skiftet alle passwords og ssh-nøgler. Det lader til at intet
andet er ændret.

Fokuser derfor på at finde en vej gennem serveren, som virker selv efter
denne ændring.

# Operationelle mål:

Identificer så mange sårbarheder som muligt i den gamle server-backup,
som kan anvendes til at få hel eller delvis adgang til den rigtige
server. Dokumentér hvordan de identificerede sårbarheder kan udnyttes og
kombineres. Det ultimative mål er at få root-adgang til serveren
(root@printserver). Vejledning til klassifikationsgrader:

FORHOLDSVIS FORTROLIGT: Emner mærket med denne klassifikation (tidl.
"HØJST TYS-TYS") indeholder følsomme oplysninger, der kan kompromittere
nationale sikkerhedsinteresser eller internationale relationer, hvis de
offentliggøres. Det er som minimum lidt flovt hvis det sker.

TILPAS TYS-TYS: Emner mærket med denne klassifikation indeholder
oplysninger som helst ikke bør blive offentlig kendt, og formentlig er
svære at finde uden videre.

SLET SKJULT: Emner mærket med denne klassifikation indeholder
oplysninger, som ikke helt er offentlige, men heller ikke er godt gemt.

OPRIGTIGT OFFENTLIG: Emner mærket med denne klassifikation indeholder
oplysninger, der er beregnet til fuld offentliggørelse og kan deles frit
uden nogen begrænsninger.

Download Vores kilde har skaffet en backup af en virtuel server. Kan du
hjælpe FE med at knække gåderne?

Hvis du vælger at søge ind på akademiet, og du også har prøvet denne
operationsøvelse, er du meget velkommen til at beskrive dine fund og
konklusioner i et bilag til din ansøgning.

Det er IKKE et krav at løse denne opgave, hverken helt eller delvist,
for at søge ind på akademiet.

# Virt-manager 
Hent disk-filen How-to Hvis du kører Linux, vil vi anbefale at du
installerer maskinen via virt-manager.

Start virt-manager. Vælg Create a new virtual machine og se et nyt
vindue åbne sig. Vælg Import existing disk image. Tryk Forward. Vælg
Browse.... I det nye vindue vælger du Browse Local, og finder den
downloadede fil. Under menupunktet Choose the operating system that you
are installing: vælger du Debian 13. Tryk Forward. Giv maskinen mindst 2
GB ram. Tryk Forward. Kontroller at den sidder i et netværk med navnet
default. Tryk Finish. Hvis alt går godt starter maskinen, og du kan se
en IP-adresse og en login-prompt. Øvelsen starter ved maskinens
IP-adresse. På Windows kan du bruge VMware, VirtualBox, Hyper-V eller et
helt fjerde virtualiseringsprogram. Uanset hvad du vælger, vil
installationsprocessen være cirka den samme som beskrevet ovenfor.

Hvis du slet ikke kan få maskinen til at starte, er du velkommen til at
sende os en mail på hackerakademi@protonmail.com. Det er ikke vores
hensigt af opsætningen skal være svær.

Vi vil opfordre dig til at tage hensyn til andre operatører; uopfordrede
spoilers kan opleves som ærgerlige. Når deadline er overstået, vil vi
dog blive glade for at se offentlige writeups.

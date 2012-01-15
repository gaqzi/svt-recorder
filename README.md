== VAD OCH VARFÖR
Det här är ett program som tar adressen till en video hos SVT Play eller
Play Rapport och spelar in den med högsta upplösningen tillgänglig till
en fil på din dator. Populärt kallat "ladda ner".

Det här programmet gjorde jag därför jag vill kunna spela program från
SVT Play på min TV, men jag har ingen dator direkt kopplad till TV:n,
så jag blir tvungen att först tanka ner programmet för att sedan
spela upp det där.

== SYSTEMKRAV:
- Ruby, version 1.8.7 eller senare
- Rubygems

== Installation
För att installera det här programmet så behöver du ha
Ruby samt Rubygems installerat.

=== Linux
=== Debian/Ubuntu
Om du använder Ubuntu så kom ihåg att använda sudo!

I ett Debian/Ubuntusystem så ser du till att ha det så här:
  # aptitude install rubygems

=== Fedora / RPM-baserat
Installera Rubygems med Yum så tankar det ner Ruby med
  # yum install rubygems

=== Själva programmet
När Ruby och Rubygems är installerat så skriver du:
  # gem install svt-recorder
(ibland så heter gem något annat, t ex gem1.8 eller gem1.9)

Och nu är det bara att använda!

=== Windows
Ladda ner Ruby från http://www.ruby-lang.org/en/downloads/.
Jag använde Ruby 1.9.2 RubyInstaller.

OBS! Kryssa i rutan "Add Ruby executables to your PATH" när
installationsprogrammet frågar var du vill installera Ruby!

Gå till Kör och skriv in: cmd

I den nya kommandoprompten som kom upp skriv:
  > gem install svt-recorder
  [... programmet hämtas ned och installeras ...]

Nu kan du använda svt-recorder från kommandoprompten, se nedan på användning.

OBS! Kännt problem att byta namn på filen när programmet frågar i Windows,
sätt namnet direkt efter URL:en eller tryck ENTER för att godkänna det
föreslagna namnet.

== ANVÄNDNING:
  svt-recorder <SVT URL> [spara som namn]
Om inget namn är angett så kommer ett namn föreslås baserat på programmets namn.

== ATT GÖRA:
- Göra namngivningen av filerna mer robust, i dagsläget så accepteras
  vad som helst som filnamn
- Olika nedladdningsmetoder? (Inbyggd, wget)
- Använda rtmpdump för att spela in RTMPE-strömmar (de videos som inte går ner
  i dagsläget.
- Återupptagning av nerladdning. Eftersom det redan är uppdelat i
  "chunks" från SVT Play så blir den delen som behöver laddas ned
  extra relativt liten i sammanhanget. Finns det något bättre sätt än
  att loopa igenom HEAD-reqs för att bygga upp till totalen? Eftersom
  varje chunk har en slumpmässig storlek så går det inte att göra
  någon slags statistisk analys?
- Paketera för Debian/Ubuntu och sätt upp ett repo för nerladdning där
- Se över vad det skulle innebära att göra ett GUI för Windows

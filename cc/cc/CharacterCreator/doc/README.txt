**** NWN Character Creator ****
** halfelf@city-of-doors.com **
** garad@ageofmortals.net **

Version: v 1.3

This version was produced and released by the Player Resource Consortium or
(PRC).  Major visible changes include:
	- Multiple files can be selected when configuring haks.
	- Z-Axis scrolling available with some mice should move the vertical
	  scrollbars an appropriate distance.
	- Invalid tlk entries and invalid icons should no longer crash the CC.
	- Many resource leaks have been removed.
	- Speed and memory performance have been improved significantly

Please report bugs on the PRC website:

	http://nwnprc.netgamers.co.uk/index1.html

Version: v 1.1

This is the current release of the Character
Creator for NWN. 

This program requires Java 1.4 or better: Head to
http://java.sun.com/getjava/index.html
if you do not have Java.

Be sure to go to the Settings menu the first time you
use the program, to set your NWN directory. You can 
also select HAKs there.

At the end, a message will come up and tell you that the
BIC is written. Don't bother clicking the finalize button more;
it won't do anything. You may wish to exit the program to
create a new character; some people experience slowdowns
as they make more characters.

If you choose a package, your feats, spells, skills, etc will 
NOT appear correctly. You will have to examine them in game
for the time being.

Any files you create for this program need to be in lower
case. Otherwise the file searching stuff tends to come back
with odd information.

Also, any files you create MUST have all numbers in numerical
order, starting at 0. Otherwise the program will not work 
properly.

Please send bug reports to halfelf@city-of-doors.com and 
garad@ageofmortals.net. Thanks, and I hope you enjoy the program.

-James "Halfelf" Stoneburner
-Garad Moonbeam

****CHANGE LOG****

v.1.1:
-Updated to be SoU and 1.3x compatable.
-Skills menus are now dynamic, allowing for custom skills.

v.1.01:

-Added the ability to edit your description.

-Put code in the program to grab the NWN directory out of the registry
automatically if needed, to prevent many of the "file not found" errors

-Made the program somewhat more friendly to Linux users; More testing
will be required to complete all Linux compatibility tests.

-Favored enemy for rangers is fixed.

-Fixed the dreaded Fatal Error: skills.2da missing error. Apparently
the settings menu didn't always put a trailing \ on the end of the
directory, and it was screwing it up. If it's not present, it will
be added for your convienence.

-Made the selection for soundset.2da more forgiving - this was
crashing some people with older versions of the file

-Reformatted the pages so they would display on 800x600 resolution.
A resolution of 1024x768 or higher is highly recommended, however.

-Changed the portrait implementation so that it looks for portraits
ending in 'm' rather than '_m'. This makes more portraits work in
game.

v.1.0:

*Final Release

PRC Server Pack

This is an self-installing server package for the PRC. This should only be installed after the main PRC packages. It includes:

NWNX               2.6.1
NWNX-ODBC        0.9.2.4
NWNX-Letoscript  build 23 beta 4
SQLite             3.2.1
Precacher

NWNX and NWNX-ODBC are avaliable from www.nwnx.org Source code for these applications are in nwnxsrc.exe and odbc2src.exe.
NWNX-Letoscript is avaliable from http://weathersong.infopop.cc/groupee/forums/a/frm/f/9616039431
SQLite is avaliable from www.sqlite.org
The Precacher was made for the PRC by Yuritch


When this installer package is run, it will extract the required files to your NWN directory automatically. Then it will precache the 2da files into the database for you. There are three steps to this, firstly they must be extracted from prc_2das.hak. Secondly, the precacher tool will convert them into a single large SQL statement. Then finally, the SQL statement will be executed by SQLite.

When there is a PRC update, you can simply run the "precacher sqlite.bat" file in your NWN directory to re-cache the updated 2da files without having to re-installer the server pack.

Once you have the server all setup, you do need to set a few switches on the module. There is a full list in prc_inc_switches. To set a switch:
Open the module in the toolset
Edit -> Module Properties -> Advanced Tab -> Variables
Enter the name of the variable on the left hand box, select INT in the middle box (unless the switch says otherwise), and then enter the value in the right hand box.

This picture, http://i3.photobucket.com/albums/y68/Primogenitor/switches.jpg may help you.

Some suggested switches for a server are:

PRC_USE_DATABASE		INT	1			This will turn on the database
PRC_USE_LETOSCRIPT 		INT	1			This will turn on Letoscript
PRC_LETOSCRIPT_NWN_DIR		STRING 	[your NWN directory]	This tells Letoscript where to find NWN
PRC_LETOSCRIPT_FIX_ABILITIES	INT	1			This will use letoscript to bypass the +12 ability cap

you may also wish to use:
PRC_CONVOCC_ENABLE		INT	1			This will turn on the Conversation Character Creator, so races and base classes can be used in servervault.
PRC_LETOSCRIPT_PORTAL_IP	STRING	[your servers IP]
PRC_LETOSCRIPT_PORTAL_PASSWORD  STRING	[your servers password]	These two can be used by Letoscirpt to avoid booting your character.
PRC_LETOSCRIPT_GETNEWESTBIC	INT	1			This uses a different method to get bic files which may avoid conflicts if players have two characters named the same.


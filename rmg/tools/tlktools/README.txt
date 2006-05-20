TLKTools v1.0.3 - TLK<->XML generation tools

Copyright (C) 2004 Guido Imperiale
This code is released under the terms of the GNU GPL.
Please refer to COPYING.txt for more info.

http://crusaderky.altervista.org



Note for Linux users
--------------------
libxml2 is required to run this software.
If you're using Gnome v2.x, then you already have it installed; otherwise, you can download it from http://www.xmlsoft.org/



Usage
-----

tlktools command.xml
Read a complex XML command (See below)

tlk2xml infile.tlk [outfile.xml]
Read a TLK file and write it to an XML file; use standard output if none is provided.

xml2tlk infile.xml outfile.tlk [langcode] [m|f]
Read an XML file and write it to a TLK file.
langcode and sex default to "en" and "m" if none is provided.


The command/data files can be any XML files. Valid tags are the following:

<!--comment-->
	any type of comment, eventually on more than one line.


<tlk></tlk>
	Generic tag, used to open and close the file as well as  set "paragraphs"
	Attributes:
		offset="#"	(optional; default="0")
					Any positive or negative number. From now on, all IDs read will be summed to it.
					This stacks with any previous "offset" attributes of tags that haven't been closed yet.
		lang="xx"	(optional; default="en")
					Language to use as default in the following entries
					Possible values are: en|fr|de|it|sp|po|ko|ct|cs|jp
		sex="m|f"	(optional; default="m")
					Sex to use as default in the following entries
		quiet="0|1"	(optional; default="0")
					Do not print a warning when overwriting existing entries with a different content


<xmlread>file.xml</xmlread>
	Load an XML file. It may contain commands and/or entries, as well as other includes.
	Note that the path refers to the directory where the program is running and not the directory of the XML file.
	Attributes:
		offset="#"	(optional; default="0")
		lang="xx"	(optional; default="en")
		sex="m|f"	(optional; default="m")
		quiet="0|1"	(optional; default="0")


<tlkread>file.tlk</tlkread>
	Load a TLK file.
	Attributes:
		sex="m|f"	(optional; default="m")
			the sex of the TLK file
		offset="#"	(optional; default="0")
		quiet="0|1"	(optional; default="0")


<xmlwrite>file.xml</xmlwrite>
	Write the current talk table to an XML file

<tlkwrite>file.tlk</tlkwrite>
	Write the current talk table to a TLK file.
	Note that only one sex and language will be written.
	Attributes:
		lang="xx"	(optional; default="en")
		sex="m|f"	(optional; default="m")
	Notes:
		* If an entry exists for only one sex, that one will be used
		* If the entry does not exist for the given language at all, the "en" entry will be used


<entry id="#">Hello World!</entry>
	A TLK entry, eventually on more than one line. Note that, in the text, any '&' will have to be replaced with '&amp;'
		id="##"		(required; decimal only (hexadecimal values, exponentials, and/or sums are not accepted))
					Any number between 0 and 2^31-1, pointing the StrRef of the entry. Note that the custom table flag is stripped off from IDs, so 2^31+1 is identical to 1.
		lang="xx"	(optional; default="en")
		sex="m|f"	(optional; default="m")
		quiet="0|1"	(optional; default="0")


Please take a look at the sample XML file called sample.xml.



Advanced usage
--------------
Looking for differences:

There are two ways to check for differences between TLK versions:
The first, brutish one is to convert both the TLKs to XML and then launch 'diff -u oldtlk.xml newtlk.xml' (it's a UNIX tool. If you're using Windows, you may get it along with a cool UNIX shell with MinGW/MSYS at http://www.crusaderky.altervista.org/downloads.php#KY-MinGW).
The problem is that it will show ALL differences, while you're probably only interested in what you've already modified.

So you may use TLKTools for a more refined solution.


Simple version checking of modified lines:

<tlk>
	<tlkread "sample.tlk">
	<entry id="1" quiet="0">This is the unmodified entry</entry>
	<entry id="1" quiet="1">This is the new entry</entry>
</tlk>
	
This way, if sample.tlk contains anything different than "This is the unmodified entry" at line 1, a warning will be issued containing the line number and you'll have the chance to modify your patch.


Version checking of translated lines:

<tlk>
	<tlkread "sample.tlk">
	<entry id="1" lang="en">This is the unmodified entry</entry>
	<entry id="1" lang="it">Questa è la riga non modificata</entry>
</tlk>


Version checking of translated AND modified lines:

<tlk>
	<tlkread "sample.tlk">
	<entry id="1" lang="en"          >This is the unmodified entry</entry>    <!-- Error checking -->
	<entry id="1" lang="en" quiet="1">This is the new entry</entry>           <!-- Modification -->
	<entry id="1" lang="it"          >Questa è la nuova linea</entry>         <!-- Translation of the modified line -->
</tlk>




Compilation
-----------
To build this program from sources, you need
* any UNIX shell with gcc and make. (tested on Linux and CygWin.)
* libxml2 library and development files, that can be downloaded from http://www.xmlsoft.org/

libxml2 is available for Linux, Solaris, MacOS-X and Cygwin for Windows. No MinGW/MSYS support is available at the moment.
You could try building this using MS Visual C++, but no Makefile is provided and you'll have to do everything with your hands.

1)position yourself in the src/ directory
2)launch 'make all'
3)install the executable files (tlktools[.exe], tlk2xml[.exe], xml2tlk[.exe]) wherever you please.


Known Issues
------------

* Not tested on BigEndian systems (i.e. Macintosh) but it SHOULD work.
* Not tested on 64-bits CPUs (i.e. Athlon64) but, after a simple modification to tlktools.h, it SHOULD work.
* Not tested with non-european character sets.
* No sound support.
* Paths are relative to the present working directory (pwd) and not to the XML files.


Changelog
---------

1.0.3
-----
* Now, even if not quiet, you won't get a warning if overwriting the same string (excellent for version control!)
* Added the "Advanced Usage" section to the README file
* Improved sample.xml

1.0.2
-----
* Fixed crash in the windows version introduced in 1.0.1

1.0.1
-----
* Fixed charset handling bug
* Fixed non-escaped & for sex="f"

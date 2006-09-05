/*
	fileend.c

	generates a .nss file containing a fileends function
		for 2da files

	By: Flaming_Sword
	Created: Sept 5, 2006
	Modified: Sept 6, 2006

	Seems to work in cygwin, bugs with char arrays somewhere
	USE: Put in directory with all the 2das, run, then delete
		the line corresponding to the executable
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include <sys/types.h>
#include <dirent.h>

int main(int argc, char *argv[])
{
	if(argc < 1) return;

	char *sFile;
	char *sTemp;
	printf("int PRCGetFileEnd(string sTable)\n{\n");
	FILE *fp;
	DIR *dp;
	int nCount;
	struct dirent *ep;

	dp = opendir ("./");
	if (dp != NULL)
	{
		while (ep = readdir (dp))
		{
			sFile = ep->d_name;
			fp = fopen(sFile, "r");
			nCount = 0;
			while(fgets(sTemp, 65536, fp))
			{
				nCount++;
			}
			if(nCount - 4 < 1)
				continue;
			printf("    if(sTable == %c%s%c) return %d;\n", 34, strtok(sFile, "."), 34, nCount - 4);
			fclose(fp);
		}
		(void) closedir (dp);
	}

	printf("\n    if(DEBUG) DoDebug(%cPRCGetFileEnd: Unrecognised 2da file: %c + sTable);\n    return 0;\n}", 34, 34);
	return 0;
}

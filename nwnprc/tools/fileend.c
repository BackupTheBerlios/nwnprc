/*
	fileend.c

	generates a .nss file containing a fileends function
		for 2da files

	By: Flaming_Sword
	Created: Sept 5, 2006
	Modified: Sept 6, 2006

	USE: Put in directory with all the 2das, run with indirection
	Will work if compiled in cygwin (or presumably linux)
	Windows version (from cygwin) requires cygwin1.dll
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
	char *sTemp = (char *) malloc(65536 * sizeof(char));
	char sName[20];
	char sComp[3];
	printf("int PRCGetFileEnd(string sTable)\n{\n");
	FILE *fp;
	DIR *dp;
	int nCount, i;
	struct dirent *ep;

	dp = opendir ("./");
	if (dp != NULL)
	{
		while (ep = readdir (dp))
		{
			sFile = ep->d_name;
			fp = fopen(sFile, "r");
			nCount = 0;
			fgets(sTemp, 65536, fp);
			for(i = 0; i < 3; i++)
				sComp[i] = sTemp[i];
			if(strcmp(sComp, "2DA"))
			{
				fclose(fp);
				continue;
			}
			nCount++;
			for(i = 0; i < 20; i++)
				sName[i] = sFile[i];
			while(fgets(sTemp, 65536, fp))
			{
				nCount++;
			}
			printf("    if(sTable == %c%s%c) return %d;\n", 34, strtok(sName, "."), 34, nCount - 4);
			fclose(fp);
		}
		(void) closedir (dp);
	}

	printf("\n    if(DEBUG) DoDebug(%cPRCGetFileEnd: Unrecognised 2da file: %c + sTable);\n    return 0;\n}", 34, 34);
	free(sTemp);
	return 0;
}

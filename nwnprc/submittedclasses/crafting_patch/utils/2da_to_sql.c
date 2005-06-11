/*
    Player Resource Consortium 2DA to SQL converter
    2da_to_sql.c

    Copyright (C) 2005 Guido Imperiale

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

       Guido Imperiale
    crusaderky@libero.it
    ---------------------
         CRVSADER/KY
    CVI.SCIENTIA.IMPERIVM
*/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <ctype.h>

//maximum 2da line length, in characters
#define BUFSIZE 65536

//maximum number of columns
#define MAX_COLUMNS 100


typedef struct {
	int columns;
	char ** data;
} row;


//allocate a row and initialize it
row * alloc_row(int columns)
{
	assert(columns > 0);

	row * new_row = malloc(sizeof(row));
	assert(new_row);
	
	new_row->columns = columns;
	
	new_row->data = malloc(sizeof(char *) * columns);
	assert(new_row->data);
	memset(new_row->data, 0, (sizeof(char *) * columns));
	
	return new_row;
}


//resize a row
//NOTE: if shrinking, assume that data is empty after columns
void realloc_row(row * r, int columns)
{
	assert(columns > 0);
	assert(r != NULL);
	
	r->data = realloc(r->data, (sizeof(char *) * columns));
	r->columns = columns;
}


//free a row and all its content
void free_row(row * r)
{
	if (r == NULL)
		return;
	
	int i;
	for (i = 0; i < r->columns; i++) {
		if (r->data[i] != NULL)
			free(r->data[i]);
	}
	
	free(r->data);
	free(r);
}


//Like strtok(buf, " \t\n"), but in addition it will check for
//arguments included within " " (which may contain spaces)
//i.e. the string "arg1 arg2 \"arg3 arg4\"" will return 3 tokens.
char * get_entry(char * buf)
{
	static char * begin_ptr;
	char * end_ptr;
	int UseQuotes = 0;
	
	if (buf != NULL)
		begin_ptr = buf;
		
	if (begin_ptr == NULL)
		return NULL;

	//Cut leading spaces
	while (*begin_ptr != '\0' && (*begin_ptr == ' ' || *begin_ptr == '\t'))
		begin_ptr++;

	if (*begin_ptr == '"') {
		UseQuotes = 1;
		begin_ptr++;
	}

	if (*begin_ptr == '\0') {
		begin_ptr = NULL;
		return NULL;
	}

	end_ptr = begin_ptr;
	
	while (*end_ptr != '\0' && 
	       *end_ptr != '\n' &&
		   *end_ptr != '"'  &&
		   (UseQuotes ? 1 : *end_ptr != ' ' && *end_ptr != '\t'))
	{
		end_ptr++;
	}
	
	if (*begin_ptr == '\0' || *begin_ptr == '\n') {
		begin_ptr = NULL;
		return NULL;
	} else if (*end_ptr == '\0' || *end_ptr == '\n') {
		begin_ptr = NULL;
	}
	
	char * ret = begin_ptr;
	begin_ptr = end_ptr + 1;
	*end_ptr = '\0';
		
	return ret;
}


//parse buffer and return a new row structure, or NULL if buffer contains no entries
row * fetch_row(char * buf, int columns)
{
	int column = 0;
	int IsHeader = 0;

	assert(buf != NULL);
	assert(columns > 0);
	
	row * r = alloc_row(columns);

	if (buf[0] == ' ' || buf[0] == '\t') 
	{
		//header row
		IsHeader = 1;
		r->data[0] = malloc(4);
		assert(r->data[0]);
		
		strcpy(r->data[0], "row");
		column = 1;
	}
	
	char * tok = get_entry(buf);
	while (tok != NULL) 
	{
		if (column >= columns) {
			fprintf(stderr, "ERROR: malformed 2DA: more columns than headers\n");
			exit(1);
		}
		
		int toklen = strlen(tok);
	
		r->data[column] = malloc(toklen+1);
		assert(r->data[column]);
			
		strcpy(r->data[column], tok);
		column++;
		
		tok = get_entry(NULL);
	}
	
	if (column == 0) {
		free_row(r);
		return NULL;
	}
	
	if (IsHeader)
		realloc_row(r, column);
		
	return r;
}


//print a row to stdout, using NWNX2 compatible escape characters
void print_row(row * r, char delimiter)
{
	assert(r != NULL);
	
	int i;
	for (i = 0; i < r->columns; i++) {
		//Do not print empty headers
		if (delimiter == '`' && r->data[i] == NULL)
			break;
	
		if (i > 0)
			putchar(',');
		
		
		if (r->data[i] != NULL && strcmp(r->data[i], "****") != 0) 
		{
			putchar(delimiter);
			
			char * s = r->data[i];
			while (*s != '\0') {
				if (*s == '\'')
					putchar('~');
				else if (delimiter == '`')
					putchar(tolower(*s));
				else
				putchar(*s);
				s++;
			}
			
			putchar(delimiter);
		} else
			printf("NULL");
		
	}
}


int main(int argc, char ** argv) 
{	
	if (argc != 3) {
		fprintf(stderr, "\nPlayer Resource Consortium - CRVSADER//KY's 2DA to SQL converter\n\n");
		fprintf(stderr, "Usage: 2da_to_sql <2da name> <path>\n");
		fprintf(stderr, "The output will be printed to stdout.\n\n");
		fprintf(stderr, "example: ./2da_to_sql feat prc_2da/feat.2da > feat.sql\n\n");
		exit(1);
	}
	
	char * name = argv[1];
	char * path = argv[2];
	
	FILE * fp = fopen(path, "rt");
	if (fp == NULL) {
		fprintf(stderr, "Unable to open file: %s\n", path);
		exit(1);
	}
	
	char inbuf[BUFSIZE];
	
	
	//Discard the first two rows
	fgets(inbuf, BUFSIZE, fp);
	fgets(inbuf, BUFSIZE, fp);
	
	if (fgets(inbuf, BUFSIZE, fp) == NULL) {
		fprintf(stderr, "ERROR: Malformed 2DA: no header found at line 3\n");
		return 1;
	}
		
	//Acquire header
	row * header = fetch_row(inbuf, MAX_COLUMNS);
	
	if (header == NULL || header->columns < 2) {
		fprintf(stderr, "ERROR: Malformed 2DA\n");
		return 1;
	}
	
	//fprintf(stderr, "header->columns: %d\n", header->columns);
	
	printf ("TRUNCATE prccache_%s;\n", name);
		
	while (fgets(inbuf, BUFSIZE, fp) != NULL) {
		row * r = fetch_row(inbuf, header->columns);
		if (r == NULL)
			continue;
		
		printf("INSERT INTO prccache_%s (", name);
		print_row(header, '`');
		printf(") VALUES (");
		print_row(r, '\'');
		printf(");\n");
		
		free_row(r);
	}
	
	free_row(header);
	fclose(fp);
	return 0;
}

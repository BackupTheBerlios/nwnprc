/**
 * @file 
 * All the functions dealing with the NWNx database. Based on the APS include
 * with optimisations, renamed to avoid naming clashes with the APS system.
 * @author Primogenitor, motu99, fluffyamoeba
 * @date created on 2009-01-25
 */
 
const int PRC_SQL_ERROR = 0;
const int PRC_SQL_SUCCESS = 1;

//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

// creates and stores a 1024 Byte string for database-fetches on the module
void PRC_SQLInit();

// executes an SQL command direclty
void PRC_SQLExecDirect(string sSQL);

// fetches data from a previous SQL fetch request; returns TRUE is fetch was successful
int PRC_SQLFetch();

// gets the actual data from a fetch; if a table with more than 1 column was requested, return the table element at column iCol
string PRC_SQLGetData(int iCol);

// SQLite and MYSQL use different syntaxes
string PRC_SQLGetTick();

// Problems can arise with SQL commands if variables or values have single quotes
// in their names. These functions are a replace these quote with the tilde character
string ReplaceSingleChars(string sString, string sTarget, string sReplace);

// only needed for SQLite; commits (actually stores) the changed to the database
void PRC_SQLiteCommit();
// starts the pseudo heartbeat for committing SQLite DB
void StartSQLiteCommitHB();
//  pseudo heartbeat for committing SQLite DB; interval given in switch PRC_DB_SQLITE_INTERVAL
// default is 600 seconds (= 10 min)
void SQLiteCommitHB();

//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

void PRC_SQLInit()
{
    int i;

    // Placeholder for ODBC persistence
    string sMemory;

    for (i = 0; i < 8; i++)     // reserve 8*128 bytes
        sMemory +=
            "................................................................................................................................";

    SetLocalString(GetModule(), "NWNX!ODBC!SPACER", sMemory);
}

void PRC_SQLExecDirect(string sSQL)
{
    SetLocalString(GetModule(), "NWNX!ODBC!EXEC", sSQL);
}

int PRC_SQLFetch()
{
	string sRow;
	object oModule = GetModule();

	// initialize the fetch string to a large 1024 Byte string; this will also trigger the fetch operation in NWNX
	SetLocalString(oModule, "NWNX!ODBC!FETCH", GetLocalString(oModule, "NWNX!ODBC!SPACER"));

	// get the result from the fetch
	sRow = GetLocalString(oModule, "NWNX!ODBC!FETCH");
	if (GetStringLength(sRow) > 0)
	{
		// store the result on the module and signal success
		SetLocalString(oModule, "NWNX_ODBC_CurrentRow", sRow);
		return PRC_SQL_SUCCESS;
	}
	else
	{
		// set the result string on the module to empty and signal failure
		SetLocalString(oModule, "NWNX_ODBC_CurrentRow", "");
		return PRC_SQL_ERROR;
	}
}

/** @todo check mySQL manual, not sure if this is needed - fluffyamoeba */
string PRC_SQLGetTick()
{
    if(GetPRCSwitch(PRC_DB_SQLITE))	return "";
    else								return "`";
}

string PRC_SQLGetData(int iCol)
{
	string sResultSet = GetLocalString(GetModule(), "NWNX_ODBC_CurrentRow");
	int iPos = FindSubString(sResultSet, "�");
	if (iCol == 1)
	{
		// only one column returned ? Then we are finished
		if (iPos == -1)	return sResultSet;
		// more than one column returned ? Then return first column
		else			return GetStringLeft(sResultSet, iPos);
	}
	 // more than one column requested, but only one returned ? Something went wrong; return empty string
	else if (iPos == -1)	return "";

	// find column in current row
	int iCount = 0;
	int nLength = GetStringLength(sResultSet);

	// loop through columns until found
	while (iCount++ != iCol)
	{
		if (iCount == iCol)
			return GetStringLeft(sResultSet, iPos);

		// pull off the previous column and find new column marker
		nLength -= (iPos + 1);
		sResultSet = GetStringRight(sResultSet, nLength);
		iPos = FindSubString(sResultSet, "�");

		// special case: last column in row
		if (iPos == -1)	return sResultSet;
	}
	
	return sResultSet;
}

string ReplaceSingleChars(string sString, string sTarget, string sReplace)
{
	if (FindSubString(sString, sTarget) == -1) // not found
		return sString;

	int i;
	string sReturn = "";
	string sChar;

	// Loop over every character and replace special characters
	for (i = 0; i < GetStringLength(sString); i++)
	{
		sChar = GetSubString(sString, i, 1);
		if (sChar == sTarget)
			sReturn += sReplace;
		else
			sReturn += sChar;
	}
	return sReturn;
}

// only needed for SQLite; commits (actually stores) the changed to the database
void PRC_SQLiteCommit()
{
	PRC_SQLExecDirect("COMMIT");
	PRC_SQLExecDirect("BEGIN IMMEDIATE");
}

// starts the pseudo heartbeat for committing SQLite DB
void StartSQLiteCommitHB()
{
	if (GetPRCSwitch(PRC_DB_SQLITE))
	{	
		int nInterval = GetPRCSwitch(PRC_DB_SQLITE_INTERVAL);
		DelayCommand(nInterval ? IntToFloat(nInterval) : 600.0f, SQLiteCommitHB());
	}
}

//  pseudo heartbeat for committing SQLite DB; interval given in switch PRC_DB_SQLITE_INTERVAL
// default is 600 seconds (= 10 min)
void SQLiteCommitHB()
{
	// check if we are still using SQLite
	if (GetPRCSwitch(PRC_DB_SQLITE))
	{
		// do the commit
		PRC_SQLExecDirect("COMMIT");
		PRC_SQLExecDirect("BEGIN IMMEDIATE");
		
		// continue pseudo heartbeat
		int nInterval = GetPRCSwitch(PRC_DB_SQLITE_INTERVAL);
		DelayCommand(nInterval ? IntToFloat(nInterval) : 600.0f, SQLiteCommitHB());
	}
}

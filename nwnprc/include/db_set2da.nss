/*

// For server admins
// remove the block comments at the top and bottom of this script to allow it to compile
// you must previously have imported aps_include from the nwnx2 or nwnx-ff utilities for the required include to be present


#include "aps_include"


void Put2DAInDB(string datafile, string column, int row, string s);

void main()
{
    string datafile = GetLocalString(GetModule(), "2DA_DB_CACHE_DATAFILE");
    string column = GetLocalString(GetModule(), "2DA_DB_CACHE_COLUMN");
    int row = GetLocalInt(GetModule(), "2DA_DB_CACHE_ROW");
    string s = GetLocalString(GetModule(), "2DA_DB_CACHE_RETVAR");
    Put2DAInDB(datafile, column, row, s);
}

void Put2DAInDB(string datafile, string column, int row, string s)
{
        //not in DB already

        //try adding a new row
        string sSQL = "INSERT INTO prccache (darow , dacolumn, dafile, davalue) VALUES ('"+IntToString(row)+"', '"+column+"', '"+datafile+"', '"+s+"')";
        SQLExecDirect(sSQL);
        //check adding it worked
        sSQL = "SELECT davalue FROM prccache WHERE darow='"+IntToString(row)+"' AND dacolumn='"+column+"' AND dafile='"+datafile+"'";
        SQLExecDirect(sSQL);
        if (SQLFirstRow() == SQL_SUCCESS)
            return;

        //if it didnt work, add a new table
        sSQL = "CREATE TABLE prccache ( darow varchar(255), dacolumn varchar(255), dafile varchar(255), davalue varchar(255) )";
        SQLExecDirect(sSQL);
        sSQL = "INSERT INTO prccache (darow , dacolumn, dafile, davalue) VALUES ('"+IntToString(row)+"', '"+column+"', '"+datafile+"', '"+s+"')";
        SQLExecDirect(sSQL);
        //check adding it worked
        sSQL = "SELECT davalue FROM prccache WHERE darow='"+IntToString(row)+"' AND dacolumn='"+column+"' AND dafile='"+datafile+"'";
        SQLExecDirect(sSQL);
        if (SQLFirstRow() == SQL_SUCCESS)
            return;

        //if we get here then there has to be a db problem
        WriteTimestampedLogEntry("Problem adding to DB. datafile="+datafile+", column="+column+", row="+IntToString(row)+", s="+s);

}

*/


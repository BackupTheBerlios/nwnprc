/*
// For server admins
// remove the block comments at the top and bottom of this script to allow it to compile
// you must previously have imported aps_include from the nwnx2 or nwnx-ff utilities for the required include to be present

#include "aps_include"

string GetDB2DA(string datafile, string column, int row)
{
    string sSQL = "SELECT davalue FROM prccache WHERE darow='"+IntToString(row)+"' AND dacolumn='"+column+"' AND dafile='"+datafile+"'";
    SQLExecDirect(sSQL);
    if (SQLFirstRow() == SQL_SUCCESS)
        return SQLGetData(1);
    else
        return "";
}

void main()
{
    string datafile = GetLocalString(GetModule(), "2DA_DB_CACHE_DATAFILE");
    string column = GetLocalString(GetModule(), "2DA_DB_CACHE_COLUMN");
    int row = GetLocalInt(GetModule(), "2DA_DB_CACHE_ROW");
    SetLocalString(GetModule(),"2DA_DB_CACHE_RETVAR", GetDB2DA(datafile, column, row));
}
*/
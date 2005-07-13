MOD V1.0           �   �   �  i   �   ����                                                                                                                    aps_include         �  aps_onload         �  aps_onload         �  area001            �  area001            �  area001            �  creaturepalcus     �  doorpalcus         �  encounterpalcus    �  hb_rectriabil   	   �  hb_rectriabil   
   �  hb_spelllevel      �  hb_spellmeta       �  inc_letoscript     �  itempalcus         �  module             �  mod_hb             �  mod_hb             �  placeablepalcus    �  prc_ip86_0         �  Repute             �  soundpalcus        �  storepalcus        �  triggerpalcus      �  waypointpalcus     �                                                                                                                                                                                                          �  �V  >[  /  m\  t  �]  )	  
g  �  �h  �  fk  	t  o�  �  �  �  ��  k  .�  d  ��  _	  �  n	  _
 �@  �J �� �9 Y	  �B �  �` V	  "j �  �p   �t a  ?| �   �  �� l  k� �  // Name     : Avlis Persistence System include
// Purpose  : Various APS/NWNX2 related functions
// Authors  : Ingmar Stieger, Adam Colon, Josh Simon
// Modified : January 1st, 2005

// This file is licensed under the terms of the
// GNU GENERAL PUBLIC LICENSE (GPL) Version 2

/************************************/
/* Return codes                     */
/************************************/

const int SQL_ERROR = 0;
const int SQL_SUCCESS = 1;

/************************************/
/* Function prototypes              */
/************************************/

// Setup placeholders for ODBC requests and responses
void SQLInit();

// Execute statement in sSQL
void SQLExecDirect(string sSQL);

// Position cursor on next row of the resultset
// Call this before using SQLGetData().
// returns: SQL_SUCCESS if there is a row
//          SQL_ERROR if there are no more rows
int SQLFetch();

// * deprecated. Use SQLFetch instead.
// Position cursor on first row of the resultset and name it sResultSetName
// Call this before using SQLNextRow() and SQLGetData().
// returns: SQL_SUCCESS if result set is not empty
//          SQL_ERROR is result set is empty
int SQLFirstRow();

// * deprecated. Use SQLFetch instead.
// Position cursor on next row of the result set sResultSetName
// returns: SQL_SUCCESS if cursor could be advanced to next row
//          SQL_ERROR if there was no next row
int SQLNextRow();

// Return value of column iCol in the current row of result set sResultSetName
string SQLGetData(int iCol);

// Return a string value when given a location
string APSLocationToString(location lLocation);

// Return a location value when given the string form of the location
location APSStringToLocation(string sLocation);

// Return a string value when given a vector
string APSVectorToString(vector vVector);

// Return a vector value when given the string form of the vector
vector APSStringToVector(string sVector);

// Set oObject's persistent string variable sVarName to sValue
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
void SetPersistentString(object oObject, string sVarName, string sValue, int iExpiration =
                         0, string sTable = "pwdata");

// Set oObject's persistent integer variable sVarName to iValue
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
void SetPersistentInt(object oObject, string sVarName, int iValue, int iExpiration =
                      0, string sTable = "pwdata");

// Set oObject's persistent float variable sVarName to fValue
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
void SetPersistentFloat(object oObject, string sVarName, float fValue, int iExpiration =
                        0, string sTable = "pwdata");

// Set oObject's persistent location variable sVarName to lLocation
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
//   This function converts location to a string for storage in the database.
void SetPersistentLocation(object oObject, string sVarName, location lLocation, int iExpiration =
                           0, string sTable = "pwdata");

// Set oObject's persistent vector variable sVarName to vVector
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
//   This function converts vector to a string for storage in the database.
void SetPersistentVector(object oObject, string sVarName, vector vVector, int iExpiration =
                         0, string sTable = "pwdata");

// Set oObject's persistent object with sVarName to sValue
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwobjdata)
void SetPersistentObject(object oObject, string sVarName, object oObject2, int iExpiration =
                         0, string sTable = "pwobjdata");

// Get oObject's persistent string variable sVarName
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
// * Return value on error: ""
string GetPersistentString(object oObject, string sVarName, string sTable = "pwdata");

// Get oObject's persistent integer variable sVarName
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
// * Return value on error: 0
int GetPersistentInt(object oObject, string sVarName, string sTable = "pwdata");

// Get oObject's persistent float variable sVarName
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
// * Return value on error: 0
float GetPersistentFloat(object oObject, string sVarName, string sTable = "pwdata");

// Get oObject's persistent location variable sVarName
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
// * Return value on error: 0
location GetPersistentLocation(object oObject, string sVarname, string sTable = "pwdata");

// Get oObject's persistent vector variable sVarName
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
// * Return value on error: 0
vector GetPersistentVector(object oObject, string sVarName, string sTable = "pwdata");

// Get oObject's persistent object sVarName
// Optional parameters:
//   sTable: Name of the table where object is stored (default: pwobjdata)
// * Return value on error: 0
object GetPersistentObject(object oObject, string sVarName, object oOwner = OBJECT_INVALID, string sTable = "pwobjdata");

// Delete persistent variable sVarName stored on oObject
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
void DeletePersistentVariable(object oObject, string sVarName, string sTable = "pwdata");

// (private function) Replace special character ' with ~
string SQLEncodeSpecialChars(string sString);

// (private function)Replace special character ' with ~
string SQLDecodeSpecialChars(string sString);

/************************************/
/* Implementation                   */
/************************************/

// Functions for initializing APS and working with result sets

void SQLInit()
{
    int i;

    // Placeholder for ODBC persistence
    string sMemory;

    for (i = 0; i < 8; i++)     // reserve 8*128 bytes
        sMemory +=
            "................................................................................................................................";

    SetLocalString(GetModule(), "NWNX!ODBC!SPACER", sMemory);
}

void SQLExecDirect(string sSQL)
{
    SetLocalString(GetModule(), "NWNX!ODBC!EXEC", sSQL);
}

int SQLFetch()
{
    string sRow;
    object oModule = GetModule();

    SetLocalString(oModule, "NWNX!ODBC!FETCH", GetLocalString(oModule, "NWNX!ODBC!SPACER"));
    sRow = GetLocalString(oModule, "NWNX!ODBC!FETCH");
    if (GetStringLength(sRow) > 0)
    {
        SetLocalString(oModule, "NWNX_ODBC_CurrentRow", sRow);
        return SQL_SUCCESS;
    }
    else
    {
        SetLocalString(oModule, "NWNX_ODBC_CurrentRow", "");
        return SQL_ERROR;
    }
}

// deprecated. use SQLFetch().
int SQLFirstRow()
{
    return SQLFetch();
}

// deprecated. use SQLFetch().
int SQLNextRow()
{
    return SQLFetch();
}

string SQLGetData(int iCol)
{
    int iPos;
    string sResultSet = GetLocalString(GetModule(), "NWNX_ODBC_CurrentRow");

    // find column in current row
    int iCount = 0;
    string sColValue = "";

    iPos = FindSubString(sResultSet, "�");
    if ((iPos == -1) && (iCol == 1))
    {
        // only one column, return value immediately
        sColValue = sResultSet;
    }
    else if (iPos == -1)
    {
        // only one column but requested column > 1
        sColValue = "";
    }
    else
    {
        // loop through columns until found
        while (iCount != iCol)
        {
            iCount++;
            if (iCount == iCol)
                sColValue = GetStringLeft(sResultSet, iPos);
            else
            {
                sResultSet = GetStringRight(sResultSet, GetStringLength(sResultSet) - iPos - 1);
                iPos = FindSubString(sResultSet, "�");
            }

            // special case: last column in row
            if (iPos == -1)
                iPos = GetStringLength(sResultSet);
        }
    }

    return sColValue;
}

// These functions deal with various data types. Ultimately, all information
// must be stored in the database as strings, and converted back to the proper
// form when retrieved.

string APSVectorToString(vector vVector)
{
    return "#POSITION_X#" + FloatToString(vVector.x) + "#POSITION_Y#" + FloatToString(vVector.y) +
        "#POSITION_Z#" + FloatToString(vVector.z) + "#END#";
}

vector APSStringToVector(string sVector)
{
    float fX, fY, fZ;
    int iPos, iCount;
    int iLen = GetStringLength(sVector);

    if (iLen > 0)
    {
        iPos = FindSubString(sVector, "#POSITION_X#") + 12;
        iCount = FindSubString(GetSubString(sVector, iPos, iLen - iPos), "#");
        fX = StringToFloat(GetSubString(sVector, iPos, iCount));

        iPos = FindSubString(sVector, "#POSITION_Y#") + 12;
        iCount = FindSubString(GetSubString(sVector, iPos, iLen - iPos), "#");
        fY = StringToFloat(GetSubString(sVector, iPos, iCount));

        iPos = FindSubString(sVector, "#POSITION_Z#") + 12;
        iCount = FindSubString(GetSubString(sVector, iPos, iLen - iPos), "#");
        fZ = StringToFloat(GetSubString(sVector, iPos, iCount));
    }

    return Vector(fX, fY, fZ);
}

string APSLocationToString(location lLocation)
{
    object oArea = GetAreaFromLocation(lLocation);
    vector vPosition = GetPositionFromLocation(lLocation);
    float fOrientation = GetFacingFromLocation(lLocation);
    string sReturnValue;

    if (GetIsObjectValid(oArea))
        sReturnValue =
            "#AREA#" + GetTag(oArea) + "#POSITION_X#" + FloatToString(vPosition.x) +
            "#POSITION_Y#" + FloatToString(vPosition.y) + "#POSITION_Z#" +
            FloatToString(vPosition.z) + "#ORIENTATION#" + FloatToString(fOrientation) + "#END#";

    return sReturnValue;
}

location APSStringToLocation(string sLocation)
{
    location lReturnValue;
    object oArea;
    vector vPosition;
    float fOrientation, fX, fY, fZ;

    int iPos, iCount;
    int iLen = GetStringLength(sLocation);

    if (iLen > 0)
    {
        iPos = FindSubString(sLocation, "#AREA#") + 6;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        oArea = GetObjectByTag(GetSubString(sLocation, iPos, iCount));

        iPos = FindSubString(sLocation, "#POSITION_X#") + 12;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fX = StringToFloat(GetSubString(sLocation, iPos, iCount));

        iPos = FindSubString(sLocation, "#POSITION_Y#") + 12;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fY = StringToFloat(GetSubString(sLocation, iPos, iCount));

        iPos = FindSubString(sLocation, "#POSITION_Z#") + 12;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fZ = StringToFloat(GetSubString(sLocation, iPos, iCount));

        vPosition = Vector(fX, fY, fZ);

        iPos = FindSubString(sLocation, "#ORIENTATION#") + 13;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fOrientation = StringToFloat(GetSubString(sLocation, iPos, iCount));

        lReturnValue = Location(oArea, vPosition, fOrientation);
    }

    return lReturnValue;
}

// These functions are responsible for transporting the various data types back
// and forth to the database.

void SetPersistentString(object oObject, string sVarName, string sValue, int iExpiration =
                         0, string sTable = "pwdata")
{
    string sPlayer;
    string sTag;

    if (GetIsPC(oObject))
    {
        sPlayer = SQLEncodeSpecialChars(GetPCPlayerName(oObject));
        sTag = SQLEncodeSpecialChars(GetName(oObject));
    }
    else
    {
        sPlayer = "~";
        sTag = GetTag(oObject);
    }

    sVarName = SQLEncodeSpecialChars(sVarName);
    sValue = SQLEncodeSpecialChars(sValue);

    string sSQL = "SELECT player FROM " + sTable + " WHERE player='" + sPlayer +
        "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
    SQLExecDirect(sSQL);

    if (SQLFetch() == SQL_SUCCESS)
    {
        // row exists
        sSQL = "UPDATE " + sTable + " SET val='" + sValue +
            "',expire=" + IntToString(iExpiration) + " WHERE player='" + sPlayer +
            "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
        SQLExecDirect(sSQL);
    }
    else
    {
        // row doesn't exist
        sSQL = "INSERT INTO " + sTable + " (player,tag,name,val,expire) VALUES" +
            "('" + sPlayer + "','" + sTag + "','" + sVarName + "','" +
            sValue + "'," + IntToString(iExpiration) + ")";
        SQLExecDirect(sSQL);
    }
}

string GetPersistentString(object oObject, string sVarName, string sTable = "pwdata")
{
    string sPlayer;
    string sTag;

    if (GetIsPC(oObject))
    {
        sPlayer = SQLEncodeSpecialChars(GetPCPlayerName(oObject));
        sTag = SQLEncodeSpecialChars(GetName(oObject));
    }
    else
    {
        sPlayer = "~";
        sTag = GetTag(oObject);
    }

    sVarName = SQLEncodeSpecialChars(sVarName);

    string sSQL = "SELECT val FROM " + sTable + " WHERE player='" + sPlayer +
        "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
    SQLExecDirect(sSQL);

    if (SQLFetch() == SQL_SUCCESS)
        return SQLDecodeSpecialChars(SQLGetData(1));
    else
    {
        return "";
        // If you want to convert your existing persistent data to APS, this
        // would be the place to do it. The requested variable was not found
        // in the database, you should
        // 1) query it's value using your existing persistence functions
        // 2) save the value to the database using SetPersistentString()
        // 3) return the string value here.
    }
}

void SetPersistentInt(object oObject, string sVarName, int iValue, int iExpiration =
                      0, string sTable = "pwdata")
{
    SetPersistentString(oObject, sVarName, IntToString(iValue), iExpiration, sTable);
}

int GetPersistentInt(object oObject, string sVarName, string sTable = "pwdata")
{
    string sPlayer;
    string sTag;
    object oModule;

    if (GetIsPC(oObject))
    {
        sPlayer = SQLEncodeSpecialChars(GetPCPlayerName(oObject));
        sTag = SQLEncodeSpecialChars(GetName(oObject));
    }
    else
    {
        sPlayer = "~";
        sTag = GetTag(oObject);
    }

    sVarName = SQLEncodeSpecialChars(sVarName);

    string sSQL = "SELECT val FROM " + sTable + " WHERE player='" + sPlayer +
        "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
    SQLExecDirect(sSQL);

    oModule = GetModule();
    SetLocalString(oModule, "NWNX!ODBC!FETCH", "-2147483647");
    return StringToInt(GetLocalString(oModule, "NWNX!ODBC!FETCH"));
}

void SetPersistentFloat(object oObject, string sVarName, float fValue, int iExpiration =
                        0, string sTable = "pwdata")
{
    SetPersistentString(oObject, sVarName, FloatToString(fValue), iExpiration, sTable);
}

float GetPersistentFloat(object oObject, string sVarName, string sTable = "pwdata")
{
    string sPlayer;
    string sTag;
    object oModule;

    if (GetIsPC(oObject))
    {
        sPlayer = SQLEncodeSpecialChars(GetPCPlayerName(oObject));
        sTag = SQLEncodeSpecialChars(GetName(oObject));
    }
    else
    {
        sPlayer = "~";
        sTag = GetTag(oObject);
    }

    sVarName = SQLEncodeSpecialChars(sVarName);

    string sSQL = "SELECT val FROM " + sTable + " WHERE player='" + sPlayer +
        "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
    SQLExecDirect(sSQL);

    oModule = GetModule();
    SetLocalString(oModule, "NWNX!ODBC!FETCH", "-340282306073709650000000000000000000000.000000000");
    return StringToFloat(GetLocalString(oModule, "NWNX!ODBC!FETCH"));
}

void SetPersistentLocation(object oObject, string sVarName, location lLocation, int iExpiration =
                           0, string sTable = "pwdata")
{
    SetPersistentString(oObject, sVarName, APSLocationToString(lLocation), iExpiration, sTable);
}

location GetPersistentLocation(object oObject, string sVarName, string sTable = "pwdata")
{
    return APSStringToLocation(GetPersistentString(oObject, sVarName, sTable));
}

void SetPersistentVector(object oObject, string sVarName, vector vVector, int iExpiration =
                         0, string sTable = "pwdata")
{
    SetPersistentString(oObject, sVarName, APSVectorToString(vVector), iExpiration, sTable);
}

vector GetPersistentVector(object oObject, string sVarName, string sTable = "pwdata")
{
    return APSStringToVector(GetPersistentString(oObject, sVarName, sTable));
}

void SetPersistentObject(object oOwner, string sVarName, object oObject, int iExpiration =
                         0, string sTable = "pwobjdata")
{
    string sPlayer;
    string sTag;

    if (GetIsPC(oOwner))
    {
        sPlayer = SQLEncodeSpecialChars(GetPCPlayerName(oOwner));
        sTag = SQLEncodeSpecialChars(GetName(oOwner));
    }
    else
    {
        sPlayer = "~";
        sTag = GetTag(oOwner);
    }
    sVarName = SQLEncodeSpecialChars(sVarName);

    string sSQL = "SELECT player FROM " + sTable + " WHERE player='" + sPlayer +
        "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
    SQLExecDirect(sSQL);

    if (SQLFetch() == SQL_SUCCESS)
    {
        // row exists
        sSQL = "UPDATE " + sTable + " SET val=%s,expire=" + IntToString(iExpiration) +
            " WHERE player='" + sPlayer + "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
        SetLocalString(GetModule(), "NWNX!ODBC!SETSCORCOSQL", sSQL);
        StoreCampaignObject ("NWNX", "-", oObject);
    }
    else
    {
        // row doesn't exist
        sSQL = "INSERT INTO " + sTable + " (player,tag,name,val,expire) VALUES" +
            "('" + sPlayer + "','" + sTag + "','" + sVarName + "',%s," + IntToString(iExpiration) + ")";
        SetLocalString(GetModule(), "NWNX!ODBC!SETSCORCOSQL", sSQL);
        StoreCampaignObject ("NWNX", "-", oObject);
    }
}

object GetPersistentObject(object oObject, string sVarName, object oOwner = OBJECT_INVALID, string sTable = "pwobjdata")
{
    string sPlayer;
    string sTag;
    object oModule;

    if (GetIsPC(oObject))
    {
        sPlayer = SQLEncodeSpecialChars(GetPCPlayerName(oObject));
        sTag = SQLEncodeSpecialChars(GetName(oObject));
    }
    else
    {
        sPlayer = "~";
        sTag = GetTag(oObject);
    }
    sVarName = SQLEncodeSpecialChars(sVarName);

    string sSQL = "SELECT val FROM " + sTable + " WHERE player='" + sPlayer +
        "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
    SetLocalString(GetModule(), "NWNX!ODBC!SETSCORCOSQL", sSQL);

    if (!GetIsObjectValid(oOwner))
        oOwner = oObject;
    return RetrieveCampaignObject ("NWNX", "-", GetLocation(oOwner), oOwner);
}

void DeletePersistentVariable(object oObject, string sVarName, string sTable = "pwdata")
{
    string sPlayer;
    string sTag;

    if (GetIsPC(oObject))
    {
        sPlayer = SQLEncodeSpecialChars(GetPCPlayerName(oObject));
        sTag = SQLEncodeSpecialChars(GetName(oObject));
    }
    else
    {
        sPlayer = "~";
        sTag = GetTag(oObject);
    }

    sVarName = SQLEncodeSpecialChars(sVarName);
    string sSQL = "DELETE FROM " + sTable + " WHERE player='" + sPlayer +
        "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
    SQLExecDirect(sSQL);
}

// Problems can arise with SQL commands if variables or values have single quotes
// in their names. These functions are a replace these quote with the tilde character

string SQLEncodeSpecialChars(string sString)
{
    if (FindSubString(sString, "'") == -1)      // not found
        return sString;

    int i;
    string sReturn = "";
    string sChar;

    // Loop over every character and replace special characters
    for (i = 0; i < GetStringLength(sString); i++)
    {
        sChar = GetSubString(sString, i, 1);
        if (sChar == "'")
            sReturn += "~";
        else
            sReturn += sChar;
    }
    return sReturn;
}

string SQLDecodeSpecialChars(string sString)
{
    if (FindSubString(sString, "~") == -1)      // not found
        return sString;

    int i;
    string sReturn = "";
    string sChar;

    // Loop over every character and replace special characters
    for (i = 0; i < GetStringLength(sString); i++)
    {
        sChar = GetSubString(sString, i, 1);
        if (sChar == "~")
            sReturn += "'";
        else
            sReturn += sChar;
    }
    return sReturn;
}


NCS V1.0B  /                ����  ��������         �����  �................................................................................................................................#����  �������� $���� ���� ���:����  NWNX!ODBC!SPACER  �   9 ����  // Name     : Avlis Persistence System OnModuleLoad
// Purpose  : Initialize APS on module load event
// Authors  : Ingmar Stieger
// Modified : January 27, 2003

// This file is licensed under the terms of the
// GNU GENERAL PUBLIC LICENSE (GPL) Version 2

#include "aps_include"

void main()
{
    // Init placeholders for ODBC gateway
    SQLInit();
}

ARE V3.28      t   R   L  4   �  =   �  H  	     ����    *      �   
      �   
      �   
         
          ����      ����         
                         '   
      /                         	          
                       dd�                  22d                 22d       ���                  h~�                                        2           4B                                                                                     !          "         #         $   3      %   4      &   5      '   6      (   7      )         *         +         ,           -           .           /           0           1          2          3         *         +          ,           -           .           /           0           1          2          3         *         +         ,           -           .           /           0           1          2          3         *         +         ,           -           .           /           0           1          2          3      ID              Creator_ID      Version         Tag             Name            ResRef          Comments        Expansion_List  Flags           ModSpotCheck    ModListenCheck  MoonAmbientColorMoonDiffuseColorMoonFogAmount   MoonFogColor    MoonShadows     SunAmbientColor SunDiffuseColor SunFogAmount    SunFogColor     SunShadows      IsNight         LightingScheme  ShadowOpacity   FogClipDist     SkyBox          DayNightCycle   ChanceRain      ChanceSnow      ChanceLightning WindPower       LoadScreenID    PlayerVsPlayer  NoRest          Width           Height          OnEnter         OnExit          OnHeartbeat     OnUserDefined   Tileset         Tile_List       Tile_ID         Tile_OrientationTile_Height     Tile_MainLight1 Tile_MainLight2 Tile_SrcLight1  Tile_SrcLight2  Tile_AnimLoop1  Tile_AnimLoop2  Tile_AnimLoop3     Area001   ����          Area 001area001        tms01                            	   
                                                                      !   "   #   $   %   &   '   (   )   *   +   ,   -   .   /   0   1   2   3   4   5   6   7   8   9   :   ;   <   =   >   ?   @   A   B   C   D   E   F   G   H   I   J   K   L   M   N   O   P   Q                      GIC V3.28      D   	   �   	   @      @  $   d  $   ����    	                                                                                       Creature List   Door List       Encounter List  List            SoundList       StoreList       TriggerList     WaypointList    Placeable List                                                                  GIT V3.28      P      4     d      d  L   �  $   ����$   
   d       	                                                                   "                        	   �_    
                                                                                AreaProperties  AmbientSndDay   AmbientSndNight AmbientSndDayVolAmbientSndNitVolEnvAudio        MusicBattle     MusicDay        MusicNight      MusicDelay      Creature List   Door List       Encounter List  List            SoundList       StoreList       TriggerList     WaypointList    Placeable List                          	       
                                                               ITP V3.28     �  �  (:     �:  �%  M`    io  �  ����                                          $          4          D          T          d          l          t          |          �          �          �          �          �          �          �          �          �                            $         4         <         H         X         h         x         �         �         �         �         �         �         �         �                           (         8         H         X         h         x         �         �         �         �         �         �         �         �                           (         8         H         X         h         x         �         �         �         �         �         �         �         �         �         �         �                                                        (         0         8         @         H         P         X         `         l         |         �         �         �         �         �         �         �         �                           (         8         H         X         h         x         �         �         �         �         �         �         �         �                                                        ,         <         H         X         d         t         �         �         �         �         �         �         �         �         �                           $         4         D         T         d         t         �         �         �         �         �         �         �         �         �         �         �         �                           $         4         D         T         d         t         �         �         �         �         �         �         �         �         �         	         	         $	         4	         D	         T	         d	         t	         �	         �	         �	         �	         �	         �	         �	         �	         
         
         $
         4
         D
         T
         d
         t
         �
         �
         �
         �
         �
         �
         �
         �
                           $         4         D         T         d         t         �         �         �         �         �         �         �         �                           $         4         @         P         `         p         �         �         �         �         �         �         �         �                                     ,         <         L         \         l         |         �         �         �         �         �         �         �         �                                      0         @         P         \         l         |         �         �         �         �         �         �         �         �                               %                 �         0         L   
                           0A
      -   
      8         M           PA
      ^   
      i         �           �A
      �   
      �         �           �A
      �   
      �         �           A
              &        d         '                  (                  )                  *                  �          	         |   
                        �@
      ,  
      8        G          �@
      U        8                  �   
      a        y          �A
      �  
      �        �           A
      �  
      �        �          0A
      �  
      �                  0A
        
              1          0A
      B  
      N        a          0A
      r  
      ~        �          �A
      �        9                  :                  �   
      �        �          �A
      �  
      �                   @@
        
              2          �A
      >  
      J        c          @@
      p  
      |        �          `A
      �  
      �        �           @
      �  
      �        �          �@
      �  
                         @
      ,  
      8        P          �@
      \  
      h        �          �?
      �  
      �        �          �A
      �  
      �        �          @@
      �  
                         �A
      )  
      5        P          @@
      _  
      k        �          @A
      �  
      �        �           @
      �  
      �        �          �@
      �  
                         @
      +  
      7        Q          �@
      _  
      k        �           @
      �  
      �        �          �A
      �  
      �        �          @@
      �  
                        �A
      *  
      6        P           @
      ^  
      j        �          @A
      �  
      �        �           @
      �  
      �        �          �@
      �  
      �                   @
      "  
      .        G          @@
      T  
      _        x          �?
      �  
      �        �          �A
      �  
      �        �           @
      �  
      �        	          �A
      !	  
      -	        H	           @
      W	  
      c	        {	          @A
      �	  
      �	        �	           @
      �	  
      �	        �	          �@
      �	  
      �	        
           @
      #
  
      /
        I
          �@
      W
  
      c
        }
           @
      �
                L        G         "         H         #         I         $         J         %         1        `        2                  3                  4                  5                  6                                    �          2         ,        �        -         
         .                  �         1         8                  ;        �        <                  �  
      �
        �
          0A
      �
  
      �
        �
          �@
      �
        =                  �  
      �
        �
          pA
        
                         �A
      ,  
      8        E          A
      Q  
      ]        h           A
      p  
      |        �           A
      �  
      �        �          @A
      �  
      �        
          pA
        
      '        C          �A
      T  
      `        u          A
      �  
      �        �          0A
      �  
      �        �          @A
      �  
      �                  pA
        
      (        @           A
      Q  
      ]        u          @A
      �  
      �        �          `A
      �  
      �        �          �A
      �  
      �                  �@
        
               6          �A
      F  
      R        j          A
      {  
      �        �          0A
      �  
      �        �          PA
      �  
      �        	          pA
              >                  +         /         ?                  /                  #                
                  ,  
      &        @          �A
      M        B                  4  
      X        r          �A
              �                   <  
      �        �          �A
      �  
      �        �          �A
      �  
      �        
          B
        
      "        ?          �A
      M  
      Y        s          �A
      �  
      �        �           A
      �  
      �        �          �A
      �  
      �        �          �A
        
                         �A
      0        D                  C                  d  
      <        Y          �A
      g        k                   l  
      s        �          B
      �  
      �        �          B
      �  
      �        �          (B
        
              5          �A
      F  
      R        m          �A
      ~  
      �        �          �A
      �  
      �        �          �A
      �        E         !         �  
      �                  PA
      "  
      .        G          PA
      U        K        �                  &                   '                   (                   *                   )         !          +         #          ,         �  
      a        m          �@
      {  
      �        �          A
      �  
      �        �          �A
      �  
      �        �          �@
        
              ,          �A
      ;  
      G        \          �A
      k  
      w        �          @A
      �  
      �        �           B
      �  
      �        �          �A
        
              !          �A
      0        �          -         �        2        <          @@
      J        2        U          @@
      c        2        n          �@
      |  
      �        �          �@
      �                �                                    ��       �           @
      �        ��       �           @
      �        ��       �          �@
      �        ��       �          �@
              ��                 �@
      &        ��       1          �@
      B        ��       M          �@
      ]        ��       h          �@
      y        ��       �           A
      �        ��       �          A
      �        ��       �           A
      �        ��       �           A
      �        ��       �          @A
              ��                 PA
              ��       *          PA
      ;        ��       F          pA
      V        ��       a          pA
      r        ��       }          �A
      �        ��       �          �A
      �        ��       �          �A
      �        ��       �          �A
      �        ��       �          �A
      �        ��                 �A
              ��       $          �A
      4        ��       ?          �A
      P        ��       [          �A
      l        ��       w          �A
      �  
      �        �           >
      �  
      �        �           A
      �  
      �                   0A
        
              4          A
      A  
      M        j           A
      w  
      �        �          `A
      �  
      �        �          @A
      �  
      �                   @
        
              7          �@
      D  
      P        n          �@
      {  
      �        �          `A
      �  
      �        �          pA
      �  
      �                  �@
        
      '        G          �@
      T  
      `        r           >
      �  
      �        �           A
      �  
      �        �          0A
      �  
      �        �          �@
        
              %          �@
      2  
      >        R          `A
      c  
      o        �          �A
      �  
      �        �          �@
      �  
      �        �          @@
      �  
      �        	          @A
              !                  �  
      $        B          �A
      Q  
      ]        t           @
      �  
      �        �           A
      �  
      �        �          �@
      �  
      �        
          A
        
      $        9          �@
      G  
      S        k          @A
      y  
      �        �          `A
      �  
      �        �          pA
      �  
      �                  �@
        
      "        6          �@
      D  
      P        m          0A
      {        "                    
      �        �          @@
      �  
      �        �          pA
      �  
      �        
           �@
         
      $         C           @A
      Q   
      ]         }           �A
      �   
      �         �           PA
      �   
      �         �           �@
      �   
      !        !          �@
      #!  
      /!        J!           A
      X!  
      d!        !           A
      �!  
      �!        �!          �A
      �!  
      �!        �!           A
      �!        #                  $                  L  
      	"        !"          B
      ,"  
      8"        X"          (B
      c"  
      o"        �"          �A
      �"  
      �"        �"          �A
      �"  
      �"        �"          �A
      �"  
      #         #          �A
      +#  
      7#        A#          ,B
      H#        L         .         l  
      T#        n#           A
      |#  
      �#        �#          �@
      �#  
      �#        �#           A
      �#  
      �#        �#          A
      $  
      $        0$          �@
      >$  
      J$        i$          �A
      x$  
      �$        �$          `A
      �$  
      �$        �$           @
      �$  
      �$        �$          pA
      %  
      %        *%          PA
      8%  
      D%        \%          @A
      j%  
      v%        �%          �@
      �%  MAIN            STRREF          LIST            ID              NAME            RESREF          CR              FACTION            Summoned Battle Devourerep_summonaberat5   Hostile   Summoned Beholderep_summonaberat2   Hostile   Summoned Drider Chiefep_summonaberat1   Hostile   Summoned Mind Flayer Darkenerep_summonaberat3   Hostile   Summoned Umber Hulkep_summonaberat4   Hostile   Winter Wolfacomep_winwolf   Defender   Winter Wolfacomp_winwolf   Defender   Animated Bone Tyrantprc_sum_bonet   Commoner   Animated Objectanim_armour_0   Defender   Animated Objectanim_armour_1_4   Defender   Animated Objectanim_armour_5_8   Defender   Animated Objectanim_weapon_larg   Defender   Animated Objectanim_weapon_smal   Defender   Sphere of Ultimate Destructionsp_sphereofud   Merchant   Air Elemental Elderhen_air_eld   Defender   Air Elemental Elderhen_air_eld2   Defender   Air Elemental Greaterhen_air_gre   Defender   Air Elemental Greaterhen_air_gre2   Defender   Air Elemental Hugehen_air_hug   Defender   Air Elemental Hugehen_air_hug2   Defender   Air Elemental Largehen_air_lar   Defender   Air Elemental Largehen_air_lar2   Defender   Air Elemental Mediumhen_air_med   Defender   Air Elemental Mediumhen_air_med2   Defender   Earth Elemental Elderhen_earth_eld   Defender   Earth Elemental Elderhen_earth_eld2   Defender   Earth Elemental Greaterhen_earth_gre   Defender   Earth Elemental Greaterhen_earth_gre2   Defender   Earth Elemental Hugehen_earth_hug   Defender   Earth Elemental Hugehen_earth_hug2   Defender   Earth Elemental Largehen_earth_lar   Defender   Earth Elemental Largehen_earth_lar2   Defender   Earth Elemental Mediumhen_earth_med   Defender   Earth Elemental Mediumhen_earth_med2   Defender   Fire Elemental Elderhen_fire_eld   Defender   Fire Elemental Elderhen_fire_eld2   Defender   Fire Elemental Greaterhen_fire_gre   Defender   Fire Elemental Greaterhen_fire_gre2   Defender   Fire Elemental Hugehen_fire_hug   Defender   Fire Elemental Hugehen_fire_hug2   Defender   Fire Elemental Largehen_fire_lar   Defender   Fire Elemental Largehen_fire_lar2   Defender   Fire Elemental Mediumhen_fire_med   Hostile   Fire Elemental Mediumhen_fire_med2   Hostile   Water Elemental Elderhen_water_eld   Defender   Water Elemental Elderhen_water_eld2   Defender   Water Elemental Greaterhen_water_gre   Defender   Water Elemental Greaterhen_water_gre2   Defender   Water Elemental Hugehen_water_hug   Defender   Water Elemental Hugehen_water_hug2   Defender   Water Elemental Largehen_water_lar   Defender   Water Elemental Largehen_water_lar2   Defender   Water Elemental Mediumhen_water_med   Defender   Water Elemental Mediumhen_water_med2   Defender   Celestial Avengercouncil_npca   Commoner   Hound Archoncouncil_npcb   Commoner   Balorfiendw_npcb   Commoner   Daemon Brutebaalsummon2   Commoner	   Daemonessbaalsummon1   Commoner   Erinyeserinyes   Commoner   Monstrous Spider Servantch_dj_monstspid1   Merchant   Monstrous Spider Servantch_dj_monstspid2   Merchant   Monstrous Spider Servantch_dj_monstspid3   Merchant   Monstrous Spider Servantch_dj_monstspid4   Merchant   Myrlochar Servantch_dj_myrlochar1   Merchant   Myrlochar Servantch_dj_myrlochar2   Merchant   Myrlochar Servantch_dj_myrlochar3   Merchant   Myrlochar Servantch_dj_myrlochar4   Merchant   Phase Spider Servantch_dj_phasespid1   Merchant   Phase Spider Servantch_dj_phasespid2   Merchant   Phase Spider Servantch_dj_phasespid3   Merchant   Phase Spider Servantch_dj_phasespid4   Merchant   Succubusfiendw_npca   Commoner   Summoned Pit Fiendtwinfiend_demon   Commoner   Sword Spider Servantch_dj_swordspid1   Merchant   Sword Spider Servantch_dj_swordspid2   Merchant   Sword Spider Servantch_dj_swordspid3   Merchant   Sword Spider Servantch_dj_swordspid4   Merchant   Animated Ghoul Ravagerprc_sum_grav   Hostile   Greater Mummy of Orcusprc_to_mummy   Hostile   Animated Blood Warriorprc_sum_vamp1   Commoner   Animated Doombringer
prc_sum_dk   Commoner   Animated Doombringer Lordprc_sum_dbl   Commoner   Animated Emperor of Bloodprc_sum_vamp2   Commoner   Animated Grey Warrior prc_sum_wight   Commoner   Animated Mohrgprc_sum_mohrg   Commoner   Mohrg of Orcusprc_to_mohrg   Hostile	   Nightwingprc_to_nightwing   Commoner   Unholy Discipleunholy_disciple   Commoner   Animated Skeletal Ravagerprc_sum_sklch   Commoner   Summoned Epic Wraithsummonedgreat004   Merchant   Summoned Epic Wraithsummonedgreat005   Merchant   Summoned Greater Epic Wraithsummonedgreat006   Merchant   Summoned Greater Wraithsummonedgreat001   Merchant   Summoned Greater Wraithsummonedgreat002   Merchant   Summoned Greater Wraithsummonedgreat003   Merchant   Summoned Greater Wraithsummonedgreaterw   Merchant   Animated Festering Thugprc_tn_fthug   Commoner   Animated Rotting Lordprc_sum_zlord   Commoner   Rashemenprc_hath_rash   Commoner   Rashemen Beserkerprc_hath_rash3   Commoner   Rashemen Bodyguardprc_hath_rash6   Commoner   Rashemen Brawlerprc_hath_rash2   Commoner   Rashemen Defenderprc_hath_rash5   Commoner   Rashemen Guardianprc_hath_rash7   Commoner   Rashemen Lordprc_hath_rash4   Commoner   Rashemen Perfected Oneprc_hath_rash10   Commoner   Rashemen Thunderguardprc_hath_rash9   Commoner   Rashemen Warlordprc_hath_rash8   Commonerprc_s_wolf002   Hostileprc_s_wolf003   Hostileprc_s_wolf004   Hostile   Wolfprc_s_wolf005   Hostilepsi_astral_con1   Hostilepsi_astral_con1a   Hostilepsi_astral_con2   Hostilepsi_astral_con2a   Hostilepsi_astral_con3   Hostilepsi_astral_con3a   Hostilepsi_astral_con4   Hostilepsi_astral_con4a   Hostilepsi_astral_con4b   Hostilepsi_astral_con5   Hostilepsi_astral_con5a   Hostilepsi_astral_con5b   Hostilepsi_astral_con6   Hostilepsi_astral_con6a   Hostilepsi_astral_con6b   Hostilepsi_astral_con7   Hostilepsi_astral_con7a   Hostilepsi_astral_con7b   Hostilepsi_astral_con7c   Hostilepsi_astral_con8   Hostilepsi_astral_con8a   Hostilepsi_astral_con8b   Hostilepsi_astral_con8c   Hostilepsi_astral_con9   Hostilepsi_astral_con9a   Hostilepsi_astral_con9b   Hostilepsi_astral_con9c   Hostile   Epic Templateepicshifterliste   Commoner   Hamatulahamatula   Commoner   Horde Orc Axe Battlemasterow_sum_axe_8   Commoner   Horde Orc Axe Commanderow_sum_axe_6   Commoner   Horde Orc Axe Legionnaireow_sum_axe_7   Commoner   Horde Orc Axe Myrmidonow_sum_axe_10   Commoner   Horde Orc Axe Ravagerow_sum_axe_9   Commoner   Horde Orc Axethrowerow_sum_axe_1   Commoner   Horde Orc Elite Axetosserow_sum_axe_4   Commoner   Horde Orc Greater Marksmanow_sum_axe_5   Commoner   Horde Orc Gruumsh's Axeow_sum_axe_11   Commoner   Horde Orc Gruumsh's Chosen Axeow_sum_axe_12   Commoner   Horde Orc Marksmanow_sum_axe_3   Commoner   Horde Orc Trained Axethrowerow_sum_axe_2   Commoner   Magic Templateshifterlistenero   Commoner   Summoned Allipprc_mos_allip   Merchant   Summoned Balor	tog_balor   Hostile   Summoned Glabrezutog_glabrezu   Commoner   Summoned Marilithtog_marilith   Commoner   Summoned Spectreprc_mos_spectre1   Merchant   Summoned Spectreprc_mos_spectre2   Merchant   Summoned Succubustog_succubus   Defender   Summoned Vrock	tog_vrock   Commoner   Summoned Wraithprc_mos_wraith   Merchant   Horde Orc Bahgtru's Chosenow_sum_barb_12   Commoner   Horde Orc Barbarianow_sum_barb_1   Commoner   Horde Orc Battle Chargerow_sum_barb_7   Commoner   Horde Orc Beserkerow_sum_barb_4   Commoner   Horde Orc Breacherow_sum_barb_6   Commoner   Horde Orc Chargerow_sum_barb_3   Commoner   Horde Orc Elf Slayerow_sum_barb_9   Commoner   Horde Orc Greater Ragerow_sum_barb_10   Commoner   Horde Orc Killer of Bahgtruow_sum_barb_11   Commoner   Horde Orc Ragerow_sum_barb_5   Commoner   Horde Orc Savageow_sum_barb_2   Commoner   Horde Orc Warrior of Hateow_sum_barb_8   Commoner   Horde Orc Acolyteow_sum_sham_1   Commoner!   Horde Orc Battlepriest of Ilnevalow_sum_sham_10   Commoner   Horde Orc Deaconow_sum_sham_2   Commoner   Horde Orc Elder Witchdoctorow_sum_sham_8   Commoner   Horde Orc General of Ilnevalow_sum_sham_12   Commoner   Horde Orc Preacher of Ilnevalow_sum_sham_9   Commoner   Horde Orc Priestow_sum_sham_4   Commoner   Horde Orc Shamanow_sum_sham_3   Commoner   Horde Orc Spirit Shamanow_sum_sham_7   Commoner   Horde Orc Tribal Priestow_sum_sham_6   Commoner   Horde Orc Warleader of Ilnevalow_sum_sham_11   Commoner   Horde Orc Witchdoctorow_sum_sham_5   Commoner   Summoned Epic Wraith
prc_mos_33   Merchant   Summoned Greater Epic Wraith
prc_mos_39   Merchant   Summoned Greater Wraith
prc_mos_21   Merchant   Summoned Greater Wraith
prc_mos_24   Merchant   Summoned Greater Wraith
prc_mos_27   Merchant   Summoned Greater Wraith
prc_mos_30   Merchant   Xag-Yaxagya2   Defender   Horde Orc Battlemasterow_sum_fght_7   Commoner   Horde Orc Bodyguardow_sum_fght_3   Commoner   Horde Orc Captainow_sum_fght_5   Commoner   Horde Orc Centurionow_sum_fght_6   Commoner   Horde Orc Chieftainow_sum_fght_4   Commoner   Horde Orc Chosen of Gruumshow_sum_fght_12   Commoner   Horde Orc Emperorow_sum_fght_10   Commoner   Horde Orc Fighterow_sum_fght_1   Commoner   Horde Orc Gruumsh Handow_sum_fght_11   Commoner   Horde Orc Kingow_sum_fght_9   Commoner   Horde Orc War Leaderow_sum_fght_8   Commoner   Horde Orc Warriorow_sum_fght_2   Commoner                        	   
                                                                      !   "   #   $   %   &   '   (   )   *   +   ,   -   .   /   0   1   2   3   4   5   6   7   8   9   :   ;   <   =   >   ?   @   A   B   C   D   E   F   G   H   I   J   K   L   M   N   O   P   Q   R   S   T   U   V   W   X   Y   Z   [   \   ]   ^   _   `   a   b   c   d   e   f   g   h   i   j   k   l   m   n   o   p   q   r   s   t   u   v   w   x   y   z   {   |   }   ~      �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �                      	  
                                               !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /  0  1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ?  @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  [  \  ]  ^  _  `  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  {  |  }  ~    �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �                     	  
                                               !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /  0  1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ?  @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  [  \  ]  ^  _  `  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  {  |  }  ~    �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �                     	  
                                               !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /  0  1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ?  @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  [  \  ]  ^  _  `  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  {  |  }  ~    �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �        �   �   �                     B   G   O   R   S   T   r   s                        	   
                                             (                         !   "   #   $   %   &   '   (   )   *   +   ,   -   .   /   0   1   2   3   4   5   6   7   8   9   :   ;   <   =   >   ?   @   A      C   D   E   F      H   I   J   K   L   M   N      P   Q      U   X   o   p   q      V   W      Y   Z   [   \   ]   ^   _   `   a   b   c   d   e   f   g   h   i   j   k   l   m   n      t   v   x   �   �   �   �      u      w   	   y   z   {   |   }   ~      �   �      �      �   �   �   �   �   �   �      �   �      �   �   �   �   �   �   �   �   
   �   �   �   �   �   �   �   �   �   �      �   �   �   �      �   �   �   �   �   3   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �      �   �   �   �   �   �   �   �   �   �   �   �      �   �   �   �   �   �   �   �   �   �   �   �      �   �   �   �   �   �   �                         	  
    ITP V3.28      �      �             X   t  8   ����                                                               (          0          8          @          H          P                                                            !                  "                  #                  $                  N                  O        (         P                  Q                  R            MAIN            STRREF          LIST            ID                                      	   
                                                                        	   
      ITP V3.28      �      �             X   t  4   ����                                                               (          0          8          @          H          P                       �                  �         	         �                  �                                                       !                  "                  #                  $                  �            MAIN            STRREF          ID              LIST                                    	   
                                                                        	   
   NCS V1.0B  k         ����  ����  �����  ����  �����  ����  �����  ����  �����  ����  �����  ����*     +  ����  ���� @�  !    O,              A  ����   ���� ?�  !����  ���� ���� ����   DoOnce      3"    '    DoOnce      7     Done      3       �     Ability      3����  ��������  =<file:open OBJECT 'C:/stuff/Moneo-23beta2/prc_ip86_base.uti'>#����  ���� 	PRC_ip86_����   \#����  ��������  <gff:set 'TemplateResRef' '����   =# '>##����  ��������  <gff:set 'LocalizedName' '���� # '>##����  ��������  <gff:set 'Tag' '���� # '>##����  ����   ����  ��������    (    �����  ><gff:add 'PropertiesList/PropertyName' {type=word value='86'}>#����  ��������  8<gff:add 'PropertiesList/[_]/Subtype' {type=word value='����   \# '}>##����  ��������  ?<gff:add 'PropertiesList/[_]/CostTable' {type=byte value='28'}>#����  ��������  :<gff:add 'PropertiesList/[_]/CostValue' {type=word value='����   \# '}>##����  ��������  =<gff:add 'PropertiesList/[_]/Param1' {type=byte value='255'}>#����  ��������  @<gff:add 'PropertiesList/[_]/Param1Value' {type=byte value='0'}>#����  ��������  C<gff:add 'PropertiesList/[_]/ChanceAppear' {type=byte value='100'}>#����  �������� $���� ���� ���3����  *<file:save OBJECT 'C:/stuff/Moneo-23beta2/����   =# .uti'>##����  ��������  <file:close OBJECT>#����  �������� $���� ����   SCRIPT����     x ��������         6    Done      7 FINISHED 0    ����  Ability      7 ����  ����   >: #���� #   ����  
NWNX!LETO!���� #  �   9 
NWNX!LETO!���� #  �   5����  ��������   <: #���� #    �����  SPAWN#    ?,          ���� ����     ^  ?�        ���� ����  ����     ���� ���� ����  ����  0 ����   
StopThread���� #  �   3           �     	Polling: ���� # ����   POLL����  #                                   # #                                   # #                                   # #                                   # #                                   # #                                   # #                                   # #                                   # #                                   # ��������  ��������  Error: ���� # 
 not done.##    K,          ���� ����  ����  ?�     ����    �    �-  Poll: Executing: ���� # ���Z    
StopThread���� #  �   7,          * 
StopThread���� #  �  	  @�        ����    ���� ����  #include "inc_fileends"
#include "inc_letoscript"
#include "inc_utility"

void DoHB()
{
    if(!GetLocalInt(OBJECT_SELF, "DoOnce"))
    {
        SetLocalInt(OBJECT_SELF, "DoOnce", TRUE);
    }
    if(GetLocalInt(OBJECT_SELF, "Done"))
        return;
    int nAbility = GetLocalInt(OBJECT_SELF, "Ability");
    string sScript;
    sScript += "<file:open OBJECT 'C:/stuff/Moneo-23beta2/prc_ip86_base.uti'>";
    int nLevel;
    string sTag = "PRC_ip86_"+IntToString(nAbility);
    sScript += "<gff:set 'TemplateResRef' '"+GetStringLowerCase(sTag)+"'>";
    sScript += "<gff:set 'LocalizedName' '"+sTag+"'>";
    sScript += "<gff:set 'Tag' '"+sTag+"'>";
    for(nLevel = 1; nLevel <=40; nLevel++)
    {
        sScript += "<gff:add 'PropertiesList/PropertyName' {type=word value='86'}>";
        sScript += "<gff:add 'PropertiesList/[_]/Subtype' {type=word value='"+IntToString(nAbility)+"'}>";
        sScript += "<gff:add 'PropertiesList/[_]/CostTable' {type=byte value='28'}>";
        sScript += "<gff:add 'PropertiesList/[_]/CostValue' {type=word value='"+IntToString(nLevel)+"'}>";
        sScript += "<gff:add 'PropertiesList/[_]/Param1' {type=byte value='255'}>";
        sScript += "<gff:add 'PropertiesList/[_]/Param1Value' {type=byte value='0'}>";
        sScript += "<gff:add 'PropertiesList/[_]/ChanceAppear' {type=byte value='100'}>";
    }
    sScript += "<file:save OBJECT 'C:/stuff/Moneo-23beta2/"+GetStringLowerCase(sTag)+".uti'>";
    sScript += "<file:close OBJECT>";

    nAbility++;
    LetoScript(sScript);
    if(nAbility > 5)
    {
        SetLocalInt(OBJECT_SELF, "Done", TRUE);
        WriteTimestampedLogEntry("FINISHED");
    }
    SetLocalInt(OBJECT_SELF, "Ability", nAbility);
}

void main()
{
    float fDelay;
    while(fDelay < 6.0)
    {
        DelayCommand(fDelay, DoHB());
        fDelay += 1.0;
    }
}
/*void main()
{
#include "inc_fileends"
#include "inc_letoscript"
#include "inc_utility"

void DoHB()
{
    if(!GetLocalInt(OBJECT_SELF, "DoOnce"))
    {
        SetLocalInt(OBJECT_SELF, "DoOnce", TRUE);
    }
    if(GetLocalInt(OBJECT_SELF, "Done"))
        return;
    int bDoSpell = TRUE;;
    int nSpell = GetLocalInt(OBJECT_SELF, "Spell");
    if(Get2DACache("spells", "Bard", nSpell)==""
        && Get2DACache("spells", "Cleric", nSpell)==""
        && Get2DACache("spells", "Druid", nSpell)==""
        && Get2DACache("spells", "Paladin", nSpell)==""
        && Get2DACache("spells", "Ranger", nSpell)==""
        && Get2DACache("spells", "Wiz_Sorc", nSpell)=="")
        bDoSpell = FALSE;
    if(bDoSpell)
    {
        string sScript;
        sScript += "<file:open OBJECT 'C:/stuff/Moneo-23beta2/prc_ip85_0_1.uti'>";
        int nLevel;
        string sTag = "PRC_ip85_"+IntToString(nSpell);
        sScript += "<gff:set 'TemplateResRef' '"+GetStringLowerCase(sTag)+"'>";
        sScript += "<gff:set 'LocalizedName' '"+sTag+"'>";
        sScript += "<gff:set 'Tag' '"+sTag+"'>";
        for(nLevel = 1; nLevel <=40; nLevel++)
        {
            sScript += "<gff:add 'PropertiesList/PropertyName' {type=word value='85'}>";
            sScript += "<gff:add 'PropertiesList/[_]/Subtype' {type=word value='"+IntToString(nSpell)+"'}>";
            sScript += "<gff:add 'PropertiesList/[_]/CostTable' {type=byte value='28'}>";
            sScript += "<gff:add 'PropertiesList/[_]/CostValue' {type=word value='"+IntToString(nLevel)+"'}>";
            sScript += "<gff:add 'PropertiesList/[_]/Param1' {type=byte value='255'}>";
            sScript += "<gff:add 'PropertiesList/[_]/Param1Value' {type=byte value='0'}>";
            sScript += "<gff:add 'PropertiesList/[_]/ChanceAppear' {type=byte value='100'}>";
        }
        sScript += "<file:save OBJECT 'C:/stuff/Moneo-23beta2/"+GetStringLowerCase(sTag)+".uti'>";
        sScript += "<file:close OBJECT>";

        LetoScript(sScript);
    }
    nSpell++;
    if(nSpell > 3200)
    {
        SetLocalInt(OBJECT_SELF, "Done", TRUE);
        WriteTimestampedLogEntry("FINISHED");
    }
    SetLocalInt(OBJECT_SELF, "Spell", nSpell);
}

void main()
{
    float fDelay;
    while(fDelay < 6.0)
    {
        DelayCommand(fDelay, DoHB());
        fDelay += 0.01;
    }
}
}
/*void main()
{
#include "inc_fileends"
#include "inc_letoscript"
#include "inc_utility"

void DoHB()
{
    if(!GetLocalInt(OBJECT_SELF, "DoOnce"))
    {
        SetLocalInt(OBJECT_SELF, "DoOnce", TRUE);
    }
    if(GetLocalInt(OBJECT_SELF, "Done"))
        return;
    int bDoSpell = TRUE;;
    int nSpell = GetLocalInt(OBJECT_SELF, "Spell");
    if(Get2DACache("spells", "Bard", nSpell)==""
        && Get2DACache("spells", "Cleric", nSpell)==""
        && Get2DACache("spells", "Druid", nSpell)==""
        && Get2DACache("spells", "Paladin", nSpell)==""
        && Get2DACache("spells", "Ranger", nSpell)==""
        && Get2DACache("spells", "Wiz_Sorc", nSpell)=="")
        bDoSpell = FALSE;
    if(bDoSpell)
    {
        string sScript;
        sScript += "<file:open OBJECT 'C:/stuff/Moneo-23beta2/prc_ip92_base.uti'>";
        int nMetmagic;
        string sTag = "PRC_ip92_"+IntToString(nSpell);
        sScript += "<gff:set 'TemplateResRef' '"+GetStringLowerCase(sTag)+"'>";
        sScript += "<gff:set 'LocalizedName' '"+sTag+"'>";
        sScript += "<gff:set 'Tag' '"+sTag+"'>";
        for(nMetmagic = 0; nMetmagic <=6; nMetmagic++)
        {
            sScript += "<gff:add 'PropertiesList/PropertyName' {type=word value='92'}>";
            sScript += "<gff:add 'PropertiesList/[_]/Subtype' {type=word value='"+IntToString(nSpell)+"'}>";
            sScript += "<gff:add 'PropertiesList/[_]/CostTable' {type=byte value='29'}>";
            sScript += "<gff:add 'PropertiesList/[_]/CostValue' {type=word value='"+IntToString(nMetmagic)+"'}>";
            sScript += "<gff:add 'PropertiesList/[_]/Param1' {type=byte value='255'}>";
            sScript += "<gff:add 'PropertiesList/[_]/Param1Value' {type=byte value='0'}>";
            sScript += "<gff:add 'PropertiesList/[_]/ChanceAppear' {type=byte value='100'}>";
        }
        sScript += "<file:save OBJECT 'C:/stuff/Moneo-23beta2/"+GetStringLowerCase(sTag)+".uti'>";
        sScript += "<file:close OBJECT>";

        LetoScript(sScript);
    }
    nSpell++;
    if(nSpell > 3200)
    {
        SetLocalInt(OBJECT_SELF, "Done", TRUE);
        WriteTimestampedLogEntry("FINISHED");
    }
    SetLocalInt(OBJECT_SELF, "Spell", nSpell);
}

void main()
{
    float fDelay;
    while(fDelay < 6.0)
    {
        DelayCommand(fDelay, DoHB());
        fDelay += 0.01;
    }
}
}
#include "aps_include"
//constants defining directories
//must be changed to each install
//alternativly it will use a local string on the module named NWN_DIR if set
//in preference to the constant
const string NWN_DIR = "C:/NeverwinterNights/NWN/";
const string MOD_DIR = "hak/RIG/";
const string DB_NAME = "NWNXLeto";
const string DB_GATEWAY_VAR = "NWNXLeto";
const string WP_LIMBO = "";

//set this to true if using build 18 or earlier of letoscript.dll
const int PHEONIX_SYNTAX = TRUE;

/*YOU MUST ADD THE FOLLOWING TO YOUR ON CLIENT EXIT EVENT

    object oPC = GetExitingObject();
    LetoPCExit(oPC);

*/

//Script Types
//taken from the build03.18 release notes
/*
SCRIPT, taking a LetoScript script as a parameter. Example:

void main()
{
    SendMessageToAllDMs("Firing LetoScript test...");

    string LetoTest;
    SetLocalString(GetModule(), "NWNX!LETO!SCRIPT", "<file:open BOB 'g:/nwn/localvault/bob.bic'><FirstName> <LastName>");
    LetoTest = GetLocalString(GetModule(), "NWNX!LETO!SCRIPT");

    SendMessageToAllDMs("Result: #" + LetoTest + "#");
}


SPAWN, taking a LetoScript script as a parameter. Unlike SCRIPT, this
creates a new thread that runs (simultaneously) in the background while
your server goes on doing its business. Running a SCRIPT that takes 10
seconds to complete means your server will hang for 10 seconds while it
waits for the script to complete. Running the same script as a SPAWN means
the server doesn't hang at all, but the script runs "in the background"
instead (and still takes 10 seconds to complete). The result you get back
from SPAWN is the ThreadId created for your script. Record it! Unless you
POLL for that ThreadId, the thread will hang around indefinitely, costing
system resources, until NWNX is shut down. Note that SPAWN does not share
the state that SCRIPT maintains. That is, you cannot operate on a handle
that you have previously opened in a SCRIPT. (In fact, allowing SPAWN and
QFORGET to share state with SCRIPT could have disastrous consequences, and
force scripters using NWNX-Leto to write "thread safe" LetoScript!)

POLL, taking a ThreadId as a parameter. The result will tell you whether
this thread is still working, or has completed. You will get one of three
results: "Error: ### not done." (### is your ThreadId) if the thread is
still working, "Error: ..." for some other error (... is the exact error),
or you will not get "Error:" at the beginning of the string, and instead
you will get the result of your script. ZombieBench provides a very good
example of how to use POLL correctly.

QFORGET, taking a LetoScript script as a parameter. This is a "Queue and
Forget" version of SPAWN. Like SPAWN, the script is queued (it will not
run until all previous SPAWN and QFORGET scripts have completed), but you
cannot POLL for a QFORGET thread, and upon completion the thread is
automatically terminated. You would use QFORGET when you want to multithread
a script, but you don't care what the results are, and you don't need to
wait for it to complete to do something else (such as RCO). There is no
result from QFORGET (just an empty string).

FFORGET, taking a LetoScript script as a parameter. This is the "Fire and
Forget" version of SPAWN, but unlike QFORGET, the thread is created and
the script run immediately, rather than being put at the end of the queue.
Although this sounds like a tempting alternative to QFORGET for a script
you want completed quickly, EXTREME CAUTION must be exercised when using
FFORGET. It is unstable and prone to cause exceptions in the script it
runs. There should be no danger to NWNX itself - although even that isn't
a guarantee.
*/

//instanty runs the letoscript sScript
//for sType see abive
//if sType is POLL, PollThread is atomatically started
//and sPollScript is passed as the script name
string LetoScript(string sScript, string sType = "SCRIPT", string sPollScript = "");

//This command adds the script to the cuttent superscript
//to run the superscript use StackedLetoScripRun
void StackedLetoScript(string sScript);

//poll an existing thread
//when the thread is finished, script sScript is run
void PollThread(string sThreadID, string sScript);

//credit to demux
//gets a bicpath of a pc
//must be servervault to work
string GetBicPath(object oPC);

//credit to demux
//gets the filename of a PCs bic
//must be servervault
string GetBicFileName(object oPC);

//This will automatically add the required code before and after, and will
//adapt based on PC/NPC/etc.
//This overwites the existing object which will break stored references
//such as henchmen. The new object is returned.
//the result of the script is stored on the module in LetoResult for 1 second
//if nDestroyOriginal is set then PCs will be booted and non-pcs will be destroyed
object RunStackedLetoScriptOnObject(object oObject, string sLetoTag = "OBJECT",    string sType = "SCRIPT", string sPollScript = "", int nDestroyOriginal = TRUE);

const int DEBUG = TRUE;

void DoDebug(string s)
{
    WriteTimestampedLogEntry(s);
}

string GetNWNDir()
{
    string sReturn = GetLocalString(GetModule(), "NWN_DIR");
    if(sReturn == "")
        sReturn = NWN_DIR;
    return sReturn;
}

//credit to demux
string GetBicFileName(object oPC)
{
    string sChar, sBicName;
    string sPCName = GetStringLowerCase(GetName(oPC));
    int i, iNameLength = GetStringLength(sPCName);

    for(i=0; i < iNameLength; i++) {
        sChar = GetSubString(sPCName, i, 1);
        if (TestStringAgainstPattern("(*a|*n|*w|'|-|_)", sChar)) {
            if (sChar != " ") sBicName += sChar;
        }
    }
    return GetStringLeft(sBicName, 16);
}

//credit to demux
string GetBicPath(object oPC)
{
    // Gets a local var stored on oPC on "event client enter". I do this because
    // "on even client leave", function GetPCPlayerName() can not be used. Since
    // a .bic file can not be changed while the owner is logged in, it is typical
    // to execute leto scripts when the client leaves (on event client leave).
    string PlayerName = GetLocalString(oPC, "PlayerName");
    if(PlayerName == "")
        PlayerName = GetPCPlayerName(oPC);

    // Retruns the full path to a .bic file.
    return GetNWNDir()+"servervault/"+PlayerName+"/"+GetBicFileName(oPC)+".bic";
}

void VoidLetoScript(string sScript, string sType = "SCRIPT", string sPollScript = "")
{
    LetoScript(sScript,sType,sPollScript);
}

string LetoScript(string sScript, string sType = "SCRIPT", string sPollScript = "")
{
    string sAnswer;
    DoDebug(sType+" >: "+sScript);
    SetLocalString(GetModule(), "NWNX!LETO!"+sType, sScript);
    sAnswer = GetLocalString(GetModule(), "NWNX!LETO!"+sType);
    DoDebug(sType+" <: "+sAnswer);
    if(sType == "SPAWN")
        DelayCommand(1.0, PollThread(sAnswer, sPollScript));
    return sAnswer;
}

void LetoPCEnter(object oPC)
{
    SetLocalString(oPC, "Path", GetBicPath(oPC));
    DeleteLocalString(oPC, "LetoScript");
}

void LetoPCExit(object oPC)
{
    string sScript = GetLocalString(oPC, "LetoScript");
    if(sScript != "")
    {
        string sPath = GetLocalString(oPC, "Path");
        if(sPath == "")
            DoDebug("Path is Null");
        if(PHEONIX_SYNTAX)
        {
            //pheonix syntax
            sScript  = "<file:open CHAR <qq:"+sPath+">>"+sScript;
            sScript += "<file:save CHAR <qq:"+sPath+">>";
            sScript += "<file:close CHAR >";
        }
        else
        {
            //unicorn syntax
            sScript  = "%char= '"+sPath+"'; "+sScript;
            sScript += "%char = '>'; ";
            sScript += "close %char; ";
        }
        string sScriptResult = LetoScript(sScript);
        SetLocalString(GetModule(), "LetoResult", sScriptResult);
        AssignCommand(GetModule(), DelayCommand(1.0, DeleteLocalString(GetModule(), "LetoResult")));
    }
}

void StackedLetoScript(string sScript)
{
    DoDebug("SLS :"+sScript);
    SetLocalString(GetModule(), "LetoScript", GetLocalString(GetModule(), "LetoScript")+ sScript);
}

void PollThread(string sThreadID, string sScript)
{
    if(GetLocalInt(GetModule(), "StopThread"+sThreadID) == TRUE)
        return;
    DoDebug("Polling: "+sThreadID);
    //add blank space to capture error messages
    string sResult = LetoScript(sThreadID+"                                   "
        +"                                   "
        +"                                   "
        +"                                   "
        +"                                   "
        +"                                   "
        +"                                   "
        +"                                   "
        +"                                   ", "POLL");
    if(sResult == "Error: "+sThreadID+" not done.")
    {
        DelayCommand(1.0, PollThread(sThreadID, sScript));
        return;
    }
    else
    {
        DoDebug("Poll: Executing: "+sScript);
        SetLocalInt(GetModule(), "StopThread"+sThreadID, TRUE);
        DelayCommand(6.0, DeleteLocalInt(GetModule(), "StopThread"+sThreadID));
        ExecuteScript(sScript, OBJECT_SELF);
    }
}

void VoidRunStackedLetoScriptOnObject(object oObject, string sLetoTag = "OBJECT",
    string sType = "SCRIPT", string sPollScript = "", int nDestroyOriginal = TRUE)
{
    RunStackedLetoScriptOnObject(oObject,sLetoTag,sType,sPollScript,nDestroyOriginal);
}

object RunStackedLetoScriptOnObject(object oObject, string sLetoTag = "OBJECT",
    string sType = "SCRIPT", string sPollScript = "", int nDestroyOriginal = TRUE)
{
    if(!GetIsObjectValid(oObject))
    {
        WriteTimestampedLogEntry("ERROR: "+GetName(oObject)+"is invalid");
        WriteTimestampedLogEntry("Script was "+GetLocalString(GetModule(), "LetoScript"));
        return OBJECT_INVALID;
    }
    string sCommand;
    object oReturn;
    location lLoc;
    object oWPLimbo = GetWaypointByTag(WP_LIMBO);
    location lLimbo;
    if(GetIsObjectValid(oWPLimbo))
        lLimbo = GetLocation(oWPLimbo);
    else
        lLimbo = GetStartingLocation();
    string sScript = GetLocalString(GetModule(), "LetoScript");
    DeleteLocalString(GetModule(), "LetoScript");
    string sScriptResult;
    //check if its a DM or PC
    //these use bic files
    if(GetIsPC(oObject) || GetIsDM(oObject))
    {
        if(nDestroyOriginal == FALSE)//dont boot
        {
            string sPath = GetLocalString(oObject, "Path");
            if(PHEONIX_SYNTAX)
            {
                sCommand = "<file:open '"+sLetoTag+"' "+sPath+">";
                sScript = sCommand+sScript;
                sCommand = "<file:close '"+sLetoTag+"'>";
                sScript = sScript+sCommand;
                //unicorn
            }
            else
            {
                sCommand = "%"+sLetoTag+" = '"+sPath+"'; ";
                sScript = sCommand+sScript;
                sCommand = "close %"+sLetoTag+"; ";
                sScript = sScript+sCommand;
            }
            sScriptResult = LetoScript(sScript, sType, sPollScript);
        }
        else//boot
        {
            SetLocalString(oObject, "LetoScript", GetLocalString(oObject, "LetoScript")+sScript);
            BootPC(oObject);
            return oReturn;
        }
    }
    //its an NPC/Placeable/Item, go through DB
    else if(GetObjectType(oObject) == OBJECT_TYPE_CREATURE
        || GetObjectType(oObject) == OBJECT_TYPE_ITEM
        || GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE
        || GetObjectType(oObject) == OBJECT_TYPE_STORE
        || GetObjectType(oObject) == OBJECT_TYPE_WAYPOINT)
    {
        if(PHEONIX_SYNTAX)
        {
            //Put object into DB
            StoreCampaignObject(DB_NAME, DB_GATEWAY_VAR, oObject);
            // Reaquire DB with new object in it
            sCommand += "<file:open FPT '" + GetNWNDir() + "database/" + DB_NAME + ".fpt'>";
            //Extract object from DB
            sCommand += "<fpt:extract FPT '"+DB_GATEWAY_VAR+"' "+sLetoTag+">";
            sCommand += "<file:close FPT>";
            sCommand += "<file:use "+sLetoTag+">";
        }
        else
        {
            //unicorn
            //Put object into DB
            string sSQL = "SELECT "+DB_GATEWAY_VAR+" FROM "+DB_NAME+" WHERE "+DB_GATEWAY_VAR+"="+DB_GATEWAY_VAR+" LIMIT 1";
            SQLExecDirect(sSQL);

            if (SQLFetch() == SQL_SUCCESS)
            {
                // row exists
                sSQL = "UPDATE "+DB_NAME+" SET val=%s WHERE "+DB_GATEWAY_VAR+"="+DB_GATEWAY_VAR;
                SetLocalString(GetModule(), "NWNX!ODBC!SETSCORCOSQL", sSQL);
            }
            else
            {
                // row doesn't exist
                // assume table doesnt exist too
                sSQL = "CREATE TABLE "+DB_NAME+" ( "+DB_GATEWAY_VAR+" TEXT, blob BLOB )";
                SQLExecDirect(sSQL);
                sSQL = "INSERT INTO "+DB_NAME+" ("+DB_GATEWAY_VAR+", blob) VALUES" +
                    "("+DB_GATEWAY_VAR+", %s)";
                SetLocalString(GetModule(), "NWNX!ODBC!SETSCORCOSQL", sSQL);
            }
            StoreCampaignObject ("NWNX", "-", oObject);
            // Reaquire DB with new object in it
            //force data to be written to disk
            sSQL = "COMMIT";
            SQLExecDirect(sSQL);
            sCommand += "sql.connect 'root', '' or die $!; ";
            sCommand += "sql.query 'SELECT blob FROM "+DB_NAME+" WHERE "+DB_GATEWAY_VAR+"="+DB_GATEWAY_VAR+" LIMIT 1'; ";
            sCommand += "sql.retrieve %"+sLetoTag+"; ";
        }
        //store their location
        lLoc = GetLocation(oObject);
        if(!GetIsObjectValid(GetAreaFromLocation(lLoc)))
            lLoc = GetStartingLocation();
        //destroy the original
        if(nDestroyOriginal == TRUE)
        {
            AssignCommand(oObject, SetIsDestroyable(TRUE));
            DestroyObject(oObject);
        }

        sScript = sCommand + sScript;
        sCommand = "";

        if(nDestroyOriginal == TRUE)
        {
        //its an NPC/Placeable/Item, go through DB
            if(PHEONIX_SYNTAX)
            {
                sCommand  = "<file:open FPT '" + GetNWNDir() + "database/" + DB_NAME + ".fpt'>";
                sCommand += "<fpt:replace FPT '" +DB_GATEWAY_VAR+ "' "+sLetoTag+">";
                sCommand += "<file:save FPT>";
                sCommand += "<file:close FPT>";
                sCommand += "<file:close "+sLetoTag+">";
            }
            else
            {
                //unicorn
                sCommand += "sql.query 'SELECT blob FROM "+DB_NAME+" WHERE "+DB_GATEWAY_VAR+"="+DB_GATEWAY_VAR+" LIMIT 1'; ";
                sCommand += "sql.store %"+sLetoTag+"; ";
                sCommand += "close %"+sLetoTag+"; ";
            }
        }

        sScript = sScript + sCommand;
        sScriptResult = LetoScript(sScript, sType, sPollScript);

        if(nDestroyOriginal == TRUE && sType != "POLL")
        {
            if(PHEONIX_SYNTAX)
            {
                if(GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
                {
                    oReturn = RetrieveCampaignObject(DB_NAME, DB_GATEWAY_VAR, lLimbo);
                    AssignCommand(oReturn, JumpToLocation(lLoc));
                }
                else
                    oReturn = RetrieveCampaignObject(DB_NAME, DB_GATEWAY_VAR, lLoc);
            }
            else
            {
                string sSQL = "SELECT blob FROM "+DB_NAME+" WHERE "+DB_GATEWAY_VAR+"="+DB_GATEWAY_VAR+" LIMIT 1";
                SetLocalString(GetModule(), "NWNX!ODBC!SETSCORCOSQL", sSQL);
                if(GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
                {
                    oReturn = RetrieveCampaignObject("NWNX", "-", lLimbo);
                    AssignCommand(oReturn, JumpToLocation(lLoc));
                }
                else
                    oReturn = RetrieveCampaignObject("NWNX", "-", lLoc);
            }
        }
    }
    SetLocalString(GetModule(), "LetoResult", sScriptResult);
    AssignCommand(GetModule(), DelayCommand(1.0, DeleteLocalString(GetModule(), "LetoResult")));

//    WriteTimestampedLogEntry(GetName(oReturn)+";");
    return oReturn;
}

ITP V3.28   �  �F  �  \�     ��  ��  �� |/  � p  ����                                                    $          ,          8          @          L          T          \          h          p          x          �          �          �          �          �          �          �          �          �          �          �          �          �          �          �          �                                               (         4         <         D         L         T         `         h         p         x         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                                        (         0         8         @         H         P         X         `         h         p         x         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                                        (         0         8         @         H         P         X         `         h         p         x         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                                        (         0         8         @         H         P         X         `         h         p         x         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                                        (         0         8         @         H         P         X         `         h         p         x         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         0         8         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                                        (         0         8         @         H         P         X         `         h         p         x         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                                        (         0         8         @         H         P         X         `         h         p         x         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �          	         	         	         	          	         (	         0	         8	         @	         H	         P	         \	         d	         l	         t	         |	         �	         �	         �	         �	         �	         �	         �	         �	         �	         �	         �	         �	         �	         �	         �	         �	         
         
         
         
         $
         ,
         4
         <
         D
         L
         T
         \
         d
         l
         t
         |
         �
         �
         �
         �
         �
         �
         �
         �
         �
         �
         �
         �
         �
         �
         �
         �
                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                             $         ,         4         <         D         L         T         \         d         l         t         |         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �         �                                                 $          ,          4          <          D          L          T          \          d          l          t          |          �          �          �          �          �          �          �          �          �          �          �          �          �          �          �          �          !         !         !         !         $!         ,!         4!         <!         D!         L!         T!         \!         d!         l!         t!         |!         �!         �!         �!         �!         �!         �!         �!         �!         �!         �!         �!         �!         �!         �!         �!         �!         "         "         "         "         $"         ,"         4"         <"         D"         L"         T"         \"         d"         l"         t"         |"         �"         �"         �"         �"         �"         �"         �"         �"         �"         �"         �"         �"         �"         �"         �"         �"         #         #         #         #         $#         ,#         4#         <#         D#         L#         T#         \#         d#         l#         t#         |#         �#         �#         �#         �#         �#         �#         �#         �#         �#         �#         �#         �#         �#         �#         �#         �#         $         $         $         $         $$         ,$         4$         <$         D$         L$         T$         \$         d$         l$         t$         |$         �$         �$         �$         �$         �$         �$         �$         �$         �$         �$         �$         �$         �$         �$         �$         �$         %         %         %         %         $%         ,%         4%         <%         D%         L%         T%         \%         d%         l%         t%         |%         �%         �%         �%         �%         �%         �%         �%         �%         �%         �%         �%         �%         �%         �%         �%         �%         &         &         &         &         $&         ,&         4&         <&         D&         L&         T&         \&         d&         l&         t&         |&         �&         �&         �&         �&         �&         �&         �&         �&         �&         �&         �&         �&         �&         �&         �&         �&         '         '         '         '         $'         ,'         4'         <'         D'         L'         T'         \'         d'         l'         t'         |'         �'         �'         �'         �'         �'         �'         �'         �'         �'         �'         �'         �'         �'         �'         �'         �'         (         (         (         (         $(         ,(         4(         <(         D(         L(         T(         \(         d(         l(         t(         |(         �(         �(         �(         �(         �(         �(         �(         �(         �(         �(         �(         �(         �(         �(         �(         �(         )         )         )         )         $)         ,)         4)         <)         D)         L)         T)         \)         d)         l)         t)         |)         �)         �)         �)         �)         �)         �)         �)         �)         �)         �)         �)         �)         �)         �)         �)         �)         *         *         *         *         $*         ,*         4*         <*         D*         L*         T*         \*         d*         l*         t*         |*         �*         �*         �*         �*         �*         �*         �*         �*         �*         �*         �*         �*         �*         �*         �*         �*         +         +         +         +         $+         ,+         4+         <+         D+         L+         T+         \+         d+         l+         t+         |+         �+         �+         �+         �+         �+         �+         �+         �+         �+         �+         �+         �+         �+         �+         �+         �+         ,         ,         ,         ,         $,         ,,         4,         <,         D,         L,         T,         \,         d,         l,         t,         |,         �,         �,         �,         �,         �,         �,         �,         �,         �,         �,         �,         �,         �,         �,         �,          -         -         -         -         $-         ,-         4-         <-         D-         P-         X-         `-         h-         p-         |-         �-         �-         �-         �-         �-         �-         �-         �-         �-         �-         �-         �-         �-         �-          .         .         .         .          .         (.         4.         <.         D.         L.         T.         \.         d.         l.         x.         �.         �.         �.         �.         �.         �.         �.         �.         �.         �.         �.         �.         �.         �.         �.         �.         /         /         /         /         $/         ,/         4/         </         H/         P/         X/         `/         l/         t/                     O        l         �                      
                   
      "         /   
      9         G         �                  ,   
      R         i         S         	         D   
      z         �   
      �         �         �                  d   
      �         �                           �         :         T        �         �                  U         
         V                  W        �        �         7         �   
      �         �   
              (  
      9        V  
      g        �  
      �        �  
      �        �  
      �          
              ,  
      :        K  
      X        u        X                  �   
      �        �  
      �        �  
      �        �        �         ?           
      �          
              -  
      >        Q        �         ;         �                  0  
      b        f  
      n          
      �        �  
      �        �  
      �        �  
      �          
              0  
      >        U  
      f        �  
      �        �  
      �        �  
      �          
              9  
      J        g  
      x        �  
      �        �  
      �        �  
      �          
      '        :  
      I        a  
      r        �  
      �        �  
      �        �  
      �          
      ,        M  
      W        �  
      �        �  
      �        �  
      �        �  
      �          
              6  
      E        [  
      j        }  
      �        �  
      �        �        �         8         �  
      �        �        8        T        �         <         �  
      �        	  
      	        4	  
      D	        a	  
      q	        �	  
      �	        �	  
      �	        �	  
      �	        
  
      *
        K
  
      \
        {
  
      �
        �
  
      �
        �
  
      �
          
      '        I  
      Z        w  
      �        �  
      �        �  
      �        �  
              &  
      7        Q  
      b          
      �        �  
      �        �  
      �          
              ;  
      L        h  
      y        �  
      �        �  
      �        �  
      
        "  
      2        J  
      [        w  
      �        �  
      �        �  
      �          
              4  
      E        g  
      x        �  
      �        �  
      �        �  
      
        +  
      <        _  
      p        �  
      �        �  
      �        �  
      �          
      !        B  
      S        r  
      �        �  
      �        �  
      �          
              2  
      C        _  
      p        �  
      �        �  
      �        �  
      �          
      &        :  
      G        f  
      w        �  
      �        �  
      �        �  
              "  
      3        [  
      l        �  
      �        �  
      �        �  
              !  
      2        Q  
      b        |  
      �        �  
      �        �  
      �          
              2  
      C        \  
      l        �  
      �        �  
      �        �  
      �        �  
              '  
      7        N  
      ^        v  
      �        �  
      �        �  
      �        �  
      �          
      '        D  
      T        k  
      x        �  
      �        �  
      �        �  
      �        �  
              '  
      6        L  
      [        r  
              �  
      �        �  
      �        �  
      �          
      &        =        �         �        Y                  �                  Z                  [                  �                  �F        @         �         9         �  
      J        g  
      x        �        ]        �        ^                  _                  \                    
      �        �        +                  8  
      �        �  
      �        �  
      �        �  
      �          
              )  
      8        N        a                  b                  |  
      ]        q        �       �        �       �        ��       �  
      �        �        ��       �        ��       �        ��       �        �       
  
              2        �       A  
      R        a        ��       p        
�       �  
      �        �        ��       �        ��       �        ��       �        ��       �        �       �        ��               �               "�       %        �       6        ��       G        ��       X        ��       i  
      z        �        R�       �        ��       �        B�       �        '�       �        ��       �        @�       �        �       �        ��               ��       !        ��       2        ��       C        ��       T        ��       e        ��       v        ��       �        ��       �        ��       �        ��       �        ��       �        ��       �        7�       �         �       �        )�               +�          
      1        C        J�       R        D�       c        F�       t        H�       �        ��       �        -�       �        /�       �        1�       �        �       �        �       �        3�       �        5�                ��          
      /         B         ��       P         ��       a         ��       r         N�       �         L�       �         9�       �         ��       �         ��       �         ��       �   
      �         !        ��       !  
      %!        A!        �       R!        ��       c!        ��       t!        ��       �!  
      �!        �!        ��       �!  
      �!        �!        ��       �!        �         6                 �                            �        =        	"  
      "        /"  
      @"        _"  
      p"        �"        ��       �"        C        �"        1        �"        9        �"        *        �"        .        �"        ��       �"        A        �"  
      #        #        8        &#        ��       3#        B        @#        ��       M#        ��       Z#        N        g#        ?        t#        2        �#        5        �#  
      �#        �#        ��       �#        ��       �#        ��       �#        M        �#        /        �#        ��       $        )        $        ��       $        ��       +$        L        8$        ;        E$        ��       R$        ��       _$        ��       l$        ,        y$        K        �$        >        �$  
      �$        �$  
      �$        �$        3        �$        ��       �$        ��       �$        J        
%        ��       %        &        $%        4        1%        :        >%  
      K%        Y%  
      d%        r%  
      }%        �%  
      �%        �%  
      �%        �%  
      �%        �%  
      �%        �%  
      &        &  
      '&        7&  
      D&        T&  
      a&        q&  
      ~&        �&  
      �&        �&  
      �&        �&  
      �&        �&  
      �&        '  
      '        '  
      ,'        <'  
      I'        Y'  
      f'        v'  
      �'        �'  
      �'        �'  
      �'        �'  
      �'        �'  
      �'        (  
      (        $(  
      1(        A(  
      N(        ](  
      i(        y(  
      �(        �(  
      �(        �(  
      �(        �(  
      �(        �(  
      �(        
)  
      )        ')  
      4)        C)  
      O)        _)  
      l)        |)  
      �)        �)  
      �)        �)  
      �)        �)  
      �)        �)  
      �)        *  
      *        **  
      7*        G*  
      T*        c*  
      o*        *  
      �*        �*  
      �*        �*  
      �*        �*  
      �*        �*  
       +        +  
      +        -+  
      :+        J+  
      W+        g+  
      t+        �+  
      �+        �+  
      �+        �+  
      �+        �+  
      �+        �+  
      ,        ,  
       ,        0,  
      =,        M,  
      Z,        j,  
      w,        �,  
      �,        �,  
      �,        �,  
      �,        �,  
      �,        �,  
      -        -  
      #-        3-  
      @-        P-  
      ]-        m-  
      z-        �-  
      �-        �-  
      �-        �-  
      �-        �-  
      �-        .  
      .        .  
      *.        :.  
      G.        W.  
      d.        t.  
      �.        �.  
      �.        �.  
      �.        �.  
      �.        �.  
      �.        /  
      /        "/  
      //        >/  
      J/        Z/  
      g/        w/  
      �/        �/  
      �/        �/  
      �/        �/  
      �/        �/  
      �/        0  
      0         0  
      .0        ?0  
      M0        ^0  
      l0        }0  
      �0        �0  
      �0        �0  
      �0        �0  
      �0        �0  
      1        1  
      "1        11  
      =1        L1  
      X1        g1  
      s1        �1  
      �1        �1  
      �1        �1  
      �1        �1  
      �1        �1  
      2        2  
      2        +2  
      62        E2  
      Q2        `2  
      l2        }2  
      �2        �2  
      �2        �2  
      �2        �2  
      �2        �2  
      3        3  
      &3        73  
      E3        V3  
      d3        u3  
      �3        �3  
      �3        �3  
      �3        �3  
      �3        �3  
      �3        4  
      4        /4  
      =4        N4  
      \4        m4  
      {4        �4  
      �4        �4  
      �4        �4  
      �4        �4  
      �4        5  
      5        '5  
      55        F5  
      T5        e5  
      s5        �5  
      �5        �5  
      �5        �5  
      �5        �5  
      �5         6  
      6        6  
      -6        >6  
      L6        ]6  
      k6        |6  
      �6        �6  
      �6        �6  
      �6        �6  
      �6        �6  
      7        7  
      %7        67  
      D7        U7  
      c7        t7  
      �7        �7  
      �7        �7  
      �7        �7  
      �7        �7  
      �7        8  
      8        .8  
      <8        M8  
      [8        l8  
      z8        �8  
      �8        �8  
      �8        �8  
      �8        �8  
      �8        9  
      9        &9  
      49        E9  
      S9        d9  
      r9        �9  
      �9        �9  
      �9        �9  
      �9        �9  
      �9        �9  
      :        :  
      ,:        =:  
      K:        \:  
      j:        {:  
      �:        �:  
      �:        �:  
      �:        �:  
      �:        �:  
      ;        ;  
      $;        5;  
      C;        T;  
      b;        s;  
      �;        �;  
      �;        �;  
      �;        �;  
      �;        �;  
      �;        <  
      <        $<  
      1<        @<  
      L<        [<  
      g<        v<  
      �<        �<  
      �<        �<  
      �<        �<  
      �<        �<  
      �<        =  
      =        !=  
      .=        >=  
      K=        [=  
      h=        x=  
      �=        �=  
      �=        �=  
      �=        �=  
      �=        �=  
      �=        >  
      >        $>  
      1>        A>  
      N>        ^>  
      k>        {>  
      �>        �>  
      �>        �>  
      �>        �>  
      �>        �>  
      �>        ?  
      ?         ?  
      ,?        ;?  
      G?        W?  
      d?        t?  
      �?        �?  
      �?        �?  
      �?        �?  
      �?        �?  
      �?        @  
      @         @  
      -@        =@  
      J@        Z@  
      g@        w@  
      �@        �@  
      �@        �@  
      �@        �@  
      �@        �@  
      �@        A  
      A        $A  
      0A        @A  
      MA        ]A  
      jA        zA  
      �A        �A  
      �A        �A  
      �A        �A  
      �A        �A  
      �A        B  
      B        (B  
      5B        EB  
      RB        aB  
      mB        }B  
      �B        �B  
      �B        �B  
      �B        �B  
      �B        �B  
      �B        C  
      C        +C  
      8C        HC  
      UC        eC  
      rC        �C  
      �C        �C  
      �C        �C  
      �C        �C  
      �C        �C  
      D        D  
      D        .D  
      ;D        KD  
      XD        hD  
      uD        �D  
      �D        �D  
      �D        �D  
      �D        �D  
      �D        �D  
      E        E  
      !E        1E  
      >E        NE  
      [E        jE  
      vE        �E  
      �E        �E  
      �E        �E  
      �E        �E  
      �E        �E  
      �E        F  
      F        )F  
      5F        EF  
      RF        bF  
      oF        F  
      �F        �F  
      �F        �F  
      �F        �F  
      �F        �F  
       G        G  
      G        ,G  
      8G        HG  
      UG        eG  
      rG        �G  
      �G        �G  
      �G        �G  
      �G        �G  
      �G        �G  
      H        H  
       H        0H  
      =H        MH  
      ZH        iH  
      uH        �H  
      �H        �H  
      �H        �H  
      �H        �H  
      �H        �H  
      I        I  
      #I        3I  
      @I        OI  
      [I        kI  
      xI        �I  
      �I        �I  
      �I        �I  
      �I        �I  
      �I        �I  
      	J        J  
      &J        6J  
      CJ        SJ  
      `J        oJ  
      {J        �J  
      �J        �J  
      �J        �J  
      �J        �J  
      �J        �J  
      K        K  
      K        ,K  
      8K        GK  
      SK        bK  
      nK        }K  
      �K        �K  
      �K        �K  
      �K        �K  
      �K        �K  
      �K        L  
      L        L  
      +L        :L  
      FL        UL  
      aL        pL  
      |L        �L  
      �L        �L  
      �L        �L  
      �L        �L  
      �L        �L  
      M        M  
      M        ,M  
      7M        FM  
      RM        aM  
      mM        |M  
      �M        �M  
      �M        �M  
      �M        �M  
      �M        �M  
      �M        N  
      N        N  
      (N        7N  
      CN        RN  
      ^N        mN  
      yN        �N  
      �N        �N  
      �N        �N  
      �N        �N  
      �N        �N  
       O        O  
      O        *O  
      6O        DO        ��       OO        +        \O  
      iO        xO  
      �O        �O  
      �O        �O  
      �O        P  
       P        NP  
      \P        �P  
      �P        �P  
      �P        �P  
       Q        )Q  
      7Q        `Q  
      nQ        �Q  
      �Q        �Q  
      �Q        �Q  
      R        ,R  
      :R        ZR  
      hR        �R  
      �R        �R  
      �R        �R  
      �R        S  
       S        @S  
      NS        eS  
      sS        �S  
      �S        �S  
      �S        �S  
      �S        �S  
      T        .T  
      <T        XT  
      fT        �T  
      �T        �T  
      �T        �T  
      �T        U  
      U        /U  
      =U        ZU  
      hU        �U  
      �U        �U  
      �U        �U  
      �U        
V  
      V        7V  
      EV        dV  
      rV        �V  
      �V        �V  
      �V        �V  
      �V        W  
      "W        =W  
      KW        fW  
      tW        �W  
      �W        �W  
      �W        �W  
      �W        
X  
      X        5X  
      CX        dX  
      rX        �X  
      �X        �X  
      �X        �X  
      �X         Y  
      .Y        OY  
      ]Y        ~Y  
      �Y        �Y  
      �Y        �Y  
      �Y        (Z  
      6Z        `Z  
      nZ        �Z  
      �Z        �Z  
      �Z        �Z  
      [        [  
      ,[        B[  
      P[        f[  
      t[        �[  
      �[        �[  
      �[        �[  
      �[        \  
      \        A\  
      O\        s\  
      �\        �\  
      �\        �\  
      �\        ]  
      ]        7]  
      E]        h]  
      v]        �]  
      �]        �]  
      �]        �]  
      ^        &^  
      4^        W^  
      e^        �^  
      �^        �^  
      �^        �^  
      �^        _  
      )_        L_  
      Z_        �_  
      �_        �_  
      �_        �_  
      �_         `  
      .`        U`  
      c`        �`  
      �`        �`  
      �`        �`  
      a        )a  
      7a        Za  
      ha        �a  
      �a        �a  
      �a        �a  
      �a        b  
      (b        Jb  
      Xb        zb  
      �b        �b  
      �b        �b  
      �b        c  
      c        Cc  
      Qc        wc  
      �c        �c  
      �c        �c  
      �c        d  
      !d        Gd  
      Ud        {d  
      �d        �d  
      �d        �d  
      �d        e  
      ,e        `e  
      ne        �e  
      �e        �e  
      �e        �e  
      �e        f  
      f        7f  
      Ef        bf  
      pf        �f  
      �f        �f  
      �f        �f  
      �f        	g  
      g        /g  
      =g        Ug  
      cg        {g  
      �g        �g  
      �g        �g  
      �g        h  
      h        Fh  
      Sh        ph  
      ~h        �h  
      �h        �h  
      �h        �h  
      �h        i  
      *i        Gi  
      Ui        ri  
      �i        �i  
      �i        �i  
      �i        �i  
      �i        j  
      $j        ?j  
      Mj        hj  
      vj        �j  
      �j        �j  
      �j        �j  
      �j        k  
       k        Bk  
      Pk        tk  
      �k        �k  
      �k        �k  
      �k        l  
      "l        Jl  
      Xl        �l  
      �l        �l  
      �l        �l  
      �l        m  
      (m        Mm  
      [m        �m  
      �m        �m  
      �m        �m  
      �m        n  
      'n        Ln  
      Zn        n  
      �n        �n  
      �n        �n  
      �n        o  
      &o        Ko  
      Yo        ~o  
      �o        �o  
      �o        �o  
      �o        �o  
      p        p  
      %p        ;p  
      Ip        _p  
      mp        �p  
      �p        �p  
      �p        �p  
      �p        	q  
      q        :q  
      Hq        kq  
      yq        �q  
      �q        �q  
      �q        �q  
      r        0r  
      >r        br  
      pr        �r  
      �r        �r  
      �r        �r  
      s        *s  
      8s        \s  
      js        �s  
      �s        �s  
      �s        �s  
      �s        �s  
      t         t  
      .t        Ft  
      Tt        lt  
      zt        �t  
      �t        �t  
      �t        �t  
      �t        �t  
      u        "u  
      0u        Fu  
      Tu        ju  
      xu        �u  
      �u        �u  
      �u        �u  
      �u        	v  
      v        2v  
      @v        [v  
      iv        �v  
      �v        �v  
      �v        �v  
      �v        �v  
      w        'w  
      5w        Qw  
      _w        {w  
      �w        �w  
      �w        �w  
      �w        �w  
      x        !x  
      /x        Ix  
      Wx        xx  
      �x        �x  
      �x        �x  
      �x        y  
      y        4y  
      By        by  
      py        �y  
      �y        �y  
      �y        �y  
      �y        z  
      'z        Bz  
      Pz        tz  
      �z        �z  
      �z        �z  
      �z        �z  
      	{        %{  
      3{        O{  
      ]{        y{  
      �{        �{  
      �{        �{  
      �{        �{  
      |        !|  
      /|        K|  
      Y|        v|  
      �|        �|  
      �|        �|  
      �|        }  
      }        9}  
      G}        c}  
      o}        �}  
      �}        �}  
      �}        �}  
      ~        3~  
      A~        i~  
      w~        �~  
      �~        �~  
      �~          
              C  
      Q        {  
      �        �  
      �        �  
      �        #�  
      1�        [�  
      i�        ��  
      ��        ̀  
      ڀ        �  
      �        >�  
      L�        w�  
      ��        ��  
      ��        �  
      ��        "�  
      0�        W�  
      e�        ��  
      ��        ��  
      ��        �  
      �        �  
      �        6�  
      D�        ^�  
      l�        ��  
      ��        ��  
      ��        փ  
      �        ��  
      �        =�  
      K�        n�  
      |�        ��  
      ��          
      Є        �  
      ��        �  
      $�        @�  
      N�        j�  
      x�        ��  
      ��        ʅ  
      ؅        �  
      ��        �  
      &�        ?�  
      M�        f�  
      t�        ��  
      ��        ��  
              ۆ  
      �        �  
      �        /�  
      =�        Y�  
      g�        ��  
      ��        ��  
      ��        ׇ  
      �        �  
      �        (�  
      6�        O�  
      ]�        v�  
      ��        ��  
      ��        Ĉ  
      ҈        �  
      ��        �  
       �        ?�  
      M�        t�  
      ��        ��  
      ��        މ  
      �        �  
      �        @�  
      N�        n�  
      |�        ��  
      ��        ʊ  
      ؊        ��  
      �        &�  
      4�        T�  
      b�        ��  
      ��        ��  
      ��        ؋  
      �        �  
      �        .�  
      <�        Y�  
      g�        ��  
      ��        ��  
      ��        ތ  
      �        �  
      �        5�  
      C�        _�  
      m�        ��  
      ��        ��  
      ��        ݍ  
      �        �  
      �        1�  
      ?�        ^�  
      l�        ��  
      ��        Ď  
      Ҏ        �  
      ��        �  
      !�        7�  
      E�        [�  
      i�        �  
      ��        ��  
      ��        Ǐ  
      Տ        �  
      ��        �  
      �        7�  
      E�        ]�  
      k�        ��  
      ��        ��  
      ��        ϐ  
      ݐ        ��  
      �        2�  
      @�        W�  
      e�        |�  
      ��        ��  
      ��        Ƒ  
      ԑ        �  
      ��        �  
      �        5�  
      C�        f�  
      t�        ��  
      ��        ��  
      ̒        �  
      ��        �  
      $�        B�  
      P�        n�  
      |�        ��  
      ��        Ǔ  
      Փ        ��  
      �        !�  
      /�        N�  
      \�        {�  
      ��        ��  
      ��        Ք  
      �        �  
      �        B�  
      P�        r�  
      ��        ��  
      ��        Ε  
      ܕ        ��  
      
�        *�  
      8�        X�  
      f�        ��  
      ��        ��  
              ߖ  
      �        
�  
      �        5�  
      C�        `�  
      n�        ��  
      ��        ��  
      ė        �  
      �        �  
      �        9�  
      G�        e�  
      s�        ��  
      ��        ��  
      ˘        �  
      ��        �  
      #�        <�  
      J�        c�  
      q�        ��  
      ��        ��  
      ��        ؙ  
      �        ��  
      �        &�  
      4�        O�  
      ]�        x�  
      ��        ��  
      ��        ʚ  
      ؚ        �  
      �        �  
      *�        E�  
      S�        i�  
      w�        ��  
      ��        ��  
      ��        ՛  
      �        ��  
      �        �  
      +�        A�  
      O�        r�  
      ��        ��  
      ��        ֜  
      �        �  
      �        A�  
      O�        i�  
      w�        ��  
      ��        ��  
      ͝        �  
      ��        �  
      #�        @�  
      N�        k�  
      y�        ��  
      ��        ў  
      ߞ        �  
      &�        J�  
      X�        |�  
      ��        ��  
      ��        ܟ  
      �        �  
      �        2�  
      @�        ]�  
      k�        ��  
      ��        ��  
      ��        ޠ  
      �        �  
      �        2�  
      @�        ^�  
      l�        ��  
      ��        ��  
      ġ        �  
      �        �  
      �        :�  
      H�        k�  
      y�        ��  
      ��        ΢  
      ܢ        ��  
      �        0�  
      >�        a�  
      o�        ��  
      ��        ã  
      ѣ        ��  
      �        %�  
      3�        L�  
      Z�        x�  
      ��        ��  
      ��        Ф  
      ޤ        ��  
      
�        (�  
      6�        T�  
      b�        ��  
      ��        ��  
      ��        ̥  
      ڥ        �  
       �        �  
      &�        >�  
      L�        d�  
      r�        ��  
      ��        ��  
      ͦ        ��  
      �        )�  
      7�        ^�  
      l�        ��  
      ��        ȧ  
      ֧        ��  
      �        .�  
      <�        _�  
      m�        ��  
      ��        ��  
      Ϩ        �  
       �        #�  
      1�        T�  
      b�        ��  
      ��        ��  
      ũ        �  
      �        �  
      "�        G�  
      U�        v�  
      ��        ��  
      ��        ڪ  
      �        �  
      �        >�  
      L�        p�  
      ~�        ��  
      ��        ԫ  
      �        �  
      �        .�  
      <�        g�  
      u�        ��  
      ��        ٬  
      �        �  
       �        K�  
      Y�        ��  
      ��        ��  
      ˭        ��  
      �        #�  
      1�        S�  
      a�        �  
      ��        ��  
      ��        ֮  
      �        �  
      �        9�  
      G�        c�  
      q�        ��  
      ��        ��  
      ů        �  
      �        �  
      �        5�  
      C�        _�  
      m�        ��  
      ��        ��  
      Ű        ߰  
      ��        �  
      �        /�  
      =�        W�  
      e�        �  
      ��        ��  
      ��        ͱ  
      ۱        �  
      �        �  
      '�        ?�  
      M�        e�  
      s�        ��  
      ��        ��  
      ��        ��  
      �        "�  
      0�        M�  
      [�        x�  
      ��        ��  
      ��        γ  
      ܳ        ��  
      �        $�  
      2�        L�  
      Z�        t�  
      ��        ��  
      ��        Ĵ  
      Ҵ        �  
      ��        �  
      "�        <�  
      J�        d�  
      r�        ��  
      ��        ��  
      µ        ܵ  
      �        �  
      �        ,�  
      :�        T�  
      b�        z�  
      ��        ��  
      ��        ƶ  
      Զ        �  
      ��        �  
       �        8�  
      F�        ^�  
      l�        ��  
      ��        ��  
      ��        Է  
      �        ��  
      �        �  
      ,�        C�  
      Q�        h�  
      v�        ��  
      ��        ��  
      Ǹ        �  
      �        �  
      �        =�  
      K�        i�  
      w�        ��  
      ��        ��  
      Ϲ        �  
      �        
�  
      �        /�  
      =�        T�  
      b�        y�  
      ��        ��  
      ��        ú  
      Ѻ        �  
      ��        �  
      !�        >�  
      L�        i�  
      w�        ��  
      ��        ��  
      ͻ        �  
      ��        �  
      #�        E�  
      S�        r�  
      ��        ��  
      ��        м  
      ޼         �  
      �        1�  
      ?�        `�  
      n�        ��  
      ��        ��  
      ƽ        �  
      ��        �  
      &�        B�  
      P�        r�  
      ��        ��  
      ��        ˾  
      پ        ��  
      �        ,�  
      :�        _�  
      m�        ��  
      ��        ��  
      Ͽ        �  
      �        8�  
      F�        m�  
      {�        ��  
      ��        ��  
      ��        �  
      �        A�  
      O�        v�  
      ��        ��  
      ��        ��  
      ��        ��  
      �        &�  
      4�        R�  
      `�        ~�  
      ��        ��  
      ��        ��  
      ��        �  
      �        .�  
      <�        Z�  
      h�        ��  
      ��        ��  
      ��        ��  
      ��        �  
      �        >�  
      L�        n�  
      |�        ��  
      ��        ��  
      ��        ��  
      �        .�  
      <�        Y�  
      g�        ��  
      ��        ��  
      ��        ��  
      ��        �  
      �        ,�  
      :�        U�  
      c�        ~�  
      ��        ��  
      ��        ��  
      ��        ��  
      ��        �  
      !�        7�  
      E�        [�  
      i�        �  
      ��        ��  
      ��        ��        ��       ��        6        ��        0        �  
      �        '�  
      8�        H�        '        T�        ��       a�        I        n�  
      {�        ��  
      ��        ��        <        ��        ��       ��        7        ��        ��       ��        ��       ��        H        ��  
      �        �  
      #�        5�  
      C�        U�        @        c�        ��       p�        ��       }�        ��       ��        -        ��        ��       ��        !                  �  
      ��        ��  
      ��        ��  
      ��        ��        "                  #                  $                  �  
      �        �  
      ,�        A�  
      P�        e�  
      t�        ��        L         5         �        8        d        8        e                  0  
      ��        ��        f                  g                  �        d        j                   \  
      ��        ��        h                  i                  k        �        l         !         m         "         �  
      ��        ��        n         #         o         $         +         %         �  
      �        �  
      &�        ;�        p         &         �  
      J�        b�        �        �        q         '         r         (         s         )         t         *         �         =         w         .         $  
      p�        ��  
      ��        ��  
      ��        ��  
      ��        ��  
      ��        ��  
      ��        
�  
      �        '�        x         /         `  
      -�        =�        y        �        z         0         {         1         �  
      H�        _�  
      k�        ��  
      ��        ��  
      ��        ��  
      ��        ��  
      ��        	�  
      �        '�  
      3�        G�  
      S�        l�  
      x�        ��  
      ��        ��  
      ��        ��  
      ��        ��  
      ��        �  
      %�        >�  
      J�        a�        |         2         �         3         �        $        v         +         �         ,           
      m�        ��        �         -         �         >         �         4         d  
      ��        ��  
      ��        ��  MAIN            STRREF          LIST            ID              NAME            RESREF             Erinyes Clotheserinyesclothes	   nightwing	nightwing
   ow_light_1
ow_light_1   Baal Summon 2 Platebaalsummon2plate   Baal Summon 2 Headbaalsummon2head	   nightwingnightwing001   BaalSummonPlatebaalsummonplate   Greater Wraith Bite lv 21greaterwraithbit   Greater Wraith Bite lv 24greaterwraith001   Greater Wraith Bite lv 27greaterwraith002   Greater Wraith Bite lv 30greaterwraith003   Greater Wraith Bite lv 33greaterwraith004   Greater Wraith Bite lv 36greaterwraith005   Greater Wraith Bite lv 39greaterwraith006	   nightwingprc_nightwing   Werewolf Bitewerewolfbite   Werewolf Lycanthrope Bitewerewolfbitel   pnp_shft_cweappnp_shft_cweap   Werewolf Clawwerewolfclaw   Werewolf Lycanthrope Clawwerewolfclawl   Greater Nightshade Bite
grtrnsbite   Lesser Nightshade Bitelessernightshade   Nightshade Bitelessernightsh002    pc_skin   anim_armour_0anim_armour_0   anim_armour_1_4anim_armour_1_4   anim_armour_5_8anim_armour_5_8   anim_weapon_largeanim_weapon_larg   anim_weapon_smallanim_weapon_smal   base_prc_skinbase_prc_skin   Glabrezu Propertiesglabrezuproperti   Greater Nightshade Hidegrtrnightshadhid   Greater Wraith Hide lv 21greaterwraithhid   Greater Wraith Hide lv 24greaterwraith007   Greater Wraith Hide lv 27greaterwraith008   Greater Wraith Hide lv 30greaterwraith009   Greater Wraith Hide lv 33greaterwraith010   Greater Wraith Hide lv 36greaterwraith011   Greater Wraith Hide lv 39greaterwraith012   Lesser Nightshade Hidelessernightsh001   Marilith Propertiesmarilithproperti   Nightshade Hidenightshadehide   Nightwing Propertiesprc_to_nighthide   Spider Servant Propertiesservantprops   Spider Servant Properties 12HDservantprops2   Spider Servant Properties 14HDservantprops3   Spider Servant Properties 16HDservantprops4   TNecro Doom Knight Properties	prc_tn_dk&   Very Young Prismatic Dragon Propertiesvy_it_creitem011   Werewolf Skin 0werewolfskin0   Werewolf Skin 0 L10werewolfskin0l   Werewolf Skin 0 S5werewolfskin0s   Werewolf Skin 1werewolfskin1   Werewolf Skin 1 L10werewolfskin1l   Werewolf Skin 1 S5werewolfskin1s   Werewolf Skin 2werewolfskin2   Werewolf Skin 2 L10werewolfskin2l   Werewolf Skin 2 S5werewolfskin2s   Slam1d4slam1d4   Epic Spell: Achilles Heelepic_sp_achilles   Epic Spell: All Hope Lostepic_sp_allhope   Epic Spell: Allied Martyrepic_sp_allmart   Epic Spell: Anarchy's Callepic_sp_anarchy   Epic Spell: Animus Blastepic_sp_animblas   Epic Spell: Animus Blizzardepic_sp_animbliz   Epic Spell: Army Unfallenepic_sp_armyunfa   Epic Spell: Audience of Stoneepic_sp_audstone   Epic Spell: Battle Boundingepic_sp_batbound   Epic Spell: Celestial Councilepic_sp_celcounc   Epic Spell: Champion's Valorepic_sp_champval#   Epic Spell: Contingent Resurrectionepic_sp_contresu   Epic Spell: Contingent Reunionepic_sp_contreun   Epic Spell: Deadeye Senseepic_sp_deadeyes   Epic Spell: Deathmarkepic_sp_deathmrk   Epic Spell: Dire Winterepic_sp_direwint   Epic Spell: Dragon Knightepic_sp_dragonkn   Epic Spell: Dreamscapeepic_sp_dreamscp   Epic Spell: Dullbladesepic_sp_dullblad   Epic Spell: Dweomer Thiefepic_sp_dweomert   Epic Spell: Enslaveepic_sp_enslave   Epic Spell: Epic Mage Armorepic_sp_epmagarm   Epic Spell: Epic Repulsionepic_sp_eprepuls!   Epic Spell: Epic Spell Reflectionepic_sp_epspellr   Epic Spell: Epic Wardingepic_sp_epwardin   Epic Spell: Eternal Freedomepic_sp_eterfree   Epic Spell: Fiendish Wordsepic_sp_fiendwrd   Epic Spell: Fleetness of Footepic_sp_fleetnes   Epic Spell: Gem Cageepic_sp_gemcage   Epic Spell: Godsmiteepic_sp_godsmite   Epic Spell: Greater Ruinepic_sp_greatrui$   Epic Spell: Greater Spell Resistanceepic_sp_grspellr   Epic Spell: Greater Timestopepic_sp_grtimest   Epic Spell: Hell Sendepic_sp_hellsend   Epic Spell: Hellballepic_sp_hellball   Epic Spell: Herculean Allianceepic_sp_hercalli!   Epic Spell: Herculean Empowermentepic_sp_hercempo   Epic Spell: Impenetrabilityepic_sp_impenetr   Epic Spell: Leech Fieldepic_sp_leechfie   Epic Spell: Legendary Artisanepic_sp_legendar   Epic Spell: Life Force Transferepic_sp_lifeforc   Epic Spell: Magma Burstepic_sp_magmabur   Epic Spell: Mass Penguinepic_sp_masspeng   Epic Spell: Momento Moriepic_sp_momentom   Epic Spell: Mummy Dustepic_sp_mummdust   Epic Spell: Nailed to the Skyepic_sp_nailedsk   Epic Spell: Night's Undoingepic_sp_nightsun   Epic Spell: Order Restoredepic_sp_orderres   Epic Spell: Paths Become Knownepic_sp_pathsbec   Epic Spell: Peerless Penitenceepic_sp_peerless   Epic Spell: Pestilenceepic_sp_pestilen   Epic Spell: Pious Parleyepic_sp_piouspar   Epic Spell: Planar Cellepic_sp_planarce   Epic Spell: Psionic Salvoepic_sp_psionics   Epic Spell: Rain of Fireepic_sp_rainfire   Epic Spell: Risen Reunitedepic_sp_risenreu   Epic Spell: Ruinepic_sp_ruin   Epic Spell: Singular Sunderepic_sp_singsund   Epic Spell: Spell Wormepic_sp_spelworm   Epic Spell: Storm Mantleepic_sp_stormman   Epic Spell: Summon Aberrationepic_sp_summaber   Epic Spell: Superb Dispellingepic_sp_superbdi$   Epic Spell: Symrustar's Spellbindingepic_sp_symrusta   Epic Spell: The Witheringepic_sp_thewithe#   Epic Spell: Tolodine's Killing Windepic_sp_tolodine!   Epic Spell: Transcendent Vitalityepic_sp_transvit   Epic Spell: Twinfiendepic_sp_twinfien   Epic Spell: Unholy Discipleepic_sp_unholydi   Epic Spell: Unimpingedepic_sp_unimping   Epic Spell: Unseen Wandererepic_sp_unseenwa   Epic Spell: Whip of Sharepic_sp_whipshar   The Seed of Afflictionepic_sd_afflict   The Seed of Animating Deadepic_sd_animdead   The Seed of Animationepic_sd_animate   The Seed of Armorepic_sd_armor   The Seed of Banishmentepic_sd_banish   The Seed of Compellingepic_sd_compel   The Seed of Concealmentepic_sd_conceal   The Seed of Conjurationepic_sd_conjure   The Seed of Contactepic_sd_contact   The Seed of Delusionepic_sd_delude   The Seed of Destructionepic_sd_destroy   The Seed of Dispellingepic_sd_dispel   The Seed of Energyepic_sd_energy   The Seed of Foresightepic_sd_foresee   The Seed of Fortificationepic_sd_fortify   The Seed of Healingepic_sd_heal   The Seed of Lifeepic_sd_life   The Seed of Lightepic_sd_light   The Seed of Oppositionepic_sd_oppos   The Seed of Reflectionepic_sd_reflect   The Seed of Revealingepic_sd_reveal   The Seed of Shadowepic_sd_shadow   The Seed of Slayingepic_sd_slay   The Seed of Summoningepic_sd_summon   The Seed of Timeepic_sd_time   The Seed of Transformationepic_sd_transfrm   The Seed of Transportationepic_sd_transprt   The Seed of Wardingepic_sd_ward   Archmage's Focus of Powerarchfocusofpower
   Hide Token	hidetoken   prgt_kitprgt_kit   Harper's Flutemh_it_flute   Harper's Harp
mh_it_harp   Harper's Horn	mh_it_cor   Harper's Lute
mh_it_luth   Summoning Stonesummoningstone   Token of Sacrificecodi_sam_token   A Stolen Dweomerit_dweomerthiefsp_it_sparscr401sp_it_sparscr601sp_it_sparscr206   Animate Objectssplscrl_animobjsp_it_sparscr107sp_it_sparscr203sp_it_sparscr503sp_it_sparscr402   Blessing of Bahamutsplscrl_blsbahsp_it_sparscr101   Chill Touchsplscrl_chilltsp_it_spdvscr203sp_it_sparscr403
   Consecratesplscrl_consesp_it_spdvscr101sp_it_sparscr207sp_it_sparscr204sp_it_spdvscr302sp_it_sparscr602sp_it_spdvscr201sp_it_sparscr404sp_it_sparscr605sp_it_sparscr405sp_it_sparscr205sp_it_sparscr305sp_it_sparscr802
   Forceblastsp_it_sparscr301sp_it_sparscr201sp_it_sparscr502sp_it_sparscr501sp_it_spdvscr304sp_it_sparscr110sp_it_sparscr202sp_it_sparscr302sp_it_sparscr409sp_it_sparscr306sp_it_spdvscr301sp_it_sparscr304sp_it_spdvscr503sp_it_spdvscr403sp_it_sparscr102sp_it_sparscr103sp_it_sparscr104sp_it_sparscr105sp_it_sparscr106sp_it_spdvscr102sp_it_spdvscr202sp_it_sparscr407sp_it_sparscr801sp_it_sparscr603sp_it_sparscr604   Mass Contagionsplscrl_contagsp_it_spdvscr801sp_it_spdvscr501sp_it_spdvscr601sp_it_spdvscr701sp_it_spdvscr901sp_it_sparscr606sp_it_sparscr607sp_it_sparscr608sp_it_sparscr901sp_it_sparscr704sp_it_sparscr609sp_it_sparscr408sp_it_sparscr702   Nature's Avatarsplscrl_natavsp_it_sparscr108sp_it_sparscr705sp_it_spdvscr402sp_it_spdvscr401sp_it_spdvscr502sp_it_sparscr303sp_it_sparscr208sp_it_sparscr410sp_it_spdvscr303   Snilloc's Major Missilesplscrl_majmisssp_it_sparscr109   Snilloc's Snowball Swarmsp_it_sparscr209sp_it_sparscr406sp_it_spdvscr504sp_it_sparscr902sp_it_sparscr307   Unyielding Rootssplscrl_unyieldsp_it_sparscr411   Wall of Greater Dispel Magicsplscrl_gwdmsp_it_spdvscr7022dapoison023   Astral Construct Clawpsi_ast_con_claw   Astral Construct Propertiespsi_ast_con_skin   Astral Construct Slampsi_ast_con_slam2dapoison1352dapoison0292dapoison0112dapoison0192dapoison0042dapoison0082dapoison1422dapoison027   Can Shift Checkpnp_shft_tstpkup2dapoison0182dapoison1432dapoison0282dapoison1272dapoison1332dapoison0402dapoison0252dapoison0122dapoison015   Epic Shifter Powersepicshifterpower2dapoison1342dapoison1262dapoison1322dapoison0392dapoison0092dapoison1002dapoison0032dapoison1252dapoison1312dapoison0382dapoison0212dapoison1412dapoison1442dapoison1242dapoison0062dapoison0372dapoison024   Listener Hidelistenerhide   Magic Item Recipemagicitemrecipe2dapoison0132dapoison1232dapoison1302dapoison0362dapoison1402dapoison0002dapoison0142dapoison020
   PRC_ip85_0
prc_ip85_0
   PRC_ip85_1
prc_ip85_1   PRC_ip85_10prc_ip85_10   PRC_ip85_100prc_ip85_100   PRC_ip85_101prc_ip85_101   PRC_ip85_102prc_ip85_102   PRC_ip85_107prc_ip85_107   PRC_ip85_11prc_ip85_11   PRC_ip85_110prc_ip85_110   PRC_ip85_111prc_ip85_111   PRC_ip85_113prc_ip85_113   PRC_ip85_114prc_ip85_114   PRC_ip85_115prc_ip85_115   PRC_ip85_116prc_ip85_116   PRC_ip85_117prc_ip85_117   PRC_ip85_118prc_ip85_118   PRC_ip85_119prc_ip85_119   PRC_ip85_120prc_ip85_120   PRC_ip85_121prc_ip85_121   PRC_ip85_122prc_ip85_122   PRC_ip85_123prc_ip85_123   PRC_ip85_124prc_ip85_124   PRC_ip85_125prc_ip85_125   PRC_ip85_126prc_ip85_126   PRC_ip85_127prc_ip85_127   PRC_ip85_128prc_ip85_128   PRC_ip85_129prc_ip85_129   PRC_ip85_13prc_ip85_13   PRC_ip85_130prc_ip85_130   PRC_ip85_131prc_ip85_131   PRC_ip85_132prc_ip85_132   PRC_ip85_133prc_ip85_133   PRC_ip85_134prc_ip85_134   PRC_ip85_135prc_ip85_135   PRC_ip85_137prc_ip85_137   PRC_ip85_14prc_ip85_14   PRC_ip85_141prc_ip85_141   PRC_ip85_142prc_ip85_142   PRC_ip85_143prc_ip85_143   PRC_ip85_144prc_ip85_144   PRC_ip85_145prc_ip85_145   PRC_ip85_146prc_ip85_146   PRC_ip85_147prc_ip85_147   PRC_ip85_148prc_ip85_148   PRC_ip85_149prc_ip85_149   PRC_ip85_15prc_ip85_15   PRC_ip85_150prc_ip85_150   PRC_ip85_151prc_ip85_151   PRC_ip85_152prc_ip85_152   PRC_ip85_153prc_ip85_153   PRC_ip85_154prc_ip85_154   PRC_ip85_155prc_ip85_155   PRC_ip85_156prc_ip85_156   PRC_ip85_157prc_ip85_157   PRC_ip85_158prc_ip85_158   PRC_ip85_159prc_ip85_159   PRC_ip85_16prc_ip85_16   PRC_ip85_160prc_ip85_160   PRC_ip85_161prc_ip85_161   PRC_ip85_163prc_ip85_163   PRC_ip85_164prc_ip85_164   PRC_ip85_165prc_ip85_165   PRC_ip85_166prc_ip85_166   PRC_ip85_167prc_ip85_167   PRC_ip85_168prc_ip85_168   PRC_ip85_169prc_ip85_169   PRC_ip85_17prc_ip85_17   PRC_ip85_171prc_ip85_171   PRC_ip85_172prc_ip85_172   PRC_ip85_173prc_ip85_173   PRC_ip85_174prc_ip85_174   PRC_ip85_175prc_ip85_175   PRC_ip85_176prc_ip85_176   PRC_ip85_177prc_ip85_177   PRC_ip85_178prc_ip85_178   PRC_ip85_179prc_ip85_179   PRC_ip85_1790prc_ip85_1790   PRC_ip85_1791prc_ip85_1791   PRC_ip85_18prc_ip85_18   PRC_ip85_180prc_ip85_180   PRC_ip85_181prc_ip85_181   PRC_ip85_182prc_ip85_182   PRC_ip85_183prc_ip85_183   PRC_ip85_184prc_ip85_184   PRC_ip85_185prc_ip85_185   PRC_ip85_186prc_ip85_186   PRC_ip85_188prc_ip85_188   PRC_ip85_189prc_ip85_189   PRC_ip85_19prc_ip85_19   PRC_ip85_190prc_ip85_190   PRC_ip85_191prc_ip85_191   PRC_ip85_192prc_ip85_192   PRC_ip85_193prc_ip85_193   PRC_ip85_194prc_ip85_194
   PRC_ip85_2
prc_ip85_2   PRC_ip85_20prc_ip85_20   PRC_ip85_2096prc_ip85_2096   PRC_ip85_2097prc_ip85_2097   PRC_ip85_2098prc_ip85_2098   PRC_ip85_2099prc_ip85_2099   PRC_ip85_21prc_ip85_21   PRC_ip85_2122prc_ip85_2122   PRC_ip85_2167prc_ip85_2167   PRC_ip85_2247prc_ip85_2247   PRC_ip85_2250prc_ip85_2250   PRC_ip85_23prc_ip85_23   PRC_ip85_24prc_ip85_24   PRC_ip85_25prc_ip85_25   PRC_ip85_26prc_ip85_26   PRC_ip85_27prc_ip85_27   PRC_ip85_28prc_ip85_28   PRC_ip85_2886prc_ip85_2886   PRC_ip85_2887prc_ip85_2887   PRC_ip85_29prc_ip85_29
   PRC_ip85_3
prc_ip85_3   PRC_ip85_30prc_ip85_30   PRC_ip85_31prc_ip85_31   PRC_ip85_3100prc_ip85_3100   PRC_ip85_3101prc_ip85_3101   PRC_ip85_3102prc_ip85_3102   PRC_ip85_3103prc_ip85_3103   PRC_ip85_3104prc_ip85_3104   PRC_ip85_3105prc_ip85_3105   PRC_ip85_3106prc_ip85_3106   PRC_ip85_3107prc_ip85_3107   PRC_ip85_3108prc_ip85_3108   PRC_ip85_3109prc_ip85_3109   PRC_ip85_3110prc_ip85_3110   PRC_ip85_3111prc_ip85_3111   PRC_ip85_3112prc_ip85_3112   PRC_ip85_3113prc_ip85_3113   PRC_ip85_3119prc_ip85_3119   PRC_ip85_3120prc_ip85_3120   PRC_ip85_3121prc_ip85_3121   PRC_ip85_3122prc_ip85_3122   PRC_ip85_3123prc_ip85_3123   PRC_ip85_3124prc_ip85_3124   PRC_ip85_3125prc_ip85_3125   PRC_ip85_3126prc_ip85_3126   PRC_ip85_3127prc_ip85_3127   PRC_ip85_3133prc_ip85_3133   PRC_ip85_3134prc_ip85_3134   PRC_ip85_3135prc_ip85_3135   PRC_ip85_3136prc_ip85_3136   PRC_ip85_3137prc_ip85_3137   PRC_ip85_3138prc_ip85_3138   PRC_ip85_3139prc_ip85_3139   PRC_ip85_3140prc_ip85_3140   PRC_ip85_3141prc_ip85_3141   PRC_ip85_3142prc_ip85_3142   PRC_ip85_3143prc_ip85_3143   PRC_ip85_3144prc_ip85_3144   PRC_ip85_3145prc_ip85_3145   PRC_ip85_3146prc_ip85_3146   PRC_ip85_3147prc_ip85_3147   PRC_ip85_3148prc_ip85_3148   PRC_ip85_3149prc_ip85_3149   PRC_ip85_3150prc_ip85_3150   PRC_ip85_3151prc_ip85_3151   PRC_ip85_3152prc_ip85_3152   PRC_ip85_3153prc_ip85_3153   PRC_ip85_3154prc_ip85_3154   PRC_ip85_3155prc_ip85_3155   PRC_ip85_3156prc_ip85_3156   PRC_ip85_3157prc_ip85_3157   PRC_ip85_3158prc_ip85_3158   PRC_ip85_3159prc_ip85_3159   PRC_ip85_3160prc_ip85_3160   PRC_ip85_3161prc_ip85_3161   PRC_ip85_3162prc_ip85_3162   PRC_ip85_3163prc_ip85_3163   PRC_ip85_3164prc_ip85_3164   PRC_ip85_3165prc_ip85_3165   PRC_ip85_3166prc_ip85_3166   PRC_ip85_3168prc_ip85_3168   PRC_ip85_3169prc_ip85_3169   PRC_ip85_3170prc_ip85_3170   PRC_ip85_3171prc_ip85_3171   PRC_ip85_3172prc_ip85_3172   PRC_ip85_3173prc_ip85_3173   PRC_ip85_3174prc_ip85_3174   PRC_ip85_3175prc_ip85_3175   PRC_ip85_3176prc_ip85_3176   PRC_ip85_3177prc_ip85_3177   PRC_ip85_3178prc_ip85_3178   PRC_ip85_3179prc_ip85_3179   PRC_ip85_3180prc_ip85_3180   PRC_ip85_3181prc_ip85_3181   PRC_ip85_3182prc_ip85_3182   PRC_ip85_3183prc_ip85_3183   PRC_ip85_3184prc_ip85_3184   PRC_ip85_3185prc_ip85_3185   PRC_ip85_3186prc_ip85_3186   PRC_ip85_3187prc_ip85_3187   PRC_ip85_32prc_ip85_32   PRC_ip85_321prc_ip85_321   PRC_ip85_322prc_ip85_322   PRC_ip85_323prc_ip85_323   PRC_ip85_33prc_ip85_33   PRC_ip85_34prc_ip85_34   PRC_ip85_35prc_ip85_35   PRC_ip85_354prc_ip85_354   PRC_ip85_355prc_ip85_355   PRC_ip85_356prc_ip85_356   PRC_ip85_36prc_ip85_36   PRC_ip85_363prc_ip85_363   PRC_ip85_364prc_ip85_364   PRC_ip85_365prc_ip85_365   PRC_ip85_366prc_ip85_366   PRC_ip85_367prc_ip85_367   PRC_ip85_368prc_ip85_368   PRC_ip85_369prc_ip85_369   PRC_ip85_37prc_ip85_37   PRC_ip85_370prc_ip85_370   PRC_ip85_371prc_ip85_371   PRC_ip85_372prc_ip85_372   PRC_ip85_373prc_ip85_373   PRC_ip85_374prc_ip85_374   PRC_ip85_375prc_ip85_375   PRC_ip85_376prc_ip85_376   PRC_ip85_377prc_ip85_377   PRC_ip85_38prc_ip85_38   PRC_ip85_39prc_ip85_39
   PRC_ip85_4
prc_ip85_4   PRC_ip85_40prc_ip85_40   PRC_ip85_41prc_ip85_41   PRC_ip85_414prc_ip85_414   PRC_ip85_415prc_ip85_415   PRC_ip85_416prc_ip85_416   PRC_ip85_417prc_ip85_417   PRC_ip85_418prc_ip85_418   PRC_ip85_419prc_ip85_419   PRC_ip85_42prc_ip85_42   PRC_ip85_420prc_ip85_420   PRC_ip85_421prc_ip85_421   PRC_ip85_422prc_ip85_422   PRC_ip85_423prc_ip85_423   PRC_ip85_424prc_ip85_424   PRC_ip85_425prc_ip85_425   PRC_ip85_426prc_ip85_426   PRC_ip85_427prc_ip85_427   PRC_ip85_429prc_ip85_429   PRC_ip85_43prc_ip85_43   PRC_ip85_430prc_ip85_430   PRC_ip85_431prc_ip85_431   PRC_ip85_432prc_ip85_432   PRC_ip85_433prc_ip85_433   PRC_ip85_434prc_ip85_434   PRC_ip85_435prc_ip85_435   PRC_ip85_436prc_ip85_436   PRC_ip85_437prc_ip85_437   PRC_ip85_438prc_ip85_438   PRC_ip85_439prc_ip85_439   PRC_ip85_44prc_ip85_44   PRC_ip85_440prc_ip85_440   PRC_ip85_441prc_ip85_441   PRC_ip85_442prc_ip85_442   PRC_ip85_443prc_ip85_443   PRC_ip85_444prc_ip85_444   PRC_ip85_445prc_ip85_445   PRC_ip85_446prc_ip85_446   PRC_ip85_447prc_ip85_447   PRC_ip85_448prc_ip85_448   PRC_ip85_449prc_ip85_449   PRC_ip85_45prc_ip85_45   PRC_ip85_450prc_ip85_450   PRC_ip85_451prc_ip85_451   PRC_ip85_452prc_ip85_452   PRC_ip85_453prc_ip85_453   PRC_ip85_454prc_ip85_454   PRC_ip85_455prc_ip85_455   PRC_ip85_456prc_ip85_456   PRC_ip85_457prc_ip85_457   PRC_ip85_458prc_ip85_458   PRC_ip85_459prc_ip85_459   PRC_ip85_46prc_ip85_46   PRC_ip85_460prc_ip85_460   PRC_ip85_461prc_ip85_461   PRC_ip85_462prc_ip85_462   PRC_ip85_463prc_ip85_463   PRC_ip85_47prc_ip85_47   PRC_ip85_48prc_ip85_48   PRC_ip85_485prc_ip85_485   PRC_ip85_486prc_ip85_486   PRC_ip85_49prc_ip85_49
   PRC_ip85_5
prc_ip85_5   PRC_ip85_50prc_ip85_50   PRC_ip85_51prc_ip85_51   PRC_ip85_512prc_ip85_512   PRC_ip85_513prc_ip85_513   PRC_ip85_514prc_ip85_514   PRC_ip85_515prc_ip85_515   PRC_ip85_516prc_ip85_516   PRC_ip85_517prc_ip85_517   PRC_ip85_518prc_ip85_518   PRC_ip85_519prc_ip85_519   PRC_ip85_52prc_ip85_52   PRC_ip85_520prc_ip85_520   PRC_ip85_521prc_ip85_521   PRC_ip85_522prc_ip85_522   PRC_ip85_523prc_ip85_523   PRC_ip85_524prc_ip85_524   PRC_ip85_525prc_ip85_525   PRC_ip85_526prc_ip85_526   PRC_ip85_527prc_ip85_527   PRC_ip85_528prc_ip85_528   PRC_ip85_529prc_ip85_529   PRC_ip85_53prc_ip85_53   PRC_ip85_533prc_ip85_533   PRC_ip85_534prc_ip85_534   PRC_ip85_535prc_ip85_535   PRC_ip85_536prc_ip85_536   PRC_ip85_537prc_ip85_537   PRC_ip85_538prc_ip85_538   PRC_ip85_539prc_ip85_539   PRC_ip85_54prc_ip85_54   PRC_ip85_541prc_ip85_541   PRC_ip85_542prc_ip85_542   PRC_ip85_543prc_ip85_543   PRC_ip85_544prc_ip85_544   PRC_ip85_545prc_ip85_545   PRC_ip85_546prc_ip85_546   PRC_ip85_547prc_ip85_547   PRC_ip85_548prc_ip85_548   PRC_ip85_549prc_ip85_549   PRC_ip85_55prc_ip85_55   PRC_ip85_56prc_ip85_56   PRC_ip85_569prc_ip85_569   PRC_ip85_57prc_ip85_57   PRC_ip85_58prc_ip85_58   PRC_ip85_59prc_ip85_59
   PRC_ip85_6
prc_ip85_6   PRC_ip85_60prc_ip85_60   PRC_ip85_61prc_ip85_61   PRC_ip85_62prc_ip85_62   PRC_ip85_63prc_ip85_63   PRC_ip85_64prc_ip85_64   PRC_ip85_65prc_ip85_65   PRC_ip85_66prc_ip85_66   PRC_ip85_67prc_ip85_67   PRC_ip85_69prc_ip85_69   PRC_ip85_70prc_ip85_70   PRC_ip85_71prc_ip85_71   PRC_ip85_72prc_ip85_72   PRC_ip85_73prc_ip85_73   PRC_ip85_74prc_ip85_74   PRC_ip85_75prc_ip85_75   PRC_ip85_76prc_ip85_76   PRC_ip85_77prc_ip85_77   PRC_ip85_78prc_ip85_78   PRC_ip85_79prc_ip85_79
   PRC_ip85_8
prc_ip85_8   PRC_ip85_80prc_ip85_80   PRC_ip85_81prc_ip85_81   PRC_ip85_82prc_ip85_82   PRC_ip85_83prc_ip85_83   PRC_ip85_86prc_ip85_86   PRC_ip85_87prc_ip85_87   PRC_ip85_88prc_ip85_88   PRC_ip85_89prc_ip85_89
   PRC_ip85_9
prc_ip85_9   PRC_ip85_90prc_ip85_90   PRC_ip85_91prc_ip85_91   PRC_ip85_92prc_ip85_92   PRC_ip85_93prc_ip85_93   PRC_ip85_94prc_ip85_94   PRC_ip85_95prc_ip85_95   PRC_ip85_96prc_ip85_96   PRC_ip85_97prc_ip85_97   PRC_ip85_98prc_ip85_98   PRC_ip85_99prc_ip85_99
   PRC_ip86_0
prc_ip86_02dapoison1452dapoison005   Recipe for ireq_staffval   Recipe for Adventurer's Robeireq_adverobe$   Recipe for Amulet of Acid Resistanceireq_ammyreac$   Recipe for Amulet of Cold Resistanceireq_ammyrecd*   Recipe for Amulet of Electrical Resistanceireq_ammyreel$   Recipe for Amulet of Fire Resistanceireq_ammyrefr%   Recipe for Amulet of Natural Armor +1ireq_amulnat1%   Recipe for Amulet of Natural Armor +2ireq_amulnat2%   Recipe for Amulet of Natural Armor +3ireq_amulnat3%   Recipe for Amulet of Natural Armor +4ireq_amulnat4%   Recipe for Amulet of Natural Armor +5ireq_amulnat5    Recipe for Amulet of the Harpersireq_amulharp#   Recipe for Amulet of Undead Turningireq_amulturn   Recipe for Amulet of Will +1ireq_amywill1   Recipe for Amulet of Will +2ireq_amywill2   Recipe for Amulet of Will +3ireq_amywill3   Recipe for Amulet of Will +4ireq_amywill4   Recipe for Amulet of Will +5ireq_amywill5   Recipe for Amulet of Will +6ireq_amywill6   Recipe for Amulet of Will +7ireq_amywill7   Recipe for Arrow +1ireq_arrow001   Recipe for Arrow +2ireq_arrow002   Recipe for Arrow +3ireq_arrow003   Recipe for Arrow +4ireq_arrow004   Recipe for Arrow +5ireq_arrow005#   Recipe for Arvoreen's Amulet of Aidireq_amularvr   Recipe for Austruth Harpireq_instanst   Recipe for Bag of Holdingireq_baghold0   Recipe for Banded Mail +1ireq_bandmai1   Recipe for Banded Mail +2ireq_bandmai2   Recipe for Banded Mail +3ireq_bandmai3   Recipe for Banded Mail +4ireq_bandmai4   Recipe for Banded Mail +5ireq_bandmai5   Recipe for Banded Mail +6ireq_bandmai6   Recipe for Banded Mail +7ireq_bandmai7   Recipe for Bastard Sword +1ireq_bastard1   Recipe for Bastard Sword +2ireq_bastard2   Recipe for Bastard Sword +3ireq_bastard3   Recipe for Bastard Sword +4ireq_bastard4   Recipe for Bastard Sword +5ireq_bastard5   Recipe for Bastard Sword +6ireq_bastard6   Recipe for Bastard Sword +7ireq_bastard7   Recipe for Battleaxe +1ireq_battlea1   Recipe for Battleaxe +2ireq_battlea2   Recipe for Battleaxe +3ireq_battlea3   Recipe for Battleaxe +4ireq_battlea4   Recipe for Battleaxe +5ireq_battlea5   Recipe for Battleaxe +6ireq_battlea6   Recipe for Battleaxe +7ireq_battlea7   Recipe for Beholder Crownireq_hbndbeho   Recipe for Belt of Agility +1ireq_beltagi1   Recipe for Belt of Agility +2ireq_beltagi2   Recipe for Belt of Agility +3ireq_beltagi3   Recipe for Belt of Agility +4ireq_beltagi4   Recipe for Belt of Agility +5ireq_beltagi5   Recipe for Belt of Agility +6ireq_beltagi6   Recipe for Belt of Agility +7ireq_beltagi7'   Recipe for Belt of Cloud Giant Strengthireq_beltgiac&   Recipe for Belt of Fire Giant Strengthireq_beltgiar'   Recipe for Belt of Frost Giant Strengthireq_beltgiaf&   Recipe for Belt of Hill Giant Strengthireq_beltgiah   Recipe for Belt of Lionsireq_beltlion'   Recipe for Belt of Storm Giant Strengthireq_beltgias%   Recipe for Black Robe of the Archmagiireq_robearcb   Recipe for Bolt +1ireq_bolt0001   Recipe for Bolt +2ireq_bolt0002   Recipe for Bolt +3ireq_bolt0003   Recipe for Bolt +4ireq_bolt0004   Recipe for Bolt +5ireq_bolt0005   Recipe for Boots of Elvenkindireq_bootelvn    Recipe for Boots of Hardiness +1ireq_boothar1    Recipe for Boots of Hardiness +2ireq_boothar2    Recipe for Boots of Hardiness +3ireq_boothar3   Recipe for Boots of Reflexes +1ireq_bootref1   Recipe for Boots of Reflexes +2ireq_bootref2   Recipe for Boots of Reflexes +3ireq_bootref3   Recipe for Boots of Reflexes +4ireq_bootref4   Recipe for Boots of Reflexes +5ireq_bootref5   Recipe for Boots of Reflexes +6ireq_bootref6   Recipe for Boots of Reflexes +7ireq_bootref7   Recipe for Boots of Speedireq_bootspee   Recipe for Boots of Striding +1ireq_bootstr1   Recipe for Boots of Striding +2ireq_bootstr2   Recipe for Boots of Striding +3ireq_bootstr3   Recipe for Boots of Striding +4ireq_bootstr4   Recipe for Boots of Striding +5ireq_bootstr5   Recipe for Boots of Striding +6ireq_bootstr6   Recipe for Boots of Striding +7ireq_bootstr7#   Recipe for Boots of the Sun Soul +1ireq_bootsun1#   Recipe for Boots of the Sun Soul +2ireq_bootsun2#   Recipe for Boots of the Sun Soul +3ireq_bootsun3#   Recipe for Boots of the Sun Soul +4ireq_bootsun4#   Recipe for Boots of the Sun Soul +5ireq_bootsun5#   Recipe for Boots of the Winterlandsireq_bootwint.   Recipe for Bowl of Commanding Water Elementalsireq_bowlwatr   Recipe for Bracers of Archeryireq_bracarch   Recipe for Bracers of Armor +1ireq_bracarm1   Recipe for Bracers of Armor +10ireq_bracarm0   Recipe for Bracers of Armor +2ireq_bracarm2   Recipe for Bracers of Armor +3ireq_bracarm3   Recipe for Bracers of Armor +4ireq_bracarm4   Recipe for Bracers of Armor +5ireq_bracarm5   Recipe for Bracers of Armor +6ireq_bracarm6   Recipe for Bracers of Armor +7ireq_bracarm7   Recipe for Bracers of Armor +8ireq_bracarm8   Recipe for Bracers of Armor +9ireq_bracarm9"   Recipe for Bracers of Dexterity +1ireq_glovdex1#   Recipe for Bracers of Dexterity +10ireq_glovdex0"   Recipe for Bracers of Dexterity +2ireq_glovdex2"   Recipe for Bracers of Dexterity +3ireq_glovdex3"   Recipe for Bracers of Dexterity +4ireq_glovdex4"   Recipe for Bracers of Dexterity +5ireq_glovdex5"   Recipe for Bracers of Dexterity +6ireq_glovdex6"   Recipe for Bracers of Dexterity +7ireq_glovdex7"   Recipe for Bracers of Dexterity +8ireq_glovdex8"   Recipe for Bracers of Dexterity +9ireq_glovdex9)   Recipe for Bracers of the Blinding Strikeireq_bracblnd0   Recipe for Brazier of Commanding Fire Elementalsireq_brazfire   Recipe for Breastplate +1ireq_breastp1   Recipe for Breastplate +2ireq_breastp2   Recipe for Breastplate +3ireq_breastp3   Recipe for Breastplate +4ireq_breastp4   Recipe for Breastplate +5ireq_breastp5   Recipe for Breastplate +6ireq_breastp6   Recipe for Breastplate +7ireq_breastp7   Recipe for Brooch of Shieldingireq_brooshld   Recipe for Bullet +1ireq_bullet01   Recipe for Bullet +2ireq_bullet02   Recipe for Bullet +3ireq_bullet03   Recipe for Bullet +4ireq_bullet04   Recipe for Bullet +5ireq_bullet05   Recipe for Canaith Mandolinireq_instcana    Recipe for Cape of the Fire Bathireq_capefire   Recipe for Cape of Winterireq_capewint/   Recipe for Censer of Controlling Air Elementalsireq_censair   Recipe for Chain Shirt +1ireq_chainsh1   Recipe for Chain Shirt +2ireq_chainsh2   Recipe for Chain Shirt +3ireq_chainsh3   Recipe for Chain Shirt +4ireq_chainsh4   Recipe for Chain Shirt +5ireq_chainsh5   Recipe for Chain Shirt +6ireq_chainsh6   Recipe for Chain Shirt +7ireq_chainsh7   Recipe for Chainmail +1ireq_chainma1   Recipe for Chainmail +2ireq_chainma2   Recipe for Chainmail +3ireq_chainma3   Recipe for Chainmail +4ireq_chainma4   Recipe for Chainmail +5ireq_chainma5   Recipe for Chainmail +6ireq_chainma6   Recipe for Chainmail +7ireq_chainma7   Recipe for Chime of Openingireq_chimopen   Recipe for Cli Lyreireq_instclil   Recipe for Cloak of Arachnidaireq_clokarac   Recipe for Cloak of Blackflameireq_clokblfl    Recipe for Cloak of Displacementireq_clokdisp   Recipe for Cloak of Elvenkindireq_clokelvn)   Recipe for Cloak of Epic Spell Resistanceireq_mantsrep$   Recipe for Cloak of Fortification +1ireq_clkfort1$   Recipe for Cloak of Fortification +2ireq_clkfort2$   Recipe for Cloak of Fortification +3ireq_clkfort3$   Recipe for Cloak of Fortification +4ireq_clkfort4$   Recipe for Cloak of Fortification +5ireq_clkfort5   Recipe for Cloak of Movementireq_cloakmov!   Recipe for Cloak of Protection +1ireq_clkprot1!   Recipe for Cloak of Protection +2ireq_clkprot2!   Recipe for Cloak of Protection +3ireq_clkprot3!   Recipe for Cloak of Protection +4ireq_clkprot4!   Recipe for Cloak of Protection +5ireq_clkprot5!   Recipe for Cloak of Protection +6ireq_clkprot6!   Recipe for Cloak of Protection +7ireq_clkprot7!   Recipe for Cloak of Resistance +1ireq_clokres1!   Recipe for Cloak of Resistance +2ireq_clokres2!   Recipe for Cloak of Resistance +3ireq_clokres3!   Recipe for Cloak of Resistance +4ireq_clokres4!   Recipe for Cloak of Resistance +5ireq_clokres5   Recipe for Cloak of the Batireq_clokbat1   Recipe for Club +1ireq_club0001   Recipe for Club +2ireq_club0002   Recipe for Club +3ireq_club0003   Recipe for Club +4ireq_club0004   Recipe for Club +5ireq_club0005   Recipe for Club +6ireq_club0006   Recipe for Club +7ireq_club0007   Recipe for Composite Longbow +1ireq_clongbo1   Recipe for Composite Longbow +2ireq_clongbo2   Recipe for Composite Longbow +3ireq_clongbo3   Recipe for Composite Longbow +4ireq_clongbo4   Recipe for Composite Longbow +5ireq_clongbo5   Recipe for Composite Longbow +6ireq_clongbo6   Recipe for Composite Longbow +7ireq_clongbo7    Recipe for Composite Shortbow +1ireq_cshortb1    Recipe for Composite Shortbow +2ireq_cshortb2    Recipe for Composite Shortbow +3ireq_cshortb3    Recipe for Composite Shortbow +4ireq_cshortb4    Recipe for Composite Shortbow +5ireq_cshortb5    Recipe for Composite Shortbow +6ireq_cshortb6    Recipe for Composite Shortbow +7ireq_cshortb7   Recipe for Cowl of Wardingireq_cowlward   Recipe for Dagger +1ireq_dagger01   Recipe for Dagger +2ireq_dagger02   Recipe for Dagger +3ireq_dagger03   Recipe for Dagger +4ireq_dagger04   Recipe for Dagger +5ireq_dagger05   Recipe for Dagger +6ireq_dagger06   Recipe for Dagger +7ireq_dagger07   Recipe for Dart +1ireq_dart0001   Recipe for Dart +2ireq_dart0002   Recipe for Dart +3ireq_dart0003   Recipe for Dart +4ireq_dart0004   Recipe for Dart +5ireq_dart0005   Recipe for Dart +6ireq_dart0006   Recipe for Dart +7ireq_dart0007   Recipe for Dire Mace +1ireq_diremac1   Recipe for Dire Mace +2ireq_diremac2   Recipe for Dire Mace +3ireq_diremac3   Recipe for Dire Mace +4ireq_diremac4   Recipe for Dire Mace +5ireq_diremac5   Recipe for Dire Mace +6ireq_diremac6   Recipe for Dire Mace +7ireq_diremac7   Recipe for Doss Luteireq_instdoss   Recipe for Double Axe +1ireq_doublea1   Recipe for Double Axe +2ireq_doublea2   Recipe for Double Axe +3ireq_doublea3   Recipe for Double Axe +4ireq_doublea4   Recipe for Double Axe +5ireq_doublea5   Recipe for Double Axe +6ireq_doublea6   Recipe for Double Axe +7ireq_doublea7   Recipe for Dove's Harpireq_elixhoru   Recipe for Dove's Harpireq_harpdove   Recipe for Dust of Appearanceireq_dustappr    Recipe for Dust of Disappearanceireq_dustdisa   Recipe for Dwarven Waraxe +1ireq_dwarven1   Recipe for Dwarven Waraxe +2ireq_dwarven2   Recipe for Dwarven Waraxe +3ireq_dwarven3   Recipe for Dwarven Waraxe +4ireq_dwarven4   Recipe for Dwarven Waraxe +5ireq_dwarven5   Recipe for Dwarven Waraxe +6ireq_dwarven6   Recipe for Dwarven Waraxe +7ireq_dwarven7   Recipe for Eyes of Charmingireq_eyeschrm   Recipe for Eyes of Doomireq_eyesdoom    Recipe for Eyes of Petrificationireq_eyespetr   Recipe for Eyes of the Eagleireq_eyeseagl   Recipe for Fochluchan Bandoreireq_instfoch   Recipe for Full Plate +1ireq_fullpla1   Recipe for Full Plate +2ireq_fullpla2   Recipe for Full Plate +3ireq_fullpla3   Recipe for Full Plate +4ireq_fullpla4   Recipe for Full Plate +5ireq_fullpla5   Recipe for Full Plate +5ireq_fulpla5a   Recipe for Full Plate +6ireq_fullpla6   Recipe for Full Plate +6ireq_fulpla6a   Recipe for Full Plate +7ireq_fullpla7   Recipe for Gargoyle Bootsireq_gargboot   Recipe for Gauntlet of Furyireq_gaunfury"   Recipe for Gauntlets of Ogre Powerireq_gaunogre"   Recipe for Gauntlets of Ogre Powerireq_gaunogrl   Recipe for Gem of Brightnessireq_gembrite   Recipe for Gem of Seeingireq_gemsee   Recipe for Gloves of Lightningireq_glovligh$   Recipe for Gloves of the Hin Fist +1ireq_glovehf1$   Recipe for Gloves of the Hin Fist +2ireq_glovehf2$   Recipe for Gloves of the Hin Fist +3ireq_glovehf3$   Recipe for Gloves of the Hin Fist +4ireq_glovehf4$   Recipe for Gloves of the Hin Fist +5ireq_glovehf5$   Recipe for Gloves of the Hin Fist +6ireq_glovehf6$   Recipe for Gloves of the Hin Fist +7ireq_glovehf7&   Recipe for Gloves of the Long Death +1ireq_gloveld1&   Recipe for Gloves of the Long Death +2ireq_gloveld2&   Recipe for Gloves of the Long Death +3ireq_gloveld3&   Recipe for Gloves of the Long Death +4ireq_gloveld4&   Recipe for Gloves of the Long Death +5ireq_gloveld5&   Recipe for Gloves of the Long Death +6ireq_gloveld6&   Recipe for Gloves of the Long Death +7ireq_gloveld7'   Recipe for Gloves of the Yellow Rose +1ireq_gloveyr1'   Recipe for Gloves of the Yellow Rose +2ireq_gloveyr2'   Recipe for Gloves of the Yellow Rose +3ireq_gloveyr3'   Recipe for Gloves of the Yellow Rose +4ireq_gloveyr4'   Recipe for Gloves of the Yellow Rose +5ireq_gloveyr5'   Recipe for Gloves of the Yellow Rose +6ireq_gloveyr6'   Recipe for Gloves of the Yellow Rose +7ireq_gloveyr7#   Recipe for Goggles of Minute Seeingireq_goggmsee   Recipe for Goggles of Nightireq_goggnite   Recipe for Gold Necklaceireq_amulnat7&   Recipe for Golden Chalice of Lathanderireq_challath   Recipe for Greataxe +1ireq_greatax1   Recipe for Greataxe +2ireq_greatax2   Recipe for Greataxe +3ireq_greatax3   Recipe for Greataxe +4ireq_greatax4   Recipe for Greataxe +5ireq_greatax5   Recipe for Greataxe +6ireq_greatax6   Recipe for Greataxe +7ireq_greatax7-   Recipe for Greater Mantle of Spell Resistanceireq_mantsrgr   Recipe for Greater Robe of Eyesireq_robeeyeg   Recipe for Greatsword +1ireq_greatsw1   Recipe for Greatsword +2ireq_greatsw2   Recipe for Greatsword +3ireq_greatsw3   Recipe for Greatsword +4ireq_greatsw4   Recipe for Greatsword +5ireq_greatsw5   Recipe for Greatsword +6ireq_greatsw6   Recipe for Greatsword +7ireq_greatsw7$   Recipe for Grey Robe of the Archmagiireq_robearcg   Recipe for Halberd +1ireq_halberd1   Recipe for Halberd +2ireq_halberd2   Recipe for Halberd +3ireq_halberd3   Recipe for Halberd +4ireq_halberd4   Recipe for Halberd +5ireq_halberd5   Recipe for Halberd +6ireq_halberd6   Recipe for Halberd +7ireq_halberd7   Recipe for Half Plate +1ireq_halfpla1   Recipe for Half Plate +2ireq_halfpla2   Recipe for Half Plate +3ireq_halfpla3   Recipe for Half Plate +4ireq_halfpla4   Recipe for Half Plate +5ireq_halfpla5   Recipe for Half Plate +6ireq_halfpla6   Recipe for Half Plate +7ireq_halfpla7   Recipe for Handaxe +1ireq_handaxe1   Recipe for Handaxe +2ireq_handaxe2   Recipe for Handaxe +3ireq_handaxe3   Recipe for Handaxe +4ireq_handaxe4   Recipe for Handaxe +5ireq_handaxe5   Recipe for Handaxe +6ireq_handaxe6   Recipe for Handaxe +7ireq_handaxe7   Recipe for Harp of Charmingireq_harpchrm#   Recipe for Headband of Intellect +2ireq_hbndint2#   Recipe for Headband of Intellect +4ireq_hbndint4#   Recipe for Headband of Intellect +6ireq_hbndint6!   Recipe for Headband of the Binderireq_hbndbind   Recipe for Heart of the Beastireq_hartbeas   Recipe for Heavy Crossbow +1ireq_heavycr1   Recipe for Heavy Crossbow +2ireq_heavycr2   Recipe for Heavy Crossbow +3ireq_heavycr3   Recipe for Heavy Crossbow +4ireq_heavycr4   Recipe for Heavy Crossbow +5ireq_heavycr5   Recipe for Heavy Crossbow +6ireq_heavycr6   Recipe for Heavy Crossbow +7ireq_heavycr7   Recipe for Heavy Flail +1ireq_heavyfl1   Recipe for Heavy Flail +2ireq_heavyfl2   Recipe for Heavy Flail +3ireq_heavyfl3   Recipe for Heavy Flail +4ireq_heavyfl4   Recipe for Heavy Flail +5ireq_heavyfl5   Recipe for Heavy Flail +6ireq_heavyfl6   Recipe for Heavy Flail +7ireq_heavyfl7   Recipe for Helm of Brillianceireq_helmbril   Recipe for Helm of Darknessireq_helmdark   Recipe for Hide Armor +1ireq_hidearm1   Recipe for Hide Armor +2ireq_hidearm2   Recipe for Hide Armor +3ireq_hidearm3   Recipe for Hide Armor +4ireq_hidearm4   Recipe for Hide Armor +5ireq_hidearm5   Recipe for Hide Armor +6ireq_hidearm6   Recipe for Hide Armor +7ireq_hidearm7   Recipe for Horn of Blastingireq_hornblst    Recipe for Horn of Goodness/Evilireq_horngdev"   Recipe for Instrument of the Windsireq_instwind   Recipe for Janthra's Harpireq_harpjant   Recipe for Kama +1ireq_kama0001   Recipe for Kama +2ireq_kama0002   Recipe for Kama +3ireq_kama0003   Recipe for Kama +4ireq_kama0004   Recipe for Kama +5ireq_kama0005   Recipe for Kama +6ireq_kama0006   Recipe for Kama +7ireq_kama0007   Recipe for Katana +1ireq_katana01   Recipe for Katana +2ireq_katana02   Recipe for Katana +3ireq_katana03   Recipe for Katana +4ireq_katana04   Recipe for Katana +5ireq_katana05   Recipe for Katana +6ireq_katana06   Recipe for Katana +7ireq_katana07+   Recipe for Kossuth's Belt of Priestly Mightireq_beltpmtk   Recipe for Kukri +1ireq_kukri001   Recipe for Kukri +2ireq_kukri002   Recipe for Kukri +3ireq_kukri003   Recipe for Kukri +4ireq_kukri004   Recipe for Kukri +5ireq_kukri005   Recipe for Kukri +6ireq_kukri006   Recipe for Kukri +7ireq_kukri007   Recipe for Lantern of Revealingireq_lantreve   Recipe for Large Shield +1ireq_largesh1   Recipe for Large Shield +2ireq_largesh2   Recipe for Large Shield +3ireq_largesh3   Recipe for Large Shield +4ireq_largesh4   Recipe for Large Shield +5ireq_largesh5   Recipe for Large Shield +6ireq_largesh6   Recipe for Large Shield +7ireq_largesh7   Recipe for Leather Armor +1ireq_leather1   Recipe for Leather Armor +2ireq_leather2   Recipe for Leather Armor +3ireq_leather3   Recipe for Leather Armor +4ireq_leather4   Recipe for Leather Armor +5ireq_leather5   Recipe for Leather Armor +6ireq_leather6   Recipe for Leather Armor +7ireq_leather7   Recipe for Lens of Detectionireq_lensdete-   Recipe for Lesser Ice Necklace of the Ulutiunireq_neckulul   Recipe for Lesser Robe of Eyesireq_robeeyel   Recipe for Light Crossbow +1ireq_lightcr1   Recipe for Light Crossbow +2ireq_lightcr2   Recipe for Light Crossbow +3ireq_lightcr3   Recipe for Light Crossbow +4ireq_lightcr4   Recipe for Light Crossbow +5ireq_lightcr5   Recipe for Light Crossbow +6ireq_lightcr6   Recipe for Light Crossbow +7ireq_lightcr7   Recipe for Light Flail +1ireq_lightfl1   Recipe for Light Flail +2ireq_lightfl2   Recipe for Light Flail +3ireq_lightfl3   Recipe for Light Flail +4ireq_lightfl4   Recipe for Light Flail +5ireq_lightfl5   Recipe for Light Flail +6ireq_lightfl6   Recipe for Light Flail +7ireq_lightfl7   Recipe for Light Hammer +1ireq_lightha1   Recipe for Light Hammer +2ireq_lightha2   Recipe for Light Hammer +3ireq_lightha3   Recipe for Light Hammer +4ireq_lightha4   Recipe for Light Hammer +5ireq_lightha5   Recipe for Light Hammer +6ireq_lightha6   Recipe for Light Hammer +7ireq_lightha7   Recipe for Longbow +1ireq_longbow1   Recipe for Longbow +2ireq_longbow2   Recipe for Longbow +3ireq_longbow3   Recipe for Longbow +4ireq_longbow4   Recipe for Longbow +5ireq_longbow5   Recipe for Longbow +6ireq_longbow6   Recipe for Longbow +7ireq_longbow7   Recipe for Longsword +1ireq_longswo1   Recipe for Longsword +2ireq_longswo2   Recipe for Longsword +3ireq_longswo3   Recipe for Longsword +4ireq_longswo4   Recipe for Longsword +5ireq_longswo5   Recipe for Longsword +6ireq_longswo6   Recipe for Longsword +7ireq_longswo7   Recipe for Mace +1ireq_mace0001   Recipe for Mace +2ireq_mace0002   Recipe for Mace +3ireq_mace0003   Recipe for Mace +4ireq_mace0004   Recipe for Mace +5ireq_mace0005   Recipe for Mace +6ireq_mace0006   Recipe for Mace +7ireq_mace0007   Recipe for Mac-Fuirmidh Cithernireq_instmacf$   Recipe for Major Circlet of Blastingireq_circblag   Recipe for Mask of the Skullireq_maskskul#   Recipe for Master Adventurer's Robeireq_masadcrb$   Recipe for Minor Circlet of Blastingireq_circblal   Recipe for Monk's Beltireq_beltmonk   Recipe for Morningstar +1ireq_morning1   Recipe for Morningstar +2ireq_morning2   Recipe for Morningstar +3ireq_morning3   Recipe for Morningstar +4ireq_morning4   Recipe for Morningstar +5ireq_morning5   Recipe for Morningstar +6ireq_morning6   Recipe for Morningstar +7ireq_morning7)   Recipe for Mystran Belt of Priestly Mightireq_beltpmtm5   Recipe for Mystran Belt of Priestly Might and Wardingireq_beltpmwm    Recipe for Necklace of Fireballsireq_neckfblg    Recipe for Necklace of Fireballsireq_neckfbll#   Recipe for Necklace of Prayer Beadsireq_neckpray   Recipe for Nymph Cloak +1ireq_clokcha1   Recipe for Nymph Cloak +2ireq_clokcha2   Recipe for Nymph Cloak +3ireq_clokcha3   Recipe for Nymph Cloak +4ireq_clokcha4   Recipe for Nymph Cloak +5ireq_clokcha5   Recipe for Nymph Cloak +6ireq_clokcha6   Recipe for Nymph Cloak +7ireq_clokcha7   Recipe for Ollamh Harpireq_instolam   Recipe for Padded Armor +1ireq_paddeda1   Recipe for Padded Armor +2ireq_paddeda2   Recipe for Padded Armor +3ireq_paddeda3   Recipe for Padded Armor +4ireq_paddeda4   Recipe for Padded Armor +5ireq_paddeda5   Recipe for Padded Armor +6ireq_paddeda6   Recipe for Padded Armor +7ireq_paddeda7   Recipe for Periapt of Wisdom +1ireq_periwis1    Recipe for Periapt of Wisdom +10ireq_periwis0   Recipe for Periapt of Wisdom +2ireq_periwis2   Recipe for Periapt of Wisdom +3ireq_periwis3   Recipe for Periapt of Wisdom +4ireq_periwis4   Recipe for Periapt of Wisdom +5ireq_periwis5   Recipe for Periapt of Wisdom +6ireq_periwis6   Recipe for Periapt of Wisdom +7ireq_periwis7   Recipe for Periapt of Wisdom +8ireq_periwis8   Recipe for Periapt of Wisdom +9ireq_periwis9   Recipe for Phylacteryireq_amullich   Recipe for Quarterstaff +1ireq_quarter1   Recipe for Quarterstaff +2ireq_quarter2   Recipe for Quarterstaff +3ireq_quarter3   Recipe for Quarterstaff +4ireq_quarter4   Recipe for Quarterstaff +5ireq_quarter5   Recipe for Quarterstaff +6ireq_quarter6   Recipe for Quarterstaff +7ireq_quarter7   Recipe for Rapier +1ireq_rapier01   Recipe for Rapier +2ireq_rapier02   Recipe for Rapier +3ireq_rapier03   Recipe for Rapier +4ireq_rapier04   Recipe for Rapier +5ireq_rapier05   Recipe for Rapier +6ireq_rapier06   Recipe for Rapier +7ireq_rapier07#   Recipe for Ring of Clear Thought +1ireq_ringcth1#   Recipe for Ring of Clear Thought +2ireq_ringcth2#   Recipe for Ring of Clear Thought +3ireq_ringcth3#   Recipe for Ring of Clear Thought +4ireq_ringcth4#   Recipe for Ring of Clear Thought +5ireq_ringcth5#   Recipe for Ring of Clear Thought +6ireq_ringcth6#   Recipe for Ring of Clear Thought +7ireq_ringcth7   Recipe for Ring of Fortitude +1ireq_ringfrt1   Recipe for Ring of Fortitude +2ireq_ringfrt2   Recipe for Ring of Fortitude +3ireq_ringfrt3   Recipe for Ring of Fortitude +4ireq_ringfrt4   Recipe for Ring of Fortitude +5ireq_ringfrt5   Recipe for Ring of Fortitude +6ireq_ringfrt6   Recipe for Ring of Fortitude +7ireq_ringfrt7&   Recipe for Ring of Freedom of Movementireq_ringfree   Recipe for Ring of Hidingireq_ringhide   Recipe for Ring of Insightireq_ringinsi   Recipe for Ring of Invisibilityireq_ringinvs!   Recipe for Ring of Magic Defencesireq_ringofmd   Recipe for Ring of Nine Livesireq_ringnine    Recipe for Ring of Protection +1ireq_ringpro1    Recipe for Ring of Protection +2ireq_ringpro2    Recipe for Ring of Protection +3ireq_ringpro3    Recipe for Ring of Protection +4ireq_ringpro4    Recipe for Ring of Protection +5ireq_ringpro5    Recipe for Ring of Protection +6ireq_ringpro6    Recipe for Ring of Protection +7ireq_ringpro7   Recipe for Ring of Scholarsireq_ringscho   Recipe for Robe of Blendingireq_robblend'   Recipe for Robe of Scintillating Colorsireq_robescin'   Recipe for Robes of the Shining Hand +1ireq_robessh1'   Recipe for Robes of the Shining Hand +2ireq_robessh2'   Recipe for Robes of the Shining Hand +3ireq_robessh3'   Recipe for Robes of the Shining Hand +4ireq_robessh4'   Recipe for Robes of the Shining Hand +5ireq_robessh5'   Recipe for Robes of the Shining Hand +6ireq_robessh6'   Recipe for Robes of the Shining Hand +7ireq_robessh7   Recipe for Rod of Beguilingireq_rodofbeg   Recipe for Rod of Resurrectionireq_rodofres   Recipe for Rod of Reversalireq_rodofrev   Recipe for Rod of Terrorireq_rodofter   Recipe for Rod of the Ghostireq_rodofgho'   Recipe for Rod of Thunder and Lightningireq_rodoftal   Recipe for Scale Mail +1ireq_scalema1   Recipe for Scale Mail +2ireq_scalema2   Recipe for Scale Mail +3ireq_scalema3   Recipe for Scale Mail +4ireq_scalema4   Recipe for Scale Mail +5ireq_scalem5a   Recipe for Scale Mail +5ireq_scalema5   Recipe for Scale Mail +6ireq_scalema6   Recipe for Scale Mail +7ireq_scalema7   Recipe for Scarab of Protectionireq_scbprot   Recipe for Scimitar +1ireq_scimita1   Recipe for Scimitar +2ireq_scimita2   Recipe for Scimitar +3ireq_scimita3   Recipe for Scimitar +4ireq_scimita4   Recipe for Scimitar +5ireq_scimita5   Recipe for Scimitar +6ireq_scimita6   Recipe for Scimitar +7ireq_scimita7   Recipe for Scythe +1ireq_scythe01   Recipe for Scythe +2ireq_scythe02   Recipe for Scythe +3ireq_scythe03   Recipe for Scythe +4ireq_scythe04   Recipe for Scythe +5ireq_scythe05   Recipe for Scythe +6ireq_scythe06   Recipe for Scythe +7ireq_scythe074   Recipe for Shar's Belt of Priestly Might and Wardingireq_beltpmws   Recipe for Short Sword +1ireq_shortsw1   Recipe for Short Sword +2ireq_shortsw2   Recipe for Short Sword +3ireq_shortsw3   Recipe for Short Sword +4ireq_shortsw4   Recipe for Short Sword +5ireq_shortsw5   Recipe for Short Sword +6ireq_shortsw6   Recipe for Short Sword +7ireq_shortsw7   Recipe for Shortbow +1ireq_shortbo1   Recipe for Shortbow +2ireq_shortbo2   Recipe for Shortbow +3ireq_shortbo3   Recipe for Shortbow +4ireq_shortbo4   Recipe for Shortbow +5ireq_shortbo5   Recipe for Shortbow +6ireq_shortbo6   Recipe for Shortbow +7ireq_shortbo7   Recipe for Shuriken +1ireq_shurike1   Recipe for Shuriken +2ireq_shurike2   Recipe for Shuriken +3ireq_shurike3   Recipe for Shuriken +4ireq_shurike4   Recipe for Shuriken +5ireq_shurike5   Recipe for Shuriken +6ireq_shurike6   Recipe for Shuriken +7ireq_shurike7   Recipe for Sickle +1ireq_sickle01   Recipe for Sickle +2ireq_sickle02   Recipe for Sickle +3ireq_sickle03   Recipe for Sickle +4ireq_sickle04   Recipe for Sickle +5ireq_sickle05   Recipe for Sickle +6ireq_sickle06   Recipe for Sickle +7ireq_sickle07   Recipe for Silver Necklaceireq_amulnat6   Recipe for Sling +1ireq_sling001   Recipe for Sling +2ireq_sling002   Recipe for Sling +3ireq_sling003   Recipe for Sling +4ireq_sling004   Recipe for Sling +5ireq_sling005   Recipe for Sling +6ireq_sling006   Recipe for Sling +7ireq_sling007   Recipe for Small Shield +1ireq_smallsh1   Recipe for Small Shield +2ireq_smallsh2   Recipe for Small Shield +3ireq_smallsh3   Recipe for Small Shield +4ireq_smallsh4   Recipe for Small Shield +5ireq_smallsh5   Recipe for Small Shield +6ireq_smallsh6   Recipe for Small Shield +7ireq_smallsh7   Recipe for Soul Gemireq_soulgem   Recipe for Spear +1ireq_spear001   Recipe for Spear +2ireq_spear002   Recipe for Spear +3ireq_spear003   Recipe for Spear +4ireq_spear004   Recipe for Spear +5ireq_spear005   Recipe for Spear +6ireq_spear006   Recipe for Spear +7ireq_spear007   Recipe for Splint Mail +1ireq_splintm1   Recipe for Splint Mail +2ireq_splintm2   Recipe for Splint Mail +3ireq_splintm3   Recipe for Splint Mail +4ireq_splintm4   Recipe for Splint Mail +5ireq_splintm5   Recipe for Splint Mail +6ireq_splintm6   Recipe for Splint Mail +7ireq_splintm7   Recipe for Staff of Abjurationireq_staffabj   Recipe for Staff of Commandireq_staffcom   Recipe for Staff of Conjurationireq_staffcon   Recipe for Staff of Defenseireq_staffdef   Recipe for Staff of Divinationireq_staffdiv   Recipe for Staff of Enchantmentireq_staffenc   Recipe for Staff of Evocationireq_staffevo   Recipe for Staff of Frostireq_stafffro   Recipe for Staff of Healingireq_staffhea    Recipe for Staff of Illuminationireq_staffilm   Recipe for Staff of Illusionireq_staffill   Recipe for Staff of Lifeireq_stafflif   Recipe for Staff of Necromancyireq_staffnec   Recipe for Staff of Powerireq_staffpow   Recipe for Staff of the Holyireq_staffhly   Recipe for Staff of the Magiireq_staffmgi!   Recipe for Staff of the Woodlandsireq_staffwoo!   Recipe for Staff of Transmutationireq_stafftra    Recipe for Staff of True Defenseireq_stafftde   Recipe for Staff of True Powerireq_stafftpo0   Recipe for Stone of Controlling Earth Elementalsireq_stoneart#   Recipe for Studded Leather Armor +1ireq_studded1#   Recipe for Studded Leather Armor +2ireq_studded2#   Recipe for Studded Leather Armor +3ireq_studded3#   Recipe for Studded Leather Armor +4ireq_studded4#   Recipe for Studded Leather Armor +5ireq_studded5#   Recipe for Studded Leather Armor +6ireq_studded6#   Recipe for Studded Leather Armor +7ireq_studded7   Recipe for Throwing Axe +1ireq_throwax1   Recipe for Throwing Axe +2ireq_throwax2   Recipe for Throwing Axe +3ireq_throwax3   Recipe for Throwing Axe +4ireq_throwax4   Recipe for Throwing Axe +5ireq_throwax5   Recipe for Throwing Axe +6ireq_throwax6   Recipe for Throwing Axe +7ireq_throwax7   Recipe for Tower Shield +1ireq_towersh1   Recipe for Tower Shield +2ireq_towersh2   Recipe for Tower Shield +3ireq_towersh3   Recipe for Tower Shield +4ireq_towersh4   Recipe for Tower Shield +5ireq_towersh5   Recipe for Tower Shield +6ireq_towersh6   Recipe for Tower Shield +7ireq_towersh7   Recipe for Two-Bladed Sword +1ireq_twoblad1   Recipe for Two-Bladed Sword +2ireq_twoblad2   Recipe for Two-Bladed Sword +3ireq_twoblad3   Recipe for Two-Bladed Sword +4ireq_twoblad4   Recipe for Two-Bladed Sword +5ireq_twoblad5   Recipe for Two-Bladed Sword +6ireq_twoblad6   Recipe for Two-Bladed Sword +7ireq_twoblad7   Recipe for Vest of Escapeireq_vestescp   Recipe for Vestments of Faithireq_vestfait   Recipe for Warhammer +1ireq_warhamm1   Recipe for Warhammer +2ireq_warhamm2   Recipe for Warhammer +3ireq_warhamm3   Recipe for Warhammer +4ireq_warhamm4   Recipe for Warhammer +5ireq_warhamm5   Recipe for Warhammer +6ireq_warhamm6   Recipe for Warhammer +7ireq_warhamm7   Recipe for Whip +1ireq_whip0001   Recipe for Whip +2ireq_whip0002   Recipe for Whip +3ireq_whip0003   Recipe for Whip +4ireq_whip0004   Recipe for Whip +5ireq_whip0005   Recipe for Whip +6ireq_whip0006   Recipe for Whip +7ireq_whip0007%   Recipe for White Robe of the Archmagiireq_robearcw2dapoison1372dapoison0162dapoison010   Shadow Walkers Tokenshadowwalkerstok   Shifter Hideshifterhide2dapoison0012dapoison1292dapoison035   Spark of Lifesparkoflife   SparkBoxpnp_shft_sprkbox2dapoison0222dapoison1382dapoison0172dapoison1222dapoison1282dapoison034   Unarmed Weaponprc_unarmed_b   Unarmed Weaponprc_unarmed_p   Unarmed Weaponprc_unarmed_s2dapoison0262dapoison1462dapoison1392dapoison1362dapoison0072dapoison044   Epic Spellcastingepicspellcasting
   Phylactery
lichamulet   Soul Gemsoul_gem   A Gem Caged Creatureit_gemcage_gem   Platinum Armor +4platinumarmor4   Platinum Armor +6platinumarmor6   Platinum Armor +8platinumarmor8   Imbued Arrowwp_arr_imbue_1   Doombringer Lord Axe
prc_tn_dbl   Runescarred Daggerrunescarreddagge   BaalSummon1Kurkibaalsummon1kurki   Masterwork Katanacodi_mw_katana   Masterwork Wakizashicodi_mw_short   Baal Summon 2 Axebaalsummon2axe   Defender's Twinrash5   Demonspike Cleaverrash10   Flesh Reaverrash8   Shattering Crashrash9   Southern Icerash7   Star of the Rashemirash6   Whip of Shar
whipofshar   Staff of Abjurationjd_wmgst001   Staff of Conjurationjd_wmgst002   Staff of Divinationjd_wmgst003   Staff of Enchantmentjd_wmgst004   Staff of Evocationjd_wmgst005   Staff of Firejd_wmgst006   Staff of Frostjd_wmgst007   Staff of Healingjd_wmgst008   Staff of Illuminationjd_wmgst010   Staff of Illusionjd_wmgst009   Staff of Lifejd_wmgst011   Staff of Necromancyjd_wmgst012   Staff of the Woodlandsjd_wmgst015   Staff of Transmutationjd_wmgst014   Staff of True Defensejd_wmgst016   Staff of True Powerjd_wmgst013   Flaming Composite Longbowflamingcomposite   Henchy Axe of Doom	ow_taxe_1   Never Ending Bag of Caltropsow_caltrops                        	   
                                                                      !   "   #   $   %   &   '   (   )   *   +   ,   -   .   /   0   1   2   3   4   5   6   7   8   9   :   ;   <   =   >   ?   @   A   B   C   D   E   F   G   H   I   J   K   L   M   N   O   P   Q   R   S   T   U   V   W   X   Y   Z   [   \   ]   ^   _   `   a   b   c   d   e   f   g   h   i   j   k   l   m   n   o   p   q   r   s   t   u   v   w   x   y   z   {   |   }   ~      �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �                      	  
                                               !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /  0  1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ?  @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  [  \  ]  ^  _  `  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  {  |  }  ~    �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �                     	  
                                               !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /  0  1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ?  @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  [  \  ]  ^  _  `  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  {  |  }  ~    �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �                     	  
                                               !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /  0  1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ?  @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  [  \  ]  ^  _  `  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  {  |  }  ~    �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �                     	  
                                               !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /  0  1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ?  @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  [  \  ]  ^  _  `  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  {  |  }  ~    �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �                     	  
                                               !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /  0  1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ?  @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  [  \  ]  ^  _  `  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  {  |  }  ~    �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �                     	  
                                               !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /  0  1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ?  @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  [  \  ]  ^  _  `  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  {  |  }  ~    �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �                     	  
                                               !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /  0  1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ?  @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  [  \  ]  ^  _  `  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  {  |  }  ~    �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �                     	  
                                               !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /  0  1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ?  @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  [  \  ]  ^  _  `  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  {  |  }  ~    �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �   	  	  	  	  	  	  	  	  	  		  
	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	   	  !	  "	  #	  $	  %	  &	  '	  (	  )	  *	  +	  ,	  -	  .	  /	  0	  1	  2	  3	  4	  5	  6	  7	  8	  9	  :	  ;	  <	  =	  >	  ?	  @	  A	  B	  C	  D	  E	  F	  G	  H	  I	  J	  K	  L	  M	  N	  O	  P	  Q	  R	  S	  T	  U	  V	  W	  X	  Y	  Z	  [	  \	  ]	  ^	  _	  `	  a	  b	  c	  d	  e	  f	  g	  h	  i	  j	  k	  l	  m	  n	  o	  p	  q	  r	  s	  t	  u	  v	  w	  x	  y	  z	  {	  |	  }	  ~	  	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	   
  
  
  
  
  
  
  
  
  	
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
   
  !
  "
  #
  $
  %
  &
  '
  (
  )
  *
  +
  ,
  -
  .
  /
  0
  1
  2
  3
  4
  5
  6
  7
  8
  9
  :
  ;
  <
  =
  >
  ?
  @
  A
  B
  C
  D
  E
  F
  G
  H
  I
  J
  K
  L
  M
  N
  O
  P
  Q
  R
  S
  T
  U
  V
  W
  X
  Y
  Z
  [
  \
  ]
  ^
  _
  `
  a
  b
  c
  d
  e
  f
  g
  h
  i
  j
  k
  l
  m
  n
  o
  p
  q
  r
  s
  t
  u
  v
  w
  x
  y
  z
  {
  |
  }
  ~
  
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
                     	  
                                               !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /  0  1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ?  @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  [  \  ]  ^  _  `  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  {  |  }  ~    �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �                                                        	   
                                                                           
                                                 !   "            #      $   %   &            #   '   (   #   )   *   +   ,   -   .   /   0   1   2   3   4   5   6   7   8   9   :   ;   <   =   >   ?   @   A   B   C   D   E   F   G   H   I   J   K            #   '   (   L      M            N      O   c   P   Q   R   S   T   U   V   W   X   Y   Z   [   \   ]   ^   _   `   a   b   c   d   e   f   g   h   i   j   k   l   m   n   o   p   q   r   s   t   u   v   w   x   y   z   {   |   }   ~      �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �      O   �      �   �   �   �   �      O   �   �   �      �   �      O   �   �   �   �      �   �      O   �   �   �   �   �      �      O   �   �   �   �   �   �      �   �   �   �   �   �   	   O   �   �   �   �   �   �   �   �   W   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �                      	  
                                               !           N   "  #     $  n  %  &  '  (  )  *  +  ,  -  .  /  0  1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ?  @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  [  \  ]  ^  _  `  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  {  |  }  ~    �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �                     	  
                                               !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /  0  1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ?  @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  [  \  ]  ^  _  `  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  {  |  }  ~    �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �                     	  
                                               !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /  0  1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ?  @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  [  \  ]  ^  _  `  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  {  |  }  ~    �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �                     	  
                                               !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /  0  1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ?  @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  [  \  ]  ^  _  `  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  {  |  }  ~    �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �                     	  
                                               !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /  0  1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ?  @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  [  \  ]  ^  _  `  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  {  |  }  ~    �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �     $  �     �  �  �     $  �  �  �  �     �  �  �  �           N   "  #  �  �     �     �     �     �  �  �     �  �     �     �     �  �  �     �  �  �     �  �     �     �  �  �  �  �     �  �     �  �  �  �  �  �     �     �  �  �  �     �  �  �  �  �     �  �  �  �  �     �  �  �  �  �  �  �     �  �  �  �  �  �     �     �  �  �  �  �  �  �     �  �     �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �     �  �  �  	   �  �  �  �  �  �  �  �  �     �  �     �     �  �  �  �  
   �  �  �  �  �  �  �  �  �  �     �  �  IFO V3.28      �   ;   �  2   �  �  U  �   	  D   ����    0      .         0         1         2         3         4         5         6         7         8         9                 
                                             
      ;         E              
   	   Q      
   c            A         A                            �?                                                                            \         
         k         r         �         �         �         �         �          �      !   �      "   �      #   �      $   �      %   �      &   �      '   �      (   �      )        *        +         ,         -         .        /      
   0     
   0   "  
   0   3  
   0   E  
   0   T  
   0   `  
   0   p  
   0   |  
   0   �  
   0   �     1   @   Mod_ID          Mod_MinGameVer  Mod_Creator_ID  Mod_Version     Expansion_Pack  Mod_Name        Mod_Tag         Mod_Description Mod_IsSaveGame  Mod_CustomTlk   Mod_Entry_Area  Mod_Entry_X     Mod_Entry_Y     Mod_Entry_Z     Mod_Entry_Dir_X Mod_Entry_Dir_Y Mod_Expan_List  Mod_DawnHour    Mod_DuskHour    Mod_MinPerHour  Mod_StartMonth  Mod_StartDay    Mod_StartHour   Mod_StartYear   Mod_XPScale     Mod_OnHeartbeat Mod_OnModLoad   Mod_OnModStart  Mod_OnClientEntrMod_OnClientLeavMod_OnActvtItem Mod_OnAcquirItemMod_OnUsrDefinedMod_OnUnAqreItemMod_OnPlrDeath  Mod_OnPlrDying  Mod_OnPlrEqItm  Mod_OnPlrLvlUp  Mod_OnSpawnBtnDnMod_OnPlrRest   Mod_OnPlrUnEqItmMod_OnCutsnAbortMod_StartMovie  Mod_CutSceneListMod_GVar_List   Mod_Area_list   Area_Name       Mod_HakList     Mod_Hak         Mod_CacheNSSList   ア"*1��B"���wr   1.66   ����          prc ip temp   MODULE   ����       prc_consortiumarea001mod_hbx2_mod_def_load   x2_mod_def_actx2_mod_def_aqu x2_mod_def_unaqunw_o0_deathnw_o0_dyingx2_mod_def_equ nw_o0_respawnx2_mod_def_restx2_mod_def_unequ  area001   prc_2das   prc_craft2das   prc_epicspells   prc_include   prc_misc   prc_psionics   prc_race   prc_scripts
   prc_spells   prc_textures                            	   
                                                                      !   "   #   $   %   &   '   (   )   *   +   ,   -   /   :                     
                        	   
          NCS V1.0B  �         ����  ����  �����  ����  �����  ����  �����  ����  �����  ����  �����  ����*     +  ����  ���� @�  !    O,              A  ����   ���� <#�
!����  ���� ���� ����   DoOnce      3"    '    DoOnce      7     Done      3       =       ����  ���� Spell      3����  ��������  Bard spells   �  #����     2����  Cleric spells   �  # ����     1����  Druid spells   l  # ����     3����  Paladin spells   1  # ����     2����  Ranger spells   �  # ����     4����  Wiz_Sorc spells   �  #          ����  ����    ����    ����  :<file:open OBJECT 'C:/stuff/Moneo-23beta2/prc_ipbase.uti'>#����  ���� 	PRC_ip92_����   \#����  ��������  <gff:set 'TemplateResRef' '����   =# '>##����  ��������  <gff:set 'LocalizedName' '���� # '>##����  ��������  <gff:set 'Tag' '���� # '>##����  ����    ����  ��������        �����  ><gff:add 'PropertiesList/PropertyName' {type=word value='92'}>#����  ��������  8<gff:add 'PropertiesList/[_]/Subtype' {type=word value='����   \# '}>##����  ��������  ?<gff:add 'PropertiesList/[_]/CostTable' {type=byte value='29'}>#����  ��������  :<gff:add 'PropertiesList/[_]/CostValue' {type=word value='����   \# '}>##����  ��������  =<gff:add 'PropertiesList/[_]/Param1' {type=byte value='255'}>#����  ��������  @<gff:add 'PropertiesList/[_]/Param1Value' {type=byte value='0'}>#����  ��������  C<gff:add 'PropertiesList/[_]/ChanceAppear' {type=byte value='100'}>#����  �������� $���� ���� ���3����  *<file:save OBJECT 'C:/stuff/Moneo-23beta2/����   =# .uti'>##����  ��������  <file:close OBJECT>#����  ����   SCRIPT����    � ���� ����    ���� $���� ��������   �     6    Done      7 FINISHED 0    ����  Spell      7 ����       CACHEWP  �����  ��������   �����  ��������   *"     � ����  ����    ����   =����  ��������   =����  ���� CACHED_����   <# _#���� # _#����   �   \#����  ��������   �����  ��������   *"    M����     ����  NW_WAYPOINT001      �����  ����     2DA_���� # _#���� # _#����   \#����   5����  ���� PRC_USE_DATABASE   #����  �������� ����  ��������   #   
y����    �����  feat#����     ����     ����  spells# ����     ����     ����  	portraits# ����     ����     ����  	soundsets# ����     ����     ����  
appearance# ����     ����     ����  	portraits# ����     ����     ����  classes#     � SELECT ���� #  FROM prc_cached2da_#���� #  WHERE ( rowid = #����   \#  )#����  ����   [- ����  cls_feat_**  �    � SELECT ���� # - FROM prc_cached2da_cls_feat WHERE ( rowid = #����   \#  ) AND ( file = '#���� # ' )#����  ����    �-  +SELECT data FROM cached2da WHERE ( file = '���� # ' ) AND ( column = '#���� # ' ) AND ( rowid = #����   \#  )#����  ��������    �   "        Q-       	*����  ��������  _#      ����  ����        ����   #   l���� ���� ����  �����  ��������   #    " ****����  ����    ����    �����  feat#����     ����     ����  spells# ����     ����     ����  	portraits# ����     ����     ����  soundset# ����     ����     ����  
appearance# ����     ����     ����  	portraits# ����     ����     ����  classes#    �  SELECT rowid FROM prc_cached2da_���� #  WHERE rowid=#����   \#����  ��������    <   `    ����           �  #     � UPDATE prc_cached2da_���� #  SET  #���� #  = '#���� # '  WHERE  rowid = #����   \#  #����  ����    �-  INSERT INTO prc_cached2da_���� # 	 (rowid, #���� # 
) VALUES (#����   \#  , '#���� # ')#����  ����   �- ����  cls_feat_**  �   $  SELECT rowid FROM prc_cached2da_   ����   ?#  WHERE (rowid=#����   \# ) AND (file='#���� # ')#����  ��������        D    ����           g  #     � #UPDATE prc_cached2da_cls_feat SET  ���� #  = '#���� # 'WHERE (rowid = #����   \# ) AND (file='#���� # ')#����  ����    �-  +INSERT INTO prc_cached2da_cls_feat (rowid, ���� # , file) VALUES (#����   \#  , '#���� # ', '#���� # ')#����  ����    �-  INSERT INTO cached2da VALUES ('���� # ' , '#���� # ' , '#����   \# ' , '#���� # ')#����  ��������            ����  2DA_���� # _#���� # _#����   \#����   9    ����  ****#    *  ����  ����    < ����    *- ���� ����  ����     ���� ���� ����  ����   �   3����  ����     ���� ����  ����  NWNX!ODBC!EXEC  �   9 ����    � ����  ���� NWNX!ODBC!SPACER����   5 NWNX!ODBC!FETCH����   9 NWNX!ODBC!FETCH����   5����  ��������   ;         Y����  NWNX_ODBC_CurrentRow����   9   ����  ����    c ����    Q-    NWNX_ODBC_CurrentRow����   9    ����  ����     ���� ����   NWNX_ODBC_CurrentRow  �   5����  ����    ����  ����  ����  ���� �����   B����  ��������     ����     ����          "���� ����  ����   B- ����           ����  ����   - ���� ����      ����� $���� �������� ����      /���� ����   ?����  ����    b- ����   ;����      ����   >����  ���� �����   B����  ��������         '����   ;����  ����     �������� ����  ����     ���� ���� ����  ����   >: #���� #   ����  
NWNX!LETO!���� #  �   9 
NWNX!LETO!���� #  �   5����  ��������   <: #���� #    �����  SPAWN#    ?,          ���� ����     ^  ?�        ���� ����  ����     ���� ���� ����  ����  0 ����   
StopThread���� #  �   3           �     	Polling: ���� # ����   POLL����  #                                   # #                                   # #                                   # #                                   # #                                   # #                                   # #                                   # #                                   # #                                   # ��������  ��������  Error: ���� # 
 not done.##    K,          ���� ����  ����  ?�     ����    �    �-  Poll: Executing: ���� # ���Z    
StopThread���� #  �   7,          * 
StopThread���� #  �  	  @�        ����    ���� ����  #include "inc_fileends"
#include "inc_letoscript"
#include "inc_utility"

void DoHB()
{
    if(!GetLocalInt(OBJECT_SELF, "DoOnce"))
    {
        SetLocalInt(OBJECT_SELF, "DoOnce", TRUE);
    }
    if(GetLocalInt(OBJECT_SELF, "Done"))
        return;
    int bDoSpell = TRUE;;
    int nSpell = GetLocalInt(OBJECT_SELF, "Spell");
    if(Get2DACache("spells", "Bard", nSpell)==""
        && Get2DACache("spells", "Cleric", nSpell)==""
        && Get2DACache("spells", "Druid", nSpell)==""
        && Get2DACache("spells", "Paladin", nSpell)==""
        && Get2DACache("spells", "Ranger", nSpell)==""
        && Get2DACache("spells", "Wiz_Sorc", nSpell)=="")
        bDoSpell = FALSE;
    if(bDoSpell)
    {
        string sScript;
        sScript += "<file:open OBJECT 'C:/stuff/Moneo-23beta2/prc_ipbase.uti'>";
        int nMetmagic;
        string sTag = "PRC_ip92_"+IntToString(nSpell);
        sScript += "<gff:set 'TemplateResRef' '"+GetStringLowerCase(sTag)+"'>";
        sScript += "<gff:set 'LocalizedName' '"+sTag+"'>";
        sScript += "<gff:set 'Tag' '"+sTag+"'>";
        for(nMetmagic = 0; nMetmagic <=6; nMetmagic++)
        {
            sScript += "<gff:add 'PropertiesList/PropertyName' {type=word value='92'}>";
            sScript += "<gff:add 'PropertiesList/[_]/Subtype' {type=word value='"+IntToString(nSpell)+"'}>";
            sScript += "<gff:add 'PropertiesList/[_]/CostTable' {type=byte value='29'}>";
            sScript += "<gff:add 'PropertiesList/[_]/CostValue' {type=word value='"+IntToString(nMetmagic)+"'}>";
            sScript += "<gff:add 'PropertiesList/[_]/Param1' {type=byte value='255'}>";
            sScript += "<gff:add 'PropertiesList/[_]/Param1Value' {type=byte value='0'}>";
            sScript += "<gff:add 'PropertiesList/[_]/ChanceAppear' {type=byte value='100'}>";
        }
        sScript += "<file:save OBJECT 'C:/stuff/Moneo-23beta2/"+GetStringLowerCase(sTag)+".uti'>";
        sScript += "<file:close OBJECT>";

        LetoScript(sScript);
    }
    nSpell++;
    if(nSpell > 3200)
    {
        SetLocalInt(OBJECT_SELF, "Done", TRUE);
        WriteTimestampedLogEntry("FINISHED");
    }
    SetLocalInt(OBJECT_SELF, "Spell", nSpell);
}

void main()
{
    float fDelay;
    while(fDelay < 6.0)
    {
        DelayCommand(fDelay, DoHB());
        fDelay += 0.01;
    }
}
ITP V3.28      �  <   X     �  �   =  �   )  �   ����                                                    $          ,          8          @          H          P          X          `          h          t          |          �          �          �          �          �          �          �          �          �          �          �          �                                         ~                  �                  8         	         8   
                	         �         
         @   
               >         �                  �                  �#                  �#                          H                             `   
      K         [         !                  h   
      h         x         "                  #                  $                  �                  �                 p         �                  �                                   ��                  <                 }            MAIN            STRREF          ID              LIST            NAME            RESREF             Altarcodi_sam_altar"   Mordenkainen's Magnificent Mansionmordsmansent   prc_invisobjprc_invisobj   LichCraftinglichcrafting                        	   
                                                                      !   "   #   $   %   &   '   (   )   *   +   ,   -   .   /   0   1   2   3   4   5   6   7   8   9   :   ;                        	   
                                                                              UTI V3.28      P      �     D  S   �  l        ����           P                       1                  )         5   
      A                                      	   
       
                                                                                              U                            �                     d              
      O   TemplateResRef  BaseItem        LocalizedName   Description     DescIdentified  Tag             Charges         Cost            Stolen          StackSize       Plot            AddCost         Identified      Cursed          ModelPart1      ModelPart2      ModelPart3      PropertiesList  PropertyName    Subtype         CostTable       CostValue       Param1          Param1Value     ChanceAppear    PaletteID       Comment         
prc_ip86_0   ����       
   PRC_ip86_0   ����       ����    
   PRC_ip86_0                                	   
                                                         FAC V3.28      p  M        �  5   �  4  �  l   ����<                                      $         0          D         P         \         h         t         �         �         �         �      	   �      
   �         �         �         �         �         �                                 (                      ����
                         ����
                        ����
                        ����
                        ����
      )                                                                           2                            2                            2                           d                                                                                                                                           d                           2                           d                                                       2                           d                           d                                                       2                           d                           d   FactionList     FactionParentID FactionName     FactionGlobal   RepList         FactionID1      FactionID2      FactionRep         PC   Hostile   Commoner   Merchant   Defender                        	   
                                                                          !   "   #   $   %   &   '   (   )   *   +   ,   -   .   /   0   1   2   3   4   5   6   7   8   9   :   ;   <   =   >   ?   @   A   B   C   D   E   F   G   H   I   J   K   L                                 	   
                                                ITP V3.28      �            @      @  `   �  8   ����                                                               (          0          8          @          H          P          X                       &                  9�                  �                  �                  �                                                        !                  "                  #                  $                  �            MAIN            STRREF          ID              LIST                                    	   
                                                                              	   
      ITP V3.28      �      L     �      �  8   �  $   ����                                                               (          0                       �                                                       !                  "                  #                  $            MAIN            STRREF          ID              LIST                                    	   
                                          ITP V3.28      �      l     �      �  x   $  H   ����                                                               (          0          8          @          H          P          X          `          h          p                       :                  �                  �#                                                       !                  "                  #                  $                  �        0         ��                  �                  �                  �                  ��            MAIN            STRREF          ID              LIST                                    	   
                                                                              
                  	                     ITP V3.28      �      L     �      �  8   �  $   ����                                                               (          0                                                            !                  "                  #                  $                  �            MAIN            STRREF          LIST            ID                                      	   
                                          
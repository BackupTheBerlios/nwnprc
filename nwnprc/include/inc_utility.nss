#include "inc_array"
#include "inc_array_b"
#include "inc_array_c"

//takes a hex string "0x####" and returns the integer base 10 equivalent
//Full credit to Axe Murderer
int HexToInt( string sHex);

//checks if a PC is in a specific area
//also counts other memebers of a PCs parts (henchmen familairs etc)
int GetIsAPCInArea(object oArea);

/*
Credit to He Who Watches
taken from the Homebrew Functions sticky on the bioware scripting forum

This version stores the local strings on a different waypoint object for each
2da file. It requires you to define a waypoint with tag "CACHEWP", and to
place one instance of that waypoint somewhere in your module (preferable in a
location unviewable by players). If it is not present, the cache wil be created
at the module start.
*/

//wrapper for bioware Get2daString function
//caches the result on waypoints
//may not be needed after 1.64
//Original by He Who Watches
string Get2DACache(string datafile, string column, int row, int cachenull = TRUE, int debug = FALSE);

//::///////////////////////////////////////////////
//:: Function: GetAreaWidth
//:://////////////////////////////////////////////
//
//  This function will get the width for the
//  area passed in.
//
//:://////////////////////////////////////////////
//:: Created By:  Zaddix
//:: Created On: July 17, 2002
//:: Optimized: March , 2003 by Knat
//:://////////////////////////////////////////////
int GetAreaWidth(object oArea);

//::///////////////////////////////////////////////
//:: Function: GetAreaHeight
//:://////////////////////////////////////////////
//
//  This function will get the height for the
//  area passed in.
//
//:://////////////////////////////////////////////
//:: Created By:  Zaddix
//:: Created On: July 17, 2002
//:: Optimized: March, 2003 by Knat
//:://////////////////////////////////////////////
int GetAreaHeight(object oArea);

// returns true if given an allowable alignment
// returns false otherwise
//
// example
// GetIsValidAlignment (ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD, 21, 3, 0 );
// should return false
//
// Credit to Joe Travel
int GetIsValidAlignment( int iLawChaos, int iGoodEvil, int iAlignRestrict, int iAlignRstrctType, int iInvertRestriction );

//circular random location getter
// by Mixcoatl
// download from
// http://nwvault.ign.com/Files/scripts/data/1065075424375.shtml
location GetRandomCircleLocation(location lBase, float fDistance=1.0);

//returns a really random number within set bounds
//based upon seed set with SeedRealRandom
int GetRealRand(int nMax, int nMin = 0);

//used to set the seeds for the real random function
void SeedRealRand(int nSeed);

//taken from homebrew scripts forum sticky
//credit goes to Pherves
string FilledIntToString(int nX, int nLength = 4, int nSigned = FALSE);

int HexToInt( string sHex)
{ if( sHex == "") return 0;
  if( GetStringLeft( sHex, 2) == "0x") sHex = GetStringRight( sHex, GetStringLength( sHex) -2);
  while( GetStringLength( sHex) > 8) sHex = GetStringRight( sHex, GetStringLength( sHex) -1);
  string sConvert = "0123456789ABCDEF";
  int iMult   = 1;
  int iIntVal = 0;
  while( sHex != "")
  { string sDigit = GetStringRight( sHex, 1);
    sHex = GetStringLeft( sHex, GetStringLength( sHex) -1);
    int iPos = FindSubString( sConvert, sDigit);
    if( (iPos >= 0) && (iPos <= 15)) iIntVal += (iPos *iMult);
    else return 0;
    iMult *= 16;
  }
  return iIntVal;
}

string Get2DACache(string datafile, string column, int row, int cachenull = TRUE, int debug = FALSE)
{
    object cachewp = GetObjectByTag("CACHEWP");
    location lCache = GetLocation(cachewp);
    if (!GetIsObjectValid(cachewp))
        lCache = GetStartingLocation();
    string filewpname = "CACHED_"+GetStringUpperCase(datafile)+column;
    object filewp = GetObjectByTag(filewpname);
    if (!GetIsObjectValid(filewp))
    {
        filewp = CreateObject(OBJECT_TYPE_WAYPOINT,"NW_WAYPOINT001",lCache,FALSE,filewpname);
    }
    string s = GetLocalString(filewp, "2DA_"+datafile+"_"+column+"_"+IntToString(row));
    if (s == "")
    {
        if(GetLocalInt(GetModule(), "USE_2DA_DB_CACHE"))
        {
            SetLocalString(GetModule(), "2DA_DB_CACHE_DATAFILE", datafile);
            SetLocalString(GetModule(), "2DA_DB_CACHE_COLUMN", column);
            SetLocalInt(GetModule(), "2DA_DB_CACHE_ROW", row);
            DeleteLocalString(GetModule(),"2DA_DB_CACHE_RETVAR");
            ExecuteScript("db_get2da",GetModule());
            s = GetLocalString(GetModule(),"2DA_DB_CACHE_RETVAR");
            DeleteLocalString(GetModule(),"2DA_DB_CACHE_RETVAR");
            DeleteLocalString(GetModule(),"2DA_DB_CACHE_DATAFILE");
            DeleteLocalString(GetModule(),"2DA_DB_CACHE_COLUMN");
            DeleteLocalInt(GetModule(),"2DA_DB_CACHE_ROW");
        }
        s = Get2DAString(datafile, column, row);
        if (cachenull&&(s == ""))
        {
            if (debug) 
                SendMessageToAllDMs("Null value (****) or error opening "+datafile+".2da (row "+IntToString(row)+", column "+column+"), my tag: "+GetTag(OBJECT_SELF));
            s = "****";
        }
        if (s!="") 
            SetLocalString(filewp, "2DA_"+datafile+"_"+column+"_"+IntToString(row), s);
        if(s!="" && GetLocalInt(GetModule(), "USE_2DA_DB_CACHE"))
        {
            SetLocalString(GetModule(), "2DA_DB_CACHE_DATAFILE", datafile);
            SetLocalString(GetModule(), "2DA_DB_CACHE_COLUMN", column);
            SetLocalString(GetModule(), "2DA_DB_CACHE_RETVAR", s);
            SetLocalInt(GetModule(), "2DA_DB_CACHE_ROW", row);
            ExecuteScript("db_set2da",GetModule());
            DeleteLocalString(GetModule(),"2DA_DB_CACHE_DATAFILE");
            DeleteLocalString(GetModule(),"2DA_DB_CACHE_COLUMN");
            DeleteLocalString(GetModule(),"2DA_DB_CACHE_RETVAR");
            DeleteLocalInt(GetModule(),"2DA_DB_CACHE_ROW");
        }
    }
    if (s=="****") return "";
    else return s;
}

int GetIsValidAlignment ( int iLawChaos, int iGoodEvil,int iAlignRestrict, int iAlignRstrctType, int iInvertRestriction )
{
    //deal with no restrictions first
    if(iAlignRstrctType == 0)
        return TRUE;
    //convert the ALIGNMENT_* into powers of 2
    iLawChaos = FloatToInt(pow(2.0, IntToFloat(iLawChaos-1)));
    iGoodEvil = FloatToInt(pow(2.0, IntToFloat(iGoodEvil-1)));
    //initialise result varaibles
    int iAlignTest, iRetVal = TRUE;
    //do different test depending on what type of restriction
    if(iAlignRstrctType == 1 || iAlignRstrctType == 3)   //I.e its 1 or 3
        iAlignTest = iLawChaos;
    if(iAlignRstrctType == 2 || iAlignRstrctType == 3) //I.e its 2 or 3
        iAlignTest = iAlignTest | iGoodEvil;
    //now the real test.
    if(iAlignRestrict & iAlignTest)//bitwise AND comparison
        iRetVal = FALSE;
    //invert it if applicable
    if(iInvertRestriction)
        iRetVal = !iRetVal;
    //and return the result
    return iRetVal;
}


location GetRandomCircleLocation(location lBase, float fDistance=1.0)
{
    // Pick a random angle for the location.
    float fAngle = IntToFloat(GetRealRand(3600)) / 10.0;

    // Pick a random facing for the location.
    float fFacing = IntToFloat(GetRealRand(3600)) / 10.0;

    // Pick a random distance from the base location.
    float fHowFar = IntToFloat(GetRealRand(FloatToInt(fDistance * 10.0))) / 10.0;

    // Retreive the position vector from the location.
    vector vPosition = GetPositionFromLocation(lBase);

    // Modify the base x/y position by the distance and angle.
    vPosition.y += (sin(fAngle) * fHowFar);
    vPosition.x += (cos(fAngle) * fHowFar);

    // Return the new random location.
    return Location(GetAreaFromLocation(lBase), vPosition, fFacing);
}

void SeedRealRand(int nSeed)
{
    if(nSeed < 0)
        nSeed = -nSeed;
    if(nSeed > 99)
        nSeed = nSeed%100;
    if(GetTimeMillisecond()%2 == 0)
        SetLocalInt(GetModule(), "LastRow", nSeed);
    else
        SetLocalInt(GetModule(), "LastColumn", nSeed);
}

int GetRealRand(int nMax, int nMin = 0)
{
    return Random(nMax-nMin)+nMin;

    int nRow =    GetLocalInt(GetModule(), "LastRow");
    int nColumn = GetLocalInt(GetModule(), "LastColumn");
    int nNumber = StringToInt(Get2DAString("RealRandom", IntToString(nColumn%10), nRow%100));
    SetLocalInt(GetModule(), "LastRow", nNumber);
    SetLocalInt(GetModule(), "LastColumn", nRow);
    nNumber = (nNumber%(nMax-nMin))+nMin;
    return nNumber;
}


int GetAreaWidth(object oArea)
{
  int nX = GetLocalInt(oArea,"#WIDTH");
  if( nX == 0)
  {
    int nY = 0; int nColor;
    for (nX = 0; nX < 32; ++nX)
    {
      nColor = GetTileMainLight1Color(Location(oArea, Vector(IntToFloat(nX), 0.0, 0.0), 0.0));
      if (nColor < 0 || nColor > 255)
      {
        SetLocalInt(oArea,"#WIDTH", nX);
        return(nX);
      }
    }
    SetLocalInt(oArea,"#WIDTH", 32);
    return 32;
  }
  else
    return nX;
}

int GetAreaHeight(object oArea)
{
  int nY = GetLocalInt(oArea,"#HEIGHT");
  if( nY == 0)
  {
    int nX = 0; int nColor;
    for (nY=0; nY<32; ++nY)
    {
      nColor = GetTileMainLight1Color(Location(oArea, Vector(0.0, IntToFloat(nY), 0.0),0.0));
      if (nColor < 0 || nColor > 255)
      {
        SetLocalInt(oArea,"#HEIGHT",nY);
        return(nY);
      }
    }
    SetLocalInt(oArea,"#HEIGHT",32);
    return 32;
  }
  else
    return nY;
}

int GetIsAPCInArea(object oArea)
{
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC) == TRUE)
    {
        object oFaction = GetFirstFactionMember(oPC, FALSE);
        while(GetIsObjectValid(oFaction))
        {
            if (GetArea(oFaction) == oArea)
                return TRUE;
            oFaction = GetNextFactionMember(oPC, FALSE);
        }
        oPC = GetNextPC();
    }
    return FALSE;
}

string FilledIntToString(int nX, int nLength = 4, int nSigned = FALSE)
{
    if(nSigned)
        nLength--;//to allow for sign
    string sResult = IntToString(nX);
    while(GetStringLength(sResult)<nLength)
    {
        sResult = "0" +sResult;
    }
    if(nSigned)
    {
        if(nX>=0)
            sResult = "+"+sResult;
        else
            sResult = "-"+sResult;
    }
    return sResult;
}

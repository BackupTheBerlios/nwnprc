#include "inc_array"
#include "inc_array_b"
#include "inc_array_c"

//takes a hex string "0x####" and returns the integer base 10 equivalent
//Full credit to Axe Murderer
int HexToInt( string sHex);

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
        s = Get2DAString(datafile, column, row);
        if (cachenull&&(s == ""))
        {
            if (debug) SendMessageToAllDMs("Null value (****) or error opening "+datafile+".2da (row "+IntToString(row)+", column "+column+"), my tag: "+GetTag(OBJECT_SELF));
            s = "****";
        }
        if (s!="") SetLocalString(filewp, "2DA_"+datafile+"_"+column+"_"+IntToString(row), s);
    }
    if (s=="****") return "";
    else return s;
}


// returns true if given an allowable alignment
// returns false otherwise
//
// example
// GetIsValidAlignment (ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD, 21, 3, 0 );
// should return false
//
// Credit to Joe Travel
int GetIsValidAlignment( int iLawChaos, int iGoodEvil, int iAlignRestrict, int iAlignRstrctType, int iInvertRestriction );

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
/*
//circular random location getter
// by Mixcoatl
// download from
// http://nwvault.ign.com/Files/scripts/data/1065075424375.shtml
location GetRandomLocation(location lBase, float fDistance=1.0);
location GetRandomLocation(location lBase, float fDistance=1.0)
{
    // Pick a random angle for the location.
    float fAngle = IntToFloat(Random(3600)) / 10.0;

    // Pick a random facing for the location.
    float fFacing = IntToFloat(Random(3600)) / 10.0;

    // Pick a random distance from the base location.
    float fHowFar = IntToFloat(Random(FloatToInt(fDistance * 10.0))) / 10.0;

    // Retreive the position vector from the location.
    vector vPosition = GetPositionFromLocation(lBase);

    // Modify the base x/y position by the distance and angle.
    vPosition.y += (sin(fAngle) * fHowFar);
    vPosition.x += (cos(fAngle) * fHowFar);

    // Return the new random location.
    return Location(GetAreaFromLocation(lBase), vPosition, fFacing);
}
*/

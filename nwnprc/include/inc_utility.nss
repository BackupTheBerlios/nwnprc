//takes a hex string "0x####" and returns the integer base 10 equivalent
//Full credit to Axe Murderer
int HexToInt( string sHex);

//checks if a PC is in a specific area
//also counts other memebers of a PCs parts (henchmen familairs etc)
int GetIsAPCInArea(object oArea);

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

//taken from homebrew scripts forum sticky
//credit goes to Pherves
string FilledIntToString(int nX, int nLength = 4, int nSigned = FALSE);

//used by the dyynamic onversation system to track token assignment
void SetToken(int nTokenID, string sString);

//replaces specific substrings
//sTarget and sReplacement must be the same length
string ReplaceChars(string sString, string sTarget, string sReplacement);

// A wrapper for DestroyObject. Attempts to bypass any conditions that might prevent destroying the object
// =======================================================================================================
// oObject  object to destroy
void MyDestroyObject(object oObject);

///////////////////////////////////////////////////////////////
//  GetArmorType
///////////////////////////////////////////////////////////////
// returns -1 on error, or base AC of armor
int GetItemACBase(object oArmor);
// returns -1 on error, or the const int ARMOR_TYPE_*
int GetArmorType(object oArmor);

//returns the number of steps on both axis that the alignments differ
int CompareAlignment(object oSource, object oTarget);

void ForceEquip(object oPC, object oItem, int nSlot);
void ForceUnequip(object oPC, object oItem, int nSlot);



#include "inc_array"
#include "inc_array_b"
#include "inc_heap"

#include "inc_2dacache"


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

void SetToken(int nTokenID, string sString)
{
    SetCustomToken(nTokenID, sString);
    SetLocalString(OBJECT_SELF, "TOKEN"+IntToString(nTokenID), sString);
}


string ReplaceChars(string sString, string sTarget, string sReplacement)
{
    if (FindSubString(sString, sTarget) == -1)      // not found
        return sString;

    int i;
    string sReturn = "";
    string sChar;
    int nLength = GetStringLength(sTarget);
    // Loop over every character and replace special characters
    for (i = 0; i < GetStringLength(sString)-nLength+1; i++)
    {
        sChar = GetSubString(sString, i, nLength);
        if (sChar == sTarget)
            sReturn += sReplacement;
        else
            sReturn += GetSubString(sString, i, 1);
    }
    return sReturn;
}


void MyDestroyObject(object oObject)
{
    if(GetIsObjectValid(oObject))
    {
        SetCommandable(TRUE ,oObject);
        AssignCommand(oObject, ClearAllActions());
        AssignCommand(oObject, SetIsDestroyable(TRUE, FALSE, FALSE));
        // May not necessarily work on first iteration
        DestroyObject(oObject);
        DelayCommand(0.1f, MyDestroyObject(oObject));
    }
}



///////////////////////////////////////////////////////////////
//  GetArmorType
///////////////////////////////////////////////////////////////
const int ARMOR_TYPE_CLOTH      = 0;
const int ARMOR_TYPE_LIGHT      = 1;
const int ARMOR_TYPE_MEDIUM     = 2;
const int ARMOR_TYPE_HEAVY      = 3;

// returns -1 on error, or base AC of armor
int GetItemACBase(object oArmor)
{
    int nBonusAC = 0;

    // oItem is not armor then return an error
    if(GetBaseItemType(oArmor) != BASE_ITEM_ARMOR)
        return -1;

    // check each itemproperty for AC Bonus
    itemproperty ipAC = GetFirstItemProperty(oArmor);

    while(GetIsItemPropertyValid(ipAC))
    {
        int nType = GetItemPropertyType(ipAC);

        // check for ITEM_PROPERTY_AC_BONUS
        if(nType == ITEM_PROPERTY_AC_BONUS)
        {
            nBonusAC = GetItemPropertyCostTableValue(ipAC);
            break;
        }

        // get next itemproperty
        ipAC = GetNextItemProperty(oArmor);
    }

    // return base AC
    return GetItemACValue(oArmor) - nBonusAC;
}

// returns -1 on error, or the const int ARMOR_TYPE_*
int GetArmorType(object oArmor)
{
    int nType = -1;

    // get and check Base AC
    switch(GetItemACBase(oArmor) )
    {
        case 0: nType = ARMOR_TYPE_CLOTH;   break;
        case 1: nType = ARMOR_TYPE_LIGHT;   break;
        case 2: nType = ARMOR_TYPE_LIGHT;   break;
        case 3: nType = ARMOR_TYPE_LIGHT;   break;
        case 4: nType = ARMOR_TYPE_MEDIUM;  break;
        case 5: nType = ARMOR_TYPE_MEDIUM;  break;
        case 6: nType = ARMOR_TYPE_HEAVY;   break;
        case 7: nType = ARMOR_TYPE_HEAVY;   break;
        case 8: nType = ARMOR_TYPE_HEAVY;   break;
    }

    // return type
    return nType;
}

int CompareAlignment(object oSource, object oTarget)
{
    int iStepDif;
    int iGE1 = GetAlignmentGoodEvil(oSource);
    int iLC1 = GetAlignmentLawChaos(oSource);
    int iGE2 = GetAlignmentGoodEvil(oTarget);
    int iLC2 = GetAlignmentLawChaos(oTarget);

    if(iGE1 == ALIGNMENT_GOOD){
        if(iGE2 == ALIGNMENT_NEUTRAL)
            iStepDif += 1;
        if(iGE2 == ALIGNMENT_EVIL)
            iStepDif += 2;
    }
    if(iGE1 == ALIGNMENT_NEUTRAL){
        if(iGE2 != ALIGNMENT_NEUTRAL)
            iStepDif += 1;
    }
    if(iGE1 == ALIGNMENT_EVIL){
        if(iLC2 == ALIGNMENT_NEUTRAL)
            iStepDif += 1;
        if(iLC2 == ALIGNMENT_GOOD)
            iStepDif += 2;
    }
    if(iLC1 == ALIGNMENT_LAWFUL){
        if(iLC2 == ALIGNMENT_NEUTRAL)
            iStepDif += 1;
        if(iLC2 == ALIGNMENT_CHAOTIC)
            iStepDif += 2;
    }
    if(iLC1 == ALIGNMENT_NEUTRAL){
        if(iLC2 != ALIGNMENT_NEUTRAL)
            iStepDif += 1;
    }
    if(iLC1 == ALIGNMENT_CHAOTIC){
        if(iLC2 == ALIGNMENT_NEUTRAL)
            iStepDif += 1;
        if(iLC2 == ALIGNMENT_LAWFUL)
            iStepDif += 2;
    }
    return iStepDif;
}


void ForceUnequip(object oPC, object oItem, int nSlot)
{
    if(GetItemInSlot(nSlot, oPC) == oItem)
    {
        AssignCommand(oPC, ActionUnequipItem(oItem));
        DelayCommand(0.1, ForceUnequip(oPC, oItem, nSlot));
    }
}

void ForceEquip(object oPC, object oItem, int nSlot)
{
    if(GetItemInSlot(nSlot, oPC) != oItem)
    {
        AssignCommand(oPC, ActionEquipItem(oItem, nSlot));
        DelayCommand(0.1, ForceEquip(oPC, oItem, nSlot));
    }
}
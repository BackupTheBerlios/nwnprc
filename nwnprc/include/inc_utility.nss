#include "inc_array"
#include "inc_array_b"
#include "inc_heap"

#include "inc_2dacache"

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


//  int GetSkill(object oObject, int nSkill, int bSynergy = FALSE,
//      int bSize = FALSE, int bAbilityMod = TRUE, int bEffect = TRUE,
//      int bArmor = TRUE, int bShield = TRUE, int bFeat = TRUE);
//  by Primogenitor
//  oObject     subject to get skills of
//  nSkill      SKILL_*
//  bSynergy    include any applicable synergy bonus
//  bSize       include any applicable size bonus
//  bAbilityMod include relevant ability modification (including effects on that ability)
//  bEffect     include skill changing effects and itemproperties
//  bArmor      include armor mod if applicable (excluding shield)
//  bShield     include shield mod if applicable (excluding armor)
//  bFeat       include any applicable feats, including racial ones
//  this returns 0 if the subject does not have any ranks in the skill and the skill is trained only
//  the defaults are the same as biowares GetSkillRank function
int GetSkill(object oObject, int nSkill, int bSynergy = FALSE, int bSize = FALSE, int bAbilityMod = TRUE, int bEffect = TRUE, int bArmor = TRUE, int bShield = TRUE, int bFeat = TRUE);

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

 //  int GetSkill(object oObject, int nSkill, int bSynergy = FALSE,
//      int bSize = FALSE, int bAbilityMod = TRUE, int bEffect = TRUE,
//      int bArmor = TRUE, int bShield = TRUE, int bFeat = TRUE);
//  by Primogenitor
//  oObject     subject to get skills of
//  nSkill      SKILL_*
//  bSynergy    include any applicable synergy bonus
//  bSize       include any applicable size bonus
//  bAbilityMod include relevant ability modification (including effects on that ability)
//  bEffect     include skill changing effects and itemproperties
//  bArmor      include armor mod if applicable (excluding shield)
//  bShield     include shield mod if applicable (excluding armor)
//  bFeat       include any applicable feats, including racial ones
//  this returns 0 if the subject does not have any ranks in the skill and the skill is trained only
//  the defaults are the same as biowares GetSkillRank function
int GetSkill(object oObject, int nSkill, int bSynergy = FALSE, int bSize = FALSE, int bAbilityMod = TRUE, int bEffect = TRUE, int bArmor = TRUE, int bShield = TRUE, int bFeat = TRUE);

int GetSkill(object oObject, int nSkill, int bSynergy = FALSE, int bSize = FALSE, int bAbilityMod = TRUE, int bEffect = TRUE, int bArmor = TRUE, int bShield = TRUE, int bFeat = TRUE)
{
    if(!GetIsObjectValid(oObject))
        return 0;
    if(!GetHasSkill(nSkill, oObject))
        return 0;//no skill set it to zero
    int nSkillRank;  //get the current value at the end, after effects are applied
    if(bSynergy)
    {
        if(nSkill == SKILL_SET_TRAP
            && GetSkill(oObject, SKILL_DISABLE_TRAP, FALSE, FALSE, FALSE,
                FALSE, FALSE, FALSE, FALSE) >= 5)
                nSkillRank += 2;
        if(nSkill == SKILL_DISABLE_TRAP
            && GetSkill(oObject, SKILL_SET_TRAP, FALSE, FALSE, FALSE,
                FALSE, FALSE, FALSE, FALSE) >= 5)
                nSkillRank += 2;
    }
    if(bSize)
        nSkillRank += (GetCreatureSize(oObject)-3)*(0-4);
    if(!bAbilityMod)
    {
        string sAbility = Get2DACache("skills", "KeyAbility", nSkill);
        int nAbility;
        if(sAbility == "STR")
            nAbility = ABILITY_STRENGTH;
        else if(sAbility == "DEX")
            nAbility = ABILITY_DEXTERITY;
        else if(sAbility == "CON")
            nAbility = ABILITY_CONSTITUTION;
        else if(sAbility == "INT")
            nAbility = ABILITY_INTELLIGENCE;
        else if(sAbility == "WIS")
            nAbility = ABILITY_WISDOM;
        else if(sAbility == "CHA")
            nAbility = ABILITY_CHARISMA;
        nSkillRank -= GetAbilityModifier(nAbility, oObject);
    }
    if(!bEffect)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(nSkill, 30), oObject, 0.001);
        nSkillRank -= 30;
    }
    if(!bArmor
        && GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CHEST, oObject))
        && Get2DACache("skills", "ArmorCheckPenalty", nSkill) == "1")
    {
        object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oObject);
        // Get the torso model number
        int nTorso = GetItemAppearance( oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);
        // Read 2DA for base AC
        // Can also use "parts_chest" which returns it as a "float"
        int nACBase = StringToInt(Get2DACache( "des_crft_appear", "BaseAC", nTorso));
        int nSkillMod;
        switch(nACBase)
        {
            case 0: nSkillMod = 0; break;
            case 1: nSkillMod = 0; break;
            case 2: nSkillMod = 0; break;
            case 3: nSkillMod = -1; break;
            case 4: nSkillMod = -2; break;
            case 5: nSkillMod = -5; break;
            case 6: nSkillMod = -7; break;
            case 7: nSkillMod = -7; break;
            case 8: nSkillMod = -8; break;
        }
        nSkillRank -= nSkillMod;
    }
    if(!bShield
        && GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oObject))
        && Get2DACache("skills", "ArmorCheckPenalty", nSkill) == "1")
    {
        object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oObject);
        int nBase = GetBaseItemType(oItem);
        int nSkillMod;
        switch(nBase)
        {
            case BASE_ITEM_TOWERSHIELD: nSkillMod = -10; break;
            case BASE_ITEM_LARGESHIELD: nSkillMod = -2; break;
            case BASE_ITEM_SMALLSHIELD: nSkillMod = -1; break;
        }
        nSkillRank -= nSkillMod;
    }
    if(!bFeat)
    {
        int nSkillMod;
        int nEpicFeat;
        int nFocusFeat;
        switch(nSkill)
        {
            case SKILL_ANIMAL_EMPATHY:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_ANIMAL_EMPATHY;
                nFocusFeat = FEAT_SKILL_FOCUS_ANIMAL_EMPATHY;
                break;
            case SKILL_APPRAISE:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_APPRAISE;
                nFocusFeat = FEAT_SKILLFOCUS_APPRAISE;
                if(GetHasFeat(FEAT_SILVER_PALM, oObject))
                    nSkillMod += 2;
                break;
            case SKILL_BLUFF:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_BLUFF;
                nFocusFeat = FEAT_SKILL_FOCUS_BLUFF;
                break;
            case SKILL_CONCENTRATION:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_CONCENTRATION;
                nFocusFeat = FEAT_SKILL_FOCUS_CONCENTRATION;
                if(GetHasFeat(FEAT_SKILL_AFFINITY_CONCENTRATION, oObject))
                    nSkillMod += 2;
                break;
            case SKILL_CRAFT_ARMOR:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_CRAFT_ARMOR;
                nFocusFeat = FEAT_SKILL_FOCUS_CRAFT_ARMOR;
                break;
            case SKILL_CRAFT_TRAP:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_CRAFT_TRAP;
                nFocusFeat = FEAT_SKILL_FOCUS_CRAFT_TRAP;
                break;
            case SKILL_CRAFT_WEAPON:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_CRAFT_WEAPON;
                nFocusFeat = FEAT_SKILL_FOCUS_CRAFT_WEAPON;
                break;
            case SKILL_DISABLE_TRAP:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_DISABLETRAP;
                nFocusFeat = FEAT_SKILL_FOCUS_DISABLE_TRAP;
                break;
            case SKILL_DISCIPLINE:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_DISCIPLINE;
                nFocusFeat = FEAT_SKILL_FOCUS_DISCIPLINE;
                break;
            case SKILL_HEAL:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_HEAL;
                nFocusFeat = FEAT_SKILL_FOCUS_HEAL;
                break;
            case SKILL_HIDE:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_HIDE;
                nFocusFeat = FEAT_SKILL_FOCUS_HIDE;
                break;
            case SKILL_INTIMIDATE:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_INTIMIDATE;
                nFocusFeat = FEAT_SKILL_FOCUS_INTIMIDATE;
                break;
            case SKILL_LISTEN:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_LISTEN;
                nFocusFeat = FEAT_SKILL_FOCUS_LISTEN;
                if(GetHasFeat(FEAT_SKILL_AFFINITY_LISTEN, oObject))
                    nSkillMod += 2;
                if(GetHasFeat(FEAT_PARTIAL_SKILL_AFFINITY_LISTEN, oObject))
                    nSkillMod += 1;
                break;
            case SKILL_LORE:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_LORE;
                nFocusFeat = FEAT_SKILL_FOCUS_LORE;
                if(GetHasFeat(FEAT_SKILL_AFFINITY_LORE, oObject))
                    nSkillMod += 2;
                if(GetHasFeat(FEAT_COURTLY_MAGOCRACY, oObject))
                    nSkillMod += 2;
                break;
            case SKILL_MOVE_SILENTLY:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_MOVESILENTLY;
                nFocusFeat = FEAT_SKILL_FOCUS_MOVE_SILENTLY;
                if(GetHasFeat(FEAT_SKILL_AFFINITY_MOVE_SILENTLY, oObject))
                    nSkillMod += 2;
                break;
            case SKILL_OPEN_LOCK:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_OPENLOCK;
                nFocusFeat = FEAT_SKILL_FOCUS_OPEN_LOCK;
                break;
            case SKILL_PARRY:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_PARRY;
                nFocusFeat = FEAT_SKILL_FOCUS_PARRY;
                break;
            case SKILL_PERFORM:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_PERFORM;
                nFocusFeat = FEAT_SKILL_FOCUS_PERFORM;
                if(GetHasFeat(FEAT_ARTIST, oObject))
                    nSkillMod += 2;
                break;
            case SKILL_PERSUADE:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_PERSUADE;
                nFocusFeat = FEAT_SKILL_FOCUS_PERSUADE;
                if(GetHasFeat(FEAT_SILVER_PALM, oObject))
                    nSkillMod += 2;
                break;
            case SKILL_PICK_POCKET:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_PICKPOCKET;
                nFocusFeat = FEAT_SKILL_FOCUS_PICK_POCKET;
                break;
            case SKILL_SEARCH:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_SEARCH;
                nFocusFeat = FEAT_SKILL_FOCUS_SEARCH;
                if(GetHasFeat(FEAT_SKILL_AFFINITY_SEARCH, oObject))
                    nSkillMod += 2;
                if(GetHasFeat(FEAT_PARTIAL_SKILL_AFFINITY_SEARCH, oObject))
                    nSkillMod += 1;
                break;
            case SKILL_SET_TRAP:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_SETTRAP;
                nFocusFeat = FEAT_SKILL_FOCUS_SET_TRAP;
                break;
            case SKILL_SPELLCRAFT:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_SPELLCRAFT;
                nFocusFeat = FEAT_SKILL_FOCUS_SPELLCRAFT;
                if(GetHasFeat(FEAT_COURTLY_MAGOCRACY, oObject))
                    nSkillMod += 2;
                break;
            case SKILL_SPOT:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_SPOT;
                nFocusFeat = FEAT_SKILL_FOCUS_SPOT;
                if(GetHasFeat(FEAT_SKILL_AFFINITY_SPOT, oObject))
                    nSkillMod += 2;
                if(GetHasFeat(FEAT_PARTIAL_SKILL_AFFINITY_SPOT, oObject))
                    nSkillMod += 1;
                if(GetHasFeat(FEAT_ARTIST, oObject))
                    nSkillMod += 2;
                if(GetHasFeat(FEAT_BLOODED, oObject))
                    nSkillMod += 2;
                break;
            case SKILL_TAUNT:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_TAUNT;
                nFocusFeat = FEAT_SKILL_FOCUS_TAUNT;
                break;
            case SKILL_TUMBLE:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_TUMBLE;
                nFocusFeat = FEAT_SKILL_FOCUS_TUMBLE;
                break;
            case SKILL_USE_MAGIC_DEVICE:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_USEMAGICDEVICE;
                nFocusFeat = FEAT_SKILL_FOCUS_USE_MAGIC_DEVICE;
                break;
        }
        if(nEpicFeat != 0
            && GetHasFeat(nEpicFeat, oObject))
            nSkillMod += 10;
        if(nFocusFeat != 0
            && GetHasFeat(nFocusFeat, oObject))
            nSkillMod += 3;
        nSkillRank -= nSkillMod;
    }
    //add this at the end so any effects applied are counted
    nSkillRank += GetSkillRank(nSkill, oObject);
    return nSkillRank;
}

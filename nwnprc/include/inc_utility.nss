//:://////////////////////////////////////////////
//:: General utility functions
//:: inc_utility
//:://////////////////////////////////////////////
/** @file
    An include file for various small and generally
    useful functions.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


/**********************\
* Constant Definitions *
\**********************/

const int ARMOR_TYPE_CLOTH      = 0;
const int ARMOR_TYPE_LIGHT      = 1;
const int ARMOR_TYPE_MEDIUM     = 2;
const int ARMOR_TYPE_HEAVY      = 3;


/*********************\
* Function Prototypes *
\*********************/

/**
 * Returns the greater of the two values passed to it.
 *
 * @param a An integer
 * @param b Another integer
 * @return  The greater of a and b
 */
int max(int a, int b);

/**
 * Returns the lesser of the two values passed to it.
 *
 * @param a An integer
 * @param b Another integer
 * @return  The lesser of a and b
 */
int min(int a, int b);

/**
 * Returns the greater of the two values passed to it.
 *
 * @param a A float
 * @param b Another float
 * @return  The greater of a and b
 */
float fmax(float a, float b);

/**
 * Returns the lesser of the two values passed to it.
 *
 * @param a A float
 * @param b Another float
 * @return  The lesser of a and b
 */
float fmin(float a, float b);

/**
 * Gets the absolute value of a float
 *
 * @param f  A float value
 * @return   f if it's 0 or greater, -f otherwise
 */
float fabs(float f);

/**
 * Takes a string in the standard hex number format (0x####) and converts it
 * into an integer type value. Only the last 8 characters are parsed in order
 * to avoid overflows.
 * If the string is not parseable (empty or contains characters other than
 * those used in hex notation), the function errors and returns 0.
 *
 * Full credit to Axe Murderer
 *
 * @param sHex  The string to convert
 * @return      Integer value of sHex or 0 on error
 */
int HexToInt(string sHex);

/**
 * Checks whether an alignment matches given restrictions.
 * For example
 * GetIsValidAlignment (ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD, 21, 3, 0 );
 * should return FALSE.
 *
 * Credit to Joe Travel
 *
 * @param iLawChaos          ALIGNMENT_* constant
 * @param iGoodEvil          ALIGNMENT_* constant
 * @param iAlignRestrict     Similar format as the restrictions in classes.2da
 * @param iAlignRstrctType   Similar format as the restrictions in classes.2da
 * @param iInvertRestriction Similar format as the restrictions in classes.2da
 *
 * @return TRUE if the alignment does not break the restrictions,
 *          FALSE otherwise.
 */
int GetIsValidAlignment( int iLawChaos, int iGoodEvil, int iAlignRestrict, int iAlignRstrctType, int iInvertRestriction );

/**
 * Gets a random location within an circular area around a base location.
 *
 * by Mixcoatl
 * download from
 * http://nwvault.ign.com/Files/scripts/data/1065075424375.shtml
 *
 * @param lBase     The center of the circle.
 * @param fDistance The radius of the circle. ie, the maximum distance the
 *                  new location may be from lBase.
 *
 * @return          A location in random direction from lBase between
 *                  0 and fDistance meters away.
 */
location GetRandomCircleLocation(location lBase, float fDistance=1.0);

/**
 * This function will get the width of the area passed in.
 *
 * Created By:  Zaddix
 * Created On: July 17, 2002
 * Optimized: March , 2003 by Knat
 *
 * @param oArea  The area to get the width of.
 * @return       The width of oArea, as number of tiles. One tile = 10 meters.
 */
int GetAreaWidth(object oArea);

/**
 * This function will get the height of the area passed in.
 *
 * Created By:  Zaddix
 * Created On: July 17, 2002
 * Optimized: March , 2003 by Knat
 *
 * @param oArea  The area to get the height of.
 * @return       The height of oArea, as number of tiles. One tile = 10 meters.
 */
int GetAreaHeight(object oArea);

// Genji Include Color gen_inc_color
// first: 1-4-03
// simple function to use the name of a item holding escape sequences that, though they will not compile,
// they can be interpreted at run time and produce rbg scales between 32 and 255 in increments.
// -- allows 3375 colors to be made.
// for example SendMessageToPC(pc,GetRGB(15,15,1)+ "Help, I'm on fire!") will produce yellow text.
// more examples:
/*
    GetRGB() := WHITE // no parameters, default is white
    GetRGB(15,15,1):= YELLOW
    GetRGB(15,5,1) := ORANGE
    GetRGB(15,1,1) := RED
    GetRGB(7,7,15) := BLUE
    GetRGB(1,15,1) := NEON GREEN
    GetRGB(1,11,1) := GREEN
    GetRGB(9,6,1)  := BROWN
    GetRGB(11,9,11):= LIGHT PURPLE
    GetRGB(12,10,7):= TAN
    GetRGB(8,1,8)  := PURPLE
    GetRGB(13,9,13):= PLUM
    GetRGB(1,7,7)  := TEAL
    GetRGB(1,15,15):= CYAN
    GetRGB(1,1,15) := BRIGHT BLUE
*/
// issues? contact genji@thegenji.com
// special thanks to ADAL-Miko and Rich Dersheimer in the bio forums.
string GetRGB(int red = 15,int green = 15,int blue = 15);

/**
 * Checks if any PCs (or optionally their NPC party members) are in the
 * given area.
 *
 * @param oArea            The area to check
 * @param bNPCPartyMembers Whether to check the PC's party members, too
 */
int GetIsAPCInArea(object oArea, int bNPCPartyMembers = TRUE);

/**
 * Converts the given integer to string as IntToString and then
 * pads the left side until it's nLength characters long. If sign
 * is specified, the first character is reserved for it, and it is
 * always present.
 * Strings longer than the given length are trunctated to their nLength
 * right characters.
 *
 * credit goes to Pherves, who posted the original in homebrew scripts forum sticky
 *
 * @param nX      The integer to convert
 * @param nLength The length of the resulting string
 * @param nSigned If this is TRUE, a sign character is inserted as the leftmost
 *                character. Doing so leaves one less character for use as a digit.
 *
 * @return        The string that results from conversion as specified above.
 */
string IntToPaddedString(int nX, int nLength = 4, int nSigned = FALSE);

/**
 * Looks through the given string, replacing all instances of sToReplace with
 * sReplacement. If such a replacement creates another instance of sToReplace,
 * it, too is replaced. Be aware that you can cause an infinite loop with
 * properly constructed parameters due to this.
 *
 * @param sString      The string to modify
 * @param sToReplace   The substring to replace
 * @param sReplacement The replacement string
 * @return             sString with all instances of sToReplace replaced
 *                     with sReplacement
 */
string ReplaceChars(string sString, string sToReplace, string sReplacement);

/**
 * A wrapper for DestroyObject(). Attempts to bypass any
 * conditions that might prevent destroying the object.
 *
 * WARNING: This will destroy any object that can at all be
 *          destroyed by DestroyObject(). In other words, you
 *          can clobber critical bits with careless use.
 *          Only the module, PCs and areas are unaffected. Using this
 *          function on any of those will cause an infinite
 *          DelayCommand loop that will eat up resources, though.
 *
 *
 * @param oObject The object to destroy
 */
void MyDestroyObject(object oObject);

/**
 * Calculates the base AC of the given armor.
 *
 * @param oArmor  An item of type BASE_ITEM_ARMOR
 * @return        The base AC of oArmor, or -1 on error
 */
int GetItemACBase(object oArmor);

/**
 * Gets the type of the given armor based on it's base AC.
 *
 * @param oArmor  An item of type BASE_ITEM_ARMOR
 * @return        ARMOR_TYPE_* constant of the armor, or -1 on error
 */
int GetArmorType(object oArmor);

/**
 * Calculates the number of steps along both moral and ethical axes that
 * the two target's alignments' differ.
 *
 * @param oSource A creature
 * @param oTarget Another creature
 * @return        The number of steps the target's alignment differs
 */
int CompareAlignment(object oSource, object oTarget);

/**
 * Repeatedly assigns an equipping action to equip the given item until
 * it is equipped. Used for getting around the fact that a player can
 * cancel the action. They will give up eventually :D
 *
 * WARNING: Note that forcing an equip into offhand when mainhand is empty
 * will result in an infinite loop. So will attempting to equip an item
 * into a slot it can't be equipped in.
 *
 * @param oPC     The creature to do the equipping.
 * @param oItem   The item to equip.
 * @param nSlot   INVENTORY_SLOT_* constant of the slot to equip into.
 * @param nThCall Internal parameter, leave as default. This determines
 *                how many times ForceEquip has called itself.
 */
void ForceEquip(object oPC, object oItem, int nSlot, int nThCall = 0);

/**
 * Repeatedly attempts to unequip the given item until it is no longer
 * in the slot given. Used for getting around the fact that a player can
 * cancel the action. They will give up eventually :D
 *
 * @param oPC    The creature to do the unequipping.
 * @param oItem  The item to unequip.
 * @param nSlot  INVENTORY_SLOT_* constant of the slot containing oItem.
 * @param bFirst Leave this to TRUE when calling, see code for reason.
 */
void ForceUnequip(object oPC, object oItem, int nSlot, int bFirst = TRUE);

/**
 * Try to identify all unidentified objects within the given creature's inventory
 * using it's skill ranks in lore.
 *
 * @param oPC The creature whose items to identify
 */
void TryToIDItems(object oPC = OBJECT_SELF);

//////////////////////////////////////////////////
/* Include section                              */
//////////////////////////////////////////////////

// No dependecies outiside their own loops -section
#include "inc_draw"       // includes inc_draw_text and inc_draw_tools
#include "inc_debug"
#include "inc_target_list"
#include "inc_logmessage"
#include "inc_threads"
#include "inc_time"
#include "inc_rand_equip"
#include "inc_class_by_pos"

#include "inc_pers_array"   // includes inc_array, inc_persist_loca, inc_item_props, inc_prc_npc and inc_2dacache
#include "inc_eventhook"    // Should be after inc_pers_array, which it is dependent on
#include "inc_heap"         // Should be after inc_pers_array, as it needs inc_array
#include "prc_inc_switch"   // Should be after inc_pers_array, as it needs inc_array
#include "inc_ecl"          // Depends on inc_2dacache, prc_inc_switch and inc_class_by_pos
#include "inc_metalocation" // Depends on inc_persist_loca



/**********************\
* Function Definitions *
\**********************/

int max(int a, int b) {return (a > b ? a : b);}

int min(int a, int b) {return (a < b ? a : b);}

float fmax(float a, float b) {return (a > b ? a : b);}

float fmin(float a, float b) {return (a < b ? a : b);}

float fabs(float f) {return (f < 0.0f ? -f : f);}

int HexToInt(string sHex)
{
    if(sHex == "") return 0;                            // Some quick optimisation for empty strings
    sHex = GetStringRight(GetStringLowerCase(sHex), 8); // Trunctate to last 8 characters and convert to lowercase
    if(GetStringLeft(sHex, 2) == "0x")                  // Cut out '0x' if it's still present
        sHex = GetStringRight(sHex, 6);
    string sConvert = "0123456789abcdef";               // The string to index using the characters in sHex
    int nReturn, nHalfByte;
    while(sHex != "")
    {
        nHalfByte = FindSubString(sConvert, GetStringRight(sHex, 1)); // Get the value of the next hexadecimal character
        if(nHalfByte == -1) return 0;                                 // Invalid character in the string!
        nReturn  = nReturn << 4;                                      // Rightshift by 4 bits
        nReturn |= nHalfByte;                                         // OR in the next bits
        sHex = GetStringLeft(sHex, GetStringLength(sHex) - 1);        // Remove the parsed character from the string
    }

    return nReturn;
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


string GetRGB(int red = 15,int green = 15,int blue = 15)
{
    object coloringBook = GetObjectByTag("ColoringBook");
    if (coloringBook == OBJECT_INVALID)
        coloringBook = CreateObject(OBJECT_TYPE_ITEM,"gen_coloringbook",GetLocation(GetObjectByTag("HEART_OF_CHAOS")));
    string buffer = GetName(coloringBook);
    if(red > 15) red = 15; if(green > 15) green = 15; if(blue > 15) blue = 15;
    if(red < 1)  red = 1;  if(green < 1)  green = 1;  if(blue < 1)  blue = 1;
    return "<c" + GetSubString(buffer, red - 1, 1) + GetSubString(buffer, green - 1, 1) + GetSubString(buffer, blue - 1, 1) +">";
}

int GetIsAPCInArea(object oArea, int bNPCPartyMembers = TRUE)
{
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC))
    {
        if(bNPCPartyMembers)
        {
            object oFaction = GetFirstFactionMember(oPC, FALSE);
            while(GetIsObjectValid(oFaction))
            {
                if (GetArea(oFaction) == oArea)
                    return TRUE;
                oFaction = GetNextFactionMember(oPC, FALSE);
            }
        }
        oPC = GetNextPC();
    }
    return FALSE;
}

string IntToPaddedString(int nX, int nLength = 4, int nSigned = FALSE)
{
    if(nSigned)
        nLength--;//to allow for sign
    string sResult = IntToString(nX);
    // Trunctate to nLength rightmost characters
    if(GetStringLength(sResult) > nLength)
        sResult = GetStringRight(sResult, nLength);
    // Pad the left side with zero
    while(GetStringLength(sResult) < nLength)
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

string ReplaceChars(string sString, string sToReplace, string sReplacement)
{
    int nInd = FindSubString(sString, sToReplace);
    while(nInd != -1)
    {
        sString = GetStringLeft(sString, nInd) +
                  sReplacement +
                  GetSubString(sString,
                               nInd + GetStringLength(sToReplace),
                               GetStringLength(sString) - nInd - GetStringLength(sToReplace)
                               );
    }
    return sString;
}

void MyDestroyObject(object oObject)
{
    if(GetIsObjectValid(oObject))
    {
        SetCommandable(TRUE ,oObject);
        AssignCommand(oObject, ClearAllActions());
        AssignCommand(oObject, SetIsDestroyable(TRUE, FALSE, FALSE));
        AssignCommand(oObject, DestroyObject(oObject));
        // May not necessarily work on first iteration
        DestroyObject(oObject);
        DelayCommand(0.1f, MyDestroyObject(oObject));
    }
}

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

void ForceEquip(object oPC, object oItem, int nSlot, int nThCall = 0)
{
    // Sanity checks
    // Make sure the parameters are valid
    if(!GetIsObjectValid(oPC)) return;
    if(!GetIsObjectValid(oItem)) return;
    // Make sure that the object we are attempting equipping is the latest one to be ForceEquipped into this slot
    if(GetIsObjectValid(GetLocalObject(oPC, "ForceEquipToSlot_" + IntToString(nSlot)))
        &&
       GetLocalObject(oPC, "ForceEquipToSlot_" + IntToString(nSlot)) != oItem
       )
        return;

    float fDelay;

    // Check if the equipping has already happened
    if(GetItemInSlot(nSlot, oPC) != oItem)
    {
        // Test and increment the control counter
        if(!nThCall++)
        {
            // First, try to do the equipping non-intrusively and give the target a reasonable amount of time to do it
            AssignCommand(oPC, ActionEquipItem(oItem, nSlot));
            fDelay = 1.0f;
            // Store the item to be equipped in a local variable to prevent contest between two different calls to ForceEquip
            SetLocalObject(oPC, "ForceEquipToSlot_" + IntToString(nSlot), oItem);
        }
        else
        {
            // Nuke the target's action queue. This should result in "immediate" equipping of the item
            AssignCommand(oPC, ClearAllActions());
            AssignCommand(oPC, ActionEquipItem(oItem, nSlot));
            // Use a lenghtening delay in order to attempt handling lag and possible other interference. From 0.1s to 1s
            fDelay = min(nThCall, 10) / 10.0f;
        }

        // Loop
        DelayCommand(fDelay, ForceEquip(oPC, oItem, nSlot, nThCall));
    }
    // It has, so clean up
    else
        DeleteLocalObject(oPC, "ForceEquipToSlot_" + IntToString(nSlot));
}

void ForceUnequip(object oPC, object oItem, int nSlot, int nThCall = 0)
{
    // Sanity checks
    if(!GetIsObjectValid(oPC)) return;
    if(!GetIsObjectValid(oItem)) return;

    float fDelay;

    // Delay the first unequipping call to avoid a bug that occurs when an object that was just equipped is unequipped right away
    // - The item is not unequipped properly, leaving some of it's effects in the creature's stats and on it's model.
    if(!nThCall)
    {
        //DelayCommand(0.5, ForceUnequip(oPC, oItem, nSlot, FALSE));
        fDelay = 0.5;
    }
    else if(GetItemInSlot(nSlot, oPC) == oItem)
    {
        // Attempt to avoid interference by not clearing actions before the first attempt
        if(nThCall > 1)
            AssignCommand(oPC, ClearAllActions());

        AssignCommand(oPC, ActionUnequipItem(oItem));

        // Ramp up the delay if the action is not getting through. Might let whatever is intefering finish
        fDelay = min(nThCall, 10) / 10.0f;
    }

    // Loop
    DelayCommand(fDelay, ForceUnequip(oPC, oItem, nSlot, ++nThCall));
}

void TryToIDItems(object oPC = OBJECT_SELF)
{
    int nLore = GetSkillRank(SKILL_LORE, oPC);
    int nGP;
    string sMax = Get2DACache("SkillVsItemCost", "DeviceCostMax", nLore);
    int nMax = StringToInt(sMax);
    if (sMax == "") nMax = 120000000;
    object oItem = GetFirstItemInInventory(oPC);
    while(oItem != OBJECT_INVALID)
    {
        if(!GetIdentified(oItem))
        {
            // Check for the value of the item first.
            SetIdentified(oItem, TRUE);
            nGP = GetGoldPieceValue(oItem);
            SetIdentified(oItem, FALSE);
            // If oPC has enough Lore skill to ID the item, then do so.
            if(nMax >= nGP)
            {
                SetIdentified(oItem, TRUE);
                SendMessageToPC(oPC, GetStringByStrRef(16826224) + " " + GetName(oItem) + " " + GetStringByStrRef(16826225));
            }
        }
        oItem = GetNextItemInInventory(oPC);
    }
}
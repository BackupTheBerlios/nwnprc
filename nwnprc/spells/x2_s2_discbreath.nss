/*
This is the edited script I had made changes to before Silver reverted to
the original. It has:

Round delays for metabreath/multiple uses
Line breath (working)
Pyroclastic being 50% of each
PRCGetReflexAdjustedDamage to interact better with other systems
Range dependant on size
Less code duplication by using dedicated functions. Easier to fix/find bugs.
Moved breath VFX so when different ones for different colors are done they can be easily implemented


Moved to a new script so its not lost permanently. Feel free to refer to this if you want.

Primogenitor


//:: edited by Fox on 1/19/08

Script has been rewritten to use the new breath include.  Most of the above has 
been subsumed into said include where appropriate.


//::///////////////////////////////////////////////
//:: Breath Weapon for Dragon Disciple Class
//:: x2_s2_discbreath
//:: Copyright (c) 2003Bioware Corp.
//:://////////////////////////////////////////////

//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller (modified by Silver)
//:: Created On: June, 17, 2003 (June, 7, 2005)
//:://////////////////////////////////////////////
*/
#include "prc_alterations"
#include "prc_inc_breath"


//////////////////////////
// Constant Definitions //
//////////////////////////

const string DDISBREATHLOCK = "DragonDiscipleBreathLock";


int IsLineBreath()
{
    if(GetHasFeat(FEAT_BLACK_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_BLUE_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_BRASS_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_BRONZE_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_COPPER_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_AMETHYST_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_BROWN_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_CHAOS_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_OCEANUS_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_RADIANT_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_RUST_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_STYX_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_TARTIAN_DRAGON, OBJECT_SELF)
        )
        return TRUE;
    return FALSE;
}

//Returns range in feet for breath struct.  Conversion to meters is 
//handled internally in the include
float GetRangeFromSize(int nSize)
{
    float fRange = 30.0;
    switch(nSize)
    {
        case CREATURE_SIZE_FINE:        
        case CREATURE_SIZE_DIMINUTIVE:  
        case CREATURE_SIZE_TINY:        fRange = 15.0; break;
        case CREATURE_SIZE_SMALL:       fRange = 20.0; break;
        case CREATURE_SIZE_MEDIUM:      fRange = 30.0; break;
        case CREATURE_SIZE_LARGE:       fRange = 40.0; break;
        case CREATURE_SIZE_HUGE:        fRange = 50.0; break;
        case CREATURE_SIZE_GARGANTUAN:  fRange = 60.0; break;
        case CREATURE_SIZE_COLOSSAL:    fRange = 70.0; break;
    }
    return fRange;
}

void main()
{
    //Declare main variables.
    object oPC   = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    struct breath DiscBreath;

    // Check the dragon breath delay lock
    if(GetLocalInt(oPC, DDISBREATHLOCK))
    {
        SendMessageToPC(oPC, "You cannot use your breath weapon again so soon"); /// TODO: TLKify
        IncrementRemainingFeatUses(oPC, FEAT_DRAGON_DIS_BREATH);
        return;
    }
    
    int nLevel = GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE,oPC);
    int nDamageDice;

    //Sets the save DC for Dragon Breath attacks.  This is a reflex save to halve the damage.
    //Save is 10+CON+1/2 DD level.  Gains +1 at level 13, and every 3 levels after.
    int nSaveDCBonus = ((nLevel)/2) + max((nLevel - 10) / 3, 0);
    /*
    if      (nLevel <13)   nSaveDCBonus = (0 + ((nLevel)/2));
    else if (nLevel <16)   nSaveDCBonus = (1 + ((nLevel)/2));
    else if (nLevel <19)   nSaveDCBonus = (2 + ((nLevel)/2));
    else if (nLevel <22)   nSaveDCBonus = (3 + ((nLevel)/2));
    else if (nLevel <25)   nSaveDCBonus = (4 + ((nLevel)/2));
    else if (nLevel <28)   nSaveDCBonus = (5 + ((nLevel)/2));
    else                   nSaveDCBonus = (6 + ((nLevel)/2));
    */

    //Sets damage levels for Dragon Breath attacks.  2d10 at level 3,
    //4d10 at level 7, and then an additional 2d10 every 3 levels (10, 13, 16, ect)
    nDamageDice = ((nLevel < 7) ? 2 : 4) + // Special handling of the 4 level jump
                   max((nLevel - 7) / 3, 0);

    /*
    if      (nLevel <7)   nDamageDice = 2;
    else if (nLevel <10)  nDamageDice = 4;
    else if (nLevel <13)  nDamageDice = 6;
    else if (nLevel <16)  nDamageDice = 8;
    else if (nLevel <19)  nDamageDice = 10;
    else if (nLevel <22)  nDamageDice = 12;
    else if (nLevel <25)  nDamageDice = 14;
    else if (nLevel <28)  nDamageDice = 16;
    else                  nDamageDice = 18;
    */
    
    //range calculation
    float fRange = GetRangeFromSize(PRCGetCreatureSize(oPC));
    if(IsLineBreath()) fRange = fRange * 2.0;

    //Only Dragons with Breath Weapons will have damage caused by their breath attack.
    //Any Dragon type not listed here will have a breath attack, but it will not
    //cause damage or create a visual effect.
    int DBREED = GetHasFeat(FEAT_RED_DRAGON,       oPC) ? DAMAGE_TYPE_FIRE :
                 GetHasFeat(FEAT_BRASS_DRAGON,     oPC) ? DAMAGE_TYPE_FIRE :
                 GetHasFeat(FEAT_GOLD_DRAGON,      oPC) ? DAMAGE_TYPE_FIRE :
                 GetHasFeat(FEAT_LUNG_WANG_DRAGON, oPC) ? DAMAGE_TYPE_FIRE :
                 GetHasFeat(FEAT_TIEN_LUNG_DRAGON, oPC) ? DAMAGE_TYPE_FIRE :
                 GetHasFeat(FEAT_BLACK_DRAGON,     oPC) ? DAMAGE_TYPE_ACID :
                 GetHasFeat(FEAT_GREEN_DRAGON,     oPC) ? DAMAGE_TYPE_ACID :
                 GetHasFeat(FEAT_COPPER_DRAGON,    oPC) ? DAMAGE_TYPE_ACID :
                 GetHasFeat(FEAT_BROWN_DRAGON,     oPC) ? DAMAGE_TYPE_ACID :
                 GetHasFeat(FEAT_DEEP_DRAGON,      oPC) ? DAMAGE_TYPE_ACID :
                 GetHasFeat(FEAT_RUST_DRAGON,      oPC) ? DAMAGE_TYPE_ACID :
                 GetHasFeat(FEAT_STYX_DRAGON,      oPC) ? DAMAGE_TYPE_ACID :
                 GetHasFeat(FEAT_SILVER_DRAGON,    oPC) ? DAMAGE_TYPE_COLD :
                 GetHasFeat(FEAT_WHITE_DRAGON,     oPC) ? DAMAGE_TYPE_COLD :
                 GetHasFeat(FEAT_BLUE_DRAGON,      oPC) ? DAMAGE_TYPE_ELECTRICAL :
                 GetHasFeat(FEAT_BRONZE_DRAGON,    oPC) ? DAMAGE_TYPE_ELECTRICAL :
                 GetHasFeat(FEAT_OCEANUS_DRAGON,   oPC) ? DAMAGE_TYPE_ELECTRICAL :
                 GetHasFeat(FEAT_SONG_DRAGON,      oPC) ? DAMAGE_TYPE_ELECTRICAL :
                 GetHasFeat(FEAT_EMERALD_DRAGON,   oPC) ? DAMAGE_TYPE_SONIC :
                 GetHasFeat(FEAT_SAPPHIRE_DRAGON,  oPC) ? DAMAGE_TYPE_SONIC :
                 GetHasFeat(FEAT_BATTLE_DRAGON,    oPC) ? DAMAGE_TYPE_SONIC :
                 GetHasFeat(FEAT_HOWLING_DRAGON,   oPC) ? DAMAGE_TYPE_SONIC :
                 GetHasFeat(FEAT_CRYSTAL_DRAGON,   oPC) ? DAMAGE_TYPE_POSITIVE :
                 GetHasFeat(FEAT_AMETHYST_DRAGON,  oPC) ? DAMAGE_TYPE_MAGICAL :
                 GetHasFeat(FEAT_TOPAZ_DRAGON,     oPC) ? DAMAGE_TYPE_MAGICAL :
                 GetHasFeat(FEAT_ETHEREAL_DRAGON,  oPC) ? DAMAGE_TYPE_MAGICAL :
                 GetHasFeat(FEAT_RADIANT_DRAGON,   oPC) ? DAMAGE_TYPE_MAGICAL :
                 GetHasFeat(FEAT_TARTIAN_DRAGON,   oPC) ? DAMAGE_TYPE_MAGICAL :
                -1; // If none match, make the itemproperty invalid <- wtf? - Ornedan


    int dChaos  = GetHasFeat(FEAT_CHAOS_DRAGON,       oPC);
    int dPyCla  = GetHasFeat(FEAT_PYROCLASTIC_DRAGON, oPC);
    int dShadow = GetHasFeat(FEAT_SHADOW_DRAGON,      oPC);

    if (DBREED > 0)  DiscBreath = CreateBreath(oPC, IsLineBreath(), fRange, DBREED, 10, nDamageDice, ABILITY_CONSTITUTION, nSaveDCBonus);
    //If Topaz, activate override for special impact VFX for Topaz's breath
    if (GetHasFeat(FEAT_TOPAZ_DRAGON, oPC)) DiscBreath.nOverrideSpecial = BREATH_TOPAZ;
    if (dChaos > 0)  
    {
    	int eleBreath;
	
	int nNumDice = d10();
	//Sets the random Element factor of the Chaos Dragons Breath Weapon.
	//Affects damage, saving throw, and impact visual.
	if((nNumDice==1) || (nNumDice==2))
	{
	    eleBreath = DAMAGE_TYPE_COLD;
	}
	else if((nNumDice==3) || (nNumDice==4))
	{
	    eleBreath = DAMAGE_TYPE_ACID;
	}
	else if((nNumDice==5) || (nNumDice==6))
	{
	    eleBreath = DAMAGE_TYPE_FIRE;
	}
	else if((nNumDice==7) || (nNumDice==8))
	{
	    eleBreath = DAMAGE_TYPE_SONIC;
	}
	else //if((nNumDice==9) || (nNumDice==10))
	{
	    eleBreath = DAMAGE_TYPE_ELECTRICAL;
	}
	
	DiscBreath = CreateBreath(oPC, IsLineBreath(), fRange, eleBreath, 10, nDamageDice, ABILITY_CONSTITUTION, nSaveDCBonus);
    }
    if (dPyCla > 0)  DiscBreath = CreateBreath(oPC, IsLineBreath(), fRange, DAMAGE_TYPE_SONIC, 10, nDamageDice, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_PYROCLASTIC);
    if (dShadow > 0) DiscBreath = CreateBreath(oPC, IsLineBreath(), fRange, -1, 10, nDamageDice, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_SHADOW);

    //actual breath effect
    ApplyBreath(DiscBreath, PRCGetSpellTargetLocation());

    //breath VFX
    effect eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, PRCGetSpellTargetLocation());
    
    if(GetHasFeat(FEAT_FULL_DRAGON_BREATH, oPC))
    	IncrementRemainingFeatUses(oPC, FEAT_DRAGON_DIS_BREATH);
    
    // Set the lock
    SetLocalInt(oPC, DDISBREATHLOCK, TRUE);

    // Schedule opening the delay lock
    float fDelay = RoundsToSeconds(DiscBreath.nRoundsUntilRecharge);
    SendMessageToPC(oPC, "Your breath weapon will be ready again in " + IntToString(DiscBreath.nRoundsUntilRecharge) + " rounds.");

    DelayCommand(fDelay, DeleteLocalInt(oPC, DDISBREATHLOCK));
    DelayCommand(fDelay, SendMessageToPC(oPC, "Your breath weapon is ready now"));

}


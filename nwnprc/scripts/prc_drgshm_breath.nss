//:://////////////////////////////////////////////////////
//:: Breath Weapon for Dragon Shaman Class
//:: prc_drgshm_breath.nss
//:://////////////////////////////////////////////////////

#include "prc_inc_breath"
#include "prc_inc_dragsham"

//////////////////////////
// Constant Definitions //
//////////////////////////

const string DSHMBREATHLOCK = "DragonShamanBreathLock";


int IsLineBreath()
{
    if(GetHasFeat(FEAT_DRAGONSHAMAN_BLACK, OBJECT_SELF)
        || GetHasFeat(FEAT_DRAGONSHAMAN_BLUE, OBJECT_SELF)
        || GetHasFeat(FEAT_DRAGONSHAMAN_BRASS, OBJECT_SELF)
        || GetHasFeat(FEAT_DRAGONSHAMAN_BRONZE, OBJECT_SELF)
        || GetHasFeat(FEAT_DRAGONSHAMAN_COPPER, OBJECT_SELF)
        )
        return TRUE;
    return FALSE;
}

// PHB II Dragon Shaman has no mention of size being taken into account with breath weapons on players. Once this
// is looked at further, this may or may not be taken into account. These rules are gone over in more detail
// in the draconomicon which has a lot more rules for dragon breath weapons.

/* float GetRangeFromSize(int nSize)
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
} */

void main()
{
    //Declare main variables.
    object oPC   = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    float fRange = 30.0;
    struct breath ShamanBreath;

    // Check the dragon breath delay lock
    if(GetLocalInt(oPC, DSHMBREATHLOCK))
    {
        SendMessageToPC(oPC, "You cannot use your breath weapon again so soon"); /// TODO: TLKify
        return;
    }
    // Set the lock
    SetLocalInt(oPC, DSHMBREATHLOCK, TRUE);

    //set the breath range
    if(GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN) >= 20)
    {
        fRange = 60.0;
    }
    else if(GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN) >= 12)
    {
        fRange = 30.0;
    }
    else
    {
        fRange = 15.0;
    }
    
    if(IsLineBreath()) fRange = fRange * 2.0;

    int nLevel = GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN, oPC);

    //Sets the save DC for Dragon Breath attacks.  This is a reflex save to halve the damage.
    //Save is 10+CON+1/2 Dragon Shaman level.
    int nSaveDCBoost = nLevel / 2;

    //starts with 2 dice at level 4
    int nDamageDice = 2;
    //Gets one more die every 2 levels
    nDamageDice += (GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN ,oPC) - 4) / 2;

    //Only Dragons with Breath Weapons will have damage caused by their breath attack.
    //Any Dragon type not listed here will have a breath attack, but it will not
    //cause damage or create a visual effect.
    int DBREED = GetHasFeat(FEAT_DRAGONSHAMAN_RED,       oPC) ? DAMAGE_TYPE_FIRE :
                 GetHasFeat(FEAT_DRAGONSHAMAN_BRASS,     oPC) ? DAMAGE_TYPE_FIRE :
                 GetHasFeat(FEAT_DRAGONSHAMAN_GOLD,      oPC) ? DAMAGE_TYPE_FIRE :
                 GetHasFeat(FEAT_DRAGONSHAMAN_BLACK,     oPC) ? DAMAGE_TYPE_ACID :
                 GetHasFeat(FEAT_DRAGONSHAMAN_GREEN,     oPC) ? DAMAGE_TYPE_ACID :
                 GetHasFeat(FEAT_DRAGONSHAMAN_COPPER,    oPC) ? DAMAGE_TYPE_ACID :
                 GetHasFeat(FEAT_DRAGONSHAMAN_SILVER,    oPC) ? DAMAGE_TYPE_COLD :
                 GetHasFeat(FEAT_DRAGONSHAMAN_WHITE,     oPC) ? DAMAGE_TYPE_COLD :
                 GetHasFeat(FEAT_DRAGONSHAMAN_BLUE,      oPC) ? DAMAGE_TYPE_ELECTRICAL :
                 GetHasFeat(FEAT_DRAGONSHAMAN_BRONZE,    oPC) ? DAMAGE_TYPE_ELECTRICAL :
                -1; // If none match, make the itemproperty invalid <- wtf? - Ornedan

    ShamanBreath = CreateBreath(oPC, IsLineBreath(), fRange, DBREED, 6, nDamageDice, ABILITY_CONSTITUTION, nSaveDCBoost);
    
    ApplyBreath(ShamanBreath, PRCGetSpellTargetLocation());
    //breath VFX
    /* - Taken out until we have real breath VFX - Fox
    effect eVis;

    if(GetHasFeat(FEAT_DRAGONSHAMAN_RED, OBJECT_SELF) || GetHasFeat(FEAT_DRAGONSHAMAN_GOLD, OBJECT_SELF))
    {
        eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND);
    }
    else if(GetHasFeat(FEAT_DRAGONSHAMAN_BLUE, OBJECT_SELF) || GetHasFeat(FEAT_DRAGONSHAMAN_BRONZE, OBJECT_SELF))
    {
        eVis = EffectVisualEffect(VFX_BEAM_LIGHTNING);
    }
    else if(GetHasFeat(FEAT_DRAGONSHAMAN_BLACK, OBJECT_SELF) || GetHasFeat(FEAT_DRAGONSHAMAN_COPPER, OBJECT_SELF))
    {
        eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND);
    }
    else if(GetHasFeat(FEAT_DRAGONSHAMAN_WHITE, OBJECT_SELF) || GetHasFeat(FEAT_DRAGONSHAMAN_SILVER, OBJECT_SELF))
    {
        eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND);
    }
    else if(GetHasFeat(FEAT_DRAGONSHAMAN_BRASS, OBJECT_SELF))
    {
        eVis = EffectVisualEffect(VFX_BEAM_FIRE_W);
    }
    else if(GetHasFeat(FEAT_DRAGONSHAMAN_GREEN, OBJECT_SELF))
    {
        eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND);
    }

    // Apply the visual effect.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    */
    
    // Schedule opening the delay lock
    float fDelay = RoundsToSeconds(ShamanBreath.nRoundsUntilRecharge);
    SendMessageToPC(oPC, IntToString(ShamanBreath.nRoundsUntilRecharge) + " rounds until you can use your breath.");
    DelayCommand(fDelay, DeleteLocalInt(oPC, DSHMBREATHLOCK));
    DelayCommand(fDelay, SendMessageToPC(oPC, "Your breath weapon is ready now"));
}
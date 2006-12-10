//:://////////////////////////////////////////////////////
//:: Breath Weapon for Dragon Disciple Class
//:: x2_s2_discbreath
//:: Copyright (c) 2003Bioware Corp.
//:://////////////////////////////////////////////////////

//:://////////////////////////////////////////////////////
//:: Created By: Georg Zoeller (modified by Morgoth Marr}
//:: Created On: June, 17, 2003 (Dec 4, 2005)
//:://////////////////////////////////////////////////////

#include "prc_inc_dragsham"

//////////////////////////
// Constant Definitions //
//////////////////////////



const string DDISBREATHLOCK = "DragonShamanBreathLock";


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
    float fRange = 10.0;
    switch(nSize)
    {
        case CREATURE_SIZE_FINE:        fRange = FeetToMeters(30.0); break;
        case CREATURE_SIZE_DIMINUTIVE:  fRange = FeetToMeters(30.0); break;
        case CREATURE_SIZE_TINY:        fRange = FeetToMeters(30.0); break;
        case CREATURE_SIZE_SMALL:       fRange = FeetToMeters(30.0); break;
        case CREATURE_SIZE_MEDIUM:      fRange = FeetToMeters(30.0); break;
        //PnP says 30, but I think this doesnt fit the progression so Ive made it 40
        //Primogenitor
        case CREATURE_SIZE_LARGE:       fRange = FeetToMeters(40.0); break;
        case CREATURE_SIZE_HUGE:        fRange = FeetToMeters(50.0); break;
        case CREATURE_SIZE_GARGANTUAN:  fRange = FeetToMeters(60.0); break;
        case CREATURE_SIZE_COLOSSAL:    fRange = FeetToMeters(70.0); break;
    }
    return fRange;
} */

// Attack script where everything comes into play. 

void BreathAttack(object oPC ,object oSkin ,int DBREED ,int nSaveDC ,int nLevel ,int nDamage)
{
    //Sets what type of saving throw is to be made by those caught in the dragon disciples
    //breath weapon.
    int SAVETH = GetHasFeat(FEAT_DRAGONSHAMAN_RED, oPC)       ? SAVING_THROW_TYPE_FIRE :
                 GetHasFeat(FEAT_DRAGONSHAMAN_BRASS, oPC)     ? SAVING_THROW_TYPE_FIRE :
                 GetHasFeat(FEAT_DRAGONSHAMAN_GOLD, oPC)      ? SAVING_THROW_TYPE_FIRE :
                 GetHasFeat(FEAT_DRAGONSHAMAN_BLACK, oPC)     ? SAVING_THROW_TYPE_ACID :
                 GetHasFeat(FEAT_DRAGONSHAMAN_GREEN, oPC)     ? SAVING_THROW_TYPE_ACID :
                 GetHasFeat(FEAT_DRAGONSHAMAN_COPPER, oPC)    ? SAVING_THROW_TYPE_ACID :
                 GetHasFeat(FEAT_DRAGONSHAMAN_SILVER, oPC)    ? SAVING_THROW_TYPE_COLD :
                 GetHasFeat(FEAT_DRAGONSHAMAN_WHITE, oPC)     ? SAVING_THROW_TYPE_COLD :
                 GetHasFeat(FEAT_DRAGONSHAMAN_BLUE, oPC)      ? SAVING_THROW_TYPE_ELECTRICITY :
                 GetHasFeat(FEAT_DRAGONSHAMAN_BRONZE, oPC)    ? SAVING_THROW_TYPE_ELECTRICITY :
                -1; // If none match, make the itemproperty invalid

    //Sets visual effect for object struck, varying based on the element or nature of the
    //Dragon Shaman types.
    int VISUAL = GetHasFeat(FEAT_DRAGONSHAMAN_RED, oPC)       ? VFX_IMP_FLAME_M :
                 GetHasFeat(FEAT_DRAGONSHAMAN_BRASS, oPC)     ? VFX_IMP_FLAME_M :
                 GetHasFeat(FEAT_DRAGONSHAMAN_GOLD, oPC)      ? VFX_IMP_FLAME_M :
                 GetHasFeat(FEAT_DRAGONSHAMAN_BLACK, oPC)     ? VFX_IMP_ACID_S :
                 GetHasFeat(FEAT_DRAGONSHAMAN_GREEN, oPC)     ? VFX_IMP_ACID_S :
                 GetHasFeat(FEAT_DRAGONSHAMAN_COPPER, oPC)    ? VFX_IMP_ACID_S :
                 GetHasFeat(FEAT_DRAGONSHAMAN_SILVER, oPC)    ? VFX_IMP_FROST_S :
                 GetHasFeat(FEAT_DRAGONSHAMAN_WHITE, oPC)     ? VFX_IMP_FROST_S :
                 GetHasFeat(FEAT_DRAGONSHAMAN_BLUE, oPC)      ? VFX_IMP_LIGHTNING_S :
                 GetHasFeat(FEAT_DRAGONSHAMAN_BRONZE, oPC)    ? VFX_IMP_LIGHTNING_S :
                -1; // If none match, make the itemproperty invalid



    //Declare major variables
    float fDelay;
    object oTarget;
    effect eVis, eBreath;
	int nPersonalDamage;
    float fRange;
    int nBreathShape = SHAPE_SPELLCONE;
	
	if(GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN) < 12)
	{
		fRange = FeetToMeters(15.0);
	}
	else if(GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN) < 20)
	{
		fRange = FeetToMeters(30.0);
	}
	else if(GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN) >= 20)
	{
		fRange = FeetToMeters(60.0);
	}
	
    //these are lines not cones
    if(IsLineBreath())
    {
        nBreathShape = SHAPE_SPELLCYLINDER;
        fRange *= 2.0; //double the range
    }

    //Get first target in spell area
    oTarget = GetFirstObjectInShape(nBreathShape, fRange, GetSpellTargetLocation(), TRUE,
                                    OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE,
                                    GetPosition(oPC));

    while(GetIsObjectValid(oTarget))
    {
        nPersonalDamage = nDamage;
        if(oTarget != oPC && !GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oPC, GetSpellId()));
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            //Determine effect delay
            fDelay = GetDistanceBetween(oPC, oTarget)/20;
            nPersonalDamage = GetReflexAdjustedDamage(nPersonalDamage, oTarget, nSaveDC, SAVETH);

            if (nPersonalDamage > 0)
            {
                //Set Damage and VFX
                eBreath = EffectDamage(nPersonalDamage, DBREED);
                eVis = EffectVisualEffect(VISUAL);
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBreath, oTarget));
				// For when the Lingering Breath Feat is applied
				// nPersonalDamage /= 2;
				// eBreath = EffectDamage(nPersonalDamage, DBREED);
				// DelayCommand(RoundsToSeconds(1), ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				// DelayCommand(RountsToSeconds(1), ApplyEffectToObject(DURATION_TYPE_INSTANT, eBreath, oTarget));
             }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(nBreathShape, fRange, GetSpellTargetLocation(), TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
    }
}

void main()
{
    //Declare main variables.
    object oPC   = OBJECT_SELF;
    object oSkin = GetPCSkin();

    // Check the dragon breath delay lock
    if(GetLocalInt(oPC, DDISBREATHLOCK))
    {
        SendMessageToPC(oPC, "You cannot use your breath weapon again so soon"); /// TODO: TLKify
        IncrementRemainingFeatUses(oPC, FEAT_DRAGON_DIS_BREATH);
        return;
    }
    // Set the lock
    SetLocalInt(oPC, DDISBREATHLOCK, TRUE);

    // Schedule opening the delay lock
    float fDelay = RoundsToSeconds(d4());
    /// TODO: When metabreath is implemented, but the additional delay calculation here


    DelayCommand(fDelay, DeleteLocalInt(oPC, DDISBREATHLOCK));
    DelayCommand(fDelay, SendMessageToPC(oPC, "Your breath weapon is ready now")); /// TODO: TLKify

    int nConBoost = (GetAbilityModifier(ABILITY_CONSTITUTION)); // Apply Con bonus to DC if there is a bonus. Penalties do not apply
    int nLevel = GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN ,oPC);
    int nDamageDice;

    //Sets the save DC for Dragon Breath attacks.  This is a reflex save to halve the damage.
    //Save is 10+CON+1/2 DD level.  Gains +1 at level 13, and every 3 levels after.
    int nSaveDC = 10 + nConBoost + ((nLevel)/2);
	if(nLevel >= 20)
	{
		nDamageDice = 10;
	}
	else if(nLevel <=19)
	{
		nDamageDice = 9;
	}
	else if(nLevel <= 17)
	{
		nDamageDice = 8;
	}
	else if(nLevel <= 15)
	{
		nDamageDice = 7;
	}
	else if(nLevel <= 13)
	{
		nDamageDice = 6;
	}
	else if(nLevel <= 11)
	{
		nDamageDice = 5;
	}
	else if(nLevel <= 9)
	{
		nDamageDice = 4;
	}
	else if(nLevel <= 7)
	{
		nDamageDice = 3;
	}
	else
	{
		nDamageDice = 2;
	}
 
    int nDamage = d6(nDamageDice);

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

    BreathAttack (oPC, oSkin, DBREED,  nSaveDC, nLevel, nDamage);
	
    //breath VFX
	effect eVis;
	
	if(GetHasFeat(FEAT_DRAGONSHAMAN_RED, OBJECT_SELF) || GetHasFeat(FEAT_DRAGONSHAMAN_GOLD, OBJECT_SELF))
	{
	    eVis = EffectVisualEffect(VFX_CONE_RED_DRAGON_FIRE);
	}
	else if(GetHasFeat(FEAT_DRAGONSHAMAN_BLUE, OBJECT_SELF) || GetHasFeat(FEAT_DRAGONSHAMAN_BRONZE, OBJECT_SELF))
	{
		eVis = EffectVisualEffect(VFX_BEAM_LIGHTNING);
	}
	else if(GetHasFeat(FEAT_DRAGONSHAMAN_BLACK, OBJECT_SELF) || GetHasFeat(FEAT_DRAGONSHAMAN_COPPER, OBJECT_SELF))
	{
		eVis = EffectVisualEffect(VFX_BEAM_ACID);
	}
	else if(GetHasFeat(FEAT_DRAGONSHAMAN_WHITE, OBJECT_SELF) || GetHasFeat(FEAT_DRAGONSHAMAN_SILVER, OBJECT_SELF))
	{
		eVis = EffectVisualEffect(VFX_DUR_WINTER_WOLF_BREATH);
	}
	else if(GetHasFeat(FEAT_DRAGONSHAMAN_BRASS, OBJECT_SELF))
	{
		eVis = EffectVisualEffect(VFX_BEAM_FIRE);
	}
	else if(GetHasFeat(FEAT_DRAGONSHAMAN_GREEN, OBJECT_SELF))
	{
		eVis = EffectVisualEffect(VFX_CONE_ACID_BREATH);
	}
	
	// Apply the visual effect.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
}
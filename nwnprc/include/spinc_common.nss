///////////////////////////////////////////////////////////////////////////
//
// Include file for common spell definitions.
//
//
// Functions for time that are missing from BioWare's code, to be used for
// spell durations.
//
// float MinutesToSeconds(int minutes);
// float TenMinutesToSeconds(int tenMinutes);
//
// Numerous wrappers for bioware functions are provided and should be
// called in place of the bioware functions; these hooks provide
// support for the PRC class scripts.  Below is a list of the new
// functions, see their comments for exact descriptions.
//
//	int SPResistSpell(object oCaster, object oTarget, float fDelay = 0.0)
//	int SPGetSpellSaveDC(object oCaster = OBJECT_SELF)
//	void SPApplyEffectToObject(int nDurationType, effect eEffect, object oTarget, float fDuration = 0.0f, 
//		int bDispellable = TRUE, int nSpellID = -1, int nCasterLevel = -1, object oCaster = OBJECT_SELF)
//	void SPRaiseSpellCastAt(object oTarget, int bHostile = TRUE, int nSpellID = -1, object oCaster = OBJECT_SELF)
//
// Functions that have no direct bioware equivalent, but allow for hooks into the spell code.
//
//	int SPGetElementalDamageType(int nDamageType, object oCaster = OBJECT_SELF)
//	void SPSetSchool(int nSchool = SPELL_SCHOOL_GENERAL)
//
// Functions that manipulate metamagic, these have no direct bioware equivalents, but should be called
// instead of GetMetaMagic() and checking flags.
//
//	int SPGetMetaMagic()
//	int SPGetMetaMagicDamage(int nDamageType, int nDice, int nDieSize, 
//		int nBonusPerDie = 0, int nBonus = 0, int nMetaMagic = -1)
//	float SPGetMetaMagicDuration(float fDuration, int nMetaMagic = -1)
//
// Functions to return effects, use any here instead of standard EffectXXX() functions.
//
//	effect SPEffectDamage(int nDamageAmount, int nDamageType = DAMAGE_TYPE_MAGICAL, 
//		int nDamagePower = DAMAGE_POWER_NORMAL)
//	effect SPEffectDamageShield(int nDamageAmount, int nRandomAmount, int nDamageType)
//	effect SPEffectHeal(int nAmountToHeal)
//	effect SPEffectTemporaryHitpoints(int nHitPoints)
//
///////////////////////////////////////////////////////////////////////////

#include "X2_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "prc_alterations"

// Spell IDs.
const int SPELL_ACID_ORB							= 3100;
const int SPELL_COLD_ORB							= 3101;
const int SPELL_ELECTRIC_ORB						= 3102;
const int SPELL_FIRE_ORB							= 3103;
const int SPELL_SONIC_ORB							= 3104;
const int SPELL_ACID_STORM							= 3106;
const int SPELL_BLAST_OF_FLAME						= 3110;
const int SPELL_BURNING_BOLT						= 3109;
const int SPELL_DISINTEGRATE						= 3111;
const int SPELL_ENERGY_IMMUNITY						= 3113;
const int SPELL_ICE_BURST							= 3105;
const int SPELL_LOWER_SR							= 3126;
const int SPELL_MANTLE_OF_EGREG_MIGHT				= 3112;
const int SPELL_MASS_BULLS_STRENGTH					= 3119;
const int SPELL_MASS_CATS_GRACE						= 3120;
const int SPELL_MASS_EAGLES_SPLENDOR				= 3121;
const int SPELL_MASS_ENDURANCE						= 3122;
const int SPELL_MASS_FOXS_CUNNING					= 3123;
const int SPELL_MASS_HOLD_MONSTER					= 3108;
const int SPELL_MASS_HOLD_PERSON					= 3107;
const int SPELL_MASS_OWLS_WISDOM					= 3124;
const int SPELL_MASS_ULTRAVISION					= 3125;
const int SPELL_SERPENTS_SIGH						= 3127;
const int SPELL_HEROISM								= 3133;
const int SPELL_GREATER_HEROISM						= 3134;
const int SPELL_MASS_CURE_LIGHT						= 3135;
const int SPELL_MASS_CURE_MODERATE					= 3136;
const int SPELL_MASS_CURE_SERIOUS					= 3137;
const int SPELL_MASS_CURE_CRITICAL					= 3138;
const int SPELL_RIGHTEOUS_MIGHT						= 3139;
const int SPELL_RECITATION							= 3140;
const int SPELL_FORCEBLAST							= 3141;
const int SPELL_GLITTERDUST							= 3142;
const int SPELL_MORDENKAINENS_MAGNIFICENT_MANSION	= 3143;
const int SPELL_LESSER_ACID_ORB						= 3144;
const int SPELL_LESSER_COLD_ORB						= 3145;
const int SPELL_LESSER_ELECTRIC_ORB					= 3146;
const int SPELL_LESSER_FIRE_ORB						= 3147;
const int SPELL_LESSER_SONIC_ORB					= 3148;
const int SPELL_BALEFUL_TRANSPOSITION				= 3149;
const int SPELL_BENIGN_TRANSPOSITION				= 3150;
const int SPELL_CONVICTION							= 3151;
const int SPELL_LEGIONS_CONVICTION					= 3152;
const int SPELL_CURSE_OF_IMPENDING_BLADES			= 3153;
const int SPELL_LEGIONS_CURSE_OF_IMPENDING_BLADES	= 3154;
const int SPELL_CURSE_OF_PETTY_FAILING				= 3155;
const int SPELL_LEGIONS_CURSE_OF_PETTY_FAILING		= 3156;
const int SPELL_DIVINE_PROTECTION					= 3157;
const int SPELL_FIREBURST							= 3158;
const int SPELL_GREATER_FIREBURST					= 3159;
const int SPELL_LIONHEART							= 3160;
const int SPELL_LIVING_UNDEATH						= 3161;
const int SPELL_PANACEA								= 3162;
const int SPELL_LEGIONS_SHIELD_OF_FAITH				= 3163;
const int SPELL_SLASHING_DARKNESS					= 3164;
const int SPELL_ANGAZZARS_SCORCHER					= 3165;
const int SPELL_CREATE_MAGIC_TATOO					= 3166;
const int SPELL_FLASHBURST							= 3168;
const int SPELL_FLENSING							= 3169;
const int SPELL_SHADOW_SPRAY						= 3170;
const int SPELL_SNILLOCS_SNOWBALL_SWARM				= 3171;
const int SPELL_BELTYNS_BURNING_BLOOD				= 3172;
const int SPELL_ILYYKURS_MANTLE						= 3173;
const int SPELL_IMPROVED_MAGE_ARMOR					= 3174;
const int SPELL_NYBORS_GENTLE_REMINDER				= 3175;
const int SPELL_NYBORS_STERN_REPROOF				= 3176;
const int SPELL_SINSABURS_BALEFUL_BOLT				= 3177;
const int SPELL_SNILLOCS_SNOWBALL					= 3178;
const int SPELL_SOULSCOUR							= 3179;
const int SPELL_SPHERE_OF_ULTIMATE_DESTRUCTION		= 3180;
const int SPELL_CLARITY_OF_MIND						= 3181;
const int SPELL_MASS_DROWN							= 3182;
const int SPELL_HAIL_OF_STONE						= 3183;
const int SPELL_SPIDERSKIN							= 3184;
const int SPELL_VISCID_GLOB							= 3185;
const int SPELL_WORD_OF_BALANCE						= 3186;
const int SPELL_GREENFIRE							= 3187;




// Coding issues with this one, need a collection of targets for napalm effect.
const int SPELL_LIQUID_FIRE					= 0; 

//const int SPELL_


//
// Time duration methods that are missing from BioWare's code, to do
// minute / level and 10 minute / level spells in scaled time.
//

float MinutesToSeconds(int minutes)
{
	return TurnsToSeconds(minutes);
/*
	// Use HoursToSeconds to figure out how long a scaled minute
	// is and then calculate the number of real seconds based
	// on that.
	float scaledMinute = HoursToSeconds(1) / 60.0;
	float totalMinutes = minutes * scaledMinute;
	
	// Return our scaled duration, but before doing so check to make sure
	// that it is at least as long as a round / level (time scale is in
	// the module properties, it's possible a minute / level could last less
	// time than a round / level !, so make sure they get at least as much
	// time as a round / level.
	float totalRounds = RoundsToSeconds(minutes);
	float result = totalMinutes > totalRounds ? totalMinutes : totalRounds;
	return result;
*/
}

float TenMinutesToSeconds(int tenMinutes)
{
	return TurnsToSeconds(tenMinutes) * 10;
/*
	// Use HoursToSeconds to figure out how long a scaled 10 minute
	// duration is and then calculate the number of real seconds based
	// on that.
	float scaledMinute = HoursToSeconds(1) / 6.0;
	float totalMinutes = tenMinutes * scaledMinute;
	
	// Return our scaled duration, but before doing so check to make sure
	// that it is at least as long as a round / level (time scale is in
	// the module properties, it's possible a 10 minute / level could last less
	// time than a round / level !, so make sure they get at least as much
	// time as a round / level.
	float totalRounds = RoundsToSeconds(tenMinutes);
	float result = totalMinutes > totalRounds ? totalMinutes : totalRounds;
	return result;
*/
}



//
// Wrappers for the PRC stuff in prc_alterations.nss, to keep my scripts somewhat isolated
// just in case it needs to get ripped out or changed.
//

// New function for SR checks to take PRC levels into account.
//		oCaster - caster object.
//		oTargret - target object.
//		fDelay - delay before visual effect is played.
//		automaticCleanup - TRUE if PRCResistSpellEnd() should be called via
//		DelayCommand(), FALSE if the spell script will do it.
int SPResistSpell(object oCaster, object oTarget,int nCasterLevel = 0, float fDelay = 0.0 )
{
//	return MyResistSpell(oCaster, oTarget, fDelay);
	int result = MyPRCResistSpell(oCaster, oTarget,nCasterLevel, fDelay);
	return result;
}

// New function for adjusted save DC's. Seems like this needs more than the caster
// for things like elemental savant. (need spell damage type?)
//		oCaster - caster object.
int SPGetSpellSaveDC(object oCaster = OBJECT_SELF)
{
//	return GetSpellSaveDC();
	return GetSpellSaveDC() + GetChangesToSaveDC(oCaster);
}

// Get altered damage type for energy sub feats.
//		nDamageType - The DAMAGE_TYPE_xxx constant of the damage. All types other
//			than elemental damage types are ignored.
//		oCaster - caster object.
int SPGetElementalDamageType(int nDamageType, object oCaster = OBJECT_SELF)
{
	// Only apply change to elemental damages.
	int nOldDamageType = nDamageType;
	switch (nDamageType)
	{
	case DAMAGE_TYPE_ACID:
	case DAMAGE_TYPE_COLD:
	case DAMAGE_TYPE_ELECTRICAL:
	case DAMAGE_TYPE_FIRE:
	case DAMAGE_TYPE_SONIC:
		nDamageType = ChangedElementalDamage(oCaster, nDamageType);
	}
	
	return nDamageType;
}

// Must be called for all spell effects.  Takes into account passing the extra spell information
// required by the PRC apply effect function, trying to keep this as transparent as possible to
// the spell scripts.
//		nDurationType - DURATION_TYPE_xxx constant for the duration type.
//		eEffect - effect to apply
//		oTarget - object to apply the effect on.
//		fDuration - duration of the effect, only used for some duration types.
//		bDispellable - flag to indicate whether spell is dispellable or not, default TRUE.
//		nSpellID - ID of spell being cast, if -1 GetSpellId() is used.
//		nCasterLevel - effective caster level, if -1 GetCasterLevel() is used.
//		oCaster - caster object.
/*
void SPApplyEffectToObject(int nDurationType, effect eEffect, object oTarget, float fDuration = 0.0f, 
	int bDispellable = TRUE, int nSpellID = -1, int nCasterLevel = -1, object oCaster = OBJECT_SELF)
{
	// PRC pack does not use version 2.0 of Bumpkin's PRC script package, so there is no
	// PRCApplyEffectToObject() method.  So just call the bioware default.
	ApplyEffectToObject(nDurationType, eEffect, oTarget, fDuration);
/*
	// Instant duration effects can use BioWare code, the PRC code doesn't care about those, as
	// well as any non-dispellable effect.
	if (DURATION_TYPE_INSTANT == nDurationType || !bDispellable)
	{
		ApplyEffectToObject(nDurationType, eEffect, oTarget, fDuration);
	}
	else
	{
//		ApplyEffectToObject(nDurationType, eEffect, oTarget, fDuration);
		// We need the extra arguments for the PRC code, get them if defaults were passed in.
		if (-1 == nSpellID) nSpellID = GetSpellId();
		if (-1 == nCasterLevel) nCasterLevel = PRCGetCasterLevel(oCaster);

		// Invoke the PRC apply function passing the extra data.
		PRCApplyEffectToObject(nSpellID, nCasterLevel, oCaster, nDurationType, eEffect, oTarget, fDuration);
	}

}
*/

// This function gets the meta magic int value
int SPGetMetaMagic()
{
	// Get the meta magic value from the engine then let the PRC code override.
	int nMetaMagic = GetMetaMagicFeat();
	// PRC pack does not use version 2.0 of Bumpkin's PRC script package, so there is no
	// PRCGetMetamagic() method.  So just call the bioware default.
	//nMetaMagic = PRCGetMetamagic(nMetaMagic);
	return nMetaMagic;
}

// This function rolls damage and applies metamagic feats to the damage.
//		nDamageType - The DAMAGE_TYPE_xxx constant for the damage, or -1 for no
//			a non-damaging effect.
//		nDice - number of dice to roll.
//		nDieSize - size of dice, i.e. d4, d6, d8, etc.
//		nBonusPerDie - Amount of bonus damage per die.
//		nBonus - Amount of overall bonus damage.
//		nMetaMagic - metamagic constant, if -1 GetMetaMagic() is called.
//		returns - the damage rolled with metamagic applied.
int SPGetMetaMagicDamage(int nDamageType, int nDice, int nDieSize, 
	int nBonusPerDie = 0, int nBonus = 0, int nMetaMagic = -1)
{
	// If the metamagic argument wasn't given get it.
	if (-1 == nMetaMagic) nMetaMagic = SPGetMetaMagic();

	// Roll the damage, applying metamagic.	
	int nDamage = MaximizeOrEmpower(nDieSize, nDice, nMetaMagic, (nBonusPerDie * nDice) + nBonus);
	return nDamage;
}

// This function applies metamagic to a spell's duration, returning the new duration.
//		fDuration - the spell's normal duration.
//		nMetaMagic - metamagic constant, if -1 GetMetaMagic() is called.
float SPGetMetaMagicDuration(float fDuration, int nMetaMagic = -1)
{
	// If the metamagic argument wasn't given get it.
	if (-1 == nMetaMagic) nMetaMagic = SPGetMetaMagic();

	// Apply extend metamagic.
    if (nMetaMagic == METAMAGIC_EXTEND) fDuration *= 2.0;
    return fDuration;
}

// Function to save the school of the currently cast spell in a variable.  This should be
// called at the beginning of the script to set the spell school (passing the school) and
// once at the end of the script (with no arguments) to delete the variable.
//	nSchool - SPELL_SCHOOL_xxx constant to set, if general then the variable is
//		deleted.
void SPSetSchool(int nSchool = SPELL_SCHOOL_GENERAL)
{
	// Remove the last value in case it is there and set the new value if it is NOT general.
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	if (SPELL_SCHOOL_GENERAL != nSchool)
		SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", nSchool);
}

// Function to raise the spell cast at event.
//		oTarget - Target of the spell.
//		bHostile - TRUE if the spell is a hostile act.
//		nSpellID - Spell ID or -1 if GetSpellId() should be used.
//		oCaster - Object doing the casting.
void SPRaiseSpellCastAt(object oTarget, int bHostile = TRUE, int nSpellID = -1, object oCaster = OBJECT_SELF)
{
	if (-1 == nSpellID) nSpellID = GetSpellId();
	
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, bHostile));
}


// Function to return a damage effect.
//		nDamageAmount - Amount of damage to apply.
//		nDamageType - DAMAGE_TYPE_xxx for the type of damage.
//		nDamagePower - DAMAGE_POWER_xxx power rating for the damage.
effect SPEffectDamage(int nDamageAmount, int nDamageType = DAMAGE_TYPE_MAGICAL, 
	int nDamagePower = DAMAGE_POWER_NORMAL)
{
	return EffectDamage(nDamageAmount, nDamageType, nDamagePower);
	// PRC pack does not use version 2.0 of Bumpkin's PRC script package, so there is no
	// EffectPRCDamage() method.  So just call the bioware default.
	//return EffectPRCDamage(nDamageAmount, nDamageType, nDamagePower);
}


// Function to return damage shield effect
//		nDamageAmount - Amount of damage to apply.
//		nRandomAmount - DAMAGE_BONUS_xxx for amount of random bonus damage to apply.
//		nDamageType - DAMAGE_TYPE_xxx for the type of damage.
effect SPEffectDamageShield(int nDamageAmount, int nRandomAmount, int nDamageType)
{
	return EffectDamageShield(nDamageAmount, nRandomAmount, nDamageType);
	// PRC pack does not use version 2.0 of Bumpkin's PRC script package, so there is no
	// EffectPRCDamageShield() method.  So just call the bioware default.
	//return EffectPRCDamageShield(nDamageAmount, nRandomAmount, nDamageType);
}


// Function to return healing effect
//		nAmountToHeal - Amount of damage to heal.
effect SPEffectHeal(int nAmountToHeal)
{
	return EffectHeal(nAmountToHeal);
	// PRC pack does not use version 2.0 of Bumpkin's PRC script package, so there is no
	// EffectPRCHeal() method.  So just call the bioware default.
	//return EffectPRCHeal(nAmountToHeal);
}

// Function to return temporary hit points effect
//		nHitPoints - Number of temp. hit points.
effect SPEffectTemporaryHitpoints(int nHitPoints)
{
	return EffectTemporaryHitpoints(nHitPoints);
	// PRC pack does not use version 2.0 of Bumpkin's PRC script package, so there is no
	// EffectPRCTemporaryHitpoints() method.  So just call the bioware default.
	//return EffectPRCTemporaryHitpoints(nHitPoints);
}


// Sets up all of the AoE's int values, but only if they aren't already set.
// When called in a function nMetamagic should be GetMetamagicFeat(), and nBaseSaveDC should be GetSpellSaveDC()
void SetAllAoEInts(int SpellID, object oAoE, int nBaseSaveDC ,int SpecDispel = 0 , int nCasterLevel = 0)
{
    if(GetLocalInt(oAoE, "X2_AoE_Is_Modified") != 1)
    {

       // I keep making calls to GetAreaOfEffectCreator()
       // I'm not sure if it would be better to just set it one time as an object variable
       // It would certainly be better in terms of number of operations, but I'm not sure
       // if it's as accurate.
       // It's a total of 7 calls, so I figure it doesn't matter that much.  Still, 1 would be better than 7.
       // Also: the 7 calls only happen once per casting of the AoE.
       if ( !nCasterLevel) nCasterLevel = PRCGetCasterLevel(GetAreaOfEffectCreator());

       ActionDoCommand(SetLocalInt(oAoE, "X2_AoE_Caster_Level", nCasterLevel));
       ActionDoCommand(SetLocalInt(oAoE, "X2_AoE_SpellID", SpellID));
       ActionDoCommand(SetLocalInt(oAoE, "X2_AoE_Weave", GetHasFeat(FEAT_SHADOWWEAVE,GetAreaOfEffectCreator())));
      // ActionDoCommand(SetLocalInt(oAoE, "X2_AoE_Save_DC", (nBaseSaveDC + GetChangesToSaveDC(GetAreaOfEffectCreator()))));
      // ActionDoCommand(SetLocalInt(oAoE, "X2_AoE_Modify_Spell_Penetr", ExecuteScriptAndReturnInt("add_spell_penetr", GetAreaOfEffectCreator())));
      // ActionDoCommand(SetLocalInt(oAoE, "X2_AoE_Modify_Elemental_Damage", ChangedElementalDamage(GetAreaOfEffectCreator(), 0)));
      // ActionDoCommand(SetLocalInt(oAoE, "X2_AoE_Store_Metamagic", nMetamagic));
       if (SpecDispel) ActionDoCommand(SetLocalInt(oAoE, "X2_AoE_SpecDispel", SpecDispel));
       ActionDoCommand(SetLocalInt(oAoE, "X2_AoE_Is_Modified", 1));
       

      // The AoE object is deleted after the duration runs out anyway, so I don't
      // think it will be necessary to actually delete these.
    }
    
       SendMessageToPC(GetFirstPC(), "X2_AoE_Caster_Level:"+ IntToString(GetLocalInt(oAoE, "X2_AoE_Caster_Level")));
   SendMessageToPC(GetFirstPC(), "X2_AoE_SpellID:"+ IntToString(GetLocalInt(oAoE, "X2_AoE_SpellID")));
   SendMessageToPC(GetFirstPC(), "X2_AoE_Weave:"+ IntToString(GetLocalInt(oAoE, "X2_AoE_Weave")));
 
}

// Just returns the stored value.
int AoECasterLevel(object oAoE = OBJECT_SELF)
{
   int toReturn = GetLocalInt(oAoE, "X2_AoE_Caster_Level");
   return toReturn;
}
 //::///////////////////////////////////////////////
//:: OnHit Darkfire
//:: x2_s3_darkfire
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

   OnHit Castspell Fire Damage property for the
   flaming weapon spell (x2_s0_flmeweap).

   We need to use this property because we can not
   add random elemental damage to a weapon in any
   other way and implementation should be as close
   as possible to the book.

   Behavior:
   The casterlevel is set as a variable on the
   weapon, so if players leave and rejoin, it
   is lost (and the script will just assume a
   minimal caster level).


*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-17
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin on Dec 4, 2003 for prc stuff - caster level left alone.
//:: altered by motu99 on Apr 7, 2007

#include "prc_alterations"
#include "prc_inc_combat"


// wrapper function (experimental) for GetSpellCastItem()
// This function should eventually be moved to prc_inc_spells.nss

// Note that we are giving preference for the local object "PRC-SPELLCASTITEM_OVERRIDE"
// therefore it is absolutely essential, in order to have this variable not interfere with "normal" spell casting
// to delete it immediately after the spell script executed

// another possibility is to give preference to the GetSpellCastItem() call and only use the local object "PRC_SPELLCASTITEM_OVERRIDE"
// when GetSpellCastItem() returns an invalid object. This is how it is done in prc_onhitcast.nss (lines 58-61)

// Note also, that if you cast a spell with an Action Command (="normal" spellcasting), you never know whether there
// are other spell cast actions in the action queue before this script executes.
// So if the wrapper-function PRCGetSpellCastItem prefers the local object "PRC_SPELLCASTITEM_OVERRIDE",
// don't set this variable for a spell you wan't to cast as an action! (or change the preference as it is done in prc_onhitcast.nss)

object PRCGetSpellCastItem()
{
	object oItem = GetLocalObject(OBJECT_SELF, "PRC_SPELLCASTITEM_OVERRIDE");
	if (!GetIsObjectValid(oItem))
		oItem = GetSpellCastItem();

	return oItem;
}


void main()
{
	//string toSay =  " Self: " + GetTag(OBJECT_SELF) + " Item: " + GetTag(GetSpellCastItem());
	//SendMessageToPC(OBJECT_SELF, toSay);
	//  GetTag(OBJECT_SELF) was nothing, just ""  and the SendMessageToPC sent the message to my player.
	//  It's funny because I thought player characters had tags :-?  So who knows what to make of it?

	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

	object oWeapon = PRCGetSpellCastItem();
		
	// eventually the check for the local object "PRC_SPELL_TARGET_OBJECT_OVERRIDE" should be moved to PRCGetSpellTargetObject()
	// but as long as we are experimenting, let it remain here
	object oTarget = GetLocalObject(OBJECT_SELF, "PRC_SPELL_TARGET_OBJECT_OVERRIDE");
	if (!GetIsObjectValid(oTarget))
		oTarget = PRCGetSpellTargetObject();
	

	if (GetIsObjectValid(oWeapon) && GetIsObjectValid(oTarget) && !GetIsDead(oTarget))
	{
		// ugly workaround, in order to have the aurora engine to execute *all* onhitcast spells on the weapon.
		// so far Aurora only seems to execute the first onhitcast spell, forgetting about all others
		// the following code, if inserted into *every* impact spell script used by aurora, will cycle through all onhitcast spells on the weapon
		// this is still experimental; it is dangerous because it could result in an infinite recursive call sequence, if the local int "ApplyOnHitSpell" is screwed up
		int bStack = GetPRCSwitch(PRC_FLAMEWEAPON_DARKFIRE_STACK);
		if (bStack && !GetLocalInt(oWeapon, "ApplyOnHitSpell"))
		{
//DoDebug("x2_s3_darkfire: preparing to apply all on hit spells stored on "+GetName(oWeapon));
			SetLocalInt(oWeapon, "ApplyOnHitSpell", TRUE);
			ApplyAllOnHitCastSpells(oTarget, oWeapon, OBJECT_SELF);
			DeleteLocalInt(oWeapon, "ApplyOnHitSpell");
//DoDebug("x2_s3_darkfire: finished applying all on hit spells stored on "+GetName(oWeapon));
		}
		else
		{
			// motu99: added differentiation between darkfire and flame weapon damage
			int nDamageType = GetLocalInt(oWeapon, "X2_Wep_Dam_Type_DF");

			int nAppearanceTypeS = VFX_IMP_FLAME_S;
			int nAppearanceTypeM = VFX_IMP_FLAME_M;

			switch(nDamageType)
			{
				case DAMAGE_TYPE_ACID: nAppearanceTypeS = VFX_IMP_ACID_S; nAppearanceTypeM = VFX_IMP_ACID_L; break;
				case DAMAGE_TYPE_COLD: nAppearanceTypeS = VFX_IMP_FROST_S; nAppearanceTypeM = VFX_IMP_FROST_L; break;
				case DAMAGE_TYPE_ELECTRICAL: nAppearanceTypeS = VFX_IMP_LIGHTNING_S; nAppearanceTypeM =VFX_IMP_LIGHTNING_M;break;
				case DAMAGE_TYPE_SONIC: nAppearanceTypeS = VFX_IMP_SONIC; nAppearanceTypeM = VFX_IMP_SONIC; break;
			}

			// Get Caster Level
			// motu99: added differentiation between darkfire and flame weapon damage
			int nLevel = GetLocalInt(oWeapon, "X2_Wep_Caster_Lvl_DF");
			// assume minimum level, if level not found

			if (DEBUG) DoDebug("x2_s3_darkfire: on hit cast with weapon "+GetName(oWeapon)+", caster level = "+IntToString(nLevel));

			if (!nLevel) nLevel = 5;

			nLevel /= 2;

			// motu99: maximum was missing (and badly implemented in x2_s0_enhweap) ; put it on a switch!
			int iLimit = GetPRCSwitch(PRC_DARKFIRE_DAMAGE_MAX);
			if (iLimit && nLevel > iLimit)	nLevel = iLimit;

			int nDmg = d6() + nLevel;
// DoDebug("x2_s3_darkfire: damage (1d6 + "+IntToString(nLevel)+") = "+IntToString(nDmg));
			effect eDmg = EffectDamage(nDmg,nDamageType);
			effect eVis;
			if (nDmg<10) // if we are doing below 12 point of damage, use small flame
			{
				eVis =EffectVisualEffect(nAppearanceTypeS);
			}
			else
			{
				eVis =EffectVisualEffect(nAppearanceTypeM);
			}
			eDmg = EffectLinkEffects (eVis, eDmg);
// DoDebug("x2_s3_darkfire: applying damage to target "+GetName(oTarget));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
		}
	}
	else
	{
//DoDebug("x2_s3_darkfire: invalid weapon ("+GetName(oWeapon)+") or invalid/dead target ("+GetName(oTarget)+")");
	}

	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

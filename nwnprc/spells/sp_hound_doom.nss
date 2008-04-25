///////////////////////////////////////////////////
//:: Name      Hound of Doom
//:: FileName  sp_hound_doom.nss
//////////////////////////////////////////////////
/**@file Hound of Doom
Illusion (Shadow)
Level: Hexblade 3
Components: V,S
Casting Time: 1 round
Range: Close
Duration: 1 minute/level (D) or until destroyed
Saving Throw: None
Spell Resistance: No

You shape the essence of the Plane of Shadow to 
create a powerful doglike companion that serves you
for the duration of the spell.  The hound of doom has 
the statistics of a dire wolf with the following 
adjustments: It gains a deflection bonus to Armor 
Class equal to your Charisma bonus, it's hit points
when created are equal to you fill normal hit points,
and it uses your base attack bonus instad of its own
(adding its +7 bonus from Strength and -1 penalty from
size as normal).

You can command a hound of doom as a move action just
as if it were fully trained to perform all the tricks
listed in the Handle Animal skill.

If a hound of doom's hit points are reduced to 0, it is
destroyed.  A hound of doom is treated as a magical
beast for the purpose of spells and effects, but it can
also be dispelled.  You can only have one hound of doom
in existence at a time.  If you cast a second hound of 
doom spell while the first is still active, the first
hound is instantly dispelled.
**/

///////////////////////////////////////////////////////
//:: Author: Tenjac
//:: Date:   8.9.2006 
///////////////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_ILLUSION);
	
	object oPC = OBJECT_SELF;
	location lLoc = GetSpellTargetLocation();
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = (60.0f * nCasterLvl);
	
	if(nMetaMagic == METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
	
	effect eSummon = EffectSummonCreature("PRC_Hound_Doom", VFX_NONE, 0.0f);
	
	int i = 1;
	object oTest = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
		
	while(GetIsObjectValid(oTest))
	{
		if (GetTag(oTest) == ("PRC_Hound_Doom"))
		{
			DestroyObject(oTest);
			break;
		}	
		
		i += 1;
		oTest = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);				
	}
	
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lLoc, fDur);
	
	int n = 1;
	object oHound = GetObjectByTag("PRC_Hound_Doom", n);
	
	while (GetIsObjectValid(oHound))
	{
		if (GetMaster(oHound) == oPC)
		{
			break;
		}
		
		n++;
		oHound = GetObjectByTag("PRC_Hound_Doom", n);
	}
	
	effect eVis = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
	effect eBuff = EffectACIncrease(GetAbilityModifier(ABILITY_CHARISMA, oPC), AC_DEFLECTION_BONUS);
	       eBuff = EffectLinkEffects(eBuff, EffectTemporaryHitpoints(max(0,GetCurrentHitPoints(oPC) - GetCurrentHitPoints(oHound))));	
	       eBuff = EffectLinkEffects(eBuff, eVis);
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oHound, fDur);
	
	SetBaseAttackBonus(GetBaseAttackBonus(oPC), oHound);
	
	PRCSetSchool();
}
	

	
	
//::///////////////////////////////////////////////
//:: Name      Amber Sarcophagus
//:: FileName  sp_amber_sarc.nss
//:://////////////////////////////////////////////
/**@file Amber Sarcophagus
Evocation
Level: Sorcerer/wizard 7
Components: V,S,M
Casting Time: 1 standard action
Range: Close
Target: One creature
Duration: 1 day/level
Saving Throw: None
Spell Resistance: Yes

You infuse an amber sphere with magical power and
hurl it toward the target.  If you succeed on a
ranged touch attack, the amber strikes the target
and envelops it in coruscating energy that hardens
immediately, trapping the target within a 
translucent, immobile amber shell.  The target is
perfectly preserved and held in stasis, unharmed
yet unable to take any actions.  Within the amber
sarcophagus, the target is protected against all
attacks, including purely mental ones.

The amber sarcophagus has hardness 5 and 10hp per
caster level(maximum 200hp). If it is reduced to
0 hp, it shatters and crumbles to worhless amber
dust, at which point the target is released from
stasis (although it is flat footed until next 
turn).  Left alone, the amber sarcophagus traps
the target for the duration of the spell, then 
disappears before releasing the target from 
captive stasis.

Material Component: An amber sphere worth at 
least 500 gp.

Author:    Tenjac
Created:   6/19/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void SarcMonitor(object oTarget, object oPC, int nNormHP);
void RemoveSarc(object oTarget, object oPC, object oCopy);

#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_EVOCATION);
			
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	float fDur = HoursToSeconds(24 * nCasterLvl);
		
	if(nMetaMagic == METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
		
	SPRaiseSpellCastAt(oTarget,TRUE, SPELL_AMBER_SARCOPHAGUS, oPC);
	
	//Make touch attack
	int nTouch = PRCDoRangedTouchAttack(oTarget);
		
	if(nTouch)
	{
		//Sphere VFX		
		
		if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
		{
			//Apply effects
			effect eSarc = EffectLinkEffects(EffectCutsceneGhost(), EffectCutsceneParalyze());
			       eSarc = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), eSarc);
			     //eSarc = EffectVisualEffect(VFX_DUR_AMBER_SARCOPHAGUS));			
			
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSarc, oTarget, fDur);
			
			//swap out the target
			object oCopy = CopyObject(oTarget, GetLocation(oTarget));
			
			RemoveEffect(oCopy, eSarc);
			
			//Apply VFX
			//SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_AMBER_SARCOPHAGUS), oCopy, fDur);
						
			//Paralyze
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectParalyze(), oCopy, fDur);
			
			int nNormHP = GetCurrentHitPoints(oCopy);
			
			//Add 200 temp HP
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitPoints(10 * min(20, nCasterLvl)), oCopy, fDur);
			
			SarcMonitor(oCopy, oPC, oTarget, nNormHP);
		}
	}
	SPSetSchool();
}

void SarcMonitor(object oCopy, object oPC, object oTarget, int nNormHP)
{
	int nHP = GetCurrentHitPoints(oCopy);
	int bRemove = FALSE;
		
	while(bRemove == FALSE)
	{
		if(nHP <= nNormHP)
		{
			bRemove = TRUE;
			RemoveSarc(oCopy, oPC);
		}
	}
}

void RemoveSarc(object oCopy, object oTarget)
{
	effect eTest = GetFirstEffect(oTarget);
	
	while(GetIsEffectValid(eTest))
	{
		if(GetEffectSpellId(eTest) == SPELL_AMBER_SARCOPHAGUS)
		{
			if(GetEffectCreator(eTest) == oPC)
			{
				RemoveEffect(oTarget, eTest)
			}
		}
		eTest = GetNextEffect(oTarget);
	}
}

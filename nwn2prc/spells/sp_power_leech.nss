//::///////////////////////////////////////////////
//:: Name:      Power Leech
//:: Filename:  sp_power_leech.nss
//::///////////////////////////////////////////////
/**@file Power Leech
Necromancy [Evil] 
Level: Corrupt 5 
Components: V, S, Corrupt 
Casting Time: 1 action 
Range: Medium (100 ft. + 10 ft./level)
Target: One living creature 
Duration: 1 round/level 
Saving Throw: Will negates 
Spell Resistance: Yes

The caster creates a conduit of evil energy between
himself and another creature. Through the conduit,
the caster can leech off ability score points at
the rate of 1 point per round. The other creature
takes 1 point of drain from an ability score of
the caster's choosing, and the caster gains a +1
enhancement bonus to the same ability score per
point drained during the casting of this spell.
In other words, all points drained during this 
spell stack with each other to determine the
enhancement bonus, but they don't stack with
other castings of power leech or with other
enhancement bonuses.

The enhancement bonus lasts for 10 minutes per 
caster level. 

Corruption Cost: 1 point of Wisdom drain.


@author Written By: Tenjac
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
#include "spinc_common"
#include "inc_dynconv"

void main()
{
	
	SPSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	//Spellhook
	if (!X2PreSpellCastCode()) return;
	
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nAbility;
	int nSpell = GetSpellId();
	int nRoundCounter = nCasterLvl;
	float fRemove = (nCasterLvl * 600.0f);
	effect eDur  = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	
	SPRaiseSpellCastAt(oTarget, TRUE, SPELL_POWER_LEECH, oPC);
	
	//Check for Extend
	if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
	{
		fRemove = (fRemove * 2);
	}
	
	//Set float
	SetLocalFloat(oPC, "PRC_Power_Leech_fDur", fRemove);
	
	//Set counter int
	SetLocalInt(oPC, "PRC_Power_Leech_Counter", nRoundCounter);
	
	//Set target as local object
	SetLocalObject(oPC, "PRC_PowerLeechTarget", oTarget);
	
	//Clear actions for the convo
		ClearAllActions(TRUE);
		
	//Check for ability to drain
		
	/*  <Stratovarius> That would be easiest to do as a convo I think
            <Stratovarius> just steal the animal affinity one from psionics and modify*/
		
	StartDynamicConversation("power_leech", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);
						
	//Corruption Cost
	{
		DelayCommand(fRemove, DoCorruptionCost(oPC, ABILITY_WISDOM, 1, 1));
	}
	
	SPEvilShift(oPC);
	
	SPSetSchool();
}
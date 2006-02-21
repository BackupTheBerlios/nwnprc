//::///////////////////////////////////////////////
//:: Name      Command Undead
//:: FileName  sp_comm_undead.nss
//:://////////////////////////////////////////////
/**@file Command Undead
Necromancy
Level: Sor/Wiz 2
Components: V, S, M
Casting Time: 1 action
Range: Close (25 ft. + 5 ft/2 levels)
Targets: 1 undead creature
Duration: 1 day/level
Saving Throw: See text
Spell Resistance: Yes
 
This spell allows you some degree of control over an 
undead creature. Assuming the subject is intelligent,
it perceives your words and actions in the most 
favorable way (treat its attitude as friendly). It 
will not attack you while the spell lasts. You can 
try to give the subject orders, but you must win an 
opposed Charisma check to convince it to do anything 
it wouldn’t ordinarily do. (Retries are not allowed.)
An intelligent commanded undead never obeys suicidal
or obviously harmful orders, but it might be convinced 
that something very dangerous is worth doing.

A nonintelligent undead creature gets no saving throw 
against this spell. When you control a mindless being,
you can communicate only basic commands. Nonintelligent
undead won’t resist suicidal or obviously harmful orders.

Any act by you or your apparent allies that threatens 
the commanded undead (regardless of its Intelligence)
breaks the spell.

Your commands are not telepathic. The undead creature 
must be able to hear you.

Material Components: A shred of raw meat and a splinter 
of bone.

Author:    Tenjac
Created:   02/21/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"
#include "prc_inc_spells"

void main()
{
	SPSetSchool(SPELL_SCHOOL_CONJURATION);
	
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	//Define vars
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	effect eCharm = EffectCharmed();
	effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eDom = EfffectDominated();
	
	float fDuration = HoursToSeconds(24 * nCasterLvl);
	
	//Link charm and persistant VFX
	effect eLink = EffectLinkEffects(eVis, eCharm);
	eLink = EffectLinkEffects(eLink, eDur);
	eLink = SupernaturalEffect(eLink);
	
	//Link domination and persistant VFX
	effect eLink2 = EffectLinkEffects(eVis, eDom);
	eLink2 = EffectLinkEffects(eLink2, eDur);
	eLink2 = SupernaturalEffect(eLink2);
	
	SPRaiseSpellCastAt(oTarget, TRUE, SPELL_COMMAND_UNDEAD, oPC);
	
	//Undead
	if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
	{
		//Check Spell Resistance
		if (!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
		{
			//Dominate mindless
			if(GetAbilityScore(ABILITY_INTELLIGENCE, oTarget) < 11)
			
			{
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, fDuration);
			}
			
			else(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE, oPC, 1.0))
			{
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			}
		}
	}
	SPSetSchool();
}
				
				
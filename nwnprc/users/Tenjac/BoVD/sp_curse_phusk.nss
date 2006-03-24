//::///////////////////////////////////////////////
//:: Name      Curse of the Putrid Husk
//:: FileName  sp_curse_phusk.nss
//:://////////////////////////////////////////////
/**@file Curse of the Putrid Husk
Illusion (Phantasm) [Fear, Mind Affecting, Evil]
Level: Brd 3, Sor/Wiz 3
Components: V, S, M
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One creature
Duration: 1 round + 1d10 minutes
Saving Throw: Will negates
Spell Resistance: Yes
 
This illusion forces the subject to believe his flesh
is rotting and falling off his body, and that his 
internal organs are spilling out. If the target fails 
his saving throw, he is dazed (and horrified) for 1 
round. On the following round, he falls unconscious 
for 1d10 minutes, during which time he cannot be roused
normally. 

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void PassOut(object oTarget)
{
	effect eBlind = EffectBlindness();
	effect eDeaf = EffectDeaf();
	effect eLink2 = EffectLinkEffects(eBlind, eDeaf);
	float fDur = (d10(1) * 60.0f);
	
	//Blind/deaf
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, (fDur - 1.0f));
	
	//Clear all actions
	AssignCommand(oTarget, ClearAllActions());
	
	//Animation		
	PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, fDur);
	
	//Make them sit and wait. 
	DelayCommand(0.2,SetCommandable(FALSE, oTarget));
	
	//Restore Control
	DelayCommand((fDur - 0.2), SetCommandable(TRUE, oTarget));
}

void main()
{
	SPSetSchool(SPELL_SCHOOL_ILLUSION);
	
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	//define vars
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	effect eLink = EffectLinkEffects(EffectDazed, EffectFrightened);
	       eLink = EffectLinkEffects(eLink,EffectVisualEffect(VFX_IMP_DAZED_S));
	       eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR));
	
	
	SPRaiseSpellCastAt(oTarget, TRUE, SPELL_CURSE_OF_THE_PUTRID_HUSK, oPC);
	
	
	//Check Spell Resistance
	if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
	{
		//Will save
		if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
		{
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0f);
			
			DelayCommand(6.0f, PassOut(oTarget));
		}
	}
	
	SPEvilShift(oPC);
	
	SPSetSchool();
}
	
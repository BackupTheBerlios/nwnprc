//::///////////////////////////////////////////////
//:: Name      Clutch of Orcus
//:: FileName  sp_clutch_orcus.nss
//:://////////////////////////////////////////////
/**@file Clutch of Orcus
Necromancy [Evil] 
Level: Clr 3 
Components: V, S 
Casting Time: 1 action 
Range: Medium (100 ft. + 10 ft./level)
Target: One humanoid
Duration: Concentration (see text) 
Saving Throw: Fortitude  negates (see text)
Spell Resistance: Yes

The caster creates a magical force that grips the
subject's heart (or similar vital organ) and 
begins crushing it. The victim is paralyzed 
(as if having a heart attack) and takes 1d3 points
of damage per round.

Each round, the caster must concentrate to 
maintain the spell. In addition, a conscious
victim gains a new saving throw each round to stop
the spell. If the victim dies as a result of this 
spell, his chest ruptures and bursts, and his 
smoking heart appears in the caster's hand.

Author:    Tenjac
Created:   3/28/05
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void CrushLoop(object oTarget, object oPC, int bEndSpell)
{
	//Conc check
	if(GetBreakConcentrationCheck(oPC))
	{
		bEndSpell = TRUE;
	}
	
	//if makes save, abort
	if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
	{
		bEndSpell = TRUE;
	}
	
	//if Conc and failed save...
	if(bEndSpell = FALSE)
	{
		//Paral
		effect ePar = EffectParalyze();
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePar, oTarget, 6.0f);
		
		//damage
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_MAGICAL, d3(1)), oTarget);
		
		DelayCommand(6.0f, CrushLoop(oTarget, oPC, bEndSpell));
	}
}	
	
}
void main()
{	
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	object oPC = OBJECT_SELF;
	object oTarget= GetSpellTargetObject();
	int bEndSpell = FALSE;
	
	SPRaiseSpellCastAt(oTarget, TRUE, SPELL_CLUTCH_OF_ORCUS, oPC);
	
	//Check spell resistance
	if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
	{
		//start loop
		CrushLoop(oTarget, oPC, bEndSpell);
	}
	
	SPEvilShift(oPC);
	SPSetSchool();
}
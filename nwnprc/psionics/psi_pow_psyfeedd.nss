/*
   ----------------
   Psychofeedback, Dexterity
   
   prc_pow_psyfeed
   ----------------

   18/5/05 by Stratovarius

   Class: Psion (Egoist), PsyWar
   Power Level: 5
   Range: Personal
   Target: Self
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 9
   
   You can readjust your body to boost a physical ability score at the expense of another score. You can burn your ability score down
   as far as you choose, but if the score reaches 0, you will die from it. This burn is only removed by natural resting, it cannot be
   removed by magical means.
   
   Usage: Select the stat to drain by choosing mental or physical, then 1, 2 or 3. Choose how much you wish to boost/drain the stat 
   by pressing the radial feat a number of times equal to that (it counts up). Then depress the stat you wish to boost (Str, Dex, or
   Con) to cast the power. 
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 0);

/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
    	int nCaster = GetManifesterLevel(oCaster);
    	effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    	effect eVis2 = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	int nDur = nCaster;
	if (nMetaPsi == 2)	nDur *= 2;
	
	int nStatNum = GetLocalInt(oCaster, "PsychoBurnStat");
	int nStatType = GetLocalInt(oCaster, "PsychoBurnMP");
	int nBurn = GetLocalInt(oCaster, "PsychoBurnNum");
	int nAbil;
	
	if (nStatType == 1 && nStatNum == 1) nAbil = ABILITY_STRENGTH;
	if (nStatType == 1 && nStatNum == 2) nAbil = ABILITY_DEXTERITY;
	if (nStatType == 1 && nStatNum == 3) nAbil = ABILITY_CONSTITUTION;
	if (nStatType == 2 && nStatNum == 1) nAbil = ABILITY_INTELLIGENCE;
	if (nStatType == 2 && nStatNum == 2) nAbil = ABILITY_WISDOM;
	if (nStatType == 2 && nStatNum == 3) nAbil = ABILITY_CHARISMA;
	
	ApplyAbilityDamage(oTarget, nAbil, nBurn, DURATION_TYPE_PERMANENT);
        effect eStr = EffectAbilityIncrease(ABILITY_DEXTERITY,nBurn);
    	effect eLink = EffectLinkEffects(eStr, eDur);

	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
    }
}
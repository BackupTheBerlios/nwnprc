/*
   ----------------
   Second Chance
   
   prc_pow_2ndchnc
   ----------------

   16/7/05 by Stratovarius

   Class: Psion (Seer)
   Power Level: 5
   Range: Personal
   Target: Self
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 9
   
   You take a hand in influencing the probable outcomes of your immediate environment. You see the many alternative branches that 
   reality could take in the next few seconds, and with this foreknowledge you gain the ability to reroll the first failed saving throw
   each round. You must take the result of the reroll, even if it’s worse than the original roll. (Because of Bioware Hardcoding, this
   will not work on reflex saves vs damage dealing spells).
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
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);         
    
    if (nMetaPsi > 0) 
    {
    	int nCaster = GetManifesterLevel(oCaster);
    	int nDur = nCaster;
	if (nMetaPsi == 2)	nDur *= 2;     	
	
    	effect eDur = EffectVisualEffect(VFX_DUR_SPELLTURNING);
    	
	SetLocalInt(oTarget, "SecondChance", TRUE);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
	DelayCommand(RoundsToSeconds(nDur), DeleteLocalInt(oTarget, "SecondChance"));
    }
}
/*
   ----------------
   Psychofeedback
   
   psi_pow_psyfeed
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
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"
#include "inc_dynconv"

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
    object oTarget = PRCGetSpellTargetObject();
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
	int nCaster = GetManifesterLevel(oCaster);
	int nDur = nCaster;
	
	if (nMetaPsi == 2) nDur *= 2;
	SetLocalFloat(oCaster, "PsychoFeedDuration", RoundsToSeconds(nDur));
	SetLocalInt(oCaster, "PsychoFeedManifesterLevel", nCaster);
	
	StartDynamicConversation("psi_psychofeed", oCaster, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oCaster);
    }
}
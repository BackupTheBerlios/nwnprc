/*
   ----------------
   Psychic Reformation
   
   prc_pow_psyref
   ----------------

   25/3/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 4
   Range: Personal
   Target: Self
   Duration: Instant
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 7
   
   You delevel yourself down to level 1, and then back up to your current level, allowing you to repick all feats, powers, 
   and skill assignments from those levels. You lose XP equal to 50 times the number of levels changed. A level 11 using
   this power would pay a cost of 500 XP. This XP loss can cause you to be deleveled.
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
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
        int nHD = GetHitDice(oCaster);
        int nXP = (GetXP(oCaster) - (50 * nHD - 1));
        SetXP(oCaster,1);
        DelayCommand(1.0, SetXP(oCaster,nXP));
    }
}
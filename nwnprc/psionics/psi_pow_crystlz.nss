/*
    ----------------
    Crystallize
    
    psi_psi_crystlz
    ----------------

    25/10/04 by Stratovarius

    Class: Psion (Shaper)
    Power Level: 6
    Range: Medium
    Target: One Creature
    Duration: Permanent
    Saving Throw: Fortitude negates
    Power Resistance: Yes
    Power Point Cost: 11
 
    You seed the subject's flesh with super-saturated crystal. In an eyeblink, the subjects
    form seems to freeze over, as its flesh and fuilds are instantly crystallized. This has 
    the effect of petrifying the target permanently. 
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 1);

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
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, METAPSIONIC_TWIN, 0);
    
    if (nMetaPsi > 0) 
    {
        int nDC = GetManifesterDC(oCaster);
        int nCaster = GetManifesterLevel(oCaster);
        int nPen = GetPsiPenetration(oCaster);

        //Check for Power Resistance
        if (PRCMyResistPower(oCaster, oTarget, nPen))
        {

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //use bioware petrify effect instead
            //that works better for henchmen, DMs, etc
            //as well as not petrifying undead, constructs, etc
            //and putting all petrification code in one place, so builder hooks can work
            DoPetrification(nCaster, oCaster, oTarget, GetSpellId(), nDC);

            /*
            if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH))
            {
                //SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectPetrify(), oTarget);
            }
            */
        }
    }
}
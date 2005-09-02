/*
   ----------------
   Ectoplasmic Form
   
   prc_pow_ectoform
   ----------------

   14/5/05 by Stratovarius

   Class: Psion (Egoist), PsyWar
   Power Level: 3
   Range: Personal
   Target: Self
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 5
   
   You and all your gear become a partially translucent rippling mass of ectoplasm in your general shape. You gain damage reduction
   10/+2, and immunity to poison, critical hits, and sneak attacks. You lose all AC from your shield and armour, and cannot physically
   attack a target. You can manifest powers, but must make a Concentration check at a DC of 20 + Power Level. 
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

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
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);

    if (nMetaPsi > 0)
    {
        int nCaster = GetManifesterLevel(oCaster);
        float fDur = (nCaster * 60.0);
        if (nMetaPsi == 2)	fDur *= 2;

        //Massive effect linkage, go me
        effect eCrit = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
        effect eSneak = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
        effect ePoison = EffectImmunity(IMMUNITY_TYPE_POISON);
        effect eDR = EffectDamageReduction(10, DAMAGE_POWER_PLUS_TWO);

        effect eVis1 = EffectVisualEffect(VFX_DUR_BLUR);
        effect eVis2 = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);

        effect eLink = EffectLinkEffects(eCrit, eSneak);
        eLink = EffectLinkEffects(eLink, ePoison);
        eLink = EffectLinkEffects(eLink, eDR);
        eLink = EffectLinkEffects(eLink, eVis1);

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,TRUE,-1,nCaster);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        SetLocalInt(oTarget, "EctoForm", TRUE);
        DelayCommand(fDur, DeleteLocalInt(oTarget, "EctoForm"));
    }
}
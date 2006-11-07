/*
   ----------------
   Moment of Prescience, Psionic

   psi_pow_mmntpre
   ----------------

   25/3/05 by Stratovarius
*/ /** @file

    Moment of Prescience, Psionic

    Clairsentience
    Level: Psion/wilder 7
    Manifesting Time: 1 swift action
    Range: Personal
    Target: You
    Duration: 1 round
    Power Points: 13
    Metapsionics: Extend

    You add a bonus equal to your manifester level (max +25) to attack, armour
    class, saves, or skills for the duration of the power.

    Manifesting the power is a swift action, like manifesting a quickened power,
    and it counts toward the normal limit of one quickened power per round.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

void main()
{
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

    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        int nBonus      = max(manif.nManifesterLevel, 25);
        effect eLink    = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);
        float fDuration = 6.0f;
        if(manif.bExtend) fDuration *= 2;

        switch(manif.nSpellID)
        {
            case POWER_MOMENTOFPRESCIENCEATTACK:
                eLink = EffectLinkEffects(eLink, EffectAttackIncrease(nBonus));
                break;
            case POWER_MOMENTOFPRESCIENCEARMOUR:
                eLink = EffectLinkEffects(eLink, EffectACIncrease(nBonus));
                break;
            case POWER_MOMENTOFPRESCIENCESAVES:
                eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus));
                break;
            case POWER_MOMENTOFPRESCIENCESKILLS:
                eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_ALL_SKILLS, nBonus));
                break;

            default:{
                string sErr = "psi_pow_mmntpre: ERROR: Unknown spellID: " + IntToString(manif.nSpellID);
                if(DEBUG) DoDebug(sErr);
                else      WriteTimestampedLogEntry(sErr);
            }
        }

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
    }
}

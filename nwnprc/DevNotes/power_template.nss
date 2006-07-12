/*
    <SCRIPT NAME>

    <DESCRIPTION>

    By:
    Created:
    Modified:

    <EXTRA NOTES>

    <BEGIN NOTES TO SCRIPTER - MAY BE DELETED LATER>
    Modify as necessary
    Most code should be put in DoSpell()

    PRC_SPELL_EVENT_ATTACK is set when a
        touch or ranged attack is used
    <END NOTES TO SCRIPTER>
*/


#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "spinc_common"

#include "prc_sp_func"

int DoPower(object oManifester, object oTarget, struct manifestation manif)
{
    int nPen          = GetPsiPenetration(oManifester);
    int nDamage, nTouchAttack;
    int bHit = 0;

    // Let the AI know
    SPRaiseSpellCastAt(oTarget, TRUE, manif.nSpellID, oManifester);

    // Handle Twin Power
    int nRepeats = manif.bTwin ? 2 : 1;
    for(; nRepeats > 0; nRepeats--)
    {
        // Perform the Touch Attach
        nTouchAttack = PRCDoMeleeTouchAttack(oTarget);
        if(nTouchAttack > 0)
        {
            bHit = 1;
            // Roll against SR
            if(PRCMyResistPower(oManifester, oTarget, nPen))
            {


            }// end if - SR check
        }// end if - Touch attack hit
    }// end for - Twin Power

    return bHit;    //Held charge is used if at least 1 touch from twinned power hits
}

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

    struct manifestation manif;

    int nEvent = GetLocalInt(oManifester, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        manif =
            EvaluateManifestation(oManifester, oTarget,
                                  PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                           1, PRC_UNLIMITED_AUGMENTATION
                                                           ),
                                  METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                                  );


        if(manif.bCanManifest)
        {
            if(GetLocalInt(oManifester, PRC_SPELL_HOLD) && oManifester == oTarget)
            {   //holding the charge, manifesting power on self
                SetLocalSpellVariables(oManifester, 1);   //change 1 to number of charges
                return;
            }
            SetLocalManifestation(oManifester, PRC_POWER_HOLD_MANIFESTATION, manif);
            DoPower(oManifester, oTarget, manif);
        }// end if - Successfull manifestation
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            manif = GetLocalManifestation(oManifester, PRC_POWER_HOLD_MANIFESTATION);
            if(DoPower(oManifester, oTarget, manif))
                DecrementSpellCharges(oManifester);
        }
    }
}

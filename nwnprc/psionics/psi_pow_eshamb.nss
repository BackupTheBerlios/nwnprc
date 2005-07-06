/*
   ----------------
   Ectoplasmic Shambler, On Exit
   
   prc_pow_eshamb
   ----------------

   23/2/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 5
   Range: Long
   Area: Colossal
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 9
   
   You fashion an ephemeral mass of psedu-living ectoplasm called an ectoplasmic shambler. Anything caught within the shambler
   is blinded, and takes 1 point of damage for every 2 manifester levels of the caster.
*/   

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

void main()
{
    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(POWER_ECTOSHAMBLER, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                if(GetEffectType(eAOE) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
                {
                    //If the effect was created by the Acid_Fog then remove it
                    if(GetEffectSpellId(eAOE) == POWER_ECTOSHAMBLER)
                    {
                        RemoveEffect(oTarget, eAOE);
                        DeleteLocalInt(oTarget, "EShamConc");
                        bValid = TRUE;
                    }
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}


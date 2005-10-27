//:://////////////////////////////////////////////
//:: Feat: Wild Talent
//:: psi_wild_talent
//:://////////////////////////////////////////////
/** @file
    Called from EvalPRCFeats. Adds Psionic Focus
    as bonus feat if it's missing.

    @author Ornedan
    @date   Created - 2005.10.27
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;

    if(GetHasFeat(FEAT_WILD_TALENT, oPC) && !GetHasFeat(FEAT_PSIONIC_FOCUS, oPC))
        IPSafeAddItemProperty(GetPCSkin(oPC), ItemPropertyBonusFeat(IP_CONST_FEAT_PSIONIC_FOCUS),
                              0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
}
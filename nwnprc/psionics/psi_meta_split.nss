//::///////////////////////////////////////////////
//:: Split Psionic Ray switch
//:: psi_meta_split
//::///////////////////////////////////////////////
/*
    Switches the metapsionic feat Split Psionic Ray on or off.
*/
//:://////////////////////////////////////////////
//:: Modified By: Ornedan
//:: Modified On: 25.03.2005
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;

    // Can't activate too many feats
    if(!GetLocalInt(oPC, "PsiMetaSplit") &&
       GetPsionicFocusUsingFeatsActive(oPC) >= GetPsionicFocusUsesPerExpenditure(oPC))
    {
        FloatingTextStringOnCreature(GetStringByStrRef(16826549/*You already have the maximum amount of psionic focus expending feats active.*/), oPC, FALSE);
        return;
    }

    SetLocalInt(oPC, "PsiMetaSplit", !GetLocalInt(oPC, "PsiMetaSplit"));
    FloatingTextStringOnCreature(GetStringByStrRef(16826540) + " " + (GetLocalInt(oPC, "PsiMetaSplit") ? GetStringByStrRef(63798/*Activated*/):GetStringByStrRef(63799/*Deactivated*/)), oPC, FALSE);
}
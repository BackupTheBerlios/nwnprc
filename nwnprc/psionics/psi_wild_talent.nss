//::///////////////////////////////////////////////
//:: Wild Talent evaluation script
//:: psi_wild_talent
//:://////////////////////////////////////////////
/*
    Gives the feat possessor Psionic Focus,
    if they do not already have it.
    
    The check is delayed a bit, so that if Wild
    Talent was taken, and the character was
    re-leveled due to something, they will not
    get Psionic Focus
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 21.03.2005
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"
#include "x2_inc_itemprop"
#include "prc_ipfeat_const"

void DoCheck(object oCreature)
{
    if(!GetHasFeat(FEAT_PSIONIC_FOCUS, oCreature) &&
       GetIsPsionicCharacter(oCreature))
    {
        object oSkin = GetPCSkin(oCreature);
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_PSIONIC_FOCUS), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
}

void main()
{
    object oCreature = OBJECT_SELF;
    DelayCommand(0.5f, DoCheck(oCreature));
}
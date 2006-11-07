//::///////////////////////////////////////////////
//:: Peerless Archer Fletching +1
//:: PRC_PA_Fletch_1.nss
//:://////////////////////////////////////////////
/*
    Creates a stack of 99 +1 Arrows.
*/
//:://////////////////////////////////////////////
//:: Created By: James Tallet
//:: Created On: Apr 4, 2004
//:://////////////////////////////////////////////

#include "prc_feat_const"
#include "inc_utility"

void main()
{

 if (!GetHasXPToSpend(OBJECT_SELF, 30))
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough XP
       IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PA_FLETCH_1);
       return ;
 }
 if (!GetHasGPToSpend(OBJECT_SELF, 300))
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough GP
       IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PA_FLETCH_1);
       return ;
 }


 SetIdentified(CreateItemOnObject("NW_WAMMAR009", OBJECT_SELF, 99), TRUE);
 SpendXP(OBJECT_SELF, 30);
 SpendGP(OBJECT_SELF, 300);
}
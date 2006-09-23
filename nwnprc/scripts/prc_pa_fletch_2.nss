//::///////////////////////////////////////////////
//:: Peerless Archer Fletching +2
//:: PRC_PA_Fletch_2.nss
//:://////////////////////////////////////////////
/*
    Creates a stack of 99 +2 Arrows.
*/
//:://////////////////////////////////////////////
//:: Created By: James Tallet
//:: Created On: Apr 4, 2004
//:://////////////////////////////////////////////

#include "prc_feat_const"
#include "inc_utility"

void main()
{

 if (!GetHasXPToSpend(OBJECT_SELF, 80))
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough XP
       IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PA_FLETCH_2);
       return ;
 }
 if (!GetHasGPToSpend(OBJECT_SELF, 800))
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough XP
       IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PA_FLETCH_2);
       return ;
 }


 SetIdentified(CreateItemOnObject("NW_WAMMAR010", OBJECT_SELF, 99), TRUE);
 SpendXP(OBJECT_SELF, 80);
 SpendGP(OBJECT_SELF, 800);
}

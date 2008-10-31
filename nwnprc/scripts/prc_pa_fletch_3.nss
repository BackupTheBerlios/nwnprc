//::///////////////////////////////////////////////
//:: Peerless Archer Fletching +3
//:: PRC_PA_Fletch_3.nss
//:://////////////////////////////////////////////
/*
    Creates a stack of 99 +3 Arrows.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Apr 4, 2004
//:://////////////////////////////////////////////

#include "prc_feat_const"
#include "inc_utility"

void main()
{

 if (!GetHasXPToSpend(OBJECT_SELF, 300))
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough XP
       IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PA_FLETCH_3);
       return ;
 }
 if (!GetHasGPToSpend(OBJECT_SELF, 3000))
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough XP
       IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PA_FLETCH_3);
       return ;
 }


 SetIdentified(CreateItemOnObject("NW_WAMMAR011", OBJECT_SELF, 99), TRUE);
 SpendXP(OBJECT_SELF, 300);
 SpendGP(OBJECT_SELF, 3000);
}

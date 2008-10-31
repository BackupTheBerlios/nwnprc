//::///////////////////////////////////////////////
//:: Peerless Archer Fletching +5
//:: PRC_PA_Fletch_5.nss
//:://////////////////////////////////////////////
/*
    Creates a stack of 99 +5 Arrows.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Apr 4, 2004
//:://////////////////////////////////////////////

#include "prc_feat_const"
#include "inc_utility"

void main()
{

 if (!GetHasXPToSpend(OBJECT_SELF, 1200))
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough XP
       IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PA_FLETCH_5);
       return ;
 }
 if (!GetHasGPToSpend(OBJECT_SELF, 12000))
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough XP
       IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PA_FLETCH_5);
       return ;
 }


 SetIdentified(CreateItemOnObject("X2_WAMMAR013", OBJECT_SELF, 99), TRUE);
 SpendXP(OBJECT_SELF, 1200);
 SpendGP(OBJECT_SELF, 12000);
}

//::///////////////////////////////////////////////
//:: Peerless Archer Fletching +4
//:: PRC_PA_Fletch_4.nss
//:://////////////////////////////////////////////
/*
    Creates a stack of 99 +4 Arrows.
*/
//:://////////////////////////////////////////////
//:: Created By: James Tallet
//:: Created On: Apr 4, 2004
//:://////////////////////////////////////////////

#include "prc_feat_const"
#include "inc_utility"

void main()
{

 if (!GetHasXPToSpend(OBJECT_SELF, 675))
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough XP
       IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PA_FLETCH_4);
       return ;
 }
 if (!GetHasGPToSpend(OBJECT_SELF, 6750))
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough XP
       IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PA_FLETCH_4);
       return ;
 }


 SetIdentified(CreateItemOnObject("X2_WAMMAR012", OBJECT_SELF, 99), TRUE);
 SpendXP(OBJECT_SELF, 675);
 SpendGP(OBJECT_SELF, 6750);
}

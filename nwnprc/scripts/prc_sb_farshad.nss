/////////////////////////////////////////////////
// Far Shadow
// prc_sb_farshad.nss
/////////////////////////////////////////////////
#include "prc_feat_const"
void main()
{
        object oPC = OBJECT_SELF;
        
        SetLocalInt(oPC, "PRC_SB_FARSHAD", 1);
        FloatingTextStringOnCreature("Far Shadow activated.", oPC, FALSE);
        DecrementRemainingFeatUses(oPC, FEAT_UNSEEN_WEAPON_ACTIVATE);
        DelayCommand(RoundsToSeconds(1), DeleteLocalInt(oPC, "PRC_SB_FARSHAD"));        
}
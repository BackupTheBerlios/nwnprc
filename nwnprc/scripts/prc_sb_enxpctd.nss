/////////////////////////////////////////////////
// Unexpected Strike
// prc_sb_enxpctd.nss
/////////////////////////////////////////////////
#include "prc_feat_const"

void main()
{
        object oPC = OBJECT_SELF;
        if(GetLocalInt(oPC, "PRC_SB_UNEXPECTED"))
        {
                DeleteLocalInt(oPC, "PRC_SB_UNEXPECTED");
                FloatingTextStringOnCreature("Unexpected Strike deactivated.", oPC, FALSE);
                IncrementRemainingFeatUses(oPC, FEAT_UNSEEN_WEAPON_ACTIVATE);
        }
        
        else
        {
                SetLocalInt(oPC, "PRC_SB_UNEXPECTED", 1);
                FloatingTextStringOnCreature("Unexpected Strike activated.", oPC, FALSE);
                DecrementRemainingFeatUses(oPC, FEAT_UNSEEN_WEAPON_ACTIVATE);
        }
}
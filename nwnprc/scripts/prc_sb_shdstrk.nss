/////////////////////////////////////////////////
// Shadowy Strike
// prc_sb_shdstrk.nss
/////////////////////////////////////////////////
#include "prc_feat_const"
void main()
{
        object oPC = OBJECT_SELF;
        if(GetLocalInt(oPC, "PRC_SB_SHADOWY"))
        {
                DeleteLocalInt(oPC, "PRC_SB_SHADOWY");
                FloatingTextStringOnCreature("Shadowy Strike deactivated.", oPC, FALSE);
                IncrementRemainingFeatUses(oPC, FEAT_UNSEEN_WEAPON_ACTIVATE);
        }
        
        else
        {
                SetLocalInt(oPC, "PRC_SB_SHADOWY", 1);
                FloatingTextStringOnCreature("Shadowy Strike activated.", oPC, FALSE);
                DecrementRemainingFeatUses(oPC, FEAT_UNSEEN_WEAPON_ACTIVATE);
        }
}
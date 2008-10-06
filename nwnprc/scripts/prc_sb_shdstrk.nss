/////////////////////////////////////////////////
// Shadowy Strike
// prc_sb_shdstrk.nss
/////////////////////////////////////////////////
void main()
{
        object oPC = OBJECT_SELF;
        if(GetLocalInt(oPC, "PRC_SB_SHADOWY", 1))
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
/////////////////////////////////////////////////
// Ephemeral Strike
// prc_sb_ephmrl.nss
/////////////////////////////////////////////////
void main()
{
        object oPC = OBJECT_SELF;
        if(GetLocalInt(oPC, "PRC_SB_EPHEMERAL", 1))
        {
                DeleteLocalInt(oPC, "PRC_SB_EPHEMERAL");
                FloatingTextStringOnCreature("Ephemeral Strike deactivated.", oPC, FALSE);
                IncrementRemainingFeatUses(oPC, FEAT_UNSEEN_WEAPON_ACTIVATE);
        }
        
        else
        {
                SetLocalInt(oPC, "PRC_SB_EPHEMERAL", 1);
                FloatingTextStringOnCreature("Ephemeral Strike activated.", oPC, FALSE);
                DecrementRemainingFeatUses(oPC, FEAT_UNSEEN_WEAPON_ACTIVATE);
        }
}
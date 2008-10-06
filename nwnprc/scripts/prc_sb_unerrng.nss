/////////////////////////////////////////////////
// Unerring Strike
// prc_sb_enerrng.nss
/////////////////////////////////////////////////
void main()
{
        object oPC = OBJECT_SELF;
        if(GetLocalInt(oPC, "PRC_SB_UNERRING", 1))
        {
                DeleteLocalInt(oPC, "PRC_SB_UNERRING");
                FloatingTextStringOnCreature("Unnerring Strike deactivated.", oPC, FALSE);
                IncrementRemainingFeatUses(oPC, FEAT_UNSEEN_WEAPON_ACTIVATE);
        }
        
        else
        {
                SetLocalInt(oPC, "PRC_SB_UNERRING", 1);
                FloatingTextStringOnCreature("Unerring Strike activated.", oPC, FALSE);
                DecrementRemainingFeatUses(oPC, FEAT_UNSEEN_WEAPON_ACTIVATE);
        }
}
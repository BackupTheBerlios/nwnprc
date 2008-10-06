/////////////////////////////////////////////////
// Far Shadow
// prc_sb_farshad.nss
/////////////////////////////////////////////////
void main()
{
        object oPC = OBJECT_SELF;
        if(GetLocalInt(oPC, "PRC_SB_FARSHAD", 1))
        {
                DeleteLocalInt(oPC, "PRC_SB_FARSHAD");
                FloatingTextStringOnCreature("Far Shadow deactivated.", oPC, FALSE);
                IncrementRemainingFeatUses(oPC, FEAT_UNSEEN_WEAPON_ACTIVATE);
        }
        
        else
        {
                SetLocalInt(oPC, "PRC_SB_FARSHAD", 1);
                FloatingTextStringOnCreature("Far Shadow activated.", oPC, FALSE);
                DecrementRemainingFeatUses(oPC, FEAT_UNSEEN_WEAPON_ACTIVATE);
        }
}
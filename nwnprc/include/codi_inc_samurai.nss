void WeaponUpgradeVisual();

object GetSamuraiToken(object oSamurai);

void WeaponUpgradeVisual()
{
    object oPC = GetPCSpeaker();
    int iCost = GetLocalInt(oPC, "CODI_SAM_WEAPON_COST");
    object oToken = GetSamuraiToken(oPC);
    int iToken = StringToInt(GetTag(oToken));
    int iGold = GetGold(oPC);
    if(iGold + iToken < iCost)
    {
        SendMessageToPC(oPC, "You sense the gods are angered!");
        AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, 25);
        object oWeapon = GetItemPossessedBy(oPC, "codi_sam_mw");
        DestroyObject(oWeapon);
        return;
    }
    else if(iToken <= iCost)
    {
        iCost = iCost - iToken;
        DestroyObject(oToken);
        TakeGoldFromCreature(iCost, oPC, TRUE);
    }
    else if (iToken > iCost)
    {
        object oNewToken = CopyObject(oToken, GetLocation(oPC), oPC, IntToString(iToken - iCost));
        DestroyObject(oToken);
    }
    effect eVis = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE,1.0,6.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2));
    DelayCommand(0.1, SetCommandable(FALSE, oPC));
    DelayCommand(6.5, SetCommandable(TRUE, oPC));
    DelayCommand(5.0,ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC)));
}

object GetSamuraiToken(object oSamurai)
{
    object oItem = GetFirstItemInInventory(oSamurai);
    while(oItem != OBJECT_INVALID)
    {
        if(GetResRef(oItem) == "codi_sam_token")
        {
            return oItem;
        }
        oItem = GetNextItemInInventory(oSamurai);
    }
    return OBJECT_INVALID;
}


void DoEquipTest();
object GetItemLastEquipped();
object GetItemLastEquippedBy();
object GetItemLastUnequipped();
object GetItemLastUnequippedBy();


object GetItemLastEquippedBy()
{
    if(GetModule() == OBJECT_SELF)
        return GetPCItemLastEquippedBy();
    else
        return OBJECT_SELF;
}

object GetItemLastUnequippedBy()
{
    if(GetModule() == OBJECT_SELF)
        return GetPCItemLastUnequippedBy();
    else
        return OBJECT_SELF;
}

object GetItemLastEquipped()
{
    if(GetModule() == OBJECT_SELF)
        return GetPCItemLastEquipped();
    else
        return GetLocalObject(OBJECT_SELF, "oLastEquipped");
}

object GetItemLastUnequipped()
{
    if(GetModule() == OBJECT_SELF)
        return GetPCItemLastUnequipped();
    else
        return GetLocalObject(OBJECT_SELF, "oLastUnequipped");
}

void DoEquipTest()
{
    int i;
    object oTest;
    object oItem;
    for(i=1; i<NUM_INVENTORY_SLOTS;i++)
    {
        oItem = GetItemInSlot(i, OBJECT_SELF);
        oTest = GetLocalObject(OBJECT_SELF, "oSlotItem"+IntToString(i));
        if(oTest != oItem)
        {
            if(GetIsObjectValid(oItem))
            {
                SetLocalObject(OBJECT_SELF, "oLastEquipped", oItem);
                ExecuteScript("prc_equip", OBJECT_SELF);
            }
            if(GetIsObjectValid(oTest))
            {
                SetLocalObject(OBJECT_SELF, "oLastUnequipped", oTest);
                ExecuteScript("prc_unequip", OBJECT_SELF);
            }
            SetLocalObject(OBJECT_SELF, "oSlotItem"+IntToString(i), oItem);
        }
    }
}

void main()
{
object oWeapon = GetSpellTargetObject();
int iType = GetBaseItemType(oWeapon);
object oPC = OBJECT_SELF;
string sName = GetName(oWeapon);
int iChosen = GetLocalInt(oPC, "HAS_CHOSEN_WEAPON");

if(iType == BASE_ITEM_SHORTSWORD||iType == BASE_ITEM_RAPIER||iType == BASE_ITEM_DAGGER)
{
        if(iChosen == 2)
        {
        SendMessageToPC(oPC, "You already have chosen a weapon, you cannot choose another.");
        }
        else
        {
        SetLocalInt(oPC, "HAS_CHOSEN_WEAPON", 2);
        SetLocalInt(oWeapon, "CHOSEN_WEAPON", 2);
        SetLocalObject(oPC, "CHOSEN_WEAPON", oWeapon);
        SetDroppableFlag(oWeapon, FALSE);
        SetPlotFlag(oWeapon, TRUE);
        SendMessageToPC(oPC, "You have chosen "+sName+" to be your chosen weapon.");
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), oWeapon, 0.0);
        }
}
else
{
 SendMessageToPC(oPC, "This is not a valid weapon, please choose either a shortsword, dagger, or rapier.");
}

}

#include "prc_alterations"
void main()
{
    object oItem = GetInventoryDisturbItem();
    object oPC = GetLastDisturbed();
    if(GetPlotFlag(oItem))
    {
        FloatingTextStringOnCreature("You cannot sacrifice plot items.", oPC, FALSE);
        ActionGiveItem(oItem, oPC);
        return;
    }
    if(!GetIdentified(oItem))
    {
        FloatingTextStringOnCreature("You cannot sacrifice unidentified items.", oPC, FALSE);
        ActionGiveItem(oItem, oPC);
        return;
    }
    int iValue = GetGoldPieceValue(oItem);
    DestroyObject(oItem);
    if (iValue > 0)
    {
        int iCurrentValue = GetPersistantLocalInt(oPC, "CODI_SAMURAI");
        SetPersistantLocalInt(oPC, "CODI_SAMURAI", iCurrentValue + iValue);
        FloatingTextStringOnCreature("Your sacrifice is accepted. You now have " + IntToString(iCurrentValue + iValue) + " gold in sacrifices.", oPC);
    }
}

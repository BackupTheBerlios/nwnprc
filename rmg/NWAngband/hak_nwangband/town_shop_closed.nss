void main()
{
    object oBasket = OBJECT_SELF;
    object oPC = GetLocalObject(oBasket, "PC");
    //clean up
    DestroyObject(oBasket, 0.2);
    //get town it was spawned from
    object oTown = GetLocalObject(oBasket, "Town");
    //copy inventory back into town
    //set the amount of gold the store has, based on the town
    SetLocalInt(oTown, "StoreGold", GetStoreGold(oBasket));
    //put the stuff from the town store into the basket
    object oItem = GetFirstItemInInventory(oBasket);
    while(GetIsObjectValid(oItem))
    {
        if(!GetLocalInt(oItem, "StoreMultiple"))
            CopyItem(oItem, oTown, TRUE);
        DestroyObject(oItem, 0.1);
        oItem = GetNextItemInInventory(oBasket);
    }
    //if a conversation is specified, (re)start it
    if(GetLocalString(oBasket, "Convo") != ""
        && GetIsObjectValid(GetLocalObject(oBasket, "ConvoSpeaker")))
        AssignCommand(GetLocalObject(oBasket, "ConvoSpeaker"),
            ActionStartConversation(oPC, GetLocalString(oBasket, "Convo"), TRUE, FALSE));

}

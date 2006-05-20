//This is the PC doing the shopping
//object oPC
//this is the container shoppng from
//object oTown
//value to tweak markup (stuff the shop sells)
//int nMarkUpTweak            =      0;
//value to tweak markdown (stuff the shop buys)
//there is a -50% markdown on top of this
//int nMarkDownTweak          =      0;
//things below this value are deemed to be avaliable in nearly infinite amounts
//int nInfiniteValue          =    100;
//if the value is half of this, there are 2 of them if the value is a third,
//there are 3 of them if the value is a quater, there are 4 of them etc
//Items with a local named "UniqueItem" on them are never duplicated
//int nMultiplesValue         =   1000;
//maximum value to use in-stock -1 means use the PCs total wealth
//int nMaxValue               = -1;
//minimum value to use in-stock
//int nMinValue               =      0;
//maximum purchase price for an individual item
//int nMaxPurchaseValue       =   5000;
//amount of cash in the store
//int nGoldAvaliable          =   1000;
//identify cost
//int nIdentify               =    100;
//this is the amount of all the goods in the town that the player has found
//out of 100
//int nProportionFound        =     50;
//is this a "normal" shop or the products of theft if greater than zero, then
//this is the DC to beat
//size and weight is applied on top of this
//int nSteal                  =      0;
//resref of the basket merchant to use
//for example, to limit what can be sold to it
//or for stolen items etc
//string sBasketResRef        = "shoppingbasket"
void DoShopping(object oPC, object oTown, int nMarkUpTweak = 0,
    int nMarkDownTweak = 0,
    int nInfiniteValue = 100,
    int nMultiplesValue = 1000, int nMaxValue = 100000, int nMinValue = 0,
    int nMaxPurchaseValue = 5000, int nGoldAvaliable = 1000, int nIdentify = 100,
    int nProportionFound = 50, int nSteal = 0,
    string sBasketResRef = "shoppingbasket", string sConvo = "town",
    object oConvoSpeaker = OBJECT_SELF);


void DoShopping(object oPC, object oTown, int nMarkUpTweak = 0,
    int nMarkDownTweak = 0,
    int nInfiniteValue = 100,
    int nMultiplesValue = 1000, int nMaxValue = 100000, int nMinValue = 0,
    int nMaxPurchaseValue = 5000, int nGoldAvaliable = 1000, int nIdentify = 100,
    int nProportionFound = 50, int nSteal = 0,
    string sBasketResRef = "shoppingbasket", string sConvo = "town",
    object oConvoSpeaker = OBJECT_SELF)
{
    //create a "basket" of avaliable goods
    object oBasket = CreateObject(OBJECT_TYPE_STORE,
        sBasketResRef, GetLocation(OBJECT_SELF));
    if(!GetIsObjectValid(oBasket))
        return;
    //store the town on the basket
    SetLocalObject(oBasket, "Town", oTown);
    //set the amount of gold the store has
    SetStoreGold(oBasket, nGoldAvaliable);
    //set the maximum amount it will pay
    SetStoreMaxBuyPrice(oBasket, nMaxPurchaseValue);
    //set the identify cost it charges
    SetStoreIdentifyCost(oBasket, nIdentify);
    if(nMaxValue == -1)
        nMaxValue = GetGold(oPC);
    //put the stuff from the town store into the basket
    object oItem = GetFirstItemInInventory(oTown);
    while(GetIsObjectValid(oItem))
    {
        if(Random(100)< nProportionFound)
        {
            //get its value
            int nValue = GetGoldPieceValue(oItem);
            if(nValue > nMinValue
                && nValue < nMaxValue)
            {
                object oTemp = CopyItem(oItem, oBasket, TRUE);
                //remove it from town
                //slight delay to avoid messing up the loop
                DestroyObject(oItem, 0.1);
                //if its cheap, make it infinite
                //assuming its not a unique item
                if(nValue < nInfiniteValue
                    && !GetLocalInt(oTemp, "UniqueItem"))
                    SetInfiniteFlag(oTemp, TRUE);
                else if(!GetLocalInt(oTemp, "UniqueItem"))
                {
                    int nCopies = nMultiplesValue/nValue;
                    //randomize a bit, +/- up to 25%
                    float fPercent = (IntToFloat(Random(50))/100)-0.25;
                    nCopies = FloatToInt(IntToFloat(nCopies)*fPercent);
                    while(nCopies > 0)
                    {
                        oTemp = CopyItem(oItem, oBasket, TRUE);
                        //mark it as a multiple
                        SetLocalInt(oTemp, "StoreMultiple", TRUE);
                        nCopies--;
                    }
                }
            }
        }
        oItem = GetNextItemInInventory(oTown);
    }
    int nMarkUp =     0;    //amount sold stuff is changed by
    int nMarkDown = -50;    //amount bought stuff is changed by
    nMarkUp += nMarkUpTweak;
    nMarkDown += nMarkDownTweak;
    //sanity check on markup/down
    if(nMarkUp<nMarkDown)
    {
        nMarkUp   = nMarkUp+nMarkDown/2;
        nMarkDown = nMarkUp+nMarkDown/2;
    }
    //setup thefts
    if(nSteal)
        SetLocalInt(oBasket, "StoreRobbingDC", nSteal);
    SetLocalString(oBasket, "Convo", sConvo);
    SetLocalObject(oBasket, "ConvoSpeaker", oConvoSpeaker);
    SetLocalObject(oBasket, "PC", oPC);
    //if a convo, restart it
    OpenStore(oBasket, oPC, nMarkUp, nMarkDown);
}

void DoShoplifting()
{
    object oPC = GetModuleItemAcquiredBy();
    object oStore = GetModuleItemAcquiredFrom();
    object oItem = GetModuleItemAcquired();
    int nDC = GetLocalInt(oStore, "StoreRobbingDC");
    if(GetIsObjectValid(oItem)
        && GetIsObjectValid(oStore)
        && GetIsObjectValid(oPC)
        && nDC)
    {
        //apply size modifier
        int nWidth  = StringToInt(Get2DAString("baseitems", "InvSlotWidth", GetBaseItemType(oItem)));
        int nHeight = StringToInt(Get2DAString("baseitems", "InvSlotHeight", GetBaseItemType(oItem)));
        int nArea = nWidth*nHeight;
        nDC += nArea*2;
        nDC += GetWeight(oItem)/10;
        int nRoll = d20()+GetSkillRank(SKILL_PICK_POCKET, oPC);
        if(nRoll < nDC-10)
        {
            //been caught stealing, do something!
        }
        else if(nRoll < nDC)
        {
            //failed to lift it
            //destroy and copy back
            CopyItem(oItem, oStore, TRUE);
            DestroyObject(oItem);
        }
        else
        {
            //sucessful
            //mark item as stolen
            SetStolenFlag(oItem, TRUE);
        }
    }
}

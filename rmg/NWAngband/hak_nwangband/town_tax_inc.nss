/*

    This include is designed to help maintain loot balance by taxing a player
    
    This should be applied when a player returns to civilization, entering a town
    for example.
    
    It is based on demanging a percentage of gold over a certain value based on level.
    For example, a level 20 fighter with a total value of 200,000 may have 100,000 for
    free and then be taxed 10% of the amount over that. In this case it would be 10,000.
    
    Using a tax has several effects:
    Firstly, it discorages players from returning to town too often.
    Secondly, it helps provide a cash sink to help stop hyperinflation of the economy.
    Thirdly, it help provide "realism" via a reason for town facilities to exist/grow.

*/


const float TAX_RATE            = 0.1;
const float TAX_ITEM_SALE_VALUE = 0.25;//items are a quarter of real value


void ApplyTaxToPlayer(object oPC, object oTown)
{
    int nTotalWealth;
    int i;
    for(i=0; i < 14; i++)
    {
        object oItem = GetItemInSlot(i, oPC);
        nTotalWealth += GetGoldPieceValue(oItem);
    }
    
    object oItem = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oItem))
    {
        nTotalWealth += GetGoldPieceValue(oItem);
        oItem = GetNextItemInInventory(oPC);
    }    
    nTotalWealth += GetGold(oPC);
    
    int nTaxThreashold;
    switch(GetECL(oPC))
    {
        case  1:
        case  2: nTaxThreashold =      900; break;
        case  3: nTaxThreashold =     2700; break;
        case  4: nTaxThreashold =     5400; break;
        case  5: nTaxThreashold =     9000; break;
        case  6: nTaxThreashold =    13000; break;
        case  7: nTaxThreashold =    19000; break;
        case  8: nTaxThreashold =    27000; break;
        case  9: nTaxThreashold =    35000; break;
        case 10: nTaxThreashold =    49000; break;
        case 11: nTaxThreashold =    65000; break;
        case 12: nTaxThreashold =    88000; break;
        case 13: nTaxThreashold =   110000; break;
        case 14: nTaxThreashold =   150000; break;
        case 15: nTaxThreashold =   200000; break;
        case 16: nTaxThreashold =   260000; break;
        case 17: nTaxThreashold =   340000; break;
        case 18: nTaxThreashold =   440000; break;
        case 19: nTaxThreashold =   580000; break;
        case 20: nTaxThreashold =   760000; break;
        case 21: nTaxThreashold =   975000; break;
        case 22: nTaxThreashold =  1200000; break;
        case 23: nTaxThreashold =  1500000; break;
        case 24: nTaxThreashold =  1800000; break;
        case 25: nTaxThreashold =  2100000; break;
        case 26: nTaxThreashold =  2500000; break;
        case 27: nTaxThreashold =  2900000; break;
        case 28: nTaxThreashold =  3300000; break;
        case 29: nTaxThreashold =  3800000; break;
        case 30: nTaxThreashold =  4300000; break;
        case 31: nTaxThreashold =  4900000; break;
        case 32: nTaxThreashold =  5600000; break;
        case 33: nTaxThreashold =  6300000; break;
        case 34: nTaxThreashold =  7000000; break;
        case 35: nTaxThreashold =  7900000; break;
        case 36: nTaxThreashold =  8800000; break;
        case 37: nTaxThreashold =  9900000; break;
        case 38: nTaxThreashold = 11000000; break;
        case 39: nTaxThreashold = 12300000; break;
        default: nTaxThreashold = 13600000; break;
    }
    
    float fTaxRate;
    fTaxRate = TAX_RATE;
    
    //setup the message
    string sMessage;
    sMessage += "You have a total value of "+IntToString(nTotalWealth)+"gp and a tax threashold of "+IntToString(nTaxThreashold)+"gp.";
    
    
    //if all below threashold, abort
    if(nTotalWealth < nTaxThreashold)
    {
        sMessage += "You do not have to pay any tax.";
        FloatingTextStringOnCreature(sMessage, oPC, FALSE);
        return;
    }
    
    //remove the stuff below the threashold
    nTotalWealth -= nTaxThreashold;
    
    int nTaxAmmount;
    nTaxAmmount = FloatToInt(fTaxRate*IntToFloat(nTotalWealth));
    
    //add any outstanding taxes from previous trips
    nTaxAmmount += GetLocalInt(oPC, "UnpaidTaxes");
    
    //see if they have the cash
    if(GetGold(oPC) < nTaxAmmount)
    {
        TakeGoldFromCreature(nTaxAmmount, oPC, TRUE);
        sMessage += "You have been taxed "+IntToString(nTaxAmmount)+"gp in cash.";
        FloatingTextStringOnCreature(sMessage, oPC, FALSE);
        return;
    }
    else
    {
        sMessage += "You have been taxed "+IntToString(GetGold(oPC))+"gp in cash.";
        //not enough cash but take what we can
        nTaxAmmount -= GetGold(oPC);
        TakeGoldFromCreature(GetGold(oPC), oPC, TRUE);      
    }
    //no cash need to take items
    //limit it to 10 most valuable items
    object oValuable1;
    object oValuable2;
    object oValuable3;
    object oValuable4;
    object oValuable5;
    object oValuable6;
    object oValuable7;
    object oValuable8;
    object oValuable9;
    object oValuable10;
    int nCount = 0;
    
    oItem = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oItem))
    {
        if(GetGoldPieceValue(oItem) > GetGoldPieceValue(oValuable1))
        {
            oValuable10 = oValuable9;
            oValuable9  = oValuable8;
            oValuable8  = oValuable7;
            oValuable7  = oValuable6;
            oValuable6  = oValuable5;
            oValuable5  = oValuable4;
            oValuable4  = oValuable3;
            oValuable3  = oValuable2;
            oValuable2  = oValuable1;
            oValuable1 = oItem; 
        }
        else if(GetGoldPieceValue(oItem) > GetGoldPieceValue(oValuable2))
        {
            oValuable10 = oValuable9;
            oValuable9  = oValuable8;
            oValuable8  = oValuable7;
            oValuable7  = oValuable6;
            oValuable6  = oValuable5;
            oValuable5  = oValuable4;
            oValuable4  = oValuable3;
            oValuable3  = oValuable2;
            oValuable2  = oItem; 
        }
        else if(GetGoldPieceValue(oItem) > GetGoldPieceValue(oValuable3))
        {
            oValuable10 = oValuable9;
            oValuable9  = oValuable8;
            oValuable8  = oValuable7;
            oValuable7  = oValuable6;
            oValuable6  = oValuable5;
            oValuable5  = oValuable4;
            oValuable4  = oValuable3;
            oValuable3  = oItem; 
        }
        else if(GetGoldPieceValue(oItem) > GetGoldPieceValue(oValuable4))
        {
            oValuable10 = oValuable9;
            oValuable9  = oValuable8;
            oValuable8  = oValuable7;
            oValuable7  = oValuable6;
            oValuable6  = oValuable5;
            oValuable5  = oValuable4;
            oValuable4  = oItem; 
        }
        else if(GetGoldPieceValue(oItem) > GetGoldPieceValue(oValuable5))
        {
            oValuable10 = oValuable9;
            oValuable9  = oValuable8;
            oValuable8  = oValuable7;
            oValuable7  = oValuable6;
            oValuable6  = oValuable5;
            oValuable5  = oItem; 
        }
        else if(GetGoldPieceValue(oItem) > GetGoldPieceValue(oValuable6))
        {
            oValuable10 = oValuable9;
            oValuable9  = oValuable8;
            oValuable8  = oValuable7;
            oValuable7  = oValuable6;
            oValuable6  = oItem; 
        }
        else if(GetGoldPieceValue(oItem) > GetGoldPieceValue(oValuable7))
        {
            oValuable10 = oValuable9;
            oValuable9  = oValuable8;
            oValuable8  = oValuable7;
            oValuable7  = oItem; 
        }
        else if(GetGoldPieceValue(oItem) > GetGoldPieceValue(oValuable8))
        {
            oValuable10 = oValuable9;
            oValuable9  = oValuable8;
            oValuable8  = oItem; 
        }
        else if(GetGoldPieceValue(oItem) > GetGoldPieceValue(oValuable9))
        {
            oValuable10 = oValuable9;
            oValuable9  = oItem; 
        }
        else if(GetGoldPieceValue(oItem) > GetGoldPieceValue(oValuable10))
        {
            oValuable10 = oItem; 
        }
        oItem = GetNextItemInInventory(oPC);
    }    
    //now we have the list of valuable items
    //and an amount of gold to remove (nTaxAmmount)
    if(GetIsObjectValid(oValuable1))
    {
        int nItemValue = FloatToInt(IntToFloat(GetGoldPieceValue(oValuable1))*TAX_ITEM_SALE_VALUE);
        if(nItemValue > nTaxAmmount)
        {
            //give them the leftovers
            GiveGoldToCreature(oPC, nItemValue-nTaxAmmount);
            sMessage += "You have been taxed "+IntToString(nTaxAmmount)+"gp from the sale of "+GetName(oValuable1)+" for "+IntToString(nItemValue)+".";
            FloatingTextStringOnCreature(sMessage, oPC, FALSE);
            return;
        }   
        else
        {
            nTaxAmmount -= nItemValue;
            sMessage += "You have sold "+GetName(oValuable1)+" for "+IntToString(nItemValue)+" to pay for taxes.";
        }    
    }
    if(GetIsObjectValid(oValuable2))
    {
        int nItemValue = FloatToInt(IntToFloat(GetGoldPieceValue(oValuable2))*TAX_ITEM_SALE_VALUE);
        if(nItemValue > nTaxAmmount)
        {
            //give them the leftovers
            GiveGoldToCreature(oPC, nItemValue-nTaxAmmount);
            sMessage += "You have been taxed "+IntToString(nTaxAmmount)+"gp from the sale of "+GetName(oValuable2)+" for "+IntToString(nItemValue)+".";
            FloatingTextStringOnCreature(sMessage, oPC, FALSE);
            return;
        }   
        else
        {
            nTaxAmmount -= nItemValue;
            sMessage += "You have sold "+GetName(oValuable2)+" for "+IntToString(nItemValue)+" to pay for taxes.";
        }    
    }
    if(GetIsObjectValid(oValuable3))
    {
        int nItemValue = FloatToInt(IntToFloat(GetGoldPieceValue(oValuable3))*TAX_ITEM_SALE_VALUE);
        if(nItemValue > nTaxAmmount)
        {
            //give them the leftovers
            GiveGoldToCreature(oPC, nItemValue-nTaxAmmount);
            sMessage += "You have been taxed "+IntToString(nTaxAmmount)+"gp from the sale of "+GetName(oValuable3)+" for "+IntToString(nItemValue)+".";
            FloatingTextStringOnCreature(sMessage, oPC, FALSE);
            return;
        }   
        else
        {
            nTaxAmmount -= nItemValue;
            sMessage += "You have sold "+GetName(oValuable3)+" for "+IntToString(nItemValue)+" to pay for taxes.";
        }    
    }
    if(GetIsObjectValid(oValuable4))
    {
        int nItemValue = FloatToInt(IntToFloat(GetGoldPieceValue(oValuable4))*TAX_ITEM_SALE_VALUE);
        if(nItemValue > nTaxAmmount)
        {
            //give them the leftovers
            GiveGoldToCreature(oPC, nItemValue-nTaxAmmount);
            sMessage += "You have been taxed "+IntToString(nTaxAmmount)+"gp from the sale of "+GetName(oValuable4)+" for "+IntToString(nItemValue)+".";
            FloatingTextStringOnCreature(sMessage, oPC, FALSE);
            return;
        }   
        else
        {
            nTaxAmmount -= nItemValue;
            sMessage += "You have sold "+GetName(oValuable4)+" for "+IntToString(nItemValue)+" to pay for taxes.";
        }    
    }
    if(GetIsObjectValid(oValuable5))
    {
        int nItemValue = FloatToInt(IntToFloat(GetGoldPieceValue(oValuable5))*TAX_ITEM_SALE_VALUE);     
        if(nItemValue > nTaxAmmount)
        {
            //give them the leftovers
            GiveGoldToCreature(oPC, nItemValue-nTaxAmmount);
            sMessage += "You have been taxed "+IntToString(nTaxAmmount)+"gp from the sale of "+GetName(oValuable5)+" for "+IntToString(nItemValue)+".";
            FloatingTextStringOnCreature(sMessage, oPC, FALSE);
            return;
        }   
        else
        {
            nTaxAmmount -= nItemValue;
            sMessage += "You have sold "+GetName(oValuable5)+" for "+IntToString(nItemValue)+" to pay for taxes.";
        }    
    }
    if(GetIsObjectValid(oValuable6))
    {
        int nItemValue = FloatToInt(IntToFloat(GetGoldPieceValue(oValuable6))*TAX_ITEM_SALE_VALUE);
        if(nItemValue > nTaxAmmount)
        {
            //give them the leftovers
            GiveGoldToCreature(oPC, nItemValue-nTaxAmmount);
            sMessage += "You have been taxed "+IntToString(nTaxAmmount)+"gp from the sale of "+GetName(oValuable6)+" for "+IntToString(nItemValue)+".";
            FloatingTextStringOnCreature(sMessage, oPC, FALSE);
            return;
        }   
        else
        {
            nTaxAmmount -= nItemValue;
            sMessage += "You have sold "+GetName(oValuable6)+" for "+IntToString(nItemValue)+" to pay for taxes.";
        }    
    }
    if(GetIsObjectValid(oValuable7))
    {
        int nItemValue = FloatToInt(IntToFloat(GetGoldPieceValue(oValuable7))*TAX_ITEM_SALE_VALUE);
        if(nItemValue > nTaxAmmount)
        {
            //give them the leftovers
            GiveGoldToCreature(oPC, nItemValue-nTaxAmmount);
            sMessage += "You have been taxed "+IntToString(nTaxAmmount)+"gp from the sale of "+GetName(oValuable7)+" for "+IntToString(nItemValue)+".";
            FloatingTextStringOnCreature(sMessage, oPC, FALSE);
            return;
        }   
        else
        {
            nTaxAmmount -= nItemValue;
            sMessage += "You have sold "+GetName(oValuable7)+" for "+IntToString(nItemValue)+" to pay for taxes.";
        }    
    }
    if(GetIsObjectValid(oValuable8))
    {
        int nItemValue = FloatToInt(IntToFloat(GetGoldPieceValue(oValuable8))*TAX_ITEM_SALE_VALUE);
        if(nItemValue > nTaxAmmount)
        {
            //give them the leftovers
            GiveGoldToCreature(oPC, nItemValue-nTaxAmmount);
            sMessage += "You have been taxed "+IntToString(nTaxAmmount)+"gp from the sale of "+GetName(oValuable8)+" for "+IntToString(nItemValue)+".";
            FloatingTextStringOnCreature(sMessage, oPC, FALSE);
            return;
        }   
        else
        {
            nTaxAmmount -= nItemValue;
            sMessage += "You have sold "+GetName(oValuable8)+" for "+IntToString(nItemValue)+" to pay for taxes.";
        }    
    }
    if(GetIsObjectValid(oValuable9))
    {
        int nItemValue = FloatToInt(IntToFloat(GetGoldPieceValue(oValuable9))*TAX_ITEM_SALE_VALUE);
        if(nItemValue > nTaxAmmount)
        {
            //give them the leftovers
            GiveGoldToCreature(oPC, nItemValue-nTaxAmmount);
            sMessage += "You have been taxed "+IntToString(nTaxAmmount)+"gp from the sale of "+GetName(oValuable9)+" for "+IntToString(nItemValue)+".";
            FloatingTextStringOnCreature(sMessage, oPC, FALSE);
            return;
        }   
        else
        {
            nTaxAmmount -= nItemValue;
            sMessage += "You have sold "+GetName(oValuable9)+" for "+IntToString(nItemValue)+" to pay for taxes.";
        }    
    }
    if(GetIsObjectValid(oValuable10))
    {
        int nItemValue = FloatToInt(IntToFloat(GetGoldPieceValue(oValuable10))*TAX_ITEM_SALE_VALUE);
        if(nItemValue > nTaxAmmount)
        {
            //give them the leftovers
            GiveGoldToCreature(oPC, nItemValue-nTaxAmmount);
            sMessage += "You have been taxed "+IntToString(nTaxAmmount)+"gp from the sale of "+GetName(oValuable10)+" for "+IntToString(nItemValue)+".";
            FloatingTextStringOnCreature(sMessage, oPC, FALSE);
            return;
        }   
        else
        {
            nTaxAmmount -= nItemValue;
            sMessage += "You have sold "+GetName(oValuable10)+" for "+IntToString(nItemValue)+" to pay for taxes.";
        }    
    }
    //if we still get to this point, the PC has had all their cash and their 10 most valuable items removed
    //Add it to their tax bill!
    SetLocalInt(oPC, "UnpaidTaxes", nTaxAmmount);
}
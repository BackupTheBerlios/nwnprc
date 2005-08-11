/*

    This file is used for lookup functions for psionics and newspellbooks
    It is supposed to reduce the need for large loops that may result in 
    TMI errors.
    It does this by creating arrays in advance and the using those as direct 
    lookups.
*/


int GetPowerFromSpellID(int nSpellID);
void MakePowerFromSpellID();

void MakePowerFromSpellID()
{
    //get the token to store it on
    //this is piggybacked into 2da caching
    object oWP = GetObjectByTag("PRC_GetPowerFromSpellID");
    if(!GetIsObjectValid(oWP))
    {
        object oChest = GetObjectByTag("Bioware2DACache");
        if(!GetIsObjectValid(oChest))
        {
            oChest = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_chest2",
                GetLocation(GetObjectByTag("HEARTOFCHAOS")), FALSE, "Bioware2DACache");     
        }
        oWP = CreateObject(OBJECT_TYPE_ITEM, "hidetoken", GetLocation(oChest), FALSE, "PRC_GetPowerFromSpellID");
        DestroyObject(oFileWP);
        oWP = CopyObject(oWP, GetLocation(oChest), oChest, "PRC_GetPowerFromSpellID");
    }
    
    //now the loops
    int i;
    for(i=0;i<250;i++)
    {
        int nSpellID = StringToInt(Get2DACache("cls_psipw_psion", "SpellID", i));
        int nPower   = StringToInt(Get2DACache("cls_psipw_psion", "RealSpellID", i));
        if(nSpellID != 0 && nPower != 0)
            SetLocalInt(oWP, "PRC_GetPowerFromSpellID_"+IntToString(nSpellID), nPower); 
    }
}

int GetPowerFromSpellID(int nSpellID)
{
    object oWP = GetObjectByTag("PRC_GetPowerFromSpellID");
    int nPower = GetLocalInt(oWP, "PRC_GetPowerFromSpellID_"+IntToString(nSpellID));
    return nPower;
}
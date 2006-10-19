

void RIG_DoDBStore2(int nBaseItemType, int nAC = 0)
{
    string sTag = "RIG_Chest_"+IntToString(nBaseItemType)+"_"+IntToString(nAC);
    object oChest = GetObjectByTag(sTag);
    if(GetIsObjectValid(oChest))
    {
        StoreCampaignObject(RIG_DB, sTag+"!", oChest); 
        int i;
        for(i=1;i<=40;i++)
        {
            sTag = "RIG_Chest_"+IntToString(nBaseItemType)+"_"+IntToString(i)+"_"+IntToString(nAC);
            int nCount = GetLocalInt(oChest, "ContentsLevel"+IntToString(i));
            SetCampaignInt(RIG_DB, sTag+"!", nCount);
        }    
    }
}

void RIG_DoDBStore()
{
    //destroy database to stop inifinite bloat
    //doesnt work on linux but oh well
    DestroyCampaignDatabase(RIG_DB);
    DelayCommand(RIG_DB_DELAY, RIG_DoDBStore());
    DoDebug("RIG_DoDBStore started");
    int i;
    for(i=0;i<RIG_ROOT_COUNT;i++)
    {
        int nBaseType = StringToInt(Get2DACache("rig_root", "BaseItem", i));
        int nAC = StringToInt(Get2DACache("rig_root", "AC", i));
        float fDelay = IntToFloat(i)/10.0;
        DelayCommand(fDelay, RIG_DoDBStore2(nBaseType, nAC));
    }
}

//spawn a chest for each base item type
void RIG_DoSetup2(location lLimbo, int nBaseItemType, int nAC = 0)
{
DoDebug("RIG_DoSetup2() for "+IntToString(nBaseItemType));
    string sTag = "RIG_Chest_"+IntToString(nBaseItemType)+"_"+IntToString(nAC);
    object oChest = GetObjectByTag(sTag);
    //check DB next
    if(!GetIsObjectValid(oChest))
    {
        oChest = RetrieveCampaignObject(RIG_DB, sTag, lLimbo);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oChest);
        if(GetIsObjectValid(oChest))
        {
            SetLocalInt(oChest, "BaseItem", nBaseItemType);
            //SetLocalInt(oChest, "Level", nLevel);
            SetLocalInt(oChest, "AC", nAC);
            //because locals arent stored on the object
            //they are stored on the database in parallel
            int i;
            for(i=1;i<=40;i++)
            {
                sTag = "RIG_Chest_"+IntToString(nBaseItemType)+"_"+IntToString(i)+"_"+IntToString(nAC);
                int nCount = GetCampaignInt(RIG_DB, sTag+"!");
                SetLocalInt(oChest, "ContentsLevel"+IntToString(i), nCount);
            }    
        }
        //create it if it doesnt exist
        //check the constant too
        else if(RIG_CREATE_ALL_CACHE_CHESTS_ON_LOAD)
        {
            oChest = CreateObject(OBJECT_TYPE_CREATURE, "rig_chest", lLimbo, FALSE, sTag);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oChest);
            SetLocalInt(oChest, "BaseItem", nBaseItemType);
            //SetLocalInt(oChest, "Level", nLevel);
            SetLocalInt(oChest, "AC", nAC);
        }
    }
}

void RIG_DoSetup()
{
    //start Pseudo-hb to store them in a database
    DelayCommand(RIG_DB_DELAY, RIG_DoDBStore());
    location lLimbo = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
    int i;
    //for(i=0;i<RIG_ROOT_COUNT;i++)
    {
        string sBaseType = Get2DACache("rig_root", "BaseItem", i);
        if(sBaseType != "")
        {
            int nBaseType = StringToInt(sBaseType);
            int nAC = StringToInt(Get2DACache("rig_root", "AC", i));
            float fDelay = IntToFloat(i)/10.0;
            DelayCommand(fDelay, RIG_DoSetup2(lLimbo, nBaseType, nAC));  
        }
    }
}

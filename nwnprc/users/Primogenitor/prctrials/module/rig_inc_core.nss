object RIG_GetCacheChest(int nBaseItemType, int nAC, int nLevel, int nCreate = TRUE)
{

    //string sTag = "RIG_Chest_"+IntToString(nBaseItemType)+"_"+IntToString(nAC)+"_"+IntToString(nLevel);
    string sTag = "RIG_Chest_"+IntToString(nBaseItemType)+"_"+IntToString(nAC);
    object oChest = GetObjectByTag(sTag);
    //check DB next
    if(!GetIsObjectValid(oChest))
    {
        location lLimbo = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
        oChest = RetrieveCampaignObject(RIG_DB, sTag, lLimbo);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oChest);
        if(GetIsObjectValid(oChest))
        {
            SetLocalInt(oChest, "BaseItem", nBaseItemType);
            SetLocalInt(oChest, "Level", nLevel);
            SetLocalInt(oChest, "AC", nAC);
            //because locals arent stored on the object
            //they are stored on the database in parallel
            sTag = "RIG_Chest_"+IntToString(nBaseItemType)+"_"+IntToString(nAC)+"_"+IntToString(nLevel);
            int nCount = GetCampaignInt(RIG_DB, sTag+"!");
            SetLocalInt(oChest, "ContentsLevel"+IntToString(nLevel), nCount);
        }
        //create it if it doesnt exist
        //check the constant too
        else if(nCreate)
        {
            //oChest = CreateObject(OBJECT_TYPE_CREATURE, "rig_chest", lLimbo, FALSE, sTag);
            oChest = CreateObject(OBJECT_TYPE_PLACEABLE, "rig_chest", lLimbo, FALSE, sTag);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oChest);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oChest);
            SetLocalInt(oChest, "BaseItem", nBaseItemType);
            SetLocalInt(oChest, "Level", nLevel);
            SetLocalInt(oChest, "AC", nAC);
        }
    }
    return oChest;
}

void RIG_DoDBStore2(int nBaseItemType, int nAC = 0)
{
    int nLevel;
    for(nLevel=1; nLevel<=40; nLevel++)
    {
        object oChest = RIG_GetCacheChest(nBaseItemType, nAC, nLevel, FALSE);
        if(GetIsObjectValid(oChest))
        {
            //string sTag = "RIG_Chest_"+IntToString(nBaseItemType)+"_"+IntToString(nAC)+"_"+IntToString(nLevel);
            string sTag = "RIG_Chest_"+IntToString(nBaseItemType)+"_"+IntToString(nAC)+"_"+IntToString(nLevel);
            StoreCampaignObject(RIG_DB, sTag+"!", oChest); 
            int nCount = GetLocalInt(oChest, "ContentsLevel"+IntToString(nLevel));
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
        if(nBaseType != BASE_ITEM_MAGICROD
            && nBaseType != BASE_ITEM_MAGICWAND
            && nBaseType != BASE_ITEM_SCROLL
            && nBaseType != BASE_ITEM_SPELLSCROLL
            && nBaseType != BASE_ITEM_THIEVESTOOLS
            && nBaseType != BASE_ITEM_TORCH
            && nBaseType != BASE_ITEM_TRAPKIT
            && nBaseType != BASE_ITEM_POTIONS
            && nBaseType != BASE_ITEM_MISCSMALL
            && nBaseType != BASE_ITEM_MISCMEDIUM
            && nBaseType != BASE_ITEM_MISCLARGE
            && nBaseType != BASE_ITEM_KEY
            && nBaseType != BASE_ITEM_LARGEBOX
            && nBaseType != BASE_ITEM_INVALID
            && nBaseType != BASE_ITEM_GOLD
            && nBaseType != BASE_ITEM_GEM
            && nBaseType != BASE_ITEM_ENCHANTED_WAND
            && nBaseType != BASE_ITEM_ENCHANTED_SCROLL
            && nBaseType != BASE_ITEM_ENCHANTED_POTION
            && nBaseType != BASE_ITEM_CSLSHPRCWEAP
            && nBaseType != BASE_ITEM_CREATUREITEM
            && nBaseType != BASE_ITEM_CSLASHWEAPON
            && nBaseType != BASE_ITEM_CRAFTMATERIALSML
            && nBaseType != BASE_ITEM_CRAFTMATERIALMED
            && nBaseType != BASE_ITEM_CPIERCWEAPON
            && nBaseType != BASE_ITEM_CBLUDGWEAPON
            && nBaseType != BASE_ITEM_BOOK
            && nBaseType != BASE_ITEM_BLANK_WAND
            && nBaseType != BASE_ITEM_BLANK_SCROLL
            && nBaseType != BASE_ITEM_BLANK_POTION        
            )
        {
            int nAC = StringToInt(Get2DACache("rig_root", "AC", i));
            float fDelay = IntToFloat(i)/10.0;
            DelayCommand(fDelay, RIG_DoDBStore2(nBaseType, nAC));
        }    
    }
}

//spawn a chest for each base item type
void RIG_DoSetup2(int nBaseItemType, int nAC = 0)
{
DoDebug("RIG_DoSetup2() for "+IntToString(nBaseItemType));
    int nLevel;
    for(nLevel=1; nLevel<=40; nLevel++)
    {
        object oChest = RIG_GetCacheChest(nBaseItemType, nAC, nLevel);
    }    
}

void RIG_DoSetup()
{
    //start Pseudo-hb to store them in a database
    //DelayCommand(RIG_DB_DELAY, RIG_DoDBStore());
    int i;
    for(i=0;i<RIG_ROOT_COUNT;i++)
    {
        string sBaseType = Get2DACache("rig_root", "BaseItem", i);
        if(sBaseType != "")
        {
            int nBaseType = StringToInt(sBaseType);
            if(nBaseType != BASE_ITEM_MAGICROD
                && nBaseType != BASE_ITEM_MAGICWAND
                && nBaseType != BASE_ITEM_SCROLL
                && nBaseType != BASE_ITEM_SPELLSCROLL
                && nBaseType != BASE_ITEM_THIEVESTOOLS
                && nBaseType != BASE_ITEM_TORCH
                && nBaseType != BASE_ITEM_TRAPKIT
                && nBaseType != BASE_ITEM_POTIONS
                && nBaseType != BASE_ITEM_MISCSMALL
                && nBaseType != BASE_ITEM_MISCMEDIUM
                && nBaseType != BASE_ITEM_MISCLARGE
                && nBaseType != BASE_ITEM_KEY
                && nBaseType != BASE_ITEM_LARGEBOX
                && nBaseType != BASE_ITEM_INVALID
                && nBaseType != BASE_ITEM_GOLD
                && nBaseType != BASE_ITEM_GEM
                && nBaseType != BASE_ITEM_ENCHANTED_WAND
                && nBaseType != BASE_ITEM_ENCHANTED_SCROLL
                && nBaseType != BASE_ITEM_ENCHANTED_POTION
                && nBaseType != BASE_ITEM_CSLSHPRCWEAP
                && nBaseType != BASE_ITEM_CREATUREITEM
                && nBaseType != BASE_ITEM_CSLASHWEAPON
                && nBaseType != BASE_ITEM_CRAFTMATERIALSML
                && nBaseType != BASE_ITEM_CRAFTMATERIALMED
                && nBaseType != BASE_ITEM_CPIERCWEAPON
                && nBaseType != BASE_ITEM_CBLUDGWEAPON
                && nBaseType != BASE_ITEM_BOOK
                && nBaseType != BASE_ITEM_BLANK_WAND
                && nBaseType != BASE_ITEM_BLANK_SCROLL
                && nBaseType != BASE_ITEM_BLANK_POTION        
                )
            {
                int nAC = StringToInt(Get2DACache("rig_root", "AC", i));
                float fDelay = IntToFloat(i)/10.0;
                DelayCommand(fDelay, RIG_DoSetup2(nBaseType, nAC));  
            }    
        }
    }
}

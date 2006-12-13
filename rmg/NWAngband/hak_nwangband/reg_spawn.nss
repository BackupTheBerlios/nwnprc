
#include "rig_inc"
#include "ref_inc"
#include "prs_inc"
#include "rng_inc"
#include "inc_ecl"
#include "pnp_shft_poly"
#include "prc_alterations"

void EquipByType(int nType, int nSlot, int nAC = 0, int nTrial = 10)
{
    //repeated failures, abort
    if(nTrial <= 0)
        return;
    //dead, abort
    if(GetIsDead(OBJECT_SELF))
        return;    
        
    object oItem = GetRandomizedItemByType(
        nType,
        //GetECL(OBJECT_SELF),
        GetHitDice(OBJECT_SELF),
        nAC);
        
    if(!GetIsObjectValid(oItem))
    {
        float fDelay = IntToFloat(Random(60))/10.0;
        DelayCommand(fDelay, 
            EquipByType(nType, nSlot, nAC, nTrial-1));
        return;
    }

    if(nSlot != -1)
    {
        //if its armor, make sure not in combat mode
        if(nType == BASE_ITEM_ARMOR)
            ClearAllActions(TRUE);
        ForceEquip(OBJECT_SELF,
            oItem,
            nSlot);
    }       
}

void DoArmor()
{
    //get AC
    int nAC = 0;
    if(GetHasFeat(FEAT_ARMOR_PROFICIENCY_HEAVY))
        nAC = RandomI(3)+6;
    else if(GetHasFeat(FEAT_ARMOR_PROFICIENCY_MEDIUM))
        nAC = RandomI(2)+4;
    else if(GetHasFeat(FEAT_ARMOR_PROFICIENCY_LIGHT))
        nAC = RandomI(3)+1;

    //monks have zero AC
    //so do wizards & sorcs
    if(GetLevelByClass(CLASS_TYPE_MONK)
        || GetLevelByClass(CLASS_TYPE_SORCERER)
        || GetLevelByClass(CLASS_TYPE_WIZARD))
        nAC = 0;
    //rangers have light armor
    //so do bards
    else if(GetLevelByClass(CLASS_TYPE_RANGER)
        || GetLevelByClass(CLASS_TYPE_BARD))
        nAC = RandomI(3)+1;
    DelayCommand(0.1, 
        EquipByType(BASE_ITEM_ARMOR, 
            INVENTORY_SLOT_CHEST, 
            nAC));
}

void DoRanged()
{
    int nType = GetHandItemType(OBJECT_SELF, FALSE, TRUE);
    //delay this so the ammo creates first
    DelayCommand(1.1, 
        EquipByType(nType, INVENTORY_SLOT_RIGHTHAND));
    if(nType == BASE_ITEM_HEAVYCROSSBOW
        || nType == BASE_ITEM_LIGHTCROSSBOW)
        DelayCommand(0.2, 
            EquipByType(BASE_ITEM_BOLT,     
                INVENTORY_SLOT_BOLTS));
    else if(nType == BASE_ITEM_LONGBOW
        || nType == BASE_ITEM_SHORTBOW)
        DelayCommand(0.3, 
            EquipByType(BASE_ITEM_ARROW, 
                INVENTORY_SLOT_ARROWS));
    else if(nType == BASE_ITEM_SLING)
        DelayCommand(0.4, 
            EquipByType(BASE_ITEM_BULLET, 
                INVENTORY_SLOT_BULLETS));
}

void main()
{
    if(GetLocalInt(OBJECT_SELF, "Spawned")) return;
    SetLocalInt(OBJECT_SELF, "Spawned", TRUE);

    //attatch prc_ai_mob_* scripts via eventhook
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONPHYSICALATTACKED,   "prc_ai_mob_attck", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONBLOCKED,            "prc_ai_mob_block", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONCOMBATROUNDEND,     "prc_ai_mob_combt", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONCONVERSATION,       "prc_ai_mob_conv",  TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONDAMAGED,            "prc_ai_mob_damag", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONDISTURBED,          "prc_ai_mob_distb", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONPERCEPTION,         "prc_ai_mob_percp", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONSPAWNED,            "prc_ai_mob_spawn", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONSPELLCASTAT,        "prc_ai_mob_spell", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONDEATH,              "prc_ai_mob_death", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONRESTED,             "prc_ai_mob_rest",  TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONUSERDEFINED,        "prc_ai_mob_userd", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONHEARTBEAT,          "prc_ai_mob_heart", TRUE, FALSE);
    //attatch prs_onpercieve script via eventhook
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONPERCEPTION,         "prs_onpercieve",   TRUE, FALSE);
    //attatch spider jumping script
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONHEARTBEAT,          "ver_spider_hb",    TRUE, FALSE);

    //sets up the faction
    PRS_DoSpawn();

    //if you have a familiar, summon it
    if(GetHasFeat(FEAT_ANIMAL_COMPANION)
        //&& GetFamiliarName(OBJECT_SELF) != ""
        )
    {
        DelayCommand(6.0, SummonAnimalCompanion());
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_ANIMAL_COMPANION);
        DoDebug("Summoning animal companion");
    }
    //if you have an animal companion, summon it
    if(GetHasFeat(FEAT_SUMMON_FAMILIAR)
        //&& GetAnimalCompanionName(OBJECT_SELF) != ""
        )
    {
        DelayCommand(6.0, SummonFamiliar());
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_SUMMON_FAMILIAR);
        DoDebug("Summoning animal companion");
    }

    //SetName(OBJECT_SELF, RandomName()+" "+RandomName());
    DelayCommand(0.01, SetName(OBJECT_SELF, RNG_GetRandomNameForObject()+" "+RNG_GetRandomNameForObject()));

    DelayCommand(1.0, DoDisguise(GetRacialType(OBJECT_SELF)));

    DelayCommand(2.0, DoArmor());

    //equip ranged first
    DelayCommand(3.0, DoRanged());
    //create melee weapons for later
    //will also make shields
    DelayCommand(4.0,
        EquipByType(GetHandItemType(OBJECT_SELF, FALSE, FALSE),-1));
    DelayCommand(5.0,
        EquipByType(GetHandItemType(OBJECT_SELF, TRUE, FALSE),-1));
        
    //other items
    int nECL = GetHitDice(OBJECT_SELF);
    //number of slots to fill
    int nSlotMax = 8;
    //half by ECL, and half by chance
    int nSlotCount = FloatToInt((IntToFloat(nECL)/20.0)*(IntToFloat(nSlotMax)/2.0));
    nSlotCount += Random(nSlotCount+1);
    //fill them
    int nSlots;
    int i;
    while(i<nSlotCount)
    {
        int nRandom = Random(8);
        switch(nRandom)
        {
            case 0:
                if(!(nSlots & 1))
                {
                    nSlots = nSlots | 1;
                    i++;
                }    
                break;
            case 1:
                if(!(nSlots & 2))
                {
                    nSlots = nSlots | 2;
                    i++;
                }    
                break;
            case 2:
                if(!(nSlots & 4))
                {
                    nSlots = nSlots | 4;
                    i++;
                }    
                break;
            case 3:
                if(!(nSlots & 8))
                {
                    nSlots = nSlots | 8;
                    i++;
                }    
                break;
            case 4:
                if(!(nSlots & 16))
                {
                    nSlots = nSlots | 16;
                    i++;
                }    
                break;
            case 5:
                if(!(nSlots & 32))
                {
                    nSlots = nSlots | 32;
                    i++;
                }    
                break;
            case 6:
                if(!(nSlots & 64))
                {
                    nSlots = nSlots | 64;
                    i++;
                }    
                break;
            case 7:
                if(!(nSlots & 128))
                {
                    nSlots = nSlots | 128;
                    i++;
                }    
                break;
        }
    }
    //bitwise math
    //head
    if(nSlots & 1)
        DelayCommand(5.0,
            EquipByType(BASE_ITEM_HELMET, INVENTORY_SLOT_HEAD));
    //rings
    if(nSlots & 2)
        DelayCommand(6.0,
            EquipByType(BASE_ITEM_RING, INVENTORY_SLOT_LEFTHAND));
    if(nSlots & 4)
        DelayCommand(7.0,
            EquipByType(BASE_ITEM_RING, INVENTORY_SLOT_RIGHTHAND));
    //belt        
    if(nSlots & 8)
        DelayCommand(8.0,
            EquipByType(BASE_ITEM_BELT, INVENTORY_SLOT_BELT));
    //belt        
    if(nSlots & 16)
        DelayCommand(9.0,
            EquipByType(BASE_ITEM_BOOTS, INVENTORY_SLOT_BOOTS));
    //cloak        
    if(nSlots & 32)
        DelayCommand(10.0,
            EquipByType(BASE_ITEM_CLOAK, INVENTORY_SLOT_CLOAK));
    //necklace        
    if(nSlots & 64)
        DelayCommand(11.0,
            EquipByType(BASE_ITEM_AMULET, INVENTORY_SLOT_NECK));
    //bracers/gloves        
    if(nSlots & 128)
        DelayCommand(12.0,
            EquipByType(BASE_ITEM_BRACER, INVENTORY_SLOT_ARMS));
}    

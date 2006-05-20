
#include "rig_inc"
#include "ref_inc"
#include "prs_inc"
#include "rng_inc"
#include "pnp_shft_poly"

void DoArmor()
{
    //get AC
    int nAC;
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
    if(nAC)
    {
        DelayCommand(0.2,
            ForceEquip(OBJECT_SELF,
                GetRandomizedItemByType(BASE_ITEM_ARMOR,
                    GetECL(OBJECT_SELF), nAC),
                INVENTORY_SLOT_CHEST));
    }
}

void DoRanged()
{
    int nType = GetHandItemType(OBJECT_SELF, FALSE, TRUE);
    //delay this so the ammo creates first
    DelayCommand(0.1, ForceEquip(OBJECT_SELF,
        GetRandomizedItemByType(
            nType,
            GetECL(OBJECT_SELF)),
        INVENTORY_SLOT_RIGHTHAND));
    if(nType == BASE_ITEM_HEAVYCROSSBOW
        || nType == BASE_ITEM_LIGHTCROSSBOW)
        ForceEquip(OBJECT_SELF,
            GetRandomizedItemByType(
                BASE_ITEM_BOLT,
                GetECL(OBJECT_SELF)),
            INVENTORY_SLOT_BOLTS);
    else if(nType == BASE_ITEM_LONGBOW
        || nType == BASE_ITEM_SHORTBOW)
        ForceEquip(OBJECT_SELF,
            GetRandomizedItemByType(
                BASE_ITEM_ARROW,
                GetECL(OBJECT_SELF)),
            INVENTORY_SLOT_ARROWS);
    else if(nType == BASE_ITEM_SLING)
        ForceEquip(OBJECT_SELF,
            GetRandomizedItemByType(
                BASE_ITEM_BULLET,
                GetECL(OBJECT_SELF)),
            INVENTORY_SLOT_BULLETS);
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

    DelayCommand(0.1, DoDisguise(GetRacialType(OBJECT_SELF)));

    DelayCommand(0.2, DoArmor());

    //equip ranged first
    DelayCommand(0.3, DoRanged());
    //create melee weapons for later
    //will also make shields
    DelayCommand(0.4,
        VoidGetRandomizedItemByType(
            GetHandItemType(OBJECT_SELF, FALSE, FALSE),
            GetECL(OBJECT_SELF)));
    DelayCommand(0.5,
        VoidGetRandomizedItemByType(
            GetHandItemType(OBJECT_SELF, TRUE, FALSE),
            GetECL(OBJECT_SELF)));
}

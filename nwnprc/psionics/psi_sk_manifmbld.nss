//::///////////////////////////////////////////////
//:: Soulknife: Manifest Mindblade
//:: psi_sk_manifmbld
//::///////////////////////////////////////////////
/*
    Handles creation of mindblades.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 07.04.2005
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"
#include "inc_eventhook"
#include "prc_feat_const"
#include "prc_ipfeat_const"
#include "prc_inc_combat"


//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

// Handles adding in the enhancement bonuses and specials
// ======================================================
// oMbld    mindblade item
void BuildMindblade(object oPC, object oMbld);


// Tries to delete the given item
// ==============================
//void DoDestroy(object oItem);

void main()
{
    WriteTimestampedLogEntry("Starting psi_sk_manifmbld");
    object oPC = OBJECT_SELF;
    object oMbld;

    // Generate the item based on type selection
    switch(GetPersistantLocalInt(oPC, MBLADE_SHAPE))
    {
        case MBLADE_SHAPE_SHORTSWORD:
        case MBLADE_SHAPE_DUAL_SHORTSWORDS:
            oMbld = CreateItemOnObject("prc_sk_mblade_ss", oPC);
            break;
        case MBLADE_SHAPE_LONGSWORD:
            oMbld = CreateItemOnObject("prc_sk_mblade_ls", oPC);
            break;
        case MBLADE_SHAPE_BASTARDSWORD:
            oMbld = CreateItemOnObject("prc_sk_mblade_bs", oPC);
            break;
        case MBLADE_SHAPE_RANGED:
            oMbld = CreateItemOnObject("prc_sk_mblade_th", oPC, GetHasFeat(FEAT_MULTIPLE_THROW, oPC) ? GetMainHandAttacks(oPC) : 1);
            break;

        default:
            WriteTimestampedLogEntry("Invalid value in MBLADE_SHAPE for " + GetName(oPC) + ": " + IntToString(GetLocalInt(oPC, MBLADE_SHAPE)));
            return;
    }

    // Construct the bonuses
    BuildMindblade(oPC, oMbld);

    // Force equip
    AssignCommand(oPC, ActionEquipItem(oMbld, INVENTORY_SLOT_RIGHTHAND));

    // Hook the mindblade into OnHit event
    AddEventScript(oMbld, EVENT_ITEM_ONHIT, "psi_sk_onhit", TRUE, FALSE);

    // Make even more sure the mindblade cannot be dropped
    SetDroppableFlag(oMbld, FALSE);
    SetItemCursedFlag(oMbld, TRUE);

    // Generate the second mindblade if set to dual shortswords
    if(GetLocalInt(oPC, MBLADE_SHAPE) == MBLADE_SHAPE_DUAL_SHORTSWORDS)
    {
        oMbld = CreateItemOnObject("prc_sk_mblade_ss", oPC);

        DelayCommand(0.1f, BuildMindblade(oPC, oMbld)); // Delay a bit to prevent a lag spike

        DelayCommand(0.6f, AssignCommand(oPC, ActionEquipItem(oMbld, INVENTORY_SLOT_LEFTHAND)));

        AddEventScript(oMbld, EVENT_ITEM_ONHIT, "psi_sk_onhit", TRUE, FALSE);

        SetDroppableFlag(oMbld, FALSE);
        SetItemCursedFlag(oMbld, TRUE);
    }
    // Not dual-wielding, so delete the second mindblade if they have suc
    else if(GetStringLeft(GetTag(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)), 14) == "prc_sk_mblade_")
    {
        MyDestroyObject(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC));
    }
        


    // Hook psi_sk_event to the mindblade-related events it handles
    AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "psi_sk_event", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "psi_sk_event", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONUNAQUIREITEM,      "psi_sk_event", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONPLAYERDEATH,       "psi_sk_event", TRUE, FALSE);
    WriteTimestampedLogEntry("Finished psi_sk_manifmbld");
}


void BuildMindblade(object oPC, object oMbld)
{
    /* Add normal stuff and VFX */
    /// Add enhancement bonus
    // Starts at 1 to make the weapon magical
    int nEnh = 1;
        nEnh += GetLevelByClass(CLASS_TYPE_SOULKNIFE, oPC) > 20 ? 
                 (GetLevelByClass(CLASS_TYPE_SOULKNIFE, oPC) - 20) / 5 + 5: // Boni are granted +1 / 5 levels epic
                 GetLevelByClass(CLASS_TYPE_SOULKNIFE, oPC) / 4;            // Boni are granget +1 / 4 levels pre-epic
        nEnh -= GetLocalInt(oPC, MBLADE_SHAPE) == MBLADE_SHAPE_DUAL_SHORTSWORDS ? 1 : 0; // Dual mindblades have one lower bonus
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(nEnh), oMbld);
    // The mindblade being magical should grant no benefits to attack or damage
    if(!GetHasFeat(FEAT_GREATER_WEAPON_FOCUS_MINDBLADE, oPC)) // Handle Greater Weapon Focus here. It grants +1 to attack, which would sum to zero with the attack penalty, so don't apply any iprops in either direction if it is present
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackPenalty(1), oMbld);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamagePenalty(1), oMbld);

    /// Add in VFX
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD ? ITEM_VISUAL_HOLY :
                                                                       GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL ? ITEM_VISUAL_EVIL :
                                                                        ITEM_VISUAL_SONIC
                                                                     ), oMbld);

    /// Add in common feats
    string sTag = GetTag(oMbld);
    // Weapon Focus
    if(GetHasFeat(FEAT_WEAPON_FOCUS_MINDBLADE, oPC))
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(sTag == "prc_sk_mblade_ss" ? IP_CONST_FEAT_WEAPON_FOCUS_SHORT_SWORD :
                                                                       sTag == "prc_sk_mblade_ls" ? IP_CONST_FEAT_WEAPON_FOCUS_LONG_SWORD :
                                                                       sTag == "prc_sk_mblade_bs" ? IP_CONST_FEAT_WEAPON_FOCUS_BASTARD_SWORD :
                                                                       IP_CONST_FEAT_WEAPON_FOCUS_THROWING_AXE
                                                                      ), oMbld);
    // Improved Critical
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_MINDBLADE, oPC))
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(sTag == "prc_sk_mblade_ss" ? IP_CONST_FEAT_IMPROVED_CRITICAL_SHORT_SWORD :
                                                                       sTag == "prc_sk_mblade_ls" ? IP_CONST_FEAT_IMPROVED_CRITICAL_LONG_SWORD :
                                                                       sTag == "prc_sk_mblade_bs" ? IP_CONST_FEAT_IMPROVED_CRITICAL_BASTARD_SWORD :
                                                                       IP_CONST_FEAT_IMPROVED_CRITICAL_THROWING_AXE
                                                                      ), oMbld);
    // Overwhelming Critical
    if(GetHasFeat(FEAT_OVERWHELMING_CRITICAL_MINDBLADE, oPC))
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(sTag == "prc_sk_mblade_ss" ? IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSWORD :
                                                                       sTag == "prc_sk_mblade_ls" ? IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_LONGSWORD :
                                                                       sTag == "prc_sk_mblade_bs" ? IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_BASTARDSWORD :
                                                                       IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_THROWINGAXE
                                                                      ), oMbld);
    // Devastating Critical
    if(GetHasFeat(FEAT_DEVASTATING_CRITICAL_MINDBLADE, oPC))
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(sTag == "prc_sk_mblade_ss" ? IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSWORD :
                                                                       sTag == "prc_sk_mblade_ls" ? IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_LONGSWORD :
                                                                       sTag == "prc_sk_mblade_bs" ? IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_BASTARDSWORD :
                                                                       IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_THROWINGAXE
                                                                      ), oMbld);
    // Weapon Specialization
    if(GetHasFeat(FEAT_WEAPON_SPECIALIZATION_MINDBLADE, oPC))
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(sTag == "prc_sk_mblade_ss" ? IP_CONST_FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD :
                                                                       sTag == "prc_sk_mblade_ls" ? IP_CONST_FEAT_WEAPON_SPECIALIZATION_LONG_SWORD :
                                                                       sTag == "prc_sk_mblade_bs" ? IP_CONST_FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD :
                                                                       IP_CONST_FEAT_WEAPON_SPECIALIZATION_THROWING_AXE
                                                                      ), oMbld);
    // Epic Weapon Focus
    if(GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_MINDBLADE, oPC))
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(sTag == "prc_sk_mblade_ss" ? IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SHORT_SWORD :
                                                                       sTag == "prc_sk_mblade_ls" ? IP_CONST_FEAT_EPIC_WEAPON_FOCUS_LONG_SWORD :
                                                                       sTag == "prc_sk_mblade_bs" ? IP_CONST_FEAT_EPIC_WEAPON_FOCUS_BASTARD_SWORD :
                                                                       IP_CONST_FEAT_EPIC_WEAPON_FOCUS_THROWING_AXE
                                                                      ), oMbld);
    // Epic Weapon Specialization
    if(GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_MINDBLADE, oPC))
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(sTag == "prc_sk_mblade_ss" ? IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SHORT_SWORD :
                                                                       sTag == "prc_sk_mblade_ls" ? IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_LONG_SWORD :
                                                                       sTag == "prc_sk_mblade_bs" ? IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_BASTARD_SWORD :
                                                                       IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_THROWING_AXE
                                                                      ), oMbld);
    // Bladewind: Due to some moron @ BioWare, calls to DoWhirlwindAttack() do not do anything if one
    // does not have the feat. Therefore, we need to grant it as a bonus feat on the blade.
    if(GetHasFeat(FEAT_BLADEWIND, oPC))
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WHIRLWIND), oMbld);
    

    /// Apply the enhancements
    int nFlags = GetPersistantLocalInt(oPC, MBLADE_FLAGS);
    int bLight = FALSE;

    if(nFlags & MBLADE_FLAG_LUCKY)
    {
        WriteTimestampedLogEntry("Mindblade enhancement Lucky activated. Please bugreport");
    }
    if(nFlags & MBLADE_FLAG_DEFENDING)
    {
        WriteTimestampedLogEntry("Mindblade enhancement Defending activated. Please bugreport");
    }
    if(nFlags & MBLADE_FLAG_KEEN)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyKeen(), oMbld);
    }
    /*if(nFlags & MBLADE_FLAG_VICIOUS)
    { OnHit
    }*/
    if(nFlags & MBLADE_FLAG_PSYCHOKINETIC)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d4), oMbld);
        bLight = TRUE;
    }
    if(nFlags & MBLADE_FLAG_MIGHTYCLEAVING)
    {
        if(GetHasFeat(FEAT_CLEAVE, oPC))
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_GREAT_CLEAVE), oMbld);
        else
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_CLEAVE), oMbld);
    }
    if(nFlags & MBLADE_FLAG_COLLISION)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PHYSICAL, IP_CONST_DAMAGEBONUS_5), oMbld);
    }
    /*if(nFlags & MBLADE_FLAG_MINDCRUSHER )
    { OnHit 
    }*/
    if(nFlags & MBLADE_FLAG_PSYCHOKINETICBURST)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d4), oMbld);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d6), oMbld);
        bLight = TRUE;
    }
    /*if(nFlags & MBLADE_FLAG_SUPPRESSION)
    { OnHit
    }*/
    /*if(nFlags & MBLADE_FLAG_WOUNDING)
    { OnHit
    }*/
    /*if(nFlags & MBLADE_FLAG_DISRUPTING)
    { OnHit
    }
    if(nFlags & MBLADE_FLAG_SOULBREAKER)
    {
    }*/
    
    if(bLight)
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_WHITE), oMbld);
}
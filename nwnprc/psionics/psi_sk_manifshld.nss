//::///////////////////////////////////////////////
//:: Soulknife: Manifest Shield of Thought
//:: psi_sk_manifshld
//::///////////////////////////////////////////////
/** 
    Handles the manifesting of a Kalashtar Soulknife's
    Shield of Thought.

*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "psi_inc_soulkn"

int LOCAL_DEBUG = DEBUG;

//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

// Handles adding in the enhancement bonuses and specials
// ======================================================
// oShield    mindblade item
void BuildMindShield(object oPC, object oShield);


void main()
{
    if(LOCAL_DEBUG) DoDebug("Starting psi_sk_manifmbld");
    object oPC = OBJECT_SELF;
    object oShield;
    int nMbldType = GetPersistantLocalInt(oPC, MBLADE_SHAPE);
    int nHand = INVENTORY_SLOT_LEFTHAND;

    // Check the item based on type selection
    switch(nMbldType)
    {
        case MBLADE_SHAPE_DUAL_SHORTSWORDS:
            //if dual-wielding, no shield
            return;
            break;
        case MBLADE_SHAPE_BASTARDSWORD:
            //bastard sword is 2-hander if you lack proficiency
            if(!GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC) && !GetHasFeat(FEAT_WEAPON_PROFICIENCY_BASTARD_SWORD)) return;
            break;

        default:
            WriteTimestampedLogEntry("Invalid value in MBLADE_SHAPE for " + GetName(oPC) + ": " + IntToString(nMbldType));
            return;
    }
    
    oShield = CreateItemOnObject("prc_sk_tshield_0", oPC);

    // Construct the bonuses
    /*DelayCommand(0.25f, */BuildMindShield(oPC, oShield)/*)*/;

    // Force equip
    AssignCommand(oPC, ActionEquipItem(oShield, nHand));

    // Make even more sure the mindshield cannot be dropped
    SetDroppableFlag(oShield, FALSE);
    SetItemCursedFlag(oShield, TRUE);

    // Get the other hand
    int nOtherHand;
    if(nHand == INVENTORY_SLOT_RIGHTHAND)
        nOtherHand = INVENTORY_SLOT_LEFTHAND;
    else
        nOtherHand = INVENTORY_SLOT_RIGHTHAND;

    if(LOCAL_DEBUG) DelayCommand(0.01f, DoDebug("Finished psi_sk_manifshld")); // Wrap in delaycommand so that the game clock gets to update for the purposes of WriteTimestampedLogEntry
}


void BuildMindShield(object oPC, object oShield)
{
    /* Add normal stuff and VFX */
    /// Add enhancement bonus
    int nSKLevel = GetLevelByClass(CLASS_TYPE_SOULKNIFE, oPC) - 2;
    int nEnh;
    // The first actual enhancement bonus is gained at L4, but the mindblade needs to
    // have enhancement right from the beginning to pierce DR as per being magical
    if(nSKLevel < 4)
    {
        nEnh = 0;
    }
    else
    {
        nEnh = nSKLevel <= 20 ?
                nSKLevel / 4:            // Boni are granget +1 / 4 levels pre-epic
                (nSKLevel - 20) / 5 + 5; // Boni are granted +1 / 5 levels epic
    }
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(nEnh), oShield);
    
    /// Add in VFX
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD ? ITEM_VISUAL_HOLY :
                                                                       GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL ? ITEM_VISUAL_EVIL :
                                                                        ITEM_VISUAL_SONIC
                                                                      ), oShield);

    /* Apply the enhancements */
    int nFlags = GetPersistantLocalInt(oPC, MBLADE_FLAGS);
    int bLight = FALSE;

}
//::///////////////////////////////////////////////
//:: Eldritch Glaive Invocation
//:: inv_eldrtch_glv
//::///////////////////////////////////////////////
/** @file
    Handles the creation of the Eldritch Glaive for
     the invocation.


    @author Fox
    @date   Created  - 07.04.2005
    @date   Modified - 01.09.2005
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "inv_inc_invfunc"

int LOCAL_DEBUG = DEBUG;

void main()
{
    if(LOCAL_DEBUG) DoDebug("Starting inv_eldrtch_glv");
    object oPC = OBJECT_SELF;
    object oGlaive = CreateItemOnObject("prc_eldrtch_glv", oPC);
    int nAtkBns = GetHasFeat(FEAT_ELDRITCH_SCULPTOR) ? 2 : 0;
    nAtkBns += GetAttackBonus(PRCGetSpellTargetObject(), oPC, OBJECT_INVALID, FALSE, TOUCH_ATTACK_MELEE_SPELL);

    // Construct the bonuses
    itemproperty ipAddon = ItemPropertyOnHitCastSpell(IP_CONST_CASTSPELL_ELDRITCH_GLAIVE_ONHIT, (GetInvokerLevel(oPC, CLASS_TYPE_WARLOCK) + 1) / 2);
    //ipAddon = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, (GetInvokerLevel(oPC, CLASS_TYPE_WARLOCK) + 1) / 2);
    IPSafeAddItemProperty(oGlaive, ipAddon, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

    // Force equip
    ClearAllActions();
    AssignCommand(oPC, ActionEquipItem(oGlaive, INVENTORY_SLOT_RIGHTHAND));

    // Make even more sure the glaive cannot be dropped
    SetDroppableFlag(oGlaive, FALSE);
    SetItemCursedFlag(oGlaive, TRUE);

    //Set up to delete after duration ends
    DelayCommand(6.0, DestroyObject(oGlaive));

    //Schedule the attack
    DelayCommand(1.0, PerformAttackRound(PRCGetSpellTargetObject(), oPC, EffectVisualEffect(VFX_IMP_MAGBLUE),
        0.0, nAtkBns, 0, DAMAGE_TYPE_SLASHING, FALSE, "*Eldritch Glaive Hit*", "*Eldritch Glaive Miss*",
        TRUE, TOUCH_ATTACK_MELEE, FALSE, PRC_COMBATMODE_ALLOW_TARGETSWITCH|PRC_COMBATMODE_ABORT_WHEN_OUT_OF_RANGE));

    //Fire cast spell at event for the specified target
    DelayCommand(2.0, SignalEvent(PRCGetSpellTargetObject(), EventSpellCastAt(OBJECT_SELF, INVOKE_ELDRITCH_BLAST)));

    if(LOCAL_DEBUG) DelayCommand(0.01f, DoDebug("Finished inv_eldrtch_glv")); // Wrap in delaycommand so that the game clock gets to update for the purposes of WriteTimestampedLogEntry
}

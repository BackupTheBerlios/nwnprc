//::///////////////////////////////////////////////
//:: codi_pre_dis
//:://////////////////////////////////////////////
/*
     Ocular Adept: Disintegrate
*/
//:://////////////////////////////////////////////
//:: Created By: James Stoneburner
//:: Created On: 2003-11-30
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "nw_i0_spells"
#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void MoveToCorpse(object oBody, object oDeadPC);

void main()
{
    //SendMessageToPC(OBJECT_SELF, "Disintegrate script online");
    int nOcLvl = GetLevelByClass(CLASS_TYPE_OCULAR, OBJECT_SELF);
    int nChaMod = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
    int nOcSv = 10 + (nOcLvl/2) + nChaMod;
    int nCasterLvl = GetLevelByTypeDivine();
    object oTarget = GetSpellTargetObject();
    int bHit = TouchAttackRanged(oTarget,FALSE)>0;
    object oCorpse;
    effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
    effect eVis2 = EffectVisualEffect(VFX_IMP_PULSE_WIND);
    effect eLink = EffectLinkEffects(eVis, eVis2);

    if(GetPlotFlag(oTarget) == TRUE) {
        bHit = 0;
        if(GetIsPC(OBJECT_SELF)) {
            SendMessageToPC(OBJECT_SELF, "The ray failed to affect its target.");
        }
    }

    if(bHit) {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_OA_DISRAY, TRUE));
        if (!MyResistSpell(OBJECT_SELF, oTarget)) {
            if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nOcSv)) {
                //SendMessageToPC(OBJECT_SELF, "Disintegrate save fail start");
                //Apply the death effect and VFX impact
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                location lLoc = GetLocation(oTarget);
                object oScorch = CreateObject(OBJECT_TYPE_PLACEABLE, "weathmark001", lLoc, FALSE);
                oCorpse = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_corpse001", lLoc, FALSE, "corpse1234");
                MoveToCorpse(oCorpse, oTarget);
                DestroyObject(oTarget);
//                object oScorch = CreateObject(OBJECT_TYPE_PLACEABLE, "weathmark001", lLoc, FALSE);
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                //SendMessageToPC(OBJECT_SELF, "Disintegrate save fail end");
            } else {
                //Roll damage
                int nDamage = d6(5);
                effect eDam = EffectDamage(nDamage, DAMAGE_POWER_ENERGY);
                //Apply damage effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                //SendMessageToPC(OBJECT_SELF, "Disintegrate save pass end");
            }
        }
    } else {
        if(GetIsPC(OBJECT_SELF)) {
            SendMessageToPC(OBJECT_SELF, "The ray missed.");
        }
    }
}

void MoveToCorpse(object oContainer, object oPC) {

    object oGear = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
    object oGear2;
    if(GetIsObjectValid(oGear))
    {
        oGear2 = CopyItem(oGear, oContainer);
        SetPlotFlag(oGear, FALSE);
        DestroyObject(oGear);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_BELT, oPC);
    if(GetIsObjectValid(oGear))
    {
        oGear2 = CopyItem(oGear, oContainer);
        SetPlotFlag(oGear, FALSE);
        DestroyObject(oGear);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
    if(GetIsObjectValid(oGear))
    {
        oGear2 = CopyItem(oGear, oContainer);
        SetPlotFlag(oGear, FALSE);
        DestroyObject(oGear);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC);
    if(GetIsObjectValid(oGear))
    {
        oGear2 = CopyItem(oGear, oContainer);
        SetPlotFlag(oGear, FALSE);
        DestroyObject(oGear);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    if(GetIsObjectValid(oGear))
    {
        oGear2 = CopyItem(oGear, oContainer);
        SetPlotFlag(oGear, FALSE);
        DestroyObject(oGear);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);
    if(GetIsObjectValid(oGear))
    {
        oGear2 = CopyItem(oGear, oContainer);
        SetPlotFlag(oGear, FALSE);
        DestroyObject(oGear);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);
    if(GetIsObjectValid(oGear))
    {
        oGear2 = CopyItem(oGear, oContainer);
        SetPlotFlag(oGear, FALSE);
        DestroyObject(oGear);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    if(GetIsObjectValid(oGear))
    {
        oGear2 = CopyItem(oGear, oContainer);
        SetPlotFlag(oGear, FALSE);
        DestroyObject(oGear);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC);
    if(GetIsObjectValid(oGear))
    {
        oGear2 = CopyItem(oGear, oContainer);
        SetPlotFlag(oGear, FALSE);
        DestroyObject(oGear);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_NECK, oPC);
    if(GetIsObjectValid(oGear))
    {
        oGear2 = CopyItem(oGear, oContainer);
        SetPlotFlag(oGear, FALSE);
        DestroyObject(oGear);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    if(GetIsObjectValid(oGear))
    {
        oGear2 = CopyItem(oGear, oContainer);
        SetPlotFlag(oGear, FALSE);
        DestroyObject(oGear);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC);
    if(GetIsObjectValid(oGear))
    {
        oGear2 = CopyItem(oGear, oContainer);
        SetPlotFlag(oGear, FALSE);
        DestroyObject(oGear);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
    if(GetIsObjectValid(oGear))
    {
        oGear2 = CopyItem(oGear, oContainer);
        SetPlotFlag(oGear, FALSE);
        DestroyObject(oGear);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
    if(GetIsObjectValid(oGear))
    {
        oGear2 = CopyItem(oGear, oContainer);
        SetPlotFlag(oGear, FALSE);
        DestroyObject(oGear);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
    if(GetIsObjectValid(oGear))
    {
        oGear2 = CopyItem(oGear, oContainer);
        SetPlotFlag(oGear, FALSE);
        DestroyObject(oGear);
    }

    oGear = GetFirstItemInInventory(oPC);
    while (oGear != OBJECT_INVALID)
    {
        oGear2 = CopyItem(oGear, oContainer);
        SetPlotFlag(oGear, FALSE);
        DestroyObject(oGear);
        oGear = GetNextItemInInventory(oPC);
    }
    int nGold = GetGold(oPC);
    TakeGoldFromCreature(nGold, oPC, TRUE);
    CreateItemOnObject("NW_IT_GOLD001", oContainer, nGold);
}

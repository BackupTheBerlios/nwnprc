#include "x2_inc_itemprop"
#include "prc_inc_switch"

const int VFX_PER_NEW_TIMESTOP = 76;
void DoTimestopEquip();
void DoTimestopUnEquip();
void ApplyTSToObject(object oTarget);
void RemoveTSFromObject(object oTarget);

void RemoveTimestopEquip()
{
    int i;
    for (i=0;i<18;i++)
    {
        IPRemoveMatchingItemProperties(GetItemInSlot(i), ITEM_PROPERTY_NO_DAMAGE, DURATION_TYPE_TEMPORARY);
    }
}

void DoTimestopEquip()
{
    object oPC = GetPCItemLastEquippedBy();
    if(!GetPRCSwitch(PRC_TIMESTOP_NO_HOSTILE)
        && !GetHasSpellEffect(SPELL_TIME_STOP, oPC)
        && !GetHasSpellEffect(4032, oPC))
        return;
    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetPCItemLastEquipped(),9999.0);
}

void DoTimestopUnEquip()
{
    object oPC = GetPCItemLastUnequippedBy();
    if(!GetPRCSwitch(PRC_TIMESTOP_NO_HOSTILE)
        && !GetHasSpellEffect(SPELL_TIME_STOP, oPC)
        && !GetHasSpellEffect(4032, oPC))
        return;
    IPRemoveMatchingItemProperties(GetPCItemLastUnequipped(), ITEM_PROPERTY_NO_DAMAGE, DURATION_TYPE_TEMPORARY);
}

void ApplyTSToObject(object oTarget)
{
    effect eTS =  EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION);
    effect eCSP = EffectCutsceneParalyze();
    effect eLink = EffectLinkEffects(eTS, eCSP);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
    if(GetIsPC(oTarget) && GetPRCSwitch(PRC_TIMESTOP_BLANK_PC))
        BlackScreen(oTarget);
    AssignCommand(oTarget, ClearAllActions(FALSE));
    SetCommandable(FALSE, oTarget);
}

void RemoveTSFromObject(object oTarget)
{
    effect eTest = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectSpellId(eTest) == SPELL_TIME_STOP
		|| GetEffectSpellId(eTest) == 4032)//epic TS
            RemoveEffect(oTarget, eTest);
        eTest = GetNextEffect(oTarget);
    }
    if(GetIsPC(oTarget))
        StopFade(oTarget);
    SetCommandable(TRUE, oTarget);
}

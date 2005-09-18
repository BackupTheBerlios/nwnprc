//::///////////////////////////////////////////////
//:: Light
//:: NW_S0_Light.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Applies a light source to the target for
    10 minutes per shadowbane inquisitor level

    XP2
    If cast on an item, item will get temporary
    property "light" for the duration of the spell
    Brightness on an item is lower than on the
    continual light version.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 15, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001
//:: Added XP2 cast on item code: Georg Z, 2003-06-05
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"
#include "prc_class_const"
#include "prc_feat_const"
#include "x2_inc_spellhook"

void main()
{

   

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run
    // this spell.
    if (!X2PreSpellCastCode())
    {
        return;
    }
if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
   {
        SpeakStringByStrRef(40550);
   }
   else
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int CasterLvl = GetLevelByClass(CLASS_TYPE_SHADOWBANE_INQUISITOR, OBJECT_SELF);
    int nDuration = CasterLvl * 10;
    int nMetaMagic;

    // Handle spell cast on item....
    if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM && ! CIGetIsCraftFeatBaseItem(oTarget))
    {
        // Do not allow casting on not equippable items
        if (!IPGetIsItemEquipable(oTarget))
        {
         // Item must be equipable...
             FloatingTextStrRefOnCreature(83326,OBJECT_SELF);
            return;
        }

        itemproperty ip = ItemPropertyLight (IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_WHITE);

        if (GetItemHasItemProperty(oTarget, ITEM_PROPERTY_LIGHT))
        {
            IPRemoveMatchingItemProperties(oTarget,ITEM_PROPERTY_LIGHT,DURATION_TYPE_TEMPORARY);
        }

        nDuration = CasterLvl;
        nMetaMagic = GetMetaMagicFeat();
        //Enter Metamagic conditions
        if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
        {
            nDuration = nDuration *2; //Duration is +100%
        }

        AddItemProperty(DURATION_TYPE_TEMPORARY,ip,oTarget,MinutesToSeconds(nDuration));
    }
    else
    {
        effect eVis = EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = EffectLinkEffects(eVis, eDur);

        nDuration = CasterLvl;
        nMetaMagic = GetMetaMagicFeat();
        //Enter Metamagic conditions
        if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
        {
            nDuration = nDuration *2; //Duration is +100%
        }
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LIGHT, FALSE));

        //Apply the VFX impact and effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, MinutesToSeconds(nDuration),TRUE,-1,CasterLvl);
    }

DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
}
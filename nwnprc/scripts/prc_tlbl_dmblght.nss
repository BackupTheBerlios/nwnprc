//::///////////////////////////////////////////////
//:: Blight Mind
//:: prc_tlbl_dmblght
//:://////////////////////////////////////////////
/*
    Will save or the target blightspawned is Dominated for
    1 minute per class level.
*/
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    object oPC = OBJECT_SELF;
    effect eDom = EffectDominated();
    eDom = GetScaledEffect(eDom, oTarget);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Link domination and persistant VFX
    effect eLink = EffectLinkEffects(eMind, eDom);
    eLink = EffectLinkEffects(eLink, eDur);
    // Can't be dispelled
    eLink = SupernaturalEffect(eLink);

    effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
    // 1 Minute per class level
    float fDuration = GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oPC) * 60.0;
    int nDC = 10 + GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oPC) + GetAbilityModifier(ABILITY_WISDOM, oPC);
    
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_MONSTER, FALSE));

    if (GetTag(oTarget) == "prc_blightspawn")
    {
               //Make a Will Save
               if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
               {
                    //Apply linked effects and VFX Impact
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

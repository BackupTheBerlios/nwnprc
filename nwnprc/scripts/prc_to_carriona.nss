//::///////////////////////////////////////////////
//:: Thrall of Orcus Carrion Stench
//:: prc_to_carrionA.nss
//:://////////////////////////////////////////////
/*
    Creatures entering the area around the Thrall
    must save or be cursed with Doom
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 11, 2004
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "prc_class_const"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eDoom = CreateDoomEffectsLink();
    effect eTest;
    eDoom = ExtraordinaryEffect(eDoom);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eDoom, eDur);
    int nDC = (10 + GetLevelByClass(CLASS_TYPE_ORCUS, OBJECT_SELF) + GetAbilityModifier(ABILITY_CONSTITUTION, OBJECT_SELF));
    int nDur = GetLevelByClass(CLASS_TYPE_ORCUS, OBJECT_SELF);

            if(!GetLevelByClass(CLASS_TYPE_ORCUS, OBJECT_SELF))
            {
                //Make a saving throw check
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON))
                {
                    //Apply the VFX impact and effects
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur));
                }
            }
}

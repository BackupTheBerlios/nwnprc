//::///////////////////////////////////////////////
//:: Name Drow Judicator Warstrike
//:: FileName prc_dj_warstrike
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
This is the spell effect of the Warstrike ability
of the Drow Judicator prestige class.
*/
//:://////////////////////////////////////////////
//:: Created By: PsychicToaster
//:: Created On: 7-24-04
//:://////////////////////////////////////////////

#include "prc_class_const"

void main()
{

//Setup Variables
object oPC      = OBJECT_SELF;
object oTarget  = GetSpellTargetObject();

int    nClass   = GetLevelByClass(CLASS_TYPE_JUDICATOR);
int    nChaMod  = GetAbilityModifier(ABILITY_CHARISMA);
int    nFortDC  = 10+nClass+nChaMod;
int    nCon     = d6(2);

//Roll Fortitude Saving Throw
if(FortitudeSave(oTarget, nFortDC, SAVING_THROW_FORT, oPC))
    {
    nCon = nCon/2;
    //Debug
    //SpeakString("Debug Save Succeeded.  Damage Dealt ="+IntToString(nCon));
    }

effect eVis1 = EffectVisualEffect(VFX_IMP_POISON_L);
effect eCon  = EffectAbilityDecrease(ABILITY_CONSTITUTION,nCon);
effect eLink = EffectLinkEffects(eVis1, eCon);

ApplyEffectToObject(DURATION_TYPE_PERMANENT, MagicalEffect(eLink), oTarget);
//Debug
//SpeakString("Damage Dealt ="+IntToString(nCon));

}

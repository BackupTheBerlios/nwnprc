#include "prc_inc_clsfunc"
void main()
{

object oTarget = GetSpellTargetObject();
int iLevel = GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, OBJECT_SELF);
int iAdd = iLevel/3;
int iImages = d4(1) + 3;
SetLocalObject(OBJECT_SELF, "FLURRY_TARGET", oTarget);
FlurryEffects(OBJECT_SELF);
    int iPlus;
    for (iPlus = 0; iPlus < iImages; iPlus++)
    {

     object oImage = CopyObject(OBJECT_SELF, GetLocation(OBJECT_SELF), OBJECT_INVALID, "PC_IMAGE");
     AssignCommand(oImage, ActionAttack(oTarget, FALSE));
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oImage, 0.0);
    }
    object oCreature = GetFirstObjectInArea(GetArea(OBJECT_SELF));
    while (GetIsObjectValid(oCreature))
        {
         if(GetTag(oCreature) == "PC_IMAGE")
         {
         DelayCommand(3.0, SPMakeAttack(oTarget, oCreature));
         }
         oCreature = GetNextObjectInArea(GetArea(OBJECT_SELF));;
        }

}

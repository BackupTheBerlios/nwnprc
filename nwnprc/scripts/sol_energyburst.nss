#include "prc_class_const"
#include "prc_alterations"

void main()
{
   if (!GetHasFeat(FEAT_TURN_UNDEAD,OBJECT_SELF))  return;

   DecrementRemainingFeatUses(OBJECT_SELF,FEAT_TURN_UNDEAD);

   if (!GetHasFeat(FEAT_TURN_UNDEAD,OBJECT_SELF))
   {
     IncrementRemainingFeatUses(OBJECT_SELF,FEAT_TURN_UNDEAD);
     return;
   }

   DecrementRemainingFeatUses(OBJECT_SELF,FEAT_TURN_UNDEAD);

   location lTarget = GetSpellTargetLocation();

   int CasterLvl = GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT);

    effect eDeath ;
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    int nDamage;

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {

      if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD )
      {

          nDamage = PRCGetReflexAdjustedDamage(d6(CasterLvl), oTarget, (10+CasterLvl), SAVING_THROW_TYPE_POSITIVE);
          eDeath = EffectDamage(nDamage,DAMAGE_TYPE_POSITIVE,DAMAGE_POWER_ENERGY);

          effect eLink = EffectLinkEffects(eDeath, eVis);

           DelayCommand(0.0f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eLink,oTarget));

      }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    }

}

//Hellfire Grasp by Sir Attilla

//Fixed some run-time errors that caused spell to do nothing
//Aaon Graywolf - Jan 9, 2004
#include "prc_alterations"
#include "prc_inc_combat"
void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nDamage = d6(1);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
   //Main Spell Body
   int iHit = GetAttackRoll(oTarget, OBJECT_SELF, OBJECT_INVALID, 0, 0,0,TRUE, 0.0, TOUCH_ATTACK_MELEE_SPELL);
   if (iHit > 0)
   {
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
   }

}

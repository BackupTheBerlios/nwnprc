
#include "prc_inc_sneak"

// return sneak attack damage for a spell
// requires caster, target, and spell damage type
int SpellSneakAttackDamage(object oCaster, object oTarget)
{
     if( GetCanSneakAttack(oTarget, oCaster) )
     {
          FloatingTextStringOnCreature("*Sneak Attack Spell*", oCaster, TRUE);
          return GetSneakAttackDamage(GetTotalSneakAttackDice(oCaster));  
     }
     else
     {
          return 0;
     }
}

// Applies damage from a ranged touch attack including critical damage and sneak attack damage
// the target to attack, the original damage ammount (will get doubled if critical)
// TouchAttackType  0 = melee, 1 = ranged  , 3 non-sneak melee, 4 non-sneak ranged
// DisplayFeedBack - default is true
int ApplyTouchAttackDamage(object oCaster, object oTarget, int iAttackRoll, int iDamage, int iDamageType, int bCanSneakAttack = TRUE)
{
     // perform critical
     if(iAttackRoll == 2)  iDamage *= 2;
     
     // add sneak attack damage if applicable
     if(bCanSneakAttack)
          iDamage += SpellSneakAttackDamage(oCaster, oTarget);
     
     // apply damage
     if(iAttackRoll > 0)
     {
          effect eDamage = EffectDamage(iDamage, iDamageType);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
     }
     
     return iAttackRoll;
}
/*
   ----------------
   Share Pain
   
   prc_pow_shrpain
   ----------------

   19/2/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 2
   Range: Touch
   Target: One Willing Creature
   Duration: 1 Hour/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   This power creates a psychometabolic connection between you and a willing subject so that some of your wounds
   are transferred to the subject. You take half damage from all attacks that deal hitpoint damage to you
   and the willing subject takes the remainder. 
*/

void main()
{
     object oCaster = OBJECT_SELF;
     int iDamageTaken = GetTotalDamageDealt();
     int iHalf = iDamageTaken/2;
     object oTarget = GetLocalObject(oCaster, "SharePainTarget");
     
     effect eHeal = EffectHeal(iHalf);
     ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oCaster);
     effect eDam = EffectDamage(iHalf, DAMAGE_TYPE_POSITIVE);
     ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
}
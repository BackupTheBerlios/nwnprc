/*
   ----------------
   Empathic Feedback
   
   prc_pow_empfeed
   ----------------

   19/2/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 4, Psychic Warrior 3
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 7, Psychic Warrior 5
   
   This power creates a psychometabolic connection between you and an unwilling subject so that some of your wounds
   are transferred to the subject. You take half damage from all attacks that deal hitpoint damage to you
   and the unwilling subject takes the remainder. 
   
   Augment: For every additional power point spend, the damage empathic feedback can deal increases by 1.
*/

void main()
{
     object oPC = OBJECT_SELF;
     object oFoe = GetLastDamager();
     
     int iDR = GetLocalInt(oPC, "EmpathicFeedback");
     int iDamageTaken = GetTotalDamageDealt();
     
     int nDam = 0;
          
     if (iDR > iDamageTaken)
     {
     	nDam = iDamageTaken;
     }
     else
     {
     	nDam = iDR;
     }
          
     effect eDam = EffectDamage(nDam, DAMAGE_TYPE_POSITIVE);
     ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oFoe);
}
//::///////////////////////////////////////////////
//:: Name      Devoted Bulwark Onhit
//:: FileName  tob_onht_dvtbwk.nss
//:://////////////////////////////////////////////7
/** If an enemy deals damage to you with a melee 
attack, you gain a +1 morale bonus to your AC until 
the end of the your next turn.
**/
//////////////////////////////////////////////////////
// Author: Tenjac
// Date:   24.4.07
//////////////////////////////////////////////////////

void main()
{
        object oSpellOrigin = OBJECT_SELF;
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(1, AC_DODGE_BONUS), oSpellOrigin, 6.0f);
}

        
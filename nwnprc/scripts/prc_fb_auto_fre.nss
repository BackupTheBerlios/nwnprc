//::///////////////////////////////////////////////
//:: Frenzied Berserker - Armor/Skin
//:://////////////////////////////////////////////
/*
    Script for Auto Frenzy on hit
    Moved to separate script to fix GetTotalDamageDealt() issues
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:://////////////////////////////////////////////

#include "prc_inc_clsfunc"
#include "prc_spell_const"

void main()
{
     // 10 + damage dealt in that hit
     int willSaveDC = 10 + GetTotalDamageDealt();
     int save = WillSave(OBJECT_SELF, willSaveDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF);
     if(save == 0)
     {
          ActionCastSpellOnSelf(SPELL_FRENZY);
     }
}